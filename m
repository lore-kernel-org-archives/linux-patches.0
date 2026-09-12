Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99381BD9C9;
	Sat, 12 Sep 2026 07:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198530; cv=none; b=KdB7LE7rabHC0IXPhZyt6x85aHWiLbWihV2qLBQVL8u4uv1i0vgtE2UJEp/svS+HujIb090oJCdz2Dv5PtI3dzZz8Pf8Q9X/Ooo/d/+ZMzSRA8K5z+xITMaszPTMvg1Z/C8imWTGXzG7NJwYA+1XcLsc3RZzYQbWPWutM0/78qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198530; c=relaxed/simple;
	bh=9s7SQo0E0lEojSUnGSfNVhUfGim9Y3Isn99M1/eHf94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzHwe0Zk/VaoWbkvH1WvGbg9clU5QUGrz511I3qr0IpWj8qvpnxp+ezeW6H05LsZGlsHug7GkRwuAXCHE10Iyul9Pci30KMBNOKm0bCDnGfHKF6XIaWPDFviDuYeUWPxOTSnWLtqlpZ5vASvRUbR8w4M8qfkZJ5U78+BAuURMWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ssqr/ZPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ssqr/ZPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129CB1F000FF;
	Sat, 12 Sep 2026 07:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198528;
	bh=/IVO/iSWf1ga8A274wIhE9XB3uClNoTD90PYd/ZbA9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ssqr/ZPzgOCH5132nrWJS7ZZylsQ82S6BFn7wfjCuleqVZEx2qBo5myzcvy1zq711
	 5Zrp/dB6V2VnRNiPtLA60AfLT8XBlJx56eJ8TlBN3cBoyMHpWnRVl1G6samZ2SdWUI
	 apgoQ7hNIcroKGc0CFMVBPrLCcFgQGWq8IhB0CeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0398/1815] firmware: arm_scmi: Avoid IDR updates while cleaning channels
Date: Sat, 12 Sep 2026 08:35:48 +0200
Message-ID: <20260912065658.238310171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6ee2152f6b01f..d17559c897a9a 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2885,7 +2885,7 @@ static int scmi_channels_setup(struct scmi_info *info)
 	return 0;
 }
 
-static int scmi_chan_destroy(int id, void *p, void *idr)
+static int scmi_chan_destroy(int id, void *p, void *data)
 {
 	struct scmi_chan_info *cinfo = p;
 
@@ -2898,8 +2898,6 @@ static int scmi_chan_destroy(int id, void *p, void *idr)
 		cinfo->dev = NULL;
 	}
 
-	idr_remove(idr, id);
-
 	return 0;
 }
 
-- 
2.53.0



