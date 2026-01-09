Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CFA2DEA6F;
	Fri,  9 Jan 2026 11:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959897; cv=none; b=RB5Ht2orEzXkMm+M56Osq+5j0PKgezVebTOkUQ0r5MFwrAeBPv7w+vXFeZs7KAsE1crXVcS6+QLI/BWTW/WIR86ythmmTRSehCSz2G9Gddr8ujCuXI6CsWe6NSepbamwDKSJVius2S3enNjHsmb15c0BZp/PhLs8gLMnKdX/FBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959897; c=relaxed/simple;
	bh=1KbdOiTyj49rHN0gj7E6VaqWCSAibGirOD5IMZ0RjF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klTlKGxfu+ocReC/QKebCHtMEacRkjbJVY2UB4rhOR3lXnyyDp91fBkC/HSkUByf6UhRQXyU8T5fPKSVQX5tVLn714EGe1A09yIJXINnzqw6ihtTf+YMSKVtQwVfohw+j9MfwVSA+KzEXdrqhfkp2YgpxNvlPYvrU0MdK+jJP1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3MFsL+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3MFsL+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2812CC4CEF1;
	Fri,  9 Jan 2026 11:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959896;
	bh=1KbdOiTyj49rHN0gj7E6VaqWCSAibGirOD5IMZ0RjF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3MFsL+6e7lwZHFxmrB2NOPYrq4wN/vZFLlJJYzvd6IhXDyScZ5Qb+9EqzSN+HXKY
	 NngNgHjOTeJG2zNcIl4otxG4djuRhmVd+Ers6ZTd87vrnYJrPwkftmVLnKZfdxbQn/
	 iLiL790sFwayfgAg2AUlzFnoLa1+uMsfzKpAvGf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/737] wifi: mac80211: fix CMAC functions not handling errors
Date: Fri,  9 Jan 2026 12:35:20 +0100
Message-ID: <20260109112140.803123967@linuxfoundation.org>
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

From: Chien Wong <m@xv97.com>

[ Upstream commit 353cda30d30e5dc7cacf8de5d2546724708ae3bb ]

The called hash functions could fail thus we should check return values.

Fixes: 26717828b75d ("mac80211: aes-cmac: switch to shash CMAC driver")
Signed-off-by: Chien Wong <m@xv97.com>
Link: https://patch.msgid.link/20251113140511.48658-2-m@xv97.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/aes_cmac.c | 63 +++++++++++++++++++++++++++++------------
 net/mac80211/aes_cmac.h |  8 +++---
 net/mac80211/wpa.c      | 20 +++++++------
 3 files changed, 61 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
index 48c04f89de20a..65989c7dfc680 100644
--- a/net/mac80211/aes_cmac.c
+++ b/net/mac80211/aes_cmac.c
@@ -22,50 +22,77 @@
 
 static const u8 zero[CMAC_TLEN_256];
 
-void ieee80211_aes_cmac(struct crypto_shash *tfm, const u8 *aad,
-			const u8 *data, size_t data_len, u8 *mic)
+int ieee80211_aes_cmac(struct crypto_shash *tfm, const u8 *aad,
+		       const u8 *data, size_t data_len, u8 *mic)
 {
+	int err;
 	SHASH_DESC_ON_STACK(desc, tfm);
 	u8 out[AES_BLOCK_SIZE];
 	const __le16 *fc;
 
 	desc->tfm = tfm;
 
-	crypto_shash_init(desc);
-	crypto_shash_update(desc, aad, AAD_LEN);
+	err = crypto_shash_init(desc);
+	if (err)
+		return err;
+	err = crypto_shash_update(desc, aad, AAD_LEN);
+	if (err)
+		return err;
 	fc = (const __le16 *)aad;
 	if (ieee80211_is_beacon(*fc)) {
 		/* mask Timestamp field to zero */
-		crypto_shash_update(desc, zero, 8);
-		crypto_shash_update(desc, data + 8, data_len - 8 - CMAC_TLEN);
+		err = crypto_shash_update(desc, zero, 8);
+		if (err)
+			return err;
+		err = crypto_shash_update(desc, data + 8,
+					  data_len - 8 - CMAC_TLEN);
+		if (err)
+			return err;
 	} else {
-		crypto_shash_update(desc, data, data_len - CMAC_TLEN);
+		err = crypto_shash_update(desc, data,
+					  data_len - CMAC_TLEN);
+		if (err)
+			return err;
 	}
-	crypto_shash_finup(desc, zero, CMAC_TLEN, out);
-
+	err = crypto_shash_finup(desc, zero, CMAC_TLEN, out);
+	if (err)
+		return err;
 	memcpy(mic, out, CMAC_TLEN);
+
+	return 0;
 }
 
-void ieee80211_aes_cmac_256(struct crypto_shash *tfm, const u8 *aad,
-			    const u8 *data, size_t data_len, u8 *mic)
+int ieee80211_aes_cmac_256(struct crypto_shash *tfm, const u8 *aad,
+			   const u8 *data, size_t data_len, u8 *mic)
 {
+	int err;
 	SHASH_DESC_ON_STACK(desc, tfm);
 	const __le16 *fc;
 
 	desc->tfm = tfm;
 
-	crypto_shash_init(desc);
-	crypto_shash_update(desc, aad, AAD_LEN);
+	err = crypto_shash_init(desc);
+	if (err)
+		return err;
+	err = crypto_shash_update(desc, aad, AAD_LEN);
+	if (err)
+		return err;
 	fc = (const __le16 *)aad;
 	if (ieee80211_is_beacon(*fc)) {
 		/* mask Timestamp field to zero */
-		crypto_shash_update(desc, zero, 8);
-		crypto_shash_update(desc, data + 8,
-				    data_len - 8 - CMAC_TLEN_256);
+		err = crypto_shash_update(desc, zero, 8);
+		if (err)
+			return err;
+		err = crypto_shash_update(desc, data + 8,
+					  data_len - 8 - CMAC_TLEN_256);
+		if (err)
+			return err;
 	} else {
-		crypto_shash_update(desc, data, data_len - CMAC_TLEN_256);
+		err = crypto_shash_update(desc, data, data_len - CMAC_TLEN_256);
+		if (err)
+			return err;
 	}
-	crypto_shash_finup(desc, zero, CMAC_TLEN_256, mic);
+	return crypto_shash_finup(desc, zero, CMAC_TLEN_256, mic);
 }
 
 struct crypto_shash *ieee80211_aes_cmac_key_setup(const u8 key[],
diff --git a/net/mac80211/aes_cmac.h b/net/mac80211/aes_cmac.h
index 76817446fb838..f74150542142a 100644
--- a/net/mac80211/aes_cmac.h
+++ b/net/mac80211/aes_cmac.h
@@ -11,10 +11,10 @@
 
 struct crypto_shash *ieee80211_aes_cmac_key_setup(const u8 key[],
 						  size_t key_len);
-void ieee80211_aes_cmac(struct crypto_shash *tfm, const u8 *aad,
-			const u8 *data, size_t data_len, u8 *mic);
-void ieee80211_aes_cmac_256(struct crypto_shash *tfm, const u8 *aad,
-			    const u8 *data, size_t data_len, u8 *mic);
+int ieee80211_aes_cmac(struct crypto_shash *tfm, const u8 *aad,
+		       const u8 *data, size_t data_len, u8 *mic);
+int ieee80211_aes_cmac_256(struct crypto_shash *tfm, const u8 *aad,
+			   const u8 *data, size_t data_len, u8 *mic);
 void ieee80211_aes_cmac_key_free(struct crypto_shash *tfm);
 
 #endif /* AES_CMAC_H */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 94dae7cb6dbd3..6223014e480c7 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -859,8 +859,9 @@ ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx)
 	/*
 	 * MIC = AES-128-CMAC(IGTK, AAD || Management Frame Body || MMIE, 64)
 	 */
-	ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
-			   skb->data + 24, skb->len - 24, mmie->mic);
+	if (ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
+			       skb->data + 24, skb->len - 24, mmie->mic))
+		return TX_DROP;
 
 	return TX_CONTINUE;
 }
@@ -902,8 +903,9 @@ ieee80211_crypto_aes_cmac_256_encrypt(struct ieee80211_tx_data *tx)
 
 	/* MIC = AES-256-CMAC(IGTK, AAD || Management Frame Body || MMIE, 128)
 	 */
-	ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
-			       skb->data + 24, skb->len - 24, mmie->mic);
+	if (ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
+				   skb->data + 24, skb->len - 24, mmie->mic))
+		return TX_DROP;
 
 	return TX_CONTINUE;
 }
@@ -942,8 +944,9 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
 		/* hardware didn't decrypt/verify MIC */
 		bip_aad(skb, aad);
-		ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
-				   skb->data + 24, skb->len - 24, mic);
+		if (ieee80211_aes_cmac(key->u.aes_cmac.tfm, aad,
+				       skb->data + 24, skb->len - 24, mic))
+			return RX_DROP_U_DECRYPT_FAIL;
 		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_U_MIC_FAIL;
@@ -992,8 +995,9 @@ ieee80211_crypto_aes_cmac_256_decrypt(struct ieee80211_rx_data *rx)
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
 		/* hardware didn't decrypt/verify MIC */
 		bip_aad(skb, aad);
-		ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
-				       skb->data + 24, skb->len - 24, mic);
+		if (ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
+					   skb->data + 24, skb->len - 24, mic))
+			return RX_DROP_U_DECRYPT_FAIL;
 		if (crypto_memneq(mic, mmie->mic, sizeof(mmie->mic))) {
 			key->u.aes_cmac.icverrors++;
 			return RX_DROP_U_MIC_FAIL;
-- 
2.51.0



