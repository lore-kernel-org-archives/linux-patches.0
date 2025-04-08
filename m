Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF47026A1D7;
	Tue,  8 Apr 2025 12:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116378; cv=none; b=ZnNDQUNIhdI31T3aFHW6iDeM9fDLYEj3ht3yWDAnkRPURbmktGbsUOA6JRv9wuYLi5I6JlVEBRfayTJpGot39Pz49nPUYi5ciQrWVOKIy2bIwBFJuJmHh2lKFlBmWFVGdlpPAWrwcmaA1l3PnAF29hHFg8S6W5x16mN17c7zZ8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116378; c=relaxed/simple;
	bh=upB4SGusFd5PqQh2cWfFri5PZxlCVoS36Df7Gw41MRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0Q8b96VRlKoRQaQcEUaZEl69w9yHSL1obC2ldUyyxzBbH+qds/p7Gmr7ZwC1EBzAPmcvm/yNsE9gyYIzQD7my7m+S+5OxkQWKk1FNe3Gn7fmJpcEYkOAPjajmA7VasPw1P6K0dMCzaESX0TLzlYtDWLKqBvQLjloiBs2lXRpOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTNexVpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTNexVpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF12C4CEE7;
	Tue,  8 Apr 2025 12:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116377;
	bh=upB4SGusFd5PqQh2cWfFri5PZxlCVoS36Df7Gw41MRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTNexVprxfNtsY7rStfHaQfsEDsXlSWStWV61VnLpn4hMLihDYrGLkOjtsBwkUYOC
	 iWfqNRIhgKCbPJ/dfURtu2uS6RyYqNerax5U5EUbOcyhuOoGFJMa/S/RQGmsgUpbTp
	 Z91u64vAfuY0GKROcVefCHUEue9CDaIwbGBSx47Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/423] crypto: tegra - Fix CMAC intermediate result handling
Date: Tue,  8 Apr 2025 12:47:24 +0200
Message-ID: <20250408104848.476765585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index 06f60260e0a0f..3308962f11c59 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1513,9 +1513,8 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 	rctx->residue.size = nresidue;
 
 	/*
-	 * If this is not the first 'update' call, paste the previous copied
+	 * If this is not the first task, paste the previous copied
 	 * intermediate results to the registers so that it gets picked up.
-	 * This is to support the import/export functionality.
 	 */
 	if (!(rctx->task & SHA_FIRST))
 		tegra_cmac_paste_result(ctx->se, rctx);
@@ -1523,13 +1522,7 @@ static int tegra_cmac_do_update(struct ahash_request *req)
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
 
 	return ret;
 }
@@ -1553,6 +1546,13 @@ static int tegra_cmac_do_final(struct ahash_request *req)
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



