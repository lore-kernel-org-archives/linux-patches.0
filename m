Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215040;
	b=bTrcn8XI/LWQC/fCpyFm3rTwvurmYQ//f3nWd6OAv7B1cZgRtsKrYuGybSLq1Np2SYNV
	 Rlfrb++C+0JAoKGkFkQc0G9xIkLyp77fZGGAVWy3/721aPZcH6KFMteAYNSevriZ0wqtf
	 Zp8lgOJV5QCXAYwPYOf7ZZ2AY4xts/2FQXXmNYeYXpZg9FugzEi5oYnlu9og9eDFHgGua
	 Zp04y7t22OZDVmgQOlF1SO//e/r8VLn8GFHjDX3ZeG6J9idWBSdIdqd0/4ZfhTQBwakuZ
	 XdAVreTfQwUsbzGZXYx+CMju3ikJZ3mCnXF1IJXzCZypT0vWlN3AR2gQp5U9RtwNYhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eXBhVtOMRXkoU17xIX4tJgIP1ldYfsVVPbf4RMlQj8E=;
	b=KeSNBEOVurtEiz+vwtC+qQ0UhSyVG90A2skB0p7s7clmTOfnsV3iqLEb8hMhpv/+tZAF
	 Mo51ImrsszYHU8Aldpt+SeEhBoIJbx6KVWyG34SeS+D8yPmxcsP+MkXVPN3z0ykoto5g5
	 dkHcNMTwkskr5l/dhxcOuKmTknI6KHQsG1b4XvIMwlcUrpM96iHn6rGXQfqbrHhhvtMvh
	 Gf5y7lKeRnxr23yRrIXQMgIAvTBgl38Laslmj8E1y6v8AgGOOCoTDqfh7LHKL8RTGZxKO
	 NGsbWH9pI/QWdwyQ/7MT4rme+vb/2/wsX8UnrKshGg02+utb7WVjex24iCD35sXuo4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vg7aEWkf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57337606A31A;
	Wed, 28 Oct 2026 19:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vg7aEWkf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1FB1F01825;
	Wed, 28 Oct 2026 19:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215040;
	bh=eXBhVtOMRXkoU17xIX4tJgIP1ldYfsVVPbf4RMlQj8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vg7aEWkftLGz7lBv0LFtAivgBU8zyPe5ZuP+Z1oHO8uBulUvqPLzErhPkjBJbmVkG
	 DazvZpZR5zzwI36vrYSBB5rOQP/yEawHLT9m2Dni+s8AypsANlbpm8DGYdCKVNj2bv
	 8aNl/mrPO4/RrJHaVx9H7youFe10bWEgymgXk1pA=
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
Subject: [PATCH 6.1 1070/1887] crypto: jitterentropy - replace long-held spinlock with mutex
Date: Wed, 28 Oct 2026 17:52:46 +0100
Message-ID: <20261028170523.760101533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4b50cbc8a2faf..74d5c8da0e8ab 100644
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
@@ -180,7 +181,7 @@ int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len)
  ***************************************************************************/
 
 struct jitterentropy {
-	spinlock_t jent_lock;
+	struct mutex jent_lock;
 	struct rand_data *entropy_collector;
 	struct crypto_shash *tfm;
 	struct shash_desc *sdesc;
@@ -190,7 +191,7 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
 
-	spin_lock(&rng->jent_lock);
+	mutex_lock(&rng->jent_lock);
 
 	if (rng->sdesc) {
 		shash_desc_zero(rng->sdesc);
@@ -205,7 +206,7 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 	if (rng->entropy_collector)
 		jent_entropy_collector_free(rng->entropy_collector);
 	rng->entropy_collector = NULL;
-	spin_unlock(&rng->jent_lock);
+	mutex_unlock(&rng->jent_lock);
 }
 
 static int jent_kcapi_init(struct crypto_tfm *tfm)
@@ -215,7 +216,7 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 	struct shash_desc *sdesc;
 	int size, ret = 0;
 
-	spin_lock_init(&rng->jent_lock);
+	mutex_init(&rng->jent_lock);
 
 	/*
 	 * Use SHA3-256 as conditioner. We allocate only the generic
@@ -250,7 +251,6 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 		goto err;
 	}
 
-	spin_lock_init(&rng->jent_lock);
 	return 0;
 
 err:
@@ -265,7 +265,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 	struct jitterentropy *rng = crypto_rng_ctx(tfm);
 	int ret = 0;
 
-	spin_lock(&rng->jent_lock);
+	mutex_lock(&rng->jent_lock);
 
 	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
 
@@ -291,7 +291,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 		ret = -EINVAL;
 	}
 
-	spin_unlock(&rng->jent_lock);
+	mutex_unlock(&rng->jent_lock);
 
 	return ret;
 }
-- 
2.53.0



