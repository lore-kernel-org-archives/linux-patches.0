Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2826814900F;
	Tue, 23 Jan 2024 00:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969183; cv=none; b=ZG3cFDR1CxqHKRH426joO1eTeGSTaydZdWSnNR6OMIMmTfMIdHuxMuO/lwRjXadZ2UcfbGT1BCP7qQMkuGsb6+gYsuLhJdiSt799ARyj0n3EzOyiprW+DIjMZBzntqqs6oUEQnaCljQl90lZ/l2klTZkQsC+Syy6HFbnvk2LILE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969183; c=relaxed/simple;
	bh=qkhnS+EZOrVgptyyRZNovtxubfyR78zJJaerIlxUgo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfledcIHpXuQXeIqyiDWsKjcL8/xAYLQ9e9IBxGEV1HObWnLyOVALZdwb18LEuXuhaowXdKl1ye/xJWNuV1/QdEcqlRGucR1VOQC8DpEQSKtbRlPgRFcmm5MPw8Z+jonR99s7ClodCjM7jm8pAzB0tFQAU+3Gils7DhTiPGp/9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksOBcYG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksOBcYG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1F1C43390;
	Tue, 23 Jan 2024 00:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969183;
	bh=qkhnS+EZOrVgptyyRZNovtxubfyR78zJJaerIlxUgo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksOBcYG2KkQ37JsUm9KXZ3HneeAl0RSlna2Dpfg8xtWvxMStGH2K582Iw0LOPx3ig
	 QncOnWhHjVZTr1PWjzZYqUQjWYX4Ph02jHGIyX8cVIHIlY/VmjrkGPpJa37+fsa8gM
	 +FoAZx+nf75qHxVh02190wmJmrcyGWjM9LSdXzi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 057/641] crypto: sahara - remove FLAGS_NEW_KEY logic
Date: Mon, 22 Jan 2024 15:49:21 -0800
Message-ID: <20240122235819.858231505@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit 8fd183435728b139248a77978ea3732039341779 ]

Remove the FLAGS_NEW_KEY logic as it has the following issues:
- the wrong key may end up being used when there are multiple data streams:
       t1            t2
    setkey()
    encrypt()
                   setkey()
                   encrypt()

    encrypt() <--- key from t2 is used
- switching between encryption and decryption with the same key is not
  possible, as the hdr flags are only updated when a new setkey() is
  performed

With this change, the key is always sent along with the cryptdata when
performing encryption/decryption operations.

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 02065131c300..5cc1cd59a384 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -43,7 +43,6 @@
 #define FLAGS_MODE_MASK		0x000f
 #define FLAGS_ENCRYPT		BIT(0)
 #define FLAGS_CBC		BIT(1)
-#define FLAGS_NEW_KEY		BIT(3)
 
 #define SAHARA_HDR_BASE			0x00800000
 #define SAHARA_HDR_SKHA_ALG_AES	0
@@ -141,8 +140,6 @@ struct sahara_hw_link {
 };
 
 struct sahara_ctx {
-	unsigned long flags;
-
 	/* AES-specific context */
 	int keylen;
 	u8 key[AES_KEYSIZE_128];
@@ -447,26 +444,22 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	int i, j;
 	int idx = 0;
 
-	/* Copy new key if necessary */
-	if (ctx->flags & FLAGS_NEW_KEY) {
-		memcpy(dev->key_base, ctx->key, ctx->keylen);
-		ctx->flags &= ~FLAGS_NEW_KEY;
+	memcpy(dev->key_base, ctx->key, ctx->keylen);
 
-		if (dev->flags & FLAGS_CBC) {
-			dev->hw_desc[idx]->len1 = AES_BLOCK_SIZE;
-			dev->hw_desc[idx]->p1 = dev->iv_phys_base;
-		} else {
-			dev->hw_desc[idx]->len1 = 0;
-			dev->hw_desc[idx]->p1 = 0;
-		}
-		dev->hw_desc[idx]->len2 = ctx->keylen;
-		dev->hw_desc[idx]->p2 = dev->key_phys_base;
-		dev->hw_desc[idx]->next = dev->hw_phys_desc[1];
+	if (dev->flags & FLAGS_CBC) {
+		dev->hw_desc[idx]->len1 = AES_BLOCK_SIZE;
+		dev->hw_desc[idx]->p1 = dev->iv_phys_base;
+	} else {
+		dev->hw_desc[idx]->len1 = 0;
+		dev->hw_desc[idx]->p1 = 0;
+	}
+	dev->hw_desc[idx]->len2 = ctx->keylen;
+	dev->hw_desc[idx]->p2 = dev->key_phys_base;
+	dev->hw_desc[idx]->next = dev->hw_phys_desc[1];
+	dev->hw_desc[idx]->hdr = sahara_aes_key_hdr(dev);
 
-		dev->hw_desc[idx]->hdr = sahara_aes_key_hdr(dev);
+	idx++;
 
-		idx++;
-	}
 
 	dev->nb_in_sg = sg_nents_for_len(dev->in_sg, dev->total);
 	if (dev->nb_in_sg < 0) {
@@ -608,7 +601,6 @@ static int sahara_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	/* SAHARA only supports 128bit keys */
 	if (keylen == AES_KEYSIZE_128) {
 		memcpy(ctx->key, key, keylen);
-		ctx->flags |= FLAGS_NEW_KEY;
 		return 0;
 	}
 
-- 
2.43.0



