Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C70513AA2F;
	Tue, 12 Aug 2025 18:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024269; cv=none; b=d8xntGo85qjToySarpHhrUtkqdYbRLjVEAlinUmtT3WOEsMxNAOllcPHypIB8n/T4jnI/LYzXcynwHjS4hjB43qxHIYzVk4elLkkuQUe32/wGsXRepc50fjtARRXV2kaf7HzV3xMgtiRhTPDBdLPUQiBEZ9ii8LAWN4SCyAJ4/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024269; c=relaxed/simple;
	bh=FTA2gUm3NNeRW+K2j340+zhRrKvlkobS9jL7kq96f4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDJ42HtKqmuRCd6EXXoblCR5IMpq4WRXqRfAcb3GbWrM8b+SJGXUJi8SfwvdCnNNsRJI4ZyPaSei+fHrB3W1hbO0KQKZHhkfi48Xf66hDZs3gx36Lq0TLd1I9EVSjtPYC2tyimxLd0ZDoMN5OHi+joV7aMQlYAS2ykXHKiAcxaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlCpd81T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlCpd81T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02D8C4CEF0;
	Tue, 12 Aug 2025 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024269;
	bh=FTA2gUm3NNeRW+K2j340+zhRrKvlkobS9jL7kq96f4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xlCpd81T7xb2g+U7Ly4JWa32fmG8zFKd1VtQ8gfXTfx8vz7JtFkOK2QEKv1U/mV4n
	 7LtHTI90ECDCELhJQOOzN+51WWJ9XDV0F8cbTdxEOWjr5YeD2rNrb9WqZAoQslo6ao
	 GCyIVWMnfCnTgwFR/1+3YrGR+7Io0DQ6twOmHkY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 324/627] crypto: ahash - Stop legacy tfms from using the set_virt fallback path
Date: Tue, 12 Aug 2025 19:30:19 +0200
Message-ID: <20250812173431.621165293@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1e2b7fcd3f075ff8c5b0e4474fe145d1c685f54f ]

Ensure that drivers that have not been converted to the ahash API
do not use the ahash_request_set_virt fallback path as they cannot
use the software fallback.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ahash.c                 | 3 +++
 include/crypto/internal/hash.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3878b4da3cfd..2f06e6b4f601 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -350,6 +350,9 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	if (!crypto_ahash_need_fallback(tfm))
 		return -ENOSYS;
 
+	if (crypto_hash_no_export_core(tfm))
+		return -ENOSYS;
+
 	{
 		u8 state[HASH_MAX_STATESIZE];
 
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 0f85c543f80b..f052afa6e7b0 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -91,6 +91,12 @@ static inline bool crypto_hash_alg_needs_key(struct hash_alg_common *alg)
 		!(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY);
 }
 
+static inline bool crypto_hash_no_export_core(struct crypto_ahash *tfm)
+{
+	return crypto_hash_alg_common(tfm)->base.cra_flags &
+	       CRYPTO_AHASH_ALG_NO_EXPORT_CORE;
+}
+
 int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
 		      struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask);
-- 
2.39.5



