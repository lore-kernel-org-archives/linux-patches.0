Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D092046BA;
	Wed, 20 May 2026 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297958; cv=none; b=cR0JnB7CUTDA1CaD4lLT+D55a2/t+HtxtfI3ieANbo+Glmk37oVWHEC9eBaqUrkBpfMTF52BsPvWjEpCKOkmRWDJKuDryPRwedmyOhkm724dy2Yeok13VDOcnyd9rTHu3tJJjj6lLTjsnVUMmdKQ/K63tHjhkxPEPSiLucTMyOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297958; c=relaxed/simple;
	bh=VJ0wFEwOOCWBoVAHOFgOdp+8yFtAec1u2Rus+4Mbdl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSh3M5tF170VOlQ3uWgWQz3bF+4Uu2aZfojQe7lOg2BSoJDsa5RdXZYGyEv7rhnO3SYms0U5Z3uSIFJVZnwoa/7QowzaiOEX2AjJlrqbXc+W9UFI1rN+R2I8yfab+Xklyga4v/y11d3WBdhGm/e1Jb8DJAUsGYJwgqhTz6ysB4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUGueASr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUGueASr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1131F000E9;
	Wed, 20 May 2026 17:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297956;
	bh=+pdAbwMX264iI/zzUGoiQVgk0+SKVBiQDRfYHR7chSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUGueASrf5YAc6vIXDL9UXDKRY8OlxCHmO3jZr6lKTtYajcmwlj6lDaJM5IFjnYjc
	 TsAyOC2yh/Ky8CYsttphD/4e6NdPVerYhClshsZXMigLpnvrnp4dyzuaYqgOOPK17c
	 rU0hfg8tWMV2EKfHV6skm1iE/d+EwTkG/vg21cBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 229/957] crypto: tegra - Disable softirqs before finalizing request
Date: Wed, 20 May 2026 18:11:52 +0200
Message-ID: <20260520162139.504593488@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 2aeec9af775fb53aa086419b953302c6f4ad4984 ]

Softirqs must be disabled when calling the finalization fucntion on
a request.

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 9 +++++++++
 drivers/crypto/tegra/tegra-se-hash.c | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 9210cceb4b7b2..30c78afe3dea6 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -4,6 +4,7 @@
  * Crypto driver to handle block cipher algorithms using NVIDIA Security Engine.
  */
 
+#include <linux/bottom_half.h>
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
@@ -333,7 +334,9 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 		tegra_key_invalidate_reserved(ctx->se, key2_id, ctx->alg);
 
 out_finalize:
+	local_bh_disable();
 	crypto_finalize_skcipher_request(se->engine, req, ret);
+	local_bh_enable();
 
 	return 0;
 }
@@ -1262,7 +1265,9 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 		tegra_key_invalidate_reserved(ctx->se, rctx->key_id, ctx->alg);
 
 out_finalize:
+	local_bh_disable();
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
+	local_bh_enable();
 
 	return 0;
 }
@@ -1348,7 +1353,9 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 		tegra_key_invalidate_reserved(ctx->se, rctx->key_id, ctx->alg);
 
 out_finalize:
+	local_bh_disable();
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
+	local_bh_enable();
 
 	return 0;
 }
@@ -1746,7 +1753,9 @@ static int tegra_cmac_do_one_req(struct crypto_engine *engine, void *areq)
 	if (tegra_key_is_reserved(rctx->key_id))
 		tegra_key_invalidate_reserved(ctx->se, rctx->key_id, ctx->alg);
 
+	local_bh_disable();
 	crypto_finalize_hash_request(se->engine, req, ret);
+	local_bh_enable();
 
 	return 0;
 }
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 06bb5bf0fa335..23d549801612e 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -4,6 +4,7 @@
  * Crypto driver to handle HASH algorithms using NVIDIA Security Engine.
  */
 
+#include <linux/bottom_half.h>
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
@@ -546,7 +547,9 @@ static int tegra_sha_do_one_req(struct crypto_engine *engine, void *areq)
 	}
 
 out:
+	local_bh_disable();
 	crypto_finalize_hash_request(se->engine, req, ret);
+	local_bh_enable();
 
 	return 0;
 }
-- 
2.53.0



