Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFCB43E08D;
	Thu, 30 Jul 2026 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426250; cv=none; b=VJF/jDEkJ8x8cpo5sx14Ce2eStbFPqMCwXIK95w6mq1rgIZbVNSXpL0PaR6Z0+oQRdF0Mf9wOG/udm9O8mb8a2SGVUbzFtb/v+onoL3rHLhttn2yC6mu0FU/LXoRBM538T2ou0z867gYt2/kvWE9+BZcFN/QEufdKassy29zn+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426250; c=relaxed/simple;
	bh=anvKuyY3bEpbDteYHWjgKvpcAzhNoqya0LTPTz8cpT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqHXlSNo6O6EPgZ+ldnn5r6pHHKF1xrjYtUBhtoruKCzrlQvQIub5kRC58nDs8oPRafc8yoYrDLYgQzSaDTTGfB7vKBYgB/4g5lTSnitk/bYG+h6Xo71UAQHoFgF/si/BDPFyuex0m8MURvBP+ppNt9ldm2iUJk44N9GQLTqrAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYoO8s4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYoO8s4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0643B1F00A3A;
	Thu, 30 Jul 2026 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426249;
	bh=UJNOz0bO9FBLuh5M2pMFoQZgegRUnJVtz81KKiaiT0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYoO8s4BnOZhNwBdXalk6rDeGUWxAiRthwrYZJ1Aiqcx/5rFPkQ6B9bZkgQe1IE4p
	 IwSQ/oZYw3ex9TPjGBcjkZh3PyNpOU9k+XNa/niHaA8e6XKXgqe6sCVASdcFd9FD8D
	 sWrD2XpjUh5UNX1jqotul7XJInG8udKBFc04DLRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Moksh Panicker <mokshpanicker.7@gmail.com>
Subject: [PATCH 6.12 353/602] staging: rtl8723bs: fix OOB reads in rtw_get_wps_ie()
Date: Thu, 30 Jul 2026 16:12:25 +0200
Message-ID: <20260730141443.378383417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moksh Panicker <mokshpanicker.7@gmail.com>

commit 0e95ff792ae0aa6fbad9455943e9e1e4062670e9 upstream.

rtw_get_wps_ie() iterates over IE data from network frames without
validating that the IE header and payload fit within the remaining
buffer before reading them. Specifically:

- in_ie[cnt + 1] is read without checking cnt + 1 < in_len
- memcmp(&in_ie[cnt + 2], ...) accesses cnt + 2 without bounds check
- in_ie[cnt + 1] is used as length without verifying payload fits

Add bounds checks at the top of the loop body to break early if fewer
than 2 bytes remain for the IE header, or if the declared payload
extends past the end of the buffer. Also require at least 4 bytes of
payload before comparing the WPS OUI.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Moksh Panicker <mokshpanicker.7@gmail.com>
Link: https://patch.msgid.link/20260625202911.26782-1-mokshpanicker.7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -679,7 +679,14 @@ u8 *rtw_get_wps_ie(u8 *in_ie, uint in_le
 	while (cnt < in_len) {
 		eid = in_ie[cnt];
 
-		if ((eid == WLAN_EID_VENDOR_SPECIFIC) && (!memcmp(&in_ie[cnt + 2], wps_oui, 4))) {
+		if (cnt + 2 > in_len)
+			break;
+
+		if (in_ie[cnt + 1] + 2 > in_len - cnt)
+			break;
+
+		if ((eid == WLAN_EID_VENDOR_SPECIFIC) && (in_ie[cnt + 1] >= 4) &&
+		    (!memcmp(&in_ie[cnt + 2], wps_oui, 4))) {
 			wpsie_ptr = &in_ie[cnt];
 
 			if (wps_ie)


