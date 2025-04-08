Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1175027F4FE;
	Tue,  8 Apr 2025 12:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117182; cv=none; b=DAxtWzk+kl6weMRc00HWVfqSmyrnuztsd2ddcQYftCB9JjRIjN6RcfjTCwb48F03KcAojxsNFi0HUrfElfJhi/vl1gjlwPdNBQNUOR9PXkxcPEeOyKmS8leMCnwV88vrpcXIPxxE29WQms60C4ZJh5z7+cMRTVuoO9Pop8Lhexo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117182; c=relaxed/simple;
	bh=wR/c2S0ZgtatJDBBBK5ZdYJ5veSMhd/4T92dIiv1SZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd38mMVvR0JjJRF9Xoav0/HRdA6xG8Cepq7/qiI/+NwJOcyhDOtvAl+VQPQ/D/fuF0L2EXj+CALKKV8FV0oB36MjCd4YwwkT2hIB2ePCP9FX7QdL8Y9qyZzNr0SpzJLhiOmuYhnFAGGUioBBQ4pEi+FNZTOH3th9C8k9U1DKtTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+l3Pv1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+l3Pv1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084BBC4CEE5;
	Tue,  8 Apr 2025 12:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117181;
	bh=wR/c2S0ZgtatJDBBBK5ZdYJ5veSMhd/4T92dIiv1SZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+l3Pv1mgmsqWKXhZiOCgmrQPTbC5FydyTsd2FkNtpQIiNuiVhjRqzP4qH8qtNbSZ
	 3kO0GRhVv0C7TZ1Q5+FOJ3op+guj2jsRAetHjrIWftnFOAaVDfe0z5ssHDhNwZMF9r
	 SGv5SegiF6z9I3W9mkAD648tr0NsH99dBD3WGEJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Murphy <lists@colorremedies.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 414/423] mm: zswap: fix crypto_free_acomp() deadlock in zswap_cpu_comp_dead()
Date: Tue,  8 Apr 2025 12:52:20 +0200
Message-ID: <20250408104855.563184655@linuxfoundation.org>
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit c11bcbc0a517acf69282c8225059b2a8ac5fe628 upstream.

Currently, zswap_cpu_comp_dead() calls crypto_free_acomp() while holding
the per-CPU acomp_ctx mutex.  crypto_free_acomp() then holds scomp_lock
(through crypto_exit_scomp_ops_async()).

On the other hand, crypto_alloc_acomp_node() holds the scomp_lock (through
crypto_scomp_init_tfm()), and then allocates memory.  If the allocation
results in reclaim, we may attempt to hold the per-CPU acomp_ctx mutex.

The above dependencies can cause an ABBA deadlock.  For example in the
following scenario:

(1) Task A running on CPU #1:
    crypto_alloc_acomp_node()
      Holds scomp_lock
      Enters reclaim
      Reads per_cpu_ptr(pool->acomp_ctx, 1)

(2) Task A is descheduled

(3) CPU #1 goes offline
    zswap_cpu_comp_dead(CPU #1)
      Holds per_cpu_ptr(pool->acomp_ctx, 1))
      Calls crypto_free_acomp()
      Waits for scomp_lock

(4) Task A running on CPU #2:
      Waits for per_cpu_ptr(pool->acomp_ctx, 1) // Read on CPU #1
      DEADLOCK

Since there is no requirement to call crypto_free_acomp() with the per-CPU
acomp_ctx mutex held in zswap_cpu_comp_dead(), move it after the mutex is
unlocked.  Also move the acomp_request_free() and kfree() calls for
consistency and to avoid any potential sublte locking dependencies in the
future.

With this, only setting acomp_ctx fields to NULL occurs with the mutex
held.  This is similar to how zswap_cpu_comp_prepare() only initializes
acomp_ctx fields with the mutex held, after performing all allocations
before holding the mutex.

Opportunistically, move the NULL check on acomp_ctx so that it takes place
before the mutex dereference.

Link: https://lkml.kernel.org/r/20250226185625.2672936-1-yosry.ahmed@linux.dev
Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources during CPU hotunplug")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reported-by: syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67bcea51.050a0220.bbfd1.0096.GAE@google.com/
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Nhat Pham <nphamcs@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Murphy <lists@colorremedies.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -876,18 +876,32 @@ static int zswap_cpu_comp_dead(unsigned
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	struct acomp_req *req;
+	struct crypto_acomp *acomp;
+	u8 *buffer;
+
+	if (IS_ERR_OR_NULL(acomp_ctx))
+		return 0;
 
 	mutex_lock(&acomp_ctx->mutex);
-	if (!IS_ERR_OR_NULL(acomp_ctx)) {
-		if (!IS_ERR_OR_NULL(acomp_ctx->req))
-			acomp_request_free(acomp_ctx->req);
-		acomp_ctx->req = NULL;
-		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
-			crypto_free_acomp(acomp_ctx->acomp);
-		kfree(acomp_ctx->buffer);
-	}
+	req = acomp_ctx->req;
+	acomp = acomp_ctx->acomp;
+	buffer = acomp_ctx->buffer;
+	acomp_ctx->req = NULL;
+	acomp_ctx->acomp = NULL;
+	acomp_ctx->buffer = NULL;
 	mutex_unlock(&acomp_ctx->mutex);
 
+	/*
+	 * Do the actual freeing after releasing the mutex to avoid subtle
+	 * locking dependencies causing deadlocks.
+	 */
+	if (!IS_ERR_OR_NULL(req))
+		acomp_request_free(req);
+	if (!IS_ERR_OR_NULL(acomp))
+		crypto_free_acomp(acomp);
+	kfree(buffer);
+
 	return 0;
 }
 


