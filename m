Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9997AC13D;
	Thu, 30 Jan 2025 14:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245656; cv=none; b=t/tzene4OohaMH/IEo+kIhdwYJ/uVbU+YFAZeGFc7i48MN0Q411KeSXRx2duTStwDArkTCBjVJnyh5UMNHk3mfqnfxprtgMtxLR0mjSnvhh2czjvsqtlO7cVYz6fdLg5Ma+BpCq22D7pBcQkVORoKgqnW6grJdFAYtY4gIUJB4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245656; c=relaxed/simple;
	bh=jeVcmipITSUhUbMPN/LFjwE+WkvhVeNb2kpHArvt0a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhGuzucSiHufTdgLa9sSd8H5VyRTQtXjgrZbtMQ9oTf7/MSmoYn3roxhbeVfqgSa5hD6tWLjhFOq/OmnaUg0AuajUTsjlmHpQrUaSy+HD1CE/3rAngJ/KRxO8bN+O0AtT2Pcmzt5D/lV6rs3KcwOMMQJajCOb5eN1Elv/RorzhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr2JpQuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr2JpQuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C51C4CED2;
	Thu, 30 Jan 2025 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245656;
	bh=jeVcmipITSUhUbMPN/LFjwE+WkvhVeNb2kpHArvt0a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr2JpQuGNkbcIS0ri9S6UuvqmZgmiH9U/mvbUmBY66kdwQaa5goSn7RwsTRJ70BDM
	 pKZEaUZ4shq+3TncaOmErijgt9sp2jB1tV6cRxdz9T309YzNtucabUQrZoBDEGA1uk
	 F7HTVCuZBev0nHU4J4in2QWTSVus67YNFBDUGlEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosryahmed@google.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 16/40] mm: zswap: move allocations during CPU init outside the lock
Date: Thu, 30 Jan 2025 14:59:16 +0100
Message-ID: <20250130133500.361454546@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

From: Yosry Ahmed <yosryahmed@google.com>

commit 779b9955f64327c339a16f68055af98252fd3315 upstream.

In zswap_cpu_comp_prepare(), allocations are made and assigned to various
members of acomp_ctx under acomp_ctx->mutex.  However, allocations may
recurse into zswap through reclaim, trying to acquire the same mutex and
deadlocking.

Move the allocations before the mutex critical section.  Only the
initialization of acomp_ctx needs to be done with the mutex held.

Link: https://lkml.kernel.org/r/20250113214458.2123410-1-yosryahmed@google.com
Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources during CPU hotunplug")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -815,15 +815,15 @@ static int zswap_cpu_comp_prepare(unsign
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct crypto_acomp *acomp;
-	struct acomp_req *req;
+	struct crypto_acomp *acomp = NULL;
+	struct acomp_req *req = NULL;
+	u8 *buffer = NULL;
 	int ret;
 
-	mutex_lock(&acomp_ctx->mutex);
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer) {
+	buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
+	if (!buffer) {
 		ret = -ENOMEM;
-		goto buffer_fail;
+		goto fail;
 	}
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
@@ -831,21 +831,25 @@ static int zswap_cpu_comp_prepare(unsign
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp));
 		ret = PTR_ERR(acomp);
-		goto acomp_fail;
+		goto fail;
 	}
-	acomp_ctx->acomp = acomp;
-	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 
-	req = acomp_request_alloc(acomp_ctx->acomp);
+	req = acomp_request_alloc(acomp);
 	if (!req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		ret = -ENOMEM;
-		goto req_fail;
+		goto fail;
 	}
-	acomp_ctx->req = req;
 
+	/*
+	 * Only hold the mutex after completing allocations, otherwise we may
+	 * recurse into zswap through reclaim and attempt to hold the mutex
+	 * again resulting in a deadlock.
+	 */
+	mutex_lock(&acomp_ctx->mutex);
 	crypto_init_wait(&acomp_ctx->wait);
+
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
@@ -854,15 +858,17 @@ static int zswap_cpu_comp_prepare(unsign
 	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
+	acomp_ctx->buffer = buffer;
+	acomp_ctx->acomp = acomp;
+	acomp_ctx->is_sleepable = acomp_is_async(acomp);
+	acomp_ctx->req = req;
 	mutex_unlock(&acomp_ctx->mutex);
 	return 0;
 
-req_fail:
-	crypto_free_acomp(acomp_ctx->acomp);
-acomp_fail:
-	kfree(acomp_ctx->buffer);
-buffer_fail:
-	mutex_unlock(&acomp_ctx->mutex);
+fail:
+	if (acomp)
+		crypto_free_acomp(acomp);
+	kfree(buffer);
 	return ret;
 }
 


