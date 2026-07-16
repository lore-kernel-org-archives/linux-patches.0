Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A007429CCA;
	Thu, 16 Jul 2026 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211896; cv=none; b=dhAF+FGpfvFEbenGUJJkxG9hCCU6dbPiwqGEnkcSEwBz5IEE2q8vDwKEDV0cXkzDE0ri560ZHyewWW1IICtpxQOhESIqv/o1N3eBvrGEVyjOc41SVu5cnNhZUfXk62L7ICRDOsdNa2VGvrGAC3usG8r7vJ8WO24rm89eH9owmYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211896; c=relaxed/simple;
	bh=ydZk+vFeBDhMtcrK89fICFurD1BJW2YPrTe8ECs4u+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWTajc5ayVIiVfuakKc+b10E1xD5ZMqbZ1rp9yTcYJMZjYkaVmggj2+m0SH7D4nQa/hL2w20XtC0iTRwAzhOgdgDxw0PLe6zoT4uxwaO/+6oz6Z72hJllRgd+nkVe7YoJC/mx2PzLJYC9Mz5jWNBFOskBWiyCnYJxF3ixpTLSLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLbVHXk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLbVHXk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD661F00ACF;
	Thu, 16 Jul 2026 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211895;
	bh=TioZ3EMv6Z+IR4vCzs1inHRDAB3clOH3Y39wWGIbCuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLbVHXk/ViN+wTrmYoKUv2cqufnZFB1uLnL29oVccdsnEYjgYXOilq48UZoA1yvoF
	 WzvVPhB0BK/VR5wdOLX7xDo4JtVSzjdBz/Jn0YKiKgcFcGKFsrTEd5YGqfmxMHrWUn
	 QWzNYX1MT/mSKdtG9jJPsqTUs0S/qMGGFuX4M02w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: [PATCH 6.12 121/349] staging: rtl8723bs: fix WEP length underflow and OOB read in OnAuth()
Date: Thu, 16 Jul 2026 15:30:55 +0200
Message-ID: <20260716133036.066952275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Alexandru Hossu <hossu.alexandru@gmail.com>

commit a1fc19d61f661d47204f095b593de507884849f7 upstream.

OnAuth() has two bugs in the shared-key authentication path.

When the Privacy bit is set, rtw_wep_decrypt() is called without
verifying that the frame is long enough to contain a valid WEP IV and
ICV.  Inside rtw_wep_decrypt(), length is computed as:

    length = len - WLAN_HDR_A3_LEN - iv_len

and then passed as (length - 4) to crc32_le().  If len is less than
WLAN_HDR_A3_LEN + iv_len + icv_len (32 bytes), length - 4 is negative
and, after the implicit cast to size_t, causes crc32_le() to read far
beyond the frame buffer.  Add a minimum length check before accessing
the IV field and calling the decryption path.

When processing a seq=3 response, rtw_get_ie() stores the Challenge
Text IE length in ie_len, but the subsequent memcmp() always reads 128
bytes regardless of ie_len.  IEEE 802.11 mandates a challenge text of
exactly 128 bytes; reject any IE whose length field differs, matching
the check already applied to OnAuthClient().

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260522004605.1039209-1-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -694,6 +694,9 @@ unsigned int OnAuth(struct adapter *pada
 	if ((pmlmeinfo->state&0x03) != WIFI_FW_AP_STATE)
 		return _FAIL;
 
+	if (len < WLAN_HDR_A3_LEN)
+		return _FAIL;
+
 	sa = GetAddr2Ptr(pframe);
 
 	auth_mode = psecuritypriv->dot11AuthAlgrthm;
@@ -705,6 +708,9 @@ unsigned int OnAuth(struct adapter *pada
 		prxattrib->hdrlen = WLAN_HDR_A3_LEN;
 		prxattrib->encrypt = _WEP40_;
 
+		if (len < WLAN_HDR_A3_LEN + 8)
+			return _FAIL;
+
 		iv = pframe+prxattrib->hdrlen;
 		prxattrib->key_index = ((iv[3]>>6)&0x3);
 
@@ -809,7 +815,7 @@ unsigned int OnAuth(struct adapter *pada
 			p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + 4 + _AUTH_IE_OFFSET_, WLAN_EID_CHALLENGE, (int *)&ie_len,
 					len - WLAN_HDR_A3_LEN - _AUTH_IE_OFFSET_ - 4);
 
-			if (!p || ie_len <= 0) {
+			if (!p || ie_len != 128) {
 				status = WLAN_STATUS_CHALLENGE_FAIL;
 				goto auth_fail;
 			}


