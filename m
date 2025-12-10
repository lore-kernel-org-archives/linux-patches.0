Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B1D221F2F;
	Wed, 10 Dec 2025 07:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351966; cv=none; b=ipHL2xbnnKZQBx4+sl1k0NAtb5S4oaM6/V74HY+vVcPnwN/HKBNihJRnm3Swu5KDPzpK5LeT1C8XPzFh9N6x4YOCq1KwN55+WpyfyaY0A14mHwA2SeGaybdzVeY1sKwuqXvP5P+r+hzh78tOsIcL+uje2Ztw7BHtrgvEXj7vfNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351966; c=relaxed/simple;
	bh=Hs6jecCTp8R1n2BgTbWkiMNRBeUaYgATJLuGHJkfaBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2f5SXGPZY0r4puCPVRp8jgNZ3em40YAy8HnMdKYlfjaD5/P6oO/azfox98wHAvQH1CmwkTSbh/52JVe0sO7X2zwPpDeNm/mq8iV6ysp9LMM6LBzdXt1sh8rL/8V9pM9awvbqvjKxwGb3rwKqgIXhpx/Agev8EnH+c4M+xAocDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxhwApt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxhwApt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DD8C4CEF1;
	Wed, 10 Dec 2025 07:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351965;
	bh=Hs6jecCTp8R1n2BgTbWkiMNRBeUaYgATJLuGHJkfaBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxhwApt0tFUjLbOAwtwsRnV6sY7+rz43DjBwBk72wy1+Ks/TEC94647yhOdDRAfx5
	 nDiBq+/wiSqa4hZsD4hIoKQYzM3SM6x/zvshIPyYCV0L+Lev0qXT/FhlZw7jje5raQ
	 bYJaA/qDFgBTrlsd8eNNaugtoZ0/sQVTqrS3tMjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 46/49] staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing
Date: Wed, 10 Dec 2025 16:30:16 +0900
Message-ID: <20251210072949.310527432@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

From: Navaneeth K <knavaneeth786@gmail.com>

commit 6ef0e1c10455927867cac8f0ed6b49f328f8cf95 upstream.

The Supported Rates IE length from an incoming Association Request frame
was used directly as the memcpy() length when copying into a fixed-size
16-byte stack buffer (supportRate). A malicious station can advertise an
IE length larger than 16 bytes, causing a stack buffer overflow.

Clamp ie_len to the buffer size before copying the Supported Rates IE,
and correct the bounds check when merging Extended Supported Rates to
prevent a second potential overflow.

This prevents kernel stack corruption triggered by malformed association
requests.

Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -1033,6 +1033,9 @@ unsigned int OnAssocReq(struct adapter *
 		status = WLAN_STATUS_CHALLENGE_FAIL;
 		goto OnAssocReqFail;
 	} else {
+		if (ie_len > sizeof(supportRate))
+			ie_len = sizeof(supportRate);
+
 		memcpy(supportRate, p+2, ie_len);
 		supportRateNum = ie_len;
 
@@ -1040,7 +1043,7 @@ unsigned int OnAssocReq(struct adapter *
 				pkt_len - WLAN_HDR_A3_LEN - ie_offset);
 		if (p) {
 
-			if (supportRateNum <= sizeof(supportRate)) {
+			if (supportRateNum + ie_len <= sizeof(supportRate)) {
 				memcpy(supportRate+supportRateNum, p+2, ie_len);
 				supportRateNum += ie_len;
 			}


