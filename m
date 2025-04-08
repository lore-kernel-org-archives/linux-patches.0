Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E8B268C72;
	Tue,  8 Apr 2025 12:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115474; cv=none; b=WJvnfj1kPSYQBjYwicE5XlxsU7lhYVltniKNy5QKXwDTWIXzIpXDp36y/lXJvxEEgiGiFh8QlCoFnxKXXaPLKmS8nH710wY2/UsXMbLh1jyaiE9GRJ/MwY/iQSs/cWCsRTsau767m3IXp+ZliW3kb6aBAuZgw5Eu10grneaqwRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115474; c=relaxed/simple;
	bh=oDIRxtXTOAwd03ADdirHXm8X7WTHBS/xzBgKZXbecYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M85VqKYmy1AQV861K2WfVDuxC6iHa3GAIQMM0iY+wAVNtJMJyuPUTzVEzioxk+4O0O40pJda4mI3ZUtWfkWyYwObVUTjEZQz56BEIOjOZBjPxrgsktF836gKAJhsVRg3t4YEs9/SvUSbtHL+0I6cdZDlXCiM8+xvTDagksitrww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCjG96w/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCjG96w/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EAAC4CEE5;
	Tue,  8 Apr 2025 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115474;
	bh=oDIRxtXTOAwd03ADdirHXm8X7WTHBS/xzBgKZXbecYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCjG96w/jv0fI+7/oyKnWTW/XXxj3LnsAVMheQDYY4AXqkVKovh1FTps4VywacImK
	 CtnOBjP1iqjcEYJbySBcz5xhPSVnVJmO/7VWtTxR/gpL6ULzhouJqt2gJCHuJ7dLAk
	 wjEEdlCn/vDoiJgKKf5Lopqw7UpdK1V/6GJmQH0Q=
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
Subject: [PATCH 6.13 488/499] mm: zswap: fix crypto_free_acomp() deadlock in zswap_cpu_comp_dead()
Date: Tue,  8 Apr 2025 12:51:40 +0200
Message-ID: <20250408104903.529819461@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -881,18 +881,32 @@ static int zswap_cpu_comp_dead(unsigned
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
 


