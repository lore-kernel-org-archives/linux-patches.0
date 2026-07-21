Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9119643E4B9;
	Tue, 21 Jul 2026 21:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671031; cv=none; b=flm8dGW4hk5J46m7t9j+x3Do+GYnMH5U5UYXIGefQwILs7aNDAinsQ+UA7elCtaU6j//BNUNergVX7yT13OS2Mixdycfjno5xJkiw651yV7CuhawFtgQ3LGW/P0xiEO+zORM7tANgvLYxRTMWTiFeLZq03WSQzaOTkbuvH0s/3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671031; c=relaxed/simple;
	bh=JmX85uZWbEVs+TtnmbHKnKiyM1TQnDwPLEYsEYqLlEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCm5chRE8pQpCxx9y4AYvPVMBzitVaCcxsVWltbxGxJmxUbjpZ3kH0KtDH4mrz5uSECAhj1NusTDdnRg51ADtAn2PcpLTHUwuQHvWis5BWBJdXwO8GeWM0ABUAyHqeM3M3ieTQK7StnG/trrRQZ3nigudGdJomj6N3J5vFQx+C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjmTxiHJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjmTxiHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C981F000E9;
	Tue, 21 Jul 2026 21:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671029;
	bh=2q+8XpT7B1ioWZgDxx0TSk4+GTNYSSOktwsU40e1KPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjmTxiHJxz0/tuxERnOi5s5XaTt1Tk7lP68Qm38lRKSYy3Bzle5r6Cg0Em4GE4EA2
	 5zOGYW4r3GAR1gm27pk2Lx5twHLntLcY+YpD0HiPQ/RfYhyEoCZWiuDesUsQ/CYKdw
	 FwnuNwLFZHzBqbs3skyruQ8XrD8ud2nOhumpfX6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: [PATCH 5.15 093/843] staging: rtl8723bs: fix WEP length underflow and OOB read in OnAuth()
Date: Tue, 21 Jul 2026 17:15:28 +0200
Message-ID: <20260721152408.092485763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -700,6 +700,9 @@ unsigned int OnAuth(struct adapter *pada
 	if ((pmlmeinfo->state&0x03) != WIFI_FW_AP_STATE)
 		return _FAIL;
 
+	if (len < WLAN_HDR_A3_LEN)
+		return _FAIL;
+
 	sa = GetAddr2Ptr(pframe);
 
 	auth_mode = psecuritypriv->dot11AuthAlgrthm;
@@ -711,6 +714,9 @@ unsigned int OnAuth(struct adapter *pada
 		prxattrib->hdrlen = WLAN_HDR_A3_LEN;
 		prxattrib->encrypt = _WEP40_;
 
+		if (len < WLAN_HDR_A3_LEN + 8)
+			return _FAIL;
+
 		iv = pframe+prxattrib->hdrlen;
 		prxattrib->key_index = ((iv[3]>>6)&0x3);
 
@@ -816,7 +822,7 @@ unsigned int OnAuth(struct adapter *pada
 			p = rtw_get_ie(pframe + WLAN_HDR_A3_LEN + 4 + _AUTH_IE_OFFSET_, WLAN_EID_CHALLENGE, (int *)&ie_len,
 					len - WLAN_HDR_A3_LEN - _AUTH_IE_OFFSET_ - 4);
 
-			if (!p || ie_len <= 0) {
+			if (!p || ie_len != 128) {
 				status = WLAN_STATUS_CHALLENGE_FAIL;
 				goto auth_fail;
 			}


