Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA50150A8E;
	Tue, 23 Jan 2024 00:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970510; cv=none; b=HkC38DvZqde941BxtYE9EeUzjuS4mxBBaciLbtxGroqEfpp8z3EtktbH3Xy2v62Hib85UMdfvv6TCGd79Mw3P707dQgoNCeHYmwVduZtOdxiu8Ti74WYbEs2GfBRdIC/c1gp/o6Cp3Yu/l0s7yxHqBjleoSX2gRg5I38xVPnnZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970510; c=relaxed/simple;
	bh=KxSu+EF3nFtWGuE9JK6ua28c+tQ5fKOqSaa/psWJNcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApuglcZjIEGVMZsvdYuZGHVN5x6C/j82ZhYkZRCukMgeRY2q+bQ5Ha9Tuu91deDbSVEUC4B8jHVDMKkGUX4DZ1EV5cqRQL8ZICFNrSt4El8q4G7pG702fK1d+LdfA0WzR3w3f7uLeibRfP3nFPUO3R7tNtIrtGCfvfWVnXowsTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GzD8a+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GzD8a+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237A6C433F1;
	Tue, 23 Jan 2024 00:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970510;
	bh=KxSu+EF3nFtWGuE9JK6ua28c+tQ5fKOqSaa/psWJNcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GzD8a+svWG4LVooWHdToaG9pEgrWNVzYpyQAoZaiqDphcWsuWtQ6eU/fa65d2glQ
	 5IjuwZI3r058iVVKq6ECUD7e3qUbsjJ7kkjpZl8i0PmBRlmRfHFdIws5VErlLFWYx9
	 DYXthXxM46lIvcz1xMndgPmYJtW91RN9BcVKs9Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/417] crypto: sahara - remove FLAGS_NEW_KEY logic
Date: Mon, 22 Jan 2024 15:53:27 -0800
Message-ID: <20240122235752.982997216@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7ab20fb95166..0e30d36b0a71 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -44,7 +44,6 @@
 #define FLAGS_MODE_MASK		0x000f
 #define FLAGS_ENCRYPT		BIT(0)
 #define FLAGS_CBC		BIT(1)
-#define FLAGS_NEW_KEY		BIT(3)
 
 #define SAHARA_HDR_BASE			0x00800000
 #define SAHARA_HDR_SKHA_ALG_AES	0
@@ -142,8 +141,6 @@ struct sahara_hw_link {
 };
 
 struct sahara_ctx {
-	unsigned long flags;
-
 	/* AES-specific context */
 	int keylen;
 	u8 key[AES_KEYSIZE_128];
@@ -448,26 +445,22 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
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
@@ -609,7 +602,6 @@ static int sahara_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	/* SAHARA only supports 128bit keys */
 	if (keylen == AES_KEYSIZE_128) {
 		memcpy(ctx->key, key, keylen);
-		ctx->flags |= FLAGS_NEW_KEY;
 		return 0;
 	}
 
-- 
2.43.0



