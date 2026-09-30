Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDB91E0DD8;
	Wed, 30 Sep 2026 16:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787518; cv=none; b=hVPSW9uoTMsMMC9q9C1jlBmgaLJGl4Smgad+iDV6HZwczHChlQ3XHZsBRiAWfPfS+fwQ43ZZEALCEwlmsxfN32/DydAfCfYues3sUZMGMPTdT55YsUn9vYsSzqrABk+j9VunkqVJ0PA7Fph2wi6ctCZHz1/AoSfyWRUYRNEiQME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787518; c=relaxed/simple;
	bh=1/Q4b97grjS4qK+eVjvIz/fzSVbuhVdYfH+irNzPMgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4B6mfdPJFNjRjwN/GwsP95a6j+cTTv92rBC+AymA/KgH7JIA/c1nT7WFvljtsNs8CrGktvC1aig5Hecf3+RXTHNpX1mbLppwZYAR/ezsDdw18CCMu65MhhdUNM/NJP7gPqjLyWLzBXEBkvXKE0cw78Xau+kbVTuCF+kvPiq1Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdtpgUKa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdtpgUKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7381F000FF;
	Wed, 30 Sep 2026 16:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787516;
	bh=vTHI91pfwiKCO1L4DsZkeQmudDjwMlxWvoWvvBr63Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdtpgUKaEL6epy7uYGoAUmC1meR3MaW6Rp9GDlDL4OFmIc5A/KqNDQyuNgAyHOYh3
	 /CNR/V3Mk3htcmGDF9SfXpMgiGATT5cJ3mT/85tHnxVxdYwuOPnc1YGmVAuwxMxvzd
	 3SC9CrGAfvhqI9r4sQIiNOIE9HgGvooM0e1XHVkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erhard Furtner <erhard_f@mailbox.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 259/457] netfs: Fix missing alloc tagging of direct mempool allocations
Date: Wed, 30 Sep 2026 17:26:04 +0200
Message-ID: <20260930152351.635941384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <hao.ge@linux.dev>

commit b78b728e21c32ec4c330b299f657fb1eb02dffc2 upstream.

Commit 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in writeback by
adding a mempool") added a mempool for the folio_queues and made the
request, subrequest and folio_queue allocations distinguish between
writeback and everything else.  Writeback is part of memory reclaim
and must not fail due to ENOMEM, so it allocates under GFP_NOFS
through mempool_alloc(), which may dip into the pool's reserve and,
if that runs empty, wait for elements to be returned.  The
GFP_KERNEL paths, which can return -ENOMEM to their callers, invoke
the pool's ->alloc() callback directly instead.

The direct call, however, skips the alloc_hooks() wrapper that the
mempool_alloc() macro provides.  The pool callbacks, mempool_alloc_slab()
and mempool_kmalloc(), call kmem_cache_alloc_noprof() and kmalloc_noprof()
and rely on current->alloc_tag having been set by the caller.  With
CONFIG_MEM_ALLOC_PROFILING_DEBUG=y this leads to

    current->alloc_tag not set
    WARNING: ./include/linux/alloc_tag.h:161 at __alloc_tagging_slab_alloc_hook
    alloc_tag was not set
    WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab_free_hook

at allocation and free time respectively, as reported when reading
files on a CIFS mount.  The allocations are also missing from
/proc/allocinfo.

Wrap the direct ->alloc() invocations in alloc_hooks() with a new
mempool_alloc_noreserve() helper in include/linux/mempool.h, next to
the other alloc_hooks()-wrapped macros such as mempool_alloc().  The
GFP_KERNEL paths keep their failable allocation semantics, they just
get tagged now.

Fixes: 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in writeback by adding a mempool")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/0b004319-9ef7-437c-a4dd-174d6a9a83db@mailbox.org/
Tested-by: Erhard Furtner <erhard_f@mailbox.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Link: https://patch.msgid.link/20260923063759.34667-1-hao.ge@linux.dev
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/objects.c        |    4 ++--
 fs/netfs/rolling_buffer.c |    2 +-
 include/linux/mempool.h   |    7 +++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -34,7 +34,7 @@ struct netfs_io_request *netfs_alloc_req
 
 		rreq = mempool_alloc(mempool, gfp);
 	} else {
-		rreq = mempool->alloc(gfp, mempool->pool_data);
+		rreq = mempool_alloc_noreserve(mempool, gfp);
 		if (!rreq)
 			return ERR_PTR(-ENOMEM);
 	}
@@ -214,7 +214,7 @@ struct netfs_io_subrequest *netfs_alloc_
 	struct kmem_cache *cache = mempool->pool_data;
 
 	if (rreq->gfp == GFP_KERNEL)
-		subreq = mempool->alloc(rreq->gfp, mempool->pool_data);
+		subreq = mempool_alloc_noreserve(mempool, rreq->gfp);
 	else
 		subreq = mempool_alloc(mempool, rreq->gfp);
 	if (!subreq)
--- a/fs/netfs/rolling_buffer.c
+++ b/fs/netfs/rolling_buffer.c
@@ -29,7 +29,7 @@ struct folio_queue *netfs_folioq_alloc(u
 	struct folio_queue *fq;
 
 	if (gfp == GFP_KERNEL)
-		fq = netfs_folioq_pool.alloc(gfp, netfs_folioq_pool.pool_data);
+		fq = mempool_alloc_noreserve(&netfs_folioq_pool, gfp);
 	else
 		fq = mempool_alloc(&netfs_folioq_pool, gfp);
 	if (fq) {
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -70,6 +70,13 @@ int mempool_alloc_bulk_noprof(struct mem
 #define mempool_alloc_bulk(...)						\
 	alloc_hooks(mempool_alloc_bulk_noprof(__VA_ARGS__))
 
+/*
+ * Allocate a new element without dipping into the pool's reserves or
+ * waiting.  Returns NULL on failure.
+ */
+#define mempool_alloc_noreserve(_pool, _gfp)				\
+	alloc_hooks((_pool)->alloc(_gfp, (_pool)->pool_data))
+
 void *mempool_alloc_preallocated(struct mempool *pool) __malloc;
 void mempool_free(void *element, struct mempool *pool);
 unsigned int mempool_free_bulk(struct mempool *pool, void **elem,


