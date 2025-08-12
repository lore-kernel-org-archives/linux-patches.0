Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B232F4A0A;
	Tue, 12 Aug 2025 18:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024266; cv=none; b=UAjSi22LME1JvyeX6+wj+MW7TQCzqJKH19C+/UNsMSVK6mcMNYHg8v/gAcgpw6a4lCKDKCgykV90k6CYGLc7KR/eBYRtgOj90PxmxPIk12gdEhsx1O7VPg3rXdbdLQUs/tnjnnVpgdPSa5yUtusTdrjS56pLg5R5YRG74FIp9gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024266; c=relaxed/simple;
	bh=2w5TGnYDvWnJJtDTurhE6ycpxJt9Gzsaz8Ydpltfm6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siQtxvZYvSy93U2ANz4UIaAbqDq7+k7Z8DYcm54P20oIN3ZR9/+NdbDFx8OWOVwhMrgPEXf35VPP3ZzKOaHEo93Rq99bgiRgDfvvTeXPoPZLQpKbuiSyfvSTdM4Z3YqxYlNpMWTBvqYVYQjMl7HRFFK1WkbzditmVJRMCWmaLNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8xLvlGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8xLvlGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64689C4CEF0;
	Tue, 12 Aug 2025 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024265;
	bh=2w5TGnYDvWnJJtDTurhE6ycpxJt9Gzsaz8Ydpltfm6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8xLvlGJmbOZFzR0vUjvWEmkeMjUWjAzHzZLONPdGwXKW1y0gkTbSTxpU8D6Ww2r2
	 7uM8J7GY7tq1HOUkKqcDTXsvqut/Sj9B/DgsLA8Oub6BqFoQ4+aE3cFghHYR15JshY
	 bMFuPxXpgbHCbviJHbsqzHmdUorkldNdwfVJhrRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 323/627] crypto: ahash - Add support for drivers with no fallback
Date: Tue, 12 Aug 2025 19:30:18 +0200
Message-ID: <20250812173431.583297700@linuxfoundation.org>
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

[ Upstream commit 4ccd065a69df163cd9fe0dd8e0f609f1eeb4723d ]

Some drivers cannot have a fallback, e.g., because the key is held
in hardware.  Allow these to be used with ahash by adding the bit
CRYPTO_ALG_NO_FALLBACK.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Harald Freudenberger <freude@linux.ibm.com>
Stable-dep-of: 1e2b7fcd3f07 ("crypto: ahash - Stop legacy tfms from using the set_virt fallback path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ahash.c         | 10 +++++++++-
 include/linux/crypto.h |  3 +++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index bc84a07c924c..3878b4da3cfd 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -347,6 +347,9 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	if (crypto_ahash_statesize(tfm) > HASH_MAX_STATESIZE)
 		return -ENOSYS;
 
+	if (!crypto_ahash_need_fallback(tfm))
+		return -ENOSYS;
+
 	{
 		u8 state[HASH_MAX_STATESIZE];
 
@@ -954,6 +957,10 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	    base->cra_reqsize > MAX_SYNC_HASH_REQSIZE)
 		return -EINVAL;
 
+	if (base->cra_flags & CRYPTO_ALG_NEED_FALLBACK &&
+	    base->cra_flags & CRYPTO_ALG_NO_FALLBACK)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
@@ -962,7 +969,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	base->cra_flags |= CRYPTO_ALG_TYPE_AHASH;
 
 	if ((base->cra_flags ^ CRYPTO_ALG_REQ_VIRT) &
-	    (CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT))
+	    (CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT) &&
+	    !(base->cra_flags & CRYPTO_ALG_NO_FALLBACK))
 		base->cra_flags |= CRYPTO_ALG_NEED_FALLBACK;
 
 	if (!alg->setkey)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b50f1954d1bb..a2137e19be7d 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -136,6 +136,9 @@
 /* Set if the algorithm supports virtual addresses. */
 #define CRYPTO_ALG_REQ_VIRT		0x00040000
 
+/* Set if the algorithm cannot have a fallback (e.g., phmac). */
+#define CRYPTO_ALG_NO_FALLBACK		0x00080000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.39.5



