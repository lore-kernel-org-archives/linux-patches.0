Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A1C30C624;
	Mon, 13 Oct 2025 15:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369902; cv=none; b=LvFVimv3lPXDxh+BpdpQ2li26G1WPPOSX3ug7mgx6laM+qBNmR1+TN2Lf8x1GNlrrg3zAzSuGuK/XpgWdmzlXll+sQ6tL1WVZUstaz3f+KHEhoOVl0Ma8CqPOSJTO1JzazXbUUaqT80loxn0PDI+hF7l1aV3FTCj0NL0NCn6pA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369902; c=relaxed/simple;
	bh=c3rhlnhUM0nr2ds0vIuwwNPvlP6JJ02Bv0h8FOQynCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cp+FBiOZVkKJDq4CkPyRC0YiMbEn1RyJtzq6BvhpiyvOGld8k4qO+eMyL1SFy/sbNK2pnclLtZz+VdPCxSnI+i/8h4N9LyVsOpHgIvFYp+GbUOnwBycrXvtqLJ6mxVt0AGq/0MTuqiQ4w00Aa+Nwzp0+jLJfakTkswjJzSPS7ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0Y5d5EQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0Y5d5EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91704C4CEE7;
	Mon, 13 Oct 2025 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369902;
	bh=c3rhlnhUM0nr2ds0vIuwwNPvlP6JJ02Bv0h8FOQynCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0Y5d5EQnPOwfw8SPQmNrWglr4gjmpkF8OjBbt2ulvj5vD2twqWI+LePqUmnzZCfI
	 QXzn1ioCYautknL7/JQdK5O6rW+VNLUzop2WPbDu/HZ/iKPYPfEjholm2ZftkA5MCE
	 tmotwQ7xyzANZWKicE4wHt1oTU1deiTqur1paI3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Moulding <dan@danm.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 407/563] crypto: comp - Use same definition of context alloc and free ops
Date: Mon, 13 Oct 2025 16:44:28 +0200
Message-ID: <20251013144426.031771531@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Moulding <dan@danm.net>

[ Upstream commit f75f66683ded09f7135aef2e763c245a07c8271a ]

In commit 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation
code into acomp"), the crypto_acomp_streams struct was made to rely on
having the alloc_ctx and free_ctx operations defined in the same order
as the scomp_alg struct. But in that same commit, the alloc_ctx and
free_ctx members of scomp_alg may be randomized by structure layout
randomization, since they are contained in a pure ops structure
(containing only function pointers). If the pointers within scomp_alg
are randomized, but those in crypto_acomp_streams are not, then
the order may no longer match. This fixes the problem by removing the
union from scomp_alg so that both crypto_acomp_streams and scomp_alg
will share the same definition of alloc_ctx and free_ctx, ensuring
they will always have the same layout.

Signed-off-by: Dan Moulding <dan@danm.net>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Fixes: 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation code into acomp")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/842.c                          |  6 ++++--
 crypto/lz4.c                          |  6 ++++--
 crypto/lz4hc.c                        |  6 ++++--
 crypto/lzo-rle.c                      |  6 ++++--
 crypto/lzo.c                          |  6 ++++--
 drivers/crypto/nx/nx-common-powernv.c |  6 ++++--
 drivers/crypto/nx/nx-common-pseries.c |  6 ++++--
 include/crypto/internal/scompress.h   | 11 +----------
 8 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 8c257c40e2b90..4007e87bed806 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -54,8 +54,10 @@ static int crypto842_sdecompress(struct crypto_scomp *tfm,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= crypto842_alloc_ctx,
-	.free_ctx		= crypto842_free_ctx,
+	.streams		= {
+		.alloc_ctx	= crypto842_alloc_ctx,
+		.free_ctx	= crypto842_free_ctx,
+	},
 	.compress		= crypto842_scompress,
 	.decompress		= crypto842_sdecompress,
 	.base			= {
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 7a984ae5ae52e..57b713516aefa 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -68,8 +68,10 @@ static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lz4_alloc_ctx,
-	.free_ctx		= lz4_free_ctx,
+	.streams		= {
+		.alloc_ctx	= lz4_alloc_ctx,
+		.free_ctx	= lz4_free_ctx,
+	},
 	.compress		= lz4_scompress,
 	.decompress		= lz4_sdecompress,
 	.base			= {
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 9c61d05b62142..bb84f8a68cb58 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -66,8 +66,10 @@ static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lz4hc_alloc_ctx,
-	.free_ctx		= lz4hc_free_ctx,
+	.streams		= {
+		.alloc_ctx	= lz4hc_alloc_ctx,
+		.free_ctx	= lz4hc_free_ctx,
+	},
 	.compress		= lz4hc_scompress,
 	.decompress		= lz4hc_sdecompress,
 	.base			= {
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index ba013f2d5090d..794e7ec49536b 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -70,8 +70,10 @@ static int lzorle_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lzorle_alloc_ctx,
-	.free_ctx		= lzorle_free_ctx,
+	.streams		= {
+		.alloc_ctx	= lzorle_alloc_ctx,
+		.free_ctx	= lzorle_free_ctx,
+	},
 	.compress		= lzorle_scompress,
 	.decompress		= lzorle_sdecompress,
 	.base			= {
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 7867e2c67c4ed..d43242b24b4e8 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -70,8 +70,10 @@ static int lzo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 }
 
 static struct scomp_alg scomp = {
-	.alloc_ctx		= lzo_alloc_ctx,
-	.free_ctx		= lzo_free_ctx,
+	.streams		= {
+		.alloc_ctx	= lzo_alloc_ctx,
+		.free_ctx	= lzo_free_ctx,
+	},
 	.compress		= lzo_scompress,
 	.decompress		= lzo_sdecompress,
 	.base			= {
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index fd0a98b2fb1b2..0493041ea0885 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -1043,8 +1043,10 @@ static struct scomp_alg nx842_powernv_alg = {
 	.base.cra_priority	= 300,
 	.base.cra_module	= THIS_MODULE,
 
-	.alloc_ctx		= nx842_powernv_crypto_alloc_ctx,
-	.free_ctx		= nx842_crypto_free_ctx,
+	.streams		= {
+		.alloc_ctx	= nx842_powernv_crypto_alloc_ctx,
+		.free_ctx	= nx842_crypto_free_ctx,
+	},
 	.compress		= nx842_crypto_compress,
 	.decompress		= nx842_crypto_decompress,
 };
diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index f528e072494a2..fc0222ebe8072 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1020,8 +1020,10 @@ static struct scomp_alg nx842_pseries_alg = {
 	.base.cra_priority	= 300,
 	.base.cra_module	= THIS_MODULE,
 
-	.alloc_ctx		= nx842_pseries_crypto_alloc_ctx,
-	.free_ctx		= nx842_crypto_free_ctx,
+	.streams		= {
+		.alloc_ctx	= nx842_pseries_crypto_alloc_ctx,
+		.free_ctx	= nx842_crypto_free_ctx,
+	},
 	.compress		= nx842_crypto_compress,
 	.decompress		= nx842_crypto_decompress,
 };
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 533d6c16a4914..6a2c5f2e90f95 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -18,11 +18,8 @@ struct crypto_scomp {
 /**
  * struct scomp_alg - synchronous compression algorithm
  *
- * @alloc_ctx:	Function allocates algorithm specific context
- * @free_ctx:	Function frees context allocated with alloc_ctx
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
- * @base:	Common crypto API algorithm data structure
  * @streams:	Per-cpu memory for algorithm
  * @calg:	Cmonn algorithm data structure shared with acomp
  */
@@ -34,13 +31,7 @@ struct scomp_alg {
 			  unsigned int slen, u8 *dst, unsigned int *dlen,
 			  void *ctx);
 
-	union {
-		struct {
-			void *(*alloc_ctx)(void);
-			void (*free_ctx)(void *ctx);
-		};
-		struct crypto_acomp_streams streams;
-	};
+	struct crypto_acomp_streams streams;
 
 	union {
 		struct COMP_ALG_COMMON;
-- 
2.51.0



