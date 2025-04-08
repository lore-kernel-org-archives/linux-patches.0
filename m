Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A405727CCFB;
	Tue,  8 Apr 2025 12:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116540; cv=none; b=G+r71PbCFWKbjSXw883V0m5nMGdPvaTeoU71+68NmwJwBb2bvpAxaBEqBssFoeoAxw4gSPa21QbcMpec2UcLzYK4uGVGUq7Bi+nm4fU98lhqc20JJcf4QhzTKZVq1KCJTghzlyZwjjSh7hqY3rHtAUjrXsVTjy5B7JUmfRR86AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116540; c=relaxed/simple;
	bh=CL2O3W0UgHqSzT2z2U5tN+CkJFY+52N/5R4jS5gQ+AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdxjkZyGnA+J4gKINlQZrq83B4sMWOrUJ+z3N75gxTHqLAG95Sww8E4cvbGLlvIL25n2dpdb3IHF/GsBU91oFA/Xg5pKqtVHCf74Lw6oyoeHbto72s2KCDmjJ94eJ53jx4Ps3ELNev3S4eG8eCnfvq2NlxVxGPGkKxoefbs78EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/U+5ZbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/U+5ZbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B5FC4CEEC;
	Tue,  8 Apr 2025 12:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116540;
	bh=CL2O3W0UgHqSzT2z2U5tN+CkJFY+52N/5R4jS5gQ+AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/U+5ZbRA5uYt7xtpYsN+zS/CIp91CppfmzYWs+JHjy12S40EQ0qoPnrh2W2pPTzV
	 qqALknRpnJkbw2aSeS2hTvDdTq/Lud5/3PQFZ78Yd+qe/xB/PEKD8IJ3ZL7qEYzvsJ
	 Sa0tD2ZvOrjU1iMlgkBYUaUWnAO/BwoVJGu42tB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coiby Xu <coxu@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/423] crypto: api - Fix larval relookup type and mask
Date: Tue,  8 Apr 2025 12:47:43 +0200
Message-ID: <20250408104848.918748362@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 7505436e2925d89a13706a295a6734d6cabb4b43 ]

When the lookup is retried after instance construction, it uses
the type and mask from the larval, which may not match the values
used by the caller.  For example, if the caller is requesting for
a !NEEDS_FALLBACK algorithm, it may end up getting an algorithm
that needs fallbacks.

Fix this by making the caller supply the type/mask and using that
for the lookup.

Reported-by: Coiby Xu <coxu@redhat.com>
Fixes: 96ad59552059 ("crypto: api - Remove instance larval fulfilment")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/api.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index bfd177a4313a0..c2c4eb14ef955 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -36,7 +36,8 @@ EXPORT_SYMBOL_GPL(crypto_chain);
 DEFINE_STATIC_KEY_FALSE(__crypto_boot_test_finished);
 #endif
 
-static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
+					     u32 type, u32 mask);
 static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
 					    u32 mask);
 
@@ -145,7 +146,7 @@ static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
 	if (alg != &larval->alg) {
 		kfree(larval);
 		if (crypto_is_larval(alg))
-			alg = crypto_larval_wait(alg);
+			alg = crypto_larval_wait(alg, type, mask);
 	}
 
 	return alg;
@@ -197,7 +198,8 @@ static void crypto_start_test(struct crypto_larval *larval)
 	crypto_schedule_test(larval);
 }
 
-static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
+					     u32 type, u32 mask)
 {
 	struct crypto_larval *larval;
 	long time_left;
@@ -219,12 +221,7 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 			crypto_larval_kill(larval);
 		alg = ERR_PTR(-ETIMEDOUT);
 	} else if (!alg) {
-		u32 type;
-		u32 mask;
-
 		alg = &larval->alg;
-		type = alg->cra_flags & ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
-		mask = larval->mask;
 		alg = crypto_alg_lookup(alg->cra_name, type, mask) ?:
 		      ERR_PTR(-EAGAIN);
 	} else if (IS_ERR(alg))
@@ -304,7 +301,7 @@ static struct crypto_alg *crypto_larval_lookup(const char *name, u32 type,
 	}
 
 	if (!IS_ERR_OR_NULL(alg) && crypto_is_larval(alg))
-		alg = crypto_larval_wait(alg);
+		alg = crypto_larval_wait(alg, type, mask);
 	else if (alg)
 		;
 	else if (!(mask & CRYPTO_ALG_TESTED))
@@ -352,7 +349,7 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 	ok = crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST, larval);
 
 	if (ok == NOTIFY_STOP)
-		alg = crypto_larval_wait(larval);
+		alg = crypto_larval_wait(larval, type, mask);
 	else {
 		crypto_mod_put(larval);
 		alg = ERR_PTR(-ENOENT);
-- 
2.39.5



