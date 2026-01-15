Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F378B3BF2E7;
	Thu, 15 Jan 2026 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497396; cv=none; b=t53TcUPBmWWuQlF88mb9Y3+w4rV9AU/+CdUi3nyX++ba2Ym6/cdR8fxV9E/qvVTJT6ElyeIj8YqCbbkqAyblbHjRZwl6jioSUzTC7m8xrwhueIp43zkiKKGQbqgXRrQ6t9E/gSTzh1qnYL8ABIN9RljfLZjhyN/dJdXRrLUI80Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497396; c=relaxed/simple;
	bh=rYVNV89rejfKw+MNnU1YIBXoScoL+C/g/CugO7AhfVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=up2a8LQeYmPPPfZydgU40sRwzbD1fxQgz+NDPxQtXMkt6kUP/x42mbL/jMokSbSOStr7nKO8SMWbzWe/kGlWM55NTCdefwU/cRyPdcAy6buE21nxdfBvko+fKuO+HSkbSvOs+1/OfcnA74K2tUlWA09C5GO0rlGjf6Oav6QC9Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWMjfCsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWMjfCsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E038C19422;
	Thu, 15 Jan 2026 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497395;
	bh=rYVNV89rejfKw+MNnU1YIBXoScoL+C/g/CugO7AhfVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWMjfCsrt4R231dzo3lujV0DKVB9Iso9VI6GG/m2v5gDFxG6U1klEKMpciHRdN/r/
	 cjCa+Rqh/YK3X3GI/BdY7rIWRyGtw6Q8Oo3RkRcF9BaE6c3dQpHJei0QR7v8TfYRmt
	 +45YxpwDMgro6flN/fRYPjuum9G0i1qLxpla6wVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 033/554] staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing
Date: Thu, 15 Jan 2026 17:41:39 +0100
Message-ID: <20260115164247.438346903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1042,6 +1042,9 @@ unsigned int OnAssocReq(struct adapter *
 		status = WLAN_STATUS_CHALLENGE_FAIL;
 		goto OnAssocReqFail;
 	} else {
+		if (ie_len > sizeof(supportRate))
+			ie_len = sizeof(supportRate);
+
 		memcpy(supportRate, p+2, ie_len);
 		supportRateNum = ie_len;
 
@@ -1049,7 +1052,7 @@ unsigned int OnAssocReq(struct adapter *
 				pkt_len - WLAN_HDR_A3_LEN - ie_offset);
 		if (p) {
 
-			if (supportRateNum <= sizeof(supportRate)) {
+			if (supportRateNum + ie_len <= sizeof(supportRate)) {
 				memcpy(supportRate+supportRateNum, p+2, ie_len);
 				supportRateNum += ie_len;
 			}


