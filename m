Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB2F217723;
	Thu, 30 Jul 2026 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427318; cv=none; b=XOxbhVrabtZaA8Z4OcjSn7tD5NmsdwnVc1reLsUw0EjpOCjHb9MFdL54ewL+S+FLXvuRoH4ybifMrWa6tD72yvVc6XE9u+9o3qpkhtR3UslHSpuQqThW1+taGsn87qvJBPYWjFSCJwKaVm4uYkJzwdVnm33oplLB4C4NzGyuaSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427318; c=relaxed/simple;
	bh=NZ6DSr0/cDko7d9db6G9D1haGFAZDQJgE5pjzE7jb7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECIWtNlNqzzMQMbe+aaN2O+cLKerC6qY9bKn+HfJyWQJF04XxwtvgulgZp4aB3QISMwEugeuY4oeKlHBWo90V8Xb5iY6PfGFdSsHG6RTC9rHSLIJKhlITqL9vU+4y0hxlHYV8mPBxqDcOs2IKZSbGE8O+szeCHz1pxf9VVfSAy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbIdFp+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbIdFp+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FBC1F000E9;
	Thu, 30 Jul 2026 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427317;
	bh=VQjk07ekTKcPZOuFcdrLH/8c0M58dHiKW0Vnjkzh4IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbIdFp+PpDSpIkzUq/T8zgGC2Iq9AWutqPESkA12/aqShP/M0wmZ7myAJpD2v3eHm
	 9PRNmgf6DWdcgFS9pWNkRDFcAnv58u1IUZDPeXAtRl+zKQvSw2UWR5tmCOAKxqoqLk
	 U12rEEV7yVdQ2pqXMdMwyALiW5IZ1H82TKEWrHDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/484] wifi: ath6kl: fix OOB read from firmware IE lengths in connect event
Date: Thu, 30 Jul 2026 16:10:23 +0200
Message-ID: <20260730141426.197938858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 6b47b29730de3232b919d8362749f6814c5f2a33 ]

The firmware-controlled beacon_ie_len, assoc_req_len, and assoc_resp_len
fields in ath6kl_wmi_connect_event_rx() are not validated against the
buffer length. Their sum (up to 765) can exceed the actual WMI event
data, causing out-of-bounds reads during IE parsing and state corruption
of wmi->is_wmm_enabled.

Add a check that the total IE length fits within the buffer.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260421135009.348084-3-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index a572952dd4b903..447896b871c3e2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -874,6 +874,14 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
 
 	ev = (struct wmi_connect_event *) datap;
 
+	if (len < sizeof(*ev) + ev->beacon_ie_len +
+	    ev->assoc_req_len + ev->assoc_resp_len) {
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "connect event: IE lengths %u+%u+%u exceed buffer %d\n",
+			   ev->beacon_ie_len, ev->assoc_req_len,
+			   ev->assoc_resp_len, len);
+		return -EINVAL;
+	}
 	if (vif->nw_type == AP_NETWORK) {
 		/* AP mode start/STA connected event */
 		struct net_device *dev = vif->ndev;
-- 
2.53.0



