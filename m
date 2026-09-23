Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2121344CAD7;
	Wed, 23 Sep 2026 14:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175353; cv=none; b=ZxUvA+RQPbjQLG0T5QfdimSRhDPSvn9DZOXiG99dfGZ3nP5Tyau9bADY6OQ9y7C2TVztkG/abUvlUQY+vePl4KrEfZdrZVD4ib3juqPWRHEUtq+KMr0bcUT5Bcf7GewAt9NZ1irgeKXKXbwoLY0NTk34bUo9wL4fqBTrMNYr6RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175353; c=relaxed/simple;
	bh=jbbYT2N7g3Rfka69am5sNhbDyafgPuh01Uyk692/sD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwAt024jwQHCgM8vHP95GRfLhpPaFLC1vuTY9ymF6WYdQIoNKh+Z4gcIwG3gIU0rnDmw2qgT8thFxoKT5nQJq5sFgrqsVJriV0MYYuGiNVBtxsKvwW2FbuIzFhb26aVbeiiQT3HKTINzYjAZs9LwBB86XDp1FVWpmsKoEWx0tWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUPkKjg+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUPkKjg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A62A1F000FF;
	Wed, 23 Sep 2026 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175352;
	bh=6htptO6GGMM8jv/CHvMBOmCQKgj1NoPdpl+k5ppLu9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUPkKjg+U8b0Rhz/sHFJfJujqNop13o/8x4RbGu/rmQ+cE4VfwGkmZy+UbGG0VS0v
	 /FuAhxOm3hP07Ahq6lDJvlVwpN8IUdnn6HWkF6iZbHCcQgaDpLQ82wlhEZsevWOdO7
	 lKWLBTh1KWweDVbcZ+c922UCoKgllXt8CB57mCGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 389/398] wifi: ipw2x00: Use michael_mic() from cfg80211
Date: Wed, 23 Sep 2026 16:07:43 +0200
Message-ID: <20260923140653.551268111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 32a0e1c63cdfaa9a6f1405b552b5f9eb2be61c59 ]

Just use the michael_mic() function from cfg80211 instead of a local
implementation of it using the crypto_shash API.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/20260408030651.80336-6-ebiggers@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 06f42accaf3c ("wifi: libipw: reject TKIP frames without a full MIC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/ipw2x00/Kconfig              |    1 
 drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c |  120 ----------------
 2 files changed, 5 insertions(+), 116 deletions(-)

--- a/drivers/net/wireless/intel/ipw2x00/Kconfig
+++ b/drivers/net/wireless/intel/ipw2x00/Kconfig
@@ -154,7 +154,6 @@ config LIBIPW
 	depends on PCI && CFG80211
 	select WIRELESS_EXT
 	select CRYPTO
-	select CRYPTO_MICHAEL_MIC
 	select CRYPTO_LIB_ARC4
 	select CRC32
 	help
--- a/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
@@ -25,8 +25,6 @@
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
 #include <crypto/arc4.h>
-#include <crypto/hash.h>
-#include <linux/crypto.h>
 #include <linux/crc32.h>
 #include "libipw.h"
 
@@ -57,11 +55,6 @@ struct libipw_tkip_data {
 
 	struct arc4_ctx rx_ctx_arc4;
 	struct arc4_ctx tx_ctx_arc4;
-	struct crypto_shash *rx_tfm_michael;
-	struct crypto_shash *tx_tfm_michael;
-
-	/* scratch buffers for virt_to_page() (crypto API) */
-	u8 rx_hdr[16], tx_hdr[16];
 
 	unsigned long flags;
 };
@@ -89,41 +82,14 @@ static void *libipw_tkip_init(int key_id
 
 	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
-		goto fail;
+		return priv;
 
 	priv->key_idx = key_idx;
-
-	priv->tx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
-	if (IS_ERR(priv->tx_tfm_michael)) {
-		priv->tx_tfm_michael = NULL;
-		goto fail;
-	}
-
-	priv->rx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
-	if (IS_ERR(priv->rx_tfm_michael)) {
-		priv->rx_tfm_michael = NULL;
-		goto fail;
-	}
-
 	return priv;
-
-      fail:
-	if (priv) {
-		crypto_free_shash(priv->tx_tfm_michael);
-		crypto_free_shash(priv->rx_tfm_michael);
-		kfree(priv);
-	}
-
-	return NULL;
 }
 
 static void libipw_tkip_deinit(void *priv)
 {
-	struct libipw_tkip_data *_priv = priv;
-	if (_priv) {
-		crypto_free_shash(_priv->tx_tfm_michael);
-		crypto_free_shash(_priv->rx_tfm_michael);
-	}
 	kfree_sensitive(priv);
 }
 
@@ -464,73 +430,6 @@ static int libipw_tkip_decrypt(struct sk
 	return keyidx;
 }
 
-static int libipw_michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
-		       u8 *data, size_t data_len, u8 *mic)
-{
-	SHASH_DESC_ON_STACK(desc, tfm_michael);
-	int err;
-
-	if (tfm_michael == NULL) {
-		pr_warn("%s(): tfm_michael == NULL\n", __func__);
-		return -1;
-	}
-
-	desc->tfm = tfm_michael;
-
-	if (crypto_shash_setkey(tfm_michael, key, 8))
-		return -1;
-
-	err = crypto_shash_init(desc);
-	if (err)
-		goto out;
-	err = crypto_shash_update(desc, hdr, 16);
-	if (err)
-		goto out;
-	err = crypto_shash_update(desc, data, data_len);
-	if (err)
-		goto out;
-	err = crypto_shash_final(desc, mic);
-
-out:
-	shash_desc_zero(desc);
-	return err;
-}
-
-static void michael_mic_hdr(struct sk_buff *skb, u8 * hdr)
-{
-	struct ieee80211_hdr *hdr11;
-
-	hdr11 = (struct ieee80211_hdr *)skb->data;
-
-	switch (le16_to_cpu(hdr11->frame_control) &
-		(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) {
-	case IEEE80211_FCTL_TODS:
-		memcpy(hdr, hdr11->addr3, ETH_ALEN);	/* DA */
-		memcpy(hdr + ETH_ALEN, hdr11->addr2, ETH_ALEN);	/* SA */
-		break;
-	case IEEE80211_FCTL_FROMDS:
-		memcpy(hdr, hdr11->addr1, ETH_ALEN);	/* DA */
-		memcpy(hdr + ETH_ALEN, hdr11->addr3, ETH_ALEN);	/* SA */
-		break;
-	case IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS:
-		memcpy(hdr, hdr11->addr3, ETH_ALEN);	/* DA */
-		memcpy(hdr + ETH_ALEN, hdr11->addr4, ETH_ALEN);	/* SA */
-		break;
-	default:
-		memcpy(hdr, hdr11->addr1, ETH_ALEN);	/* DA */
-		memcpy(hdr + ETH_ALEN, hdr11->addr2, ETH_ALEN);	/* SA */
-		break;
-	}
-
-	if (ieee80211_is_data_qos(hdr11->frame_control)) {
-		hdr[12] = le16_to_cpu(*((__le16 *)ieee80211_get_qos_ctl(hdr11)))
-			& IEEE80211_QOS_CTL_TID_MASK;
-	} else
-		hdr[12] = 0;		/* priority */
-
-	hdr[13] = hdr[14] = hdr[15] = 0;	/* reserved */
-}
-
 static int libipw_michael_mic_add(struct sk_buff *skb, int hdr_len,
 				     void *priv)
 {
@@ -544,12 +443,9 @@ static int libipw_michael_mic_add(struct
 		return -1;
 	}
 
-	michael_mic_hdr(skb, tkey->tx_hdr);
 	pos = skb_put(skb, 8);
-	if (libipw_michael_mic(tkey->tx_tfm_michael, &tkey->key[16], tkey->tx_hdr,
-			skb->data + hdr_len, skb->len - 8 - hdr_len, pos))
-		return -1;
-
+	michael_mic(&tkey->key[16], (struct ieee80211_hdr *)skb->data,
+		    skb->data + hdr_len, skb->len - 8 - hdr_len, pos);
 	return 0;
 }
 
@@ -583,10 +479,8 @@ static int libipw_michael_mic_verify(str
 	if (!tkey->key_set)
 		return -1;
 
-	michael_mic_hdr(skb, tkey->rx_hdr);
-	if (libipw_michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
-			skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
-		return -1;
+	michael_mic(&tkey->key[24], (struct ieee80211_hdr *)skb->data,
+		    skb->data + hdr_len, skb->len - 8 - hdr_len, mic);
 	if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {
 		struct ieee80211_hdr *hdr;
 		hdr = (struct ieee80211_hdr *)skb->data;
@@ -614,17 +508,13 @@ static int libipw_tkip_set_key(void *key
 {
 	struct libipw_tkip_data *tkey = priv;
 	int keyidx;
-	struct crypto_shash *tfm = tkey->tx_tfm_michael;
 	struct arc4_ctx *tfm2 = &tkey->tx_ctx_arc4;
-	struct crypto_shash *tfm3 = tkey->rx_tfm_michael;
 	struct arc4_ctx *tfm4 = &tkey->rx_ctx_arc4;
 
 	keyidx = tkey->key_idx;
 	memset(tkey, 0, sizeof(*tkey));
 	tkey->key_idx = keyidx;
-	tkey->tx_tfm_michael = tfm;
 	tkey->tx_ctx_arc4 = *tfm2;
-	tkey->rx_tfm_michael = tfm3;
 	tkey->rx_ctx_arc4 = *tfm4;
 	if (len == TKIP_KEY_LEN) {
 		memcpy(tkey->key, key, TKIP_KEY_LEN);


