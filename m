Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6A4264A76;
	Tue,  8 Apr 2025 11:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111224; cv=none; b=sNMfmE8BMQNkugyZyNA8JTHOimrvTwmfD6Ug1N3YU5AvBHA0bqL2VonSbsKgtuq1D/l8ZlLyo6/DBCoISqTDHe1hlQg41cJCxrni6kWbxP5Ka3Cu0keDWYoqe71C7rzmSnoWs7UYn0Mf142qIv+Ik3YPwbPBcDFNghJjfGtiDKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111224; c=relaxed/simple;
	bh=Vnut/WU+GnQpvsDFZnAULrdQelnAsi8vYFPO5w1CXKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fbvq3lAbbX/PZB0eF3luknxtXE0ArA8ryGxJwICjHSjG/Et425vrB2GceTwYL2jPB8KoHJpF9HHP4KDkXPhBdwht2tfzeunRIhNW0HG3Q72wOpGeu4cbrHR5/D8ieqWZVOxHMlsYZwDLKupF2lRYFwRnisLoPnVjOljhyFH4gpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtU1awvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtU1awvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F4FC4CEE5;
	Tue,  8 Apr 2025 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111224;
	bh=Vnut/WU+GnQpvsDFZnAULrdQelnAsi8vYFPO5w1CXKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtU1awvkoxqJzo/laKRRPkLFjaz6lYQ7P73mjkKjYIMwPvHVYesimq7axtiSopgMR
	 3+dqH+Vy6mk3zyp41Lo69Vd6xQMs4WJZdQVw9iR++/xDfRcAthbbcpd/50SkJ6QMMn
	 FKLan547B2uu/hmBz01LtssqNHRdphKkgKz7i8RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 355/731] crypto: tegra - check return value for hash do_one_req
Date: Tue,  8 Apr 2025 12:44:12 +0200
Message-ID: <20250408104922.529625447@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: ff4b7df0b511 ("crypto: tegra - Fix HASH intermediate result handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 10 ++++++++--
 drivers/crypto/tegra/tegra-se-hash.c |  7 +++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index c2b8891a905dc..dd147fa4af977 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1596,18 +1596,24 @@ static int tegra_cmac_do_one_req(struct crypto_engine *engine, void *areq)
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
index b4a179a8febd5..0ae5ce67bdd04 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -437,14 +437,21 @@ static int tegra_sha_do_one_req(struct crypto_engine *engine, void *areq)
 
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



