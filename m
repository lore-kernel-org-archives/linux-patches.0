Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF9C4C3A9;
	Mon,  8 Jan 2024 15:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAvQ3F5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CDCC433BD;
	Mon,  8 Jan 2024 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726767;
	bh=oO9w2MHzOQFb7LR3wh5a/9M3s2bhymNHvBjetVjT3NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAvQ3F5fepvnGRongv+geY4DCpbGMRmuI7B8PAXmy+UDAxWGNBofKc5DAkNoelELe
	 lR7itXZgfW5XF72HpfI1vjbgBn8A/rLr42GsdRNi7jnWi8o+tdWBxcKnBRplffqqFg
	 Zg7uQygNcDpi+qmC0xIxzySUdw5VVI6/7dI+dOqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/124] crypto: xts - use spawn for underlying single-block cipher
Date: Mon,  8 Jan 2024 16:08:17 +0100
Message-ID: <20240108150606.246216734@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit bb40d32689d73c46de39a0529d551f523f21dc9b ]

Since commit adad556efcdd ("crypto: api - Fix built-in testing
dependency failures"), the following warning appears when booting an
x86_64 kernel that is configured with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and CONFIG_CRYPTO_AES_NI_INTEL=y,
even when CONFIG_CRYPTO_XTS=y and CONFIG_CRYPTO_AES=y:

    alg: skcipher: skipping comparison tests for xts-aes-aesni because xts(ecb(aes-generic)) is unavailable

This is caused by an issue in the xts template where it allocates an
"aes" single-block cipher without declaring a dependency on it via the
crypto_spawn mechanism.  This issue was exposed by the above commit
because it reversed the order that the algorithms are tested in.

Specifically, when "xts(ecb(aes-generic))" is instantiated and tested
during the comparison tests for "xts-aes-aesni", the "xts" template
allocates an "aes" crypto_cipher for encrypting tweaks.  This resolves
to "aes-aesni".  (Getting "aes-aesni" instead of "aes-generic" here is a
bit weird, but it's apparently intended.)  Due to the above-mentioned
commit, the testing of "aes-aesni", and the finalization of its
registration, now happens at this point instead of before.  At the end
of that, crypto_remove_spawns() unregisters all algorithm instances that
depend on a lower-priority "aes" implementation such as "aes-generic"
but that do not depend on "aes-aesni".  However, because "xts" does not
use the crypto_spawn mechanism for its "aes", its dependency on
"aes-aesni" is not recognized by crypto_remove_spawns().  Thus,
crypto_remove_spawns() unexpectedly unregisters "xts(ecb(aes-generic))".

Fix this issue by making the "xts" template use the crypto_spawn
mechanism for its "aes" dependency, like what other templates do.

Note, this fix could be applied as far back as commit f1c131b45410
("crypto: xts - Convert to skcipher").  However, the issue only got
exposed by the much more recent changes to how the crypto API runs the
self-tests, so there should be no need to backport this to very old
kernels.  Also, an alternative fix would be to flip the list iteration
order in crypto_start_tests() to restore the original testing order.
I'm thinking we should do that too, since the original order seems more
natural, but it shouldn't be relied on for correctness.

Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/xts.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 548b302c6c6a0..038f60dd512d9 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -28,7 +28,7 @@ struct xts_tfm_ctx {
 
 struct xts_instance_ctx {
 	struct crypto_skcipher_spawn spawn;
-	char name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_cipher_spawn tweak_spawn;
 };
 
 struct xts_request_ctx {
@@ -306,7 +306,7 @@ static int xts_init_tfm(struct crypto_skcipher *tfm)
 
 	ctx->child = child;
 
-	tweak = crypto_alloc_cipher(ictx->name, 0, 0);
+	tweak = crypto_spawn_cipher(&ictx->tweak_spawn);
 	if (IS_ERR(tweak)) {
 		crypto_free_skcipher(ctx->child);
 		return PTR_ERR(tweak);
@@ -333,11 +333,13 @@ static void xts_free_instance(struct skcipher_instance *inst)
 	struct xts_instance_ctx *ictx = skcipher_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ictx->spawn);
+	crypto_drop_cipher(&ictx->tweak_spawn);
 	kfree(inst);
 }
 
 static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
+	char name[CRYPTO_MAX_ALG_NAME];
 	struct skcipher_instance *inst;
 	struct xts_instance_ctx *ctx;
 	struct skcipher_alg *alg;
@@ -363,13 +365,13 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 				   cipher_name, 0, mask);
 	if (err == -ENOENT) {
 		err = -ENAMETOOLONG;
-		if (snprintf(ctx->name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
+		if (snprintf(name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
 
 		err = crypto_grab_skcipher(&ctx->spawn,
 					   skcipher_crypto_instance(inst),
-					   ctx->name, 0, mask);
+					   name, 0, mask);
 	}
 
 	if (err)
@@ -398,23 +400,28 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (!strncmp(cipher_name, "ecb(", 4)) {
 		int len;
 
-		len = strscpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
+		len = strscpy(name, cipher_name + 4, sizeof(name));
 		if (len < 2)
 			goto err_free_inst;
 
-		if (ctx->name[len - 1] != ')')
+		if (name[len - 1] != ')')
 			goto err_free_inst;
 
-		ctx->name[len - 1] = 0;
+		name[len - 1] = 0;
 
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-			     "xts(%s)", ctx->name) >= CRYPTO_MAX_ALG_NAME) {
+			     "xts(%s)", name) >= CRYPTO_MAX_ALG_NAME) {
 			err = -ENAMETOOLONG;
 			goto err_free_inst;
 		}
 	} else
 		goto err_free_inst;
 
+	err = crypto_grab_cipher(&ctx->tweak_spawn,
+				 skcipher_crypto_instance(inst), name, 0, mask);
+	if (err)
+		goto err_free_inst;
+
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
-- 
2.43.0



