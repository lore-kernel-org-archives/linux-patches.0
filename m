Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69710269B0D;
	Tue,  8 Apr 2025 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114541; cv=none; b=gCV3csULoyzYafmOlLMJTrf+zl2pmCjGKuPTXyI7s5cY1YJgJqsXa3gdBoLrh0IohTmtKaPphi/Qmvgj4M8+pSP5apqewnQ5uFapgZlf+esSRvVIHmt31MQXqIhggkTbquYPZVRLW1BhKVgI6t6GeQkPzi+9GZ178XGfb+ptimc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114541; c=relaxed/simple;
	bh=3GtJFvk6iAlg+fhcsLlLxP2ix1qA9V6mwlz8UFgFQmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbyOkXnMFOBhebsMkZuEvrwUzYwDZbICZIi5OfLpJc+VX3c+xevN9+8aAMy1oJs4giPPJ1y2hZoDY566SL2qA0uCejrBPAq/4c1x6zFdZaFUmtFbOueEDt366nMJN9YD9CWsC3/NriPIT5YPohHC1JDkZ7mZJZfMdZ3woCn251E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/L1bMKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/L1bMKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C70C4CEE5;
	Tue,  8 Apr 2025 12:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114541;
	bh=3GtJFvk6iAlg+fhcsLlLxP2ix1qA9V6mwlz8UFgFQmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/L1bMKMbjMWYEHsz8/aljsaRXOdLjYhMppvZVa7bk3YvN0kpR17mb3oeg1nbF7Zr
	 eD0egu8i4H6Avg8dyEfjicXldaqCawcCV8OkR/zSZYJtzBbRfKU+L9KnL/SLfkFnKX
	 2WUmADjM5Fh/x0TfZtmp+AEHpiPiOQ2Jg4yk2TpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 145/499] crypto: tegra - Fix CMAC intermediate result handling
Date: Tue,  8 Apr 2025 12:45:57 +0200
Message-ID: <20250408104854.805275058@linuxfoundation.org>
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

[ Upstream commit ce390d6c2675d2e24d798169a1a0e3cdbc076907 ]

Saving and restoring of the intermediate results are needed if there is
context switch caused by another ongoing request on the same engine.
This is therefore not only to support import/export functionality.
Hence, save and restore the intermediate result for every non-first task.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 5d8237cda58f0..cdcf05e235cad 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1541,9 +1541,8 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 	rctx->residue.size = nresidue;
 
 	/*
-	 * If this is not the first 'update' call, paste the previous copied
+	 * If this is not the first task, paste the previous copied
 	 * intermediate results to the registers so that it gets picked up.
-	 * This is to support the import/export functionality.
 	 */
 	if (!(rctx->task & SHA_FIRST))
 		tegra_cmac_paste_result(ctx->se, rctx);
@@ -1551,13 +1550,7 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 	cmdlen = tegra_cmac_prep_cmd(ctx, rctx);
 	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
 
-	/*
-	 * If this is not the final update, copy the intermediate results
-	 * from the registers so that it can be used in the next 'update'
-	 * call. This is to support the import/export functionality.
-	 */
-	if (!(rctx->task & SHA_FINAL))
-		tegra_cmac_copy_result(ctx->se, rctx);
+	tegra_cmac_copy_result(ctx->se, rctx);
 
 	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
 			  rctx->datbuf.buf, rctx->datbuf.addr);
@@ -1594,6 +1587,13 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 	rctx->total_len += rctx->residue.size;
 	rctx->config = tegra234_aes_cfg(SE_ALG_CMAC, 0);
 
+	/*
+	 * If this is not the first task, paste the previous copied
+	 * intermediate results to the registers so that it gets picked up.
+	 */
+	if (!(rctx->task & SHA_FIRST))
+		tegra_cmac_paste_result(ctx->se, rctx);
+
 	/* Prepare command and submit */
 	cmdlen = tegra_cmac_prep_cmd(ctx, rctx);
 	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
-- 
2.39.5



