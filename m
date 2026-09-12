Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80552246BCD;
	Sat, 12 Sep 2026 10:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207275; cv=none; b=nRVuuOBBwKOHW9gpg2jlU5ewoTsdZQziGRmLxvVz+eQ7tsh+wXz7n6fCJ/b6Ewa7M3psi1Odj1A805sofNpkIzUz2jPr1UGklvFc9kUsf+Jn//GckGDL5fwhJJFkiilOhs6/DIhRBCm9bTbJrTfTeOiUozNILkPLsfgMPn2UpLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207275; c=relaxed/simple;
	bh=lWkdNXDEJiVChXwE2ImtpM69zuGLJNXLn+glVpumBTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej0BZOMnoL0k3a2zhAeTbpWXtefdlZkUGpOFLYm5U3bAo89UqZiXQNbrRytfGHSdrQRwy89JOfrPuAcp7Uzf4jORnKuSav/O1bB6aImSwVdAlbH40kzhmVfXD/Ns1iOz3hchw4uEQIPp5RRreQTlNq0d4MyPtUu8hxGVICtU4co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhlRehpd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhlRehpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B252D1F000FF;
	Sat, 12 Sep 2026 10:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207274;
	bh=7qi7uDcQu57mhbkWzXHo8NVHjoYy+Ssc5ApZZ+I72TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhlRehpd0IqnyGleVsQjFo+h9m5cekzJHfJJxRi6jXSV987LBudHkd+Ge9g9ob91j
	 WDj54gfqQVPMdXYlTQvkjaWkAKU1kGswcORsW/oQfPq7V1ylo3hZ0Th7OZWl8s17oV
	 GE8UpOFIFcWlUSZ9B/WZAH5BWLRmbPripfH9Bq6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0380/1518] firmware: arm_scmi: Clean up channels on setup failure
Date: Sat, 12 Sep 2026 08:42:29 +0200
Message-ID: <20260912065632.057931415@linuxfoundation.org>
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

[ Upstream commit 687d67be3d87894ef12e8a164434612e0b53cfae ]

scmi_channels_setup() can fail after the common BASE channel or earlier
protocol channels have already been registered in the TX/RX IDRs.

Route this failure through the existing channel cleanup label so the
transport channels, transport devices and IDR state created before the
failure are released before the probe error path frees the SCMI instance
ID.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-4-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 529a4e5852e6e..74a199ca4c76c 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -3171,7 +3171,7 @@ static int scmi_probe(struct platform_device *pdev)
 	ret = scmi_channels_setup(info);
 	if (ret) {
 		err_str = "failed to setup channels\n";
-		goto clear_ida;
+		goto clear_txrx_setup;
 	}
 
 	ret = bus_register_notifier(&scmi_bus_type, &info->bus_nb);
@@ -3287,7 +3287,6 @@ static int scmi_probe(struct platform_device *pdev)
 	scmi_notification_quiesce(&info->handle);
 	scmi_cleanup_txrx_channels(info);
 	scmi_notification_exit(&info->handle);
-clear_ida:
 	ida_free(&scmi_id, info->id);
 
 out_err:
-- 
2.53.0



