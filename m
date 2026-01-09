Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1162C359FBE;
	Fri,  9 Jan 2026 12:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961507; cv=none; b=NG7/7jtLYmq6/mTpF8e9OZNM4QUhWeB2fjY/nV2nUxZD1DrY1Q87ifFIMDm7NP8eZcDPJeWAc4p3+g04EyAmCqmuPJQObxj77mXeNQPW6X/LVAuZp3+GYvk3XrDmiuOkoiYMKz8GX9hD8SNLSmDvInB/XwLRlDGeFrKBZqg0kbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961507; c=relaxed/simple;
	bh=gijgAIR+hv3DghbcCor7k0gtwfAMPR5H0Ks2t9pfVzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXPToLiRgzpdOBBHDGLiLSU8DIo4N0qZknERf+FOc89uePOk9slXFhphSA9JMMD4kz+K5ZtBQ9gALgkcOTY2Bi4s3Dv85eox3z8zzyNlWUBS9jzXYep/vXz9KGbg5EoSvCgxJ6DSbSqGsTvQE8Bkyw3MjBJb2TcwtiY4bhlGdZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcGq4VCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcGq4VCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA28C4CEF1;
	Fri,  9 Jan 2026 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961506;
	bh=gijgAIR+hv3DghbcCor7k0gtwfAMPR5H0Ks2t9pfVzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcGq4VCc06e3AjpVnuyzxPe/bi8RYLq0seNIBMV4qTtKzrET2o4RosZ2b85F2TcP9
	 VStjRquBjeSbENXsbal66xXOYbOCqEY86mNYv12kpUqgkMeHClGuYMhYGdE6JCUGCD
	 mTj/e/8h2p0NWlkgT4ZKBkNq0nkNd1xXW/CCXqSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 039/634] staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing
Date: Fri,  9 Jan 2026 12:35:17 +0100
Message-ID: <20260109112118.918680616@linuxfoundation.org>
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
@@ -1036,6 +1036,9 @@ unsigned int OnAssocReq(struct adapter *
 		status = WLAN_STATUS_CHALLENGE_FAIL;
 		goto OnAssocReqFail;
 	} else {
+		if (ie_len > sizeof(supportRate))
+			ie_len = sizeof(supportRate);
+
 		memcpy(supportRate, p+2, ie_len);
 		supportRateNum = ie_len;
 
@@ -1043,7 +1046,7 @@ unsigned int OnAssocReq(struct adapter *
 				pkt_len - WLAN_HDR_A3_LEN - ie_offset);
 		if (p) {
 
-			if (supportRateNum <= sizeof(supportRate)) {
+			if (supportRateNum + ie_len <= sizeof(supportRate)) {
 				memcpy(supportRate+supportRateNum, p+2, ie_len);
 				supportRateNum += ie_len;
 			}


