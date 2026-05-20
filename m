Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9387432E128;
	Wed, 20 May 2026 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297018; cv=none; b=J4SFlnvdNfaQlPWOfCB6eNJTbxKn4HRDIe6QZ8rXECHsyRqE29ueFTSzL2C49o+05Vox8nbdq5RvYW0tFreFgFKGHk/kdMg38bHZhznDBcYEdEyMN8vjXqQ2PjCRQ8LAht5p/yGwb3NgjjTeV3hSpY+lFe2Ne/XRklN8KiT71zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297018; c=relaxed/simple;
	bh=fwRQIYIRid+Nk3JF5tkjxKiEglq0DpftlAI2xr20/bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paDgUFSwQ62YNRy9VduTvdyXofsF+BLzQxU2hhMFx6mLXMQNZVVBJ06io6XZtMcX4pQFGG9GZM+abD94W03w0dHO7ghpVrt5PRQOi1cKk8C1Igkrltyt0KLwKqek3VF+4Qimp9McNiw+/nOZIH5httfE+vUh0X+nJozoSNw5IfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcxccukF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcxccukF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BCC1F000E9;
	Wed, 20 May 2026 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297017;
	bh=RLgIOOfuscX9Syx2K8KM1nF+6B4VUgHzd+DRBu/O6jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcxccukF+v77V3h61RyluaFHsj7apH+CGQMaJhBTB+n4fueBoOrgGN6mMrUNtU3dL
	 zb53rSW5r7rJ4wDHbDSFk0vKmD60u1ZoTpDDPOgBV5dn94WXHIf7O7Ut8xQWAamFiu
	 rIYfRuMaloi8AuU0g/QD8c39u/koIfRRavOv8HMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hasan Basbunar <basbunarhasan@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1019/1146] page_pool: fix memory-provider leak in page_pool_create_percpu() error path
Date: Wed, 20 May 2026 18:21:09 +0200
Message-ID: <20260520162211.291179932@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hasan Basbunar <basbunarhasan@gmail.com>

[ Upstream commit 5ef343614db766acdc01c56d66e780a1b43c6ac6 ]

When page_pool_create_percpu() fails on page_pool_list(), it falls
through to its err_uninit: label, which calls page_pool_uninit().
At that point page_pool_init() has already taken two references
when the user requested PP_FLAG_ALLOW_UNREADABLE_NETMEM:

	pool->mp_ops->init(pool)
	static_branch_inc(&page_pool_mem_providers);

Neither is undone by page_pool_uninit(); both are only undone by
__page_pool_destroy() (success-side teardown). The error path
therefore leaks the per-provider reference taken by mp_ops->init
(io_zcrx_ifq->refs in the io_uring zcrx provider, the dmabuf
binding refcount in the devmem provider) plus one increment of
the page_pool_mem_providers static branch on every failure of
xa_alloc_cyclic() inside page_pool_list().

The leaked io_zcrx_ifq->refs in turn pins everything
io_zcrx_ifq_free() would release on cleanup: ifq->user (uid),
ifq->mm_account (mmdrop), ifq->dev (device refcount),
ifq->netdev_tracker (netdev refcount), and the rbuf region.
The leaked static branch increment forces all subsequent
page_pool_alloc_netmems() and page_pool_return_page() callers to
take the slow mp_ops branch for the lifetime of the kernel.

Reachable via the io_uring zcrx path:

	io_uring_register(IORING_REGISTER_ZCRX_IFQ)  /* CAP_NET_ADMIN */
	  -> __io_uring_register
	  -> io_register_zcrx
	  -> zcrx_register_netdev
	  -> netif_mp_open_rxq
	  -> driver ndo_queue_mem_alloc
	  -> page_pool_create_percpu
	    -> page_pool_init succeeds (mp_ops->init runs, branch++)
	    -> page_pool_list fails (xa_alloc_cyclic -ENOMEM)
	    -> goto err_uninit         <-- leak

The same shape applies to the devmem dmabuf provider via
mp_dmabuf_devmem_init()/mp_dmabuf_devmem_destroy().

Restore the cleanup symmetry by moving the mp_ops->destroy() and
static_branch_dec() calls out of __page_pool_destroy() and into
page_pool_uninit(), so page_pool_uninit() is again the strict
inverse of page_pool_init(). page_pool_uninit() has only two
callers (the err_uninit: path and __page_pool_destroy()), so this
preserves the single-call invariant on the success path while
fixing the err path. The error path of page_pool_init() itself
still skips the mp_ops cleanup correctly: mp_ops->init is the
last action that takes a reference before page_pool_init() returns
0, so when it returns an error neither the refcount nor the static
branch has been touched.

Triggering the bug requires xa_alloc_cyclic() to fail with -ENOMEM,
which under normal GFP_KERNEL retry behaviour is rare. It is
deterministic under CONFIG_FAULT_INJECTION with fail_page_alloc /
xa fault injection, or under sustained memory pressure. The leak
is silent: there is no warning, and the released kernel build
continues running with a permanently-incremented static branch.

Fixes: 0f9214046893 ("memory-provider: dmabuf devmem memory provider")
Signed-off-by: Hasan Basbunar <basbunarhasan@gmail.com>
Link: https://patch.msgid.link/20260428170739.34881-1-basbunarhasan@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 265a729431bb7..8171d1173221b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -327,6 +327,11 @@ static void page_pool_uninit(struct page_pool *pool)
 	if (!pool->system)
 		free_percpu(pool->recycle_stats);
 #endif
+
+	if (pool->mp_ops) {
+		pool->mp_ops->destroy(pool);
+		static_branch_dec(&page_pool_mem_providers);
+	}
 }
 
 /**
@@ -1126,11 +1131,6 @@ static void __page_pool_destroy(struct page_pool *pool)
 	page_pool_unlist(pool);
 	page_pool_uninit(pool);
 
-	if (pool->mp_ops) {
-		pool->mp_ops->destroy(pool);
-		static_branch_dec(&page_pool_mem_providers);
-	}
-
 	kfree(pool);
 }
 
-- 
2.53.0



