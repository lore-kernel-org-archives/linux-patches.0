Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB794F5E0;
	Wed, 20 May 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300639; cv=none; b=Vl9skTq2YxJbW7OM8Tvk7KQtl2zLQRHTam/JZLpLLB1Gm/7zXGhhgSpVZAlWYiShd/DAEOAHaakeSXUWZenJjIItMb1pBYBolX6naRWoOwdrlxlFhPU3YMEl9FT5DQ848R3CRFAh+I5nZ9hkYdJ0Xf4Vh5krQ2r3vB3zDYB1Kak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300639; c=relaxed/simple;
	bh=kPdGve4DkhqOnYDuvmsETJQq7AhSc0GBlcCSEUD7inQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/Iouk0eAUy0YDHhhSF7cUT2B0HeHZUUs7Ks5pqBnuBqYXR6m6QZrXe1uPsaI3ptH/6te8bVZ5LqqoM56v3fnZSFYZw7o3dIY/UAkzew2amQT4YlRjdmqfE3ejV4+JNc2aZsQB05v19xoSH07SabKZnf99+IYCwv4VH8iU9wguo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPwQBGis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPwQBGis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAB81F000E9;
	Wed, 20 May 2026 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300638;
	bh=T3O755qexoBPYtu6kMd1fJBWD3Np+XgTi+8gEbYM3Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPwQBGisupqK+O2Jv4zCD5uqVo2YwAW4AfrsgtXQtxSvuTk9fdvuFC7XeM7bTaxHs
	 XZMet2ZDiJY1xFhVbqg3Vt7BzbwyHhjIPjN6P0fMuUoWK3hI5pEuyno6v0Ww0uj+IU
	 j1a0wtcJnukSZg77csSZbkHphHYe/MaYi6qf41f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Haixin Xu <jerryxucs@gmail.com>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/666] crypto: jitterentropy - replace long-held spinlock with mutex
Date: Wed, 20 May 2026 18:17:40 +0200
Message-ID: <20260520162116.615147809@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haixin Xu <jerryxucs@gmail.com>

[ Upstream commit 01d798e9feb30212952d4e992801ba6bd6a82351 ]

jent_kcapi_random() serializes the shared jitterentropy state, but it
currently holds a spinlock across the jent_read_entropy() call. That
path performs expensive jitter collection and SHA3 conditioning, so
parallel readers can trigger stalls as contending waiters spin for
the same lock.

To prevent non-preemptible lock hold, replace rng->jent_lock with a
mutex so contended readers sleep instead of spinning on a shared lock
held across expensive entropy generation.

Fixes: bb5530e40824 ("crypto: jitterentropy - add jitterentropy RNG")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haixin Xu <jerryxucs@gmail.com>
Reviewed-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/jitterentropy-kcapi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 1266eb790708b..a9e9b8fe15985 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -42,6 +42,7 @@
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <crypto/internal/rng.h>
@@ -192,7 +193,7 @@ int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len)
  ***************************************************************************/
 
 struct jitterentropy {
-	spinlock_t jent_lock;
+	struct mutex jent_lock;
 	struct rand_data *entropy_collector;
 	struct crypto_shash *tfm;
 	struct shash_desc *sdesc;
@@ -202,7 +203,7 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
 
-	spin_lock(&rng->jent_lock);
+	mutex_lock(&rng->jent_lock);
 
 	if (rng->sdesc) {
 		shash_desc_zero(rng->sdesc);
@@ -217,7 +218,7 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 	if (rng->entropy_collector)
 		jent_entropy_collector_free(rng->entropy_collector);
 	rng->entropy_collector = NULL;
-	spin_unlock(&rng->jent_lock);
+	mutex_unlock(&rng->jent_lock);
 }
 
 static int jent_kcapi_init(struct crypto_tfm *tfm)
@@ -227,7 +228,7 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 	struct shash_desc *sdesc;
 	int size, ret = 0;
 
-	spin_lock_init(&rng->jent_lock);
+	mutex_init(&rng->jent_lock);
 
 	/*
 	 * Use SHA3-256 as conditioner. We allocate only the generic
@@ -264,7 +265,6 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 		goto err;
 	}
 
-	spin_lock_init(&rng->jent_lock);
 	return 0;
 
 err:
@@ -279,7 +279,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 	struct jitterentropy *rng = crypto_rng_ctx(tfm);
 	int ret = 0;
 
-	spin_lock(&rng->jent_lock);
+	mutex_lock(&rng->jent_lock);
 
 	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
 
@@ -305,7 +305,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 		ret = -EINVAL;
 	}
 
-	spin_unlock(&rng->jent_lock);
+	mutex_unlock(&rng->jent_lock);
 
 	return ret;
 }
-- 
2.53.0



