Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D143A269D04;
	Tue,  8 Apr 2025 12:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116326; cv=none; b=UHGYfzv8A7+4gc71OnT+edjoMI/OShCQPfArgzgoQkJ7aSfWh7m+kGe7F9383vr8/c8Gp3XU0kuqz43BMlgdELvwv6pm5sp09mMP4T6WTyHeypm9aJIPzxltztd66EgTQc0fVNyJqwmm8SsuGZ8DJ6afhwh5WBz5n0wxCMeah+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116326; c=relaxed/simple;
	bh=UfSnkyoqpnQfB+qnYP10M68WBxoyYYHkiRteD6c74gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfir3sr1OuJk4lwCHFvehYYvn9kVIlewW6TTuPdFxHdwfFthrCYfnxfEcHi6ysveQ0idTPP8wJICSlfEcsR5zt0/CFSaISGpDgVCUh3j8XqAdgy7z1OwExE4Nr/MFaTCHk9WwMS1BO4feq7YEze0y7G5fedP/X7c86B7da6j2+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlHdjs4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlHdjs4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62588C4CEE5;
	Tue,  8 Apr 2025 12:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116326;
	bh=UfSnkyoqpnQfB+qnYP10M68WBxoyYYHkiRteD6c74gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlHdjs4gk+7+bnlfsEACFyDVUAdMA1uIOQLNTPezyUHu6Dee5VWeRLGEM4obU4vDO
	 Np4fAGmiN5SC6DPW3ff2sQsb7aGuoKzb1OgcXfTFKXUtEx/KPY69KpIKHhRUCLVFVZ
	 vF81jQZPT6lxhPUBgeD0lE42yHswnOiM4yLw1lnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/423] crypto: tegra - check return value for hash do_one_req
Date: Tue,  8 Apr 2025 12:47:06 +0200
Message-ID: <20250408104848.065150594@linuxfoundation.org>
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

[ Upstream commit dcf8b7e49b86738296c77fb58c123dd2d74a22a7 ]

Initialize and check the return value in hash *do_one_req() functions
and exit the function if there is an error. This fixes the
'uninitialized variable' warnings reported by testbots.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202412071747.flPux4oB-lkp@intel.com/
Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 10 ++++++++--
 drivers/crypto/tegra/tegra-se-hash.c |  7 +++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index b42f791667c64..06f60260e0a0f 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1581,18 +1581,24 @@ static int tegra_cmac_do_one_req(struct crypto_engine *engine, void *areq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct tegra_se *se = ctx->se;
-	int ret;
+	int ret = 0;
 
 	if (rctx->task & SHA_UPDATE) {
 		ret = tegra_cmac_do_update(req);
+		if (ret)
+			goto out;
+
 		rctx->task &= ~SHA_UPDATE;
 	}
 
 	if (rctx->task & SHA_FINAL) {
 		ret = tegra_cmac_do_final(req);
+		if (ret)
+			goto out;
+
 		rctx->task &= ~SHA_FINAL;
 	}
-
+out:
 	crypto_finalize_hash_request(se->engine, req, ret);
 
 	return 0;
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index c7b2a062a03c0..5aead114bd967 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -417,14 +417,21 @@ static int tegra_sha_do_one_req(struct crypto_engine *engine, void *areq)
 
 	if (rctx->task & SHA_UPDATE) {
 		ret = tegra_sha_do_update(req);
+		if (ret)
+			goto out;
+
 		rctx->task &= ~SHA_UPDATE;
 	}
 
 	if (rctx->task & SHA_FINAL) {
 		ret = tegra_sha_do_final(req);
+		if (ret)
+			goto out;
+
 		rctx->task &= ~SHA_FINAL;
 	}
 
+out:
 	crypto_finalize_hash_request(se->engine, req, ret);
 
 	return 0;
-- 
2.39.5



