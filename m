Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0365A32FA3D;
	Fri,  9 Jan 2026 11:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959417; cv=none; b=VB/zyd6wmKN81bm+XWTI+T+Wp6SCm0rh2Ys9B2lXiBHB116TnHJgfr2EXAYB/UeoCgPp88jTW8oftNxS2NgPY691394UW1KFOezC6b5Pv9DlXbvprYlit/dmxYKqzahtfeeALnJHA1Mb2HhGDLs34v/b5iVlQdHZke8lHE+6Th4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959417; c=relaxed/simple;
	bh=XXdRt2jyN3zbSWl4RNIqVps5YmdMforwtzNGDMTLbZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMg7/usLovZB8wPzO3EOqjnWq5jQXYIhckI73FszJ3N40XR8yiYthXQFPpk/k8e0TntKLb2o0b7cXnd6yWBjVJcqLwneNAz7IHiQe3ncu6gi2gePIAYK0/fesQoLdGWqySvlQqUTyYp5dGWmWi9WfkKUR24q7JWyqcAcX0Y14WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrWsmuHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrWsmuHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE6BC4CEF1;
	Fri,  9 Jan 2026 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959416;
	bh=XXdRt2jyN3zbSWl4RNIqVps5YmdMforwtzNGDMTLbZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrWsmuHaIcFRNq54UoTKn+79uIwkpXGYgoppALqjdVy7yTNLZgmRBI4g24ST9FTvm
	 xgNLS/+G4azA7kpJdkz6HFUkix1y8Ru4QKRQN0n0DGD7VfJziAJOX+VWO4str43lut
	 J504pVCHlbmgk01Ne+E+prXq2SmNCCIffqljGPAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 045/737] staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing
Date: Fri,  9 Jan 2026 12:33:04 +0100
Message-ID: <20260109112135.689934544@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -1034,6 +1034,9 @@ unsigned int OnAssocReq(struct adapter *
 		status = WLAN_STATUS_CHALLENGE_FAIL;
 		goto OnAssocReqFail;
 	} else {
+		if (ie_len > sizeof(supportRate))
+			ie_len = sizeof(supportRate);
+
 		memcpy(supportRate, p+2, ie_len);
 		supportRateNum = ie_len;
 
@@ -1041,7 +1044,7 @@ unsigned int OnAssocReq(struct adapter *
 				pkt_len - WLAN_HDR_A3_LEN - ie_offset);
 		if (p) {
 
-			if (supportRateNum <= sizeof(supportRate)) {
+			if (supportRateNum + ie_len <= sizeof(supportRate)) {
 				memcpy(supportRate+supportRateNum, p+2, ie_len);
 				supportRateNum += ie_len;
 			}


