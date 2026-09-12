Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E5A3624BC;
	Sat, 12 Sep 2026 10:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207284; cv=none; b=GX1VcZNQlZwUckaOo2M2NyLjFhvMhVrYrNRDeNwdTb8QBLWLR5ULmSmdd6yT6Ux3dFxsf7PpiUiit5a+543fx5m4ftXxeLYfsx+z7YYD5VCs3lKDEXeq0zfAeWx4RlEPmA9ZcQ9D8EP4C1EYTepDb060R7NIPMSrht4Rnli4T1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207284; c=relaxed/simple;
	bh=VzbJsEXD2k+0i1Bw80pPww5z9EwtxxCdNwUZ1MzyAEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMqOU2d0aYQ7DUzTx/YfL6Z9DMB1h+jtrmsRfuyozGR92RvreeEVX9uNWTCJdznw3/g8yWZTIqto9PIIEFEeOWghYOASsbrb4yLc9ztvT7CmFJTCxWmPwx84g23cPeQMtGKG/YmQf2fWWLajQ2Jih/cB/M6kmcCM35lnFuZMqfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckQvAY/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckQvAY/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636F51F000FF;
	Sat, 12 Sep 2026 10:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207283;
	bh=2xh6txHmNDXHGhP0hn/BE0MyNKuzB4einMuxMYQErQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckQvAY/5hdrAimWx/xu5Aa3NsVicn6GQNz8G7pUOogxRyhAhkYYpjZvf2tSL96Ktg
	 WZXPOyf3jqZsol8/XOZjJBIO5WJN6ECPNfxHa+0TdhslN1XqU6vmHNIzAZr5T1VmAV
	 MCat7yxRoTbT2J9nCI5O7UO1hrl2f9skIpGa1Xe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0382/1518] firmware: arm_scmi: Avoid IDR updates while cleaning channels
Date: Sat, 12 Sep 2026 08:42:31 +0200
Message-ID: <20260912065632.102265861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit c38b1e19485aaa820e52cfe162525a8af67563da ]

scmi_cleanup_channels() walks the TX/RX channel IDRs with
idr_for_each() to free transport resources and destroy the dedicated
transport devices before calling idr_destroy().

The destroy callback removed each entry from the same IDR being walked.
That is not needed for this cleanup path, and it is unsafe because
idr_for_each() has not advanced its radix-tree iterator while the
callback is running. Removing the current entry from the callback can
invalidate the iterator state. The callback also cannot be protected by
rcu_read_lock(), because scmi_device_destroy() may sleep.

Leave IDR teardown to the following idr_destroy() call and keep the
callback limited to device destruction.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-6-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 5d7f090e98ea8..5965a9989e45b 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2796,7 +2796,7 @@ static int scmi_channels_setup(struct scmi_info *info)
 	return 0;
 }
 
-static int scmi_chan_destroy(int id, void *p, void *idr)
+static int scmi_chan_destroy(int id, void *p, void *data)
 {
 	struct scmi_chan_info *cinfo = p;
 
@@ -2809,8 +2809,6 @@ static int scmi_chan_destroy(int id, void *p, void *idr)
 		cinfo->dev = NULL;
 	}
 
-	idr_remove(idr, id);
-
 	return 0;
 }
 
-- 
2.53.0



