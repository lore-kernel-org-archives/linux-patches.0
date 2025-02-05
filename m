Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1C71553AB;
	Wed,  5 Feb 2025 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765731; cv=none; b=bfrL13kypgNDl2DWLN/1fVo3WaQRXN+HFffvHdshPux7U5bxgT00coNI9vQOR786Ht9IxXxv8zfpmzNv4XDtbDsS1OZQXsR+D11BefL/RBTIdsSHHr+RkjwoxpJTh0NaDYOFafwYvhRL56qkayeB1YyomHAaD7anck6XOnBs0js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765731; c=relaxed/simple;
	bh=UGKCsNWX5ootJjCOiX8vpugdK+5OZsm5FtG+Xy6TyrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sw3aNfM07f3e02D/ONYwKhnWcn0CsHltcRoW/5WciIvGZwc2EZ8H9gI4UdbhnXIXgFMu1gFj2mRinhqeGmy9i0pzyqSZYci6a5dxOUeNErD3w2Kv53eA+VKv2r4mX2VFzL0T9XeB6ff/faVY+JNxxJKOf2XkbEtbbSmFLJ+7sHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDqDQjoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDqDQjoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818A6C4CED1;
	Wed,  5 Feb 2025 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765731;
	bh=UGKCsNWX5ootJjCOiX8vpugdK+5OZsm5FtG+Xy6TyrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDqDQjoG5ZKgMCKYMYAuFkHFwGXiwMXxvm2y8a0Q1RHAuLYztn5ZEgCCuuTpWqf4f
	 1etH+qHwsRohP7KRFQqlGREPrsp5KgdzVz04rjtL8cPTI/Spty/V1xJ8FxmP1SBFUY
	 BgnTgxjvsURzlMU9IjDtAc1AHiiLOfeXZD4YNhhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/590] crypto: tegra - do not transfer req when tegra init fails
Date: Wed,  5 Feb 2025 14:40:02 +0100
Message-ID: <20250205134504.730274142@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 15589bda46830695a3261518bb7627afac61f519 ]

The tegra_cmac_init or tegra_sha_init function may return an error when
memory is exhausted. It should not transfer the request when they return
an error.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Akhil R <akhilrajeev@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 7 +++++--
 drivers/crypto/tegra/tegra-se-hash.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index ae7a0f8435fc6..3106fd1e84b91 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1752,10 +1752,13 @@ static int tegra_cmac_digest(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
+	int ret;
 
-	tegra_cmac_init(req);
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
+	ret = tegra_cmac_init(req);
+	if (ret)
+		return ret;
 
+	rctx->task |= SHA_UPDATE | SHA_FINAL;
 	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
 }
 
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 4d4bd727f4986..0b5cdd5676b17 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -615,13 +615,16 @@ static int tegra_sha_digest(struct ahash_request *req)
 	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
+	int ret;
 
 	if (ctx->fallback)
 		return tegra_sha_fallback_digest(req);
 
-	tegra_sha_init(req);
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
+	ret = tegra_sha_init(req);
+	if (ret)
+		return ret;
 
+	rctx->task |= SHA_UPDATE | SHA_FINAL;
 	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
 }
 
-- 
2.39.5



