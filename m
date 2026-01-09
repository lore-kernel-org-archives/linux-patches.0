Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282DB321F5E;
	Fri,  9 Jan 2026 12:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961510; cv=none; b=YK47ZbsGSzY3v3xE3MRyLJA0wbVgEPBtjxGGePfkTrOMFByR/XaZ2E/OXRPHwbm92BEaIGIyBIOzyNnniAo/aZTrwpaz/3VePZOtHsnyEfRHm3hCi5iZXeYKez3uXouNPAH1d/Rb+dkubBViEx5MLmBCok6MV7Tr819LYAyneLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961510; c=relaxed/simple;
	bh=tJY2wCGxm1mpfSy+OtmHOzpqig6Jv5gOqOXkKdeeQvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgcfESUZ/oj4DdhmHi45ZUrAKH4yKFz6xJYbg/qwUGG9388v0NLkL2VXTGLlLR0/8xwvmnjMZ9ZNDik5zqRm9mnI3b8cJlGuvRCIqoPbMbx9nknZ+kIEYTYTDuRbNlh0XI25f5MOmE2JFKgObBWvm7rklH1b6YBX/3zNRpr7O1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gYxYA12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gYxYA12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FB1C4CEF1;
	Fri,  9 Jan 2026 12:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961509;
	bh=tJY2wCGxm1mpfSy+OtmHOzpqig6Jv5gOqOXkKdeeQvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gYxYA12NZap2h2OWM3W1Or4/P+gu3aJNDvLNChw+C99ROJJwqQDZ76ACH7DszIkB
	 AGQvqii9uEvkNFLxPnSkrReILc/tSTYtuBgQVPN6aDH+Hw3Lif0AEHHraHdX5NjLBe
	 imYMXO89s5+uS17Ts52rsdtJXGVvgAAYhxIVTdzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 040/634] staging: rtl8723bs: fix out-of-bounds read in OnBeacon ESR IE parsing
Date: Fri,  9 Jan 2026 12:35:18 +0100
Message-ID: <20260109112118.955499218@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Navaneeth K <knavaneeth786@gmail.com>

commit 502ddcc405b69fa92e0add6c1714d654504f6fd7 upstream.

The Extended Supported Rates (ESR) IE handling in OnBeacon accessed
*(p + 1 + ielen) and *(p + 2 + ielen) without verifying that these
offsets lie within the received frame buffer. A malformed beacon with
an ESR IE positioned at the end of the buffer could cause an
out-of-bounds read, potentially triggering a kernel panic.

Add a boundary check to ensure that the ESR IE body and the subsequent
bytes are within the limits of the frame before attempting to access
them.

This prevents OOB reads caused by malformed beacon frames.

Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -582,9 +582,11 @@ unsigned int OnBeacon(struct adapter *pa
 
 	p = rtw_get_ie(pframe + sizeof(struct ieee80211_hdr_3addr) + _BEACON_IE_OFFSET_, WLAN_EID_EXT_SUPP_RATES, &ielen, precv_frame->u.hdr.len - sizeof(struct ieee80211_hdr_3addr) - _BEACON_IE_OFFSET_);
 	if (p && ielen > 0) {
-		if ((*(p + 1 + ielen) == 0x2D) && (*(p + 2 + ielen) != 0x2D))
-			/* Invalid value 0x2D is detected in Extended Supported Rates (ESR) IE. Try to fix the IE length to avoid failed Beacon parsing. */
-			*(p + 1) = ielen - 1;
+		if (p + 2 + ielen < pframe + len) {
+			if ((*(p + 1 + ielen) == 0x2D) && (*(p + 2 + ielen) != 0x2D))
+				/* Invalid value 0x2D is detected in Extended Supported Rates (ESR) IE. Try to fix the IE length to avoid failed Beacon parsing. */
+				*(p + 1) = ielen - 1;
+		}
 	}
 
 	if (pmlmeext->sitesurvey_res.state == SCAN_PROCESS) {


