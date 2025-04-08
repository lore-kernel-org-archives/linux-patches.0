Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585AD26156E;
	Tue,  8 Apr 2025 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114485; cv=none; b=gyJnNHHBu3MIaoKN9dOiq/Fv65prg8TwZqEJE/s4T/LtLrlJVdfeJSb4WnZcuaN+SWMJ7a3v/YOiRNhnuScabbGgCxXUvSD6JqMU54MbMtu93+d/aIECRhz7l1x+7QEcTv+l1OYFQN434/KEiUOaNFCylRKXWdD2wSZKY6zzVmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114485; c=relaxed/simple;
	bh=SEopFO0z25fkxi/+trBXOgigwPwqJoMErZ8rYh+ZVIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIzdlnr7kcUZY2QIA2kHMk9TrCORJEge6CbXGy7M7bQQ/CYDlTLuoq48+tC6f3iCC4uXO7SNQQzxN9zYrNdgbhtvb7mpyZGtBjHAGGG+d058ucLvfCxDyiAGsad7uq9CLpSd8r1mEs8onTwZQyM4YD9FO5MxQZMwZQknHdtTsWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywbvrPFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywbvrPFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5B5C4CEE5;
	Tue,  8 Apr 2025 12:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114485;
	bh=SEopFO0z25fkxi/+trBXOgigwPwqJoMErZ8rYh+ZVIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywbvrPFRjD4lkHnkLyhdbK0tVmHJyB255A9mrfVOinnCz67I6FcWn61WS5bn3e8ME
	 BnsfrJgJzLNcoPdTkiWvTVfa0i8LYldjlHbT5m9J3AKyIrUHAU1fT3Eup5StmujhYO
	 2CqZeuHAk0U3k5zgbzedcE17GbH1gGJYgqLcvKus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 122/499] crypto: tegra - Use separate buffer for setkey
Date: Tue,  8 Apr 2025 12:45:34 +0200
Message-ID: <20250408104854.243247094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit bcfc8fc53f3acb3213fb9d28675244aa4ce208e0 ]

The buffer which sends the commands to host1x was shared for all tasks
in the engine. This causes a problem with the setkey() function as it
gets called asynchronous to the crypto engine queue. Modifying the same
cmdbuf in setkey() will corrupt the ongoing host1x task and in turn
break the encryption/decryption operation. Hence use a separate cmdbuf
for setkey().

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 16 ++++++++--------
 drivers/crypto/tegra/tegra-se-hash.c | 13 +++++++------
 drivers/crypto/tegra/tegra-se-key.c  | 10 ++++++++--
 drivers/crypto/tegra/tegra-se-main.c | 16 ++++++++++++----
 drivers/crypto/tegra/tegra-se.h      |  3 ++-
 5 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index d734c9a567868..7da7e169a314b 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -282,7 +282,7 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 
 	/* Prepare the command and submit for execution */
 	cmdlen = tegra_aes_prep_cmd(ctx, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 
 	/* Copy the result */
 	tegra_aes_update_iv(req, ctx);
@@ -719,7 +719,7 @@ static int tegra_gcm_do_gmac(struct tegra_aead_ctx *ctx, struct tegra_aead_reqct
 
 	cmdlen = tegra_gmac_prep_cmd(ctx, rctx);
 
-	return tegra_se_host1x_submit(se, cmdlen);
+	return tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 }
 
 static int tegra_gcm_do_crypt(struct tegra_aead_ctx *ctx, struct tegra_aead_reqctx *rctx)
@@ -736,7 +736,7 @@ static int tegra_gcm_do_crypt(struct tegra_aead_ctx *ctx, struct tegra_aead_reqc
 
 	/* Prepare command and submit */
 	cmdlen = tegra_gcm_crypt_prep_cmd(ctx, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 	if (ret)
 		return ret;
 
@@ -759,7 +759,7 @@ static int tegra_gcm_do_final(struct tegra_aead_ctx *ctx, struct tegra_aead_reqc
 
 	/* Prepare command and submit */
 	cmdlen = tegra_gcm_prep_final_cmd(se, cpuvaddr, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 	if (ret)
 		return ret;
 
@@ -891,7 +891,7 @@ static int tegra_ccm_do_cbcmac(struct tegra_aead_ctx *ctx, struct tegra_aead_req
 	/* Prepare command and submit */
 	cmdlen = tegra_cbcmac_prep_cmd(ctx, rctx);
 
-	return tegra_se_host1x_submit(se, cmdlen);
+	return tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 }
 
 static int tegra_ccm_set_msg_len(u8 *block, unsigned int msglen, int csize)
@@ -1098,7 +1098,7 @@ static int tegra_ccm_do_ctr(struct tegra_aead_ctx *ctx, struct tegra_aead_reqctx
 
 	/* Prepare command and submit */
 	cmdlen = tegra_ctr_prep_cmd(ctx, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 	if (ret)
 		return ret;
 
@@ -1519,8 +1519,8 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 		tegra_cmac_paste_result(ctx->se, rctx);
 
 	cmdlen = tegra_cmac_prep_cmd(ctx, rctx);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 
-	ret = tegra_se_host1x_submit(se, cmdlen);
 	/*
 	 * If this is not the final update, copy the intermediate results
 	 * from the registers so that it can be used in the next 'update'
@@ -1553,7 +1553,7 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 
 	/* Prepare command and submit */
 	cmdlen = tegra_cmac_prep_cmd(ctx, rctx);
-	ret = tegra_se_host1x_submit(se, cmdlen);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 	if (ret)
 		goto out;
 
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 0b5cdd5676b17..c7b2a062a03c0 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -300,8 +300,9 @@ static int tegra_sha_do_update(struct ahash_request *req)
 {
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct tegra_se *se = ctx->se;
 	unsigned int nblks, nresidue, size, ret;
-	u32 *cpuvaddr = ctx->se->cmdbuf->addr;
+	u32 *cpuvaddr = se->cmdbuf->addr;
 
 	nresidue = (req->nbytes + rctx->residue.size) % rctx->blk_size;
 	nblks = (req->nbytes + rctx->residue.size) / rctx->blk_size;
@@ -353,11 +354,11 @@ static int tegra_sha_do_update(struct ahash_request *req)
 	 * This is to support the import/export functionality.
 	 */
 	if (!(rctx->task & SHA_FIRST))
-		tegra_sha_paste_hash_result(ctx->se, rctx);
+		tegra_sha_paste_hash_result(se, rctx);
 
-	size = tegra_sha_prep_cmd(ctx->se, cpuvaddr, rctx);
+	size = tegra_sha_prep_cmd(se, cpuvaddr, rctx);
 
-	ret = tegra_se_host1x_submit(ctx->se, size);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, size);
 
 	/*
 	 * If this is not the final update, copy the intermediate results
@@ -365,7 +366,7 @@ static int tegra_sha_do_update(struct ahash_request *req)
 	 * call. This is to support the import/export functionality.
 	 */
 	if (!(rctx->task & SHA_FINAL))
-		tegra_sha_copy_hash_result(ctx->se, rctx);
+		tegra_sha_copy_hash_result(se, rctx);
 
 	return ret;
 }
@@ -388,7 +389,7 @@ static int tegra_sha_do_final(struct ahash_request *req)
 
 	size = tegra_sha_prep_cmd(se, cpuvaddr, rctx);
 
-	ret = tegra_se_host1x_submit(se, size);
+	ret = tegra_se_host1x_submit(se, se->cmdbuf, size);
 	if (ret)
 		goto out;
 
diff --git a/drivers/crypto/tegra/tegra-se-key.c b/drivers/crypto/tegra/tegra-se-key.c
index ac14678dbd30d..276b261fb6df1 100644
--- a/drivers/crypto/tegra/tegra-se-key.c
+++ b/drivers/crypto/tegra/tegra-se-key.c
@@ -115,11 +115,17 @@ static int tegra_key_insert(struct tegra_se *se, const u8 *key,
 			    u32 keylen, u16 slot, u32 alg)
 {
 	const u32 *keyval = (u32 *)key;
-	u32 *addr = se->cmdbuf->addr, size;
+	u32 *addr = se->keybuf->addr, size;
+	int ret;
+
+	mutex_lock(&kslt_lock);
 
 	size = tegra_key_prep_ins_cmd(se, addr, keyval, keylen, slot, alg);
+	ret = tegra_se_host1x_submit(se, se->keybuf, size);
 
-	return tegra_se_host1x_submit(se, size);
+	mutex_unlock(&kslt_lock);
+
+	return ret;
 }
 
 void tegra_key_invalidate(struct tegra_se *se, u32 keyid, u32 alg)
diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index 918c0b10614d4..1c94f1de05467 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -141,7 +141,7 @@ static struct tegra_se_cmdbuf *tegra_se_host1x_bo_alloc(struct tegra_se *se, ssi
 	return cmdbuf;
 }
 
-int tegra_se_host1x_submit(struct tegra_se *se, u32 size)
+int tegra_se_host1x_submit(struct tegra_se *se, struct tegra_se_cmdbuf *cmdbuf, u32 size)
 {
 	struct host1x_job *job;
 	int ret;
@@ -160,9 +160,9 @@ int tegra_se_host1x_submit(struct tegra_se *se, u32 size)
 	job->engine_fallback_streamid = se->stream_id;
 	job->engine_streamid_offset = SE_STREAM_ID;
 
-	se->cmdbuf->words = size;
+	cmdbuf->words = size;
 
-	host1x_job_add_gather(job, &se->cmdbuf->bo, size, 0);
+	host1x_job_add_gather(job, &cmdbuf->bo, size, 0);
 
 	ret = host1x_job_pin(job, se->dev);
 	if (ret) {
@@ -220,14 +220,22 @@ static int tegra_se_client_init(struct host1x_client *client)
 		goto syncpt_put;
 	}
 
+	se->keybuf = tegra_se_host1x_bo_alloc(se, SZ_4K);
+	if (!se->keybuf) {
+		ret = -ENOMEM;
+		goto cmdbuf_put;
+	}
+
 	ret = se->hw->init_alg(se);
 	if (ret) {
 		dev_err(se->dev, "failed to register algorithms\n");
-		goto cmdbuf_put;
+		goto keybuf_put;
 	}
 
 	return 0;
 
+keybuf_put:
+	tegra_se_cmdbuf_put(&se->keybuf->bo);
 cmdbuf_put:
 	tegra_se_cmdbuf_put(&se->cmdbuf->bo);
 syncpt_put:
diff --git a/drivers/crypto/tegra/tegra-se.h b/drivers/crypto/tegra/tegra-se.h
index b9dd7ceb8783c..b54aefe717a17 100644
--- a/drivers/crypto/tegra/tegra-se.h
+++ b/drivers/crypto/tegra/tegra-se.h
@@ -420,6 +420,7 @@ struct tegra_se {
 	struct host1x_client client;
 	struct host1x_channel *channel;
 	struct tegra_se_cmdbuf *cmdbuf;
+	struct tegra_se_cmdbuf *keybuf;
 	struct crypto_engine *engine;
 	struct host1x_syncpt *syncpt;
 	struct device *dev;
@@ -502,7 +503,7 @@ void tegra_deinit_hash(struct tegra_se *se);
 int tegra_key_submit(struct tegra_se *se, const u8 *key,
 		     u32 keylen, u32 alg, u32 *keyid);
 void tegra_key_invalidate(struct tegra_se *se, u32 keyid, u32 alg);
-int tegra_se_host1x_submit(struct tegra_se *se, u32 size);
+int tegra_se_host1x_submit(struct tegra_se *se, struct tegra_se_cmdbuf *cmdbuf, u32 size);
 
 /* HOST1x OPCODES */
 static inline u32 host1x_opcode_setpayload(unsigned int payload)
-- 
2.39.5



