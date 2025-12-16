Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9A0364040;
	Tue, 16 Dec 2025 12:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887777; cv=none; b=n2Rhx1O0MNzIP3InG0op0agTYxxLnZ9JFBZh8UXOCb3SqI41k8J9/flPyOMXvtn/sSUWWyrogzY3TXpVZt01esleaq1ZHQi4+z86FIG/OwbiXcstLdapBp9MpERzlZBFkQh73MzU5xeXvp+8qcC8LNHg4j0ApbC5ZcCBwMHPRu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887777; c=relaxed/simple;
	bh=zI6KECveDQ0Jr7JV2vW+kg1NRn2Gu1fvFjM8OyoJOTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/AqKJiSFfhkenO9kPuclieWg2zTDQdpV7mphDoqhjztpQFLpAvOHkEFhy2S0mu903SNEskXKPS1mMdTv98a6/OQh7c3Ld5XQ2kloFPrzUQAD6AGI2+Paurns1F4dCGhh3aO1dQGMp64Qh7+KTu99pi7J/le/P1EFYO0Xewq+Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quA8VfYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quA8VfYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FA0C4CEF5;
	Tue, 16 Dec 2025 12:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887776;
	bh=zI6KECveDQ0Jr7JV2vW+kg1NRn2Gu1fvFjM8OyoJOTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quA8VfYNZNpKJUmBMuwMHivs5P0t4dEMlawjwoig2vAaGHfn6cXvx2zVek9E6WCCS
	 y0A44jjQw9lrCQAbtxt+Ik4bRYb6Pyhi7IZxV6x4LaZXZgScp5PlPH/P83Lm7Fq/MI
	 Za/wVfIdeYKeKrmYXHboAT7M3/lN1tvQs+4T/wi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 334/614] wifi: mac80211: fix CMAC functions not handling errors
Date: Tue, 16 Dec 2025 12:11:41 +0100
Message-ID: <20251216111413.466660190@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 40d5d9e484791..bb0fa505cdcae 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -869,8 +869,9 @@ ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx)
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
@@ -916,8 +917,9 @@ ieee80211_crypto_aes_cmac_256_encrypt(struct ieee80211_tx_data *tx)
 
 	/* MIC = AES-256-CMAC(IGTK, AAD || Management Frame Body || MMIE, 128)
 	 */
-	ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
-			       skb->data + 24, skb->len - 24, mmie->mic);
+	if (ieee80211_aes_cmac_256(key->u.aes_cmac.tfm, aad,
+				   skb->data + 24, skb->len - 24, mmie->mic))
+		return TX_DROP;
 
 	return TX_CONTINUE;
 }
@@ -956,8 +958,9 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
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
@@ -1006,8 +1009,9 @@ ieee80211_crypto_aes_cmac_256_decrypt(struct ieee80211_rx_data *rx)
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



