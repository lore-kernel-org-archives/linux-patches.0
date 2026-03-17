Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7106B2DE70D;
	Tue, 17 Mar 2026 16:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766466; cv=none; b=HkC4SO17feWR0gLDFO1kTDBS2BUrPbvg/fXxebebGyB8deK5+HGRaeU3RvEYApgKT2RUSD4K+VRNiNSjDO8ZznrXwglntuWzocQtTZLdbjdoJwQa3KWDtxDpxoZ+MisEjOVnNhgd/EBjL7eQqgieEdiHqWTCVoNPty5BKQxlcO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766466; c=relaxed/simple;
	bh=D+TBFfG/ngyS7n95019FfmXQ8FoEgUWsBaddZSgIsOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWlsI1/uHoi9QB3b8horQa/cGlfTQLsfbgAjrU91kJxy9xBUJsYRm01twR9Fa/gx+SuHsTF3d76XoxTu+7bWngbrq8wqmkNZn9RnGggrbtefepRuh4H+3nrwjqPlSGMJYEmpqWUPWVb9ks8/cmXOnvJastKwpJ7hiznNAILlvds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRR8w/Yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRR8w/Yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16E1C4CEF7;
	Tue, 17 Mar 2026 16:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766466;
	bh=D+TBFfG/ngyS7n95019FfmXQ8FoEgUWsBaddZSgIsOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRR8w/Yfu0wlC2Il1TO2ps6p87FMbrNVHZ+jV4EV126f3rDwLxpUQb04hRepZHq4U
	 7KdwPBheRMWCAwGlqoteeJsV2DnpBKWb3rxO4PwFc1rRHbQEEjTDituxDn3P+AiMDm
	 6J4lxGxgnmsTC27TUqLeL/bvnkBbxppAV+0wlfLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zw Tang <shicenci@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.19 252/378] mm/slab: fix an incorrect check in obj_exts_alloc_size()
Date: Tue, 17 Mar 2026 17:33:29 +0100
Message-ID: <20260317163016.292600622@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Yoo <harry.yoo@oracle.com>

commit 8dafa9f5900c4855a65dbfee51e3bd00636deee1 upstream.

obj_exts_alloc_size() prevents recursive allocation of slabobj_ext
array from the same cache, to avoid creating slabs that are never freed.

There is one mistake that returns the original size when memory
allocation profiling is disabled. The assumption was that
memcg-triggered slabobj_ext allocation is always served from
KMALLOC_CGROUP type. But this is wrong [1]: when the caller specifies
both __GFP_RECLAIMABLE and __GFP_ACCOUNT with SLUB_TINY enabled, the
allocation is served from normal kmalloc. This is because kmalloc_type()
prioritizes __GFP_RECLAIMABLE over __GFP_ACCOUNT, and SLUB_TINY aliases
KMALLOC_RECLAIM with KMALLOC_NORMAL.

As a result, the recursion guard is bypassed and the problematic slabs
can be created. Fix this by removing the mem_alloc_profiling_enabled()
check entirely. The remaining is_kmalloc_normal() check is still
sufficient to detect whether the cache is of KMALLOC_NORMAL type and
avoid bumping the size if it's not.

Without SLUB_TINY, no functional change intended.
With SLUB_TINY, allocations with __GFP_ACCOUNT|__GFP_RECLAIMABLE
now allocate a larger array if the sizes equal.

Reported-by: Zw Tang <shicenci@gmail.com>
Fixes: 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from its own slab")
Closes: https://lore.kernel.org/linux-mm/CAPHJ_VKuMKSke8b11AZQw1PTSFN4n2C0gFxC6xGOG0ZLHgPmnA@mail.gmail.com [1]
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Link: https://patch.msgid.link/20260309072219.22653-1-harry.yoo@oracle.com
Tested-by: Zw Tang <shicenci@gmail.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2113,13 +2113,6 @@ static inline size_t obj_exts_alloc_size
 	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
 	struct kmem_cache *obj_exts_cache;
 
-	/*
-	 * slabobj_ext array for KMALLOC_CGROUP allocations
-	 * are served from KMALLOC_NORMAL caches.
-	 */
-	if (!mem_alloc_profiling_enabled())
-		return sz;
-
 	if (sz > KMALLOC_MAX_CACHE_SIZE)
 		return sz;
 


