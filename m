Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC58346D567;
	Tue, 21 Jul 2026 15:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649214; cv=none; b=B/Gq+Gezp67HI6E9TrO0jIos9oXVICjLvtIfewcbfp6LMh5zNSd72s70lBA6hstjoM+EeF6Wiu/dbIFoXHO3aWbjWlItd+BpGrLqRwtK7OMxMBtJb7ZM788o4UHfFle+TJQHtccefDsOfDo56fDsrQHa42+AMMgf+3Oak9s07nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649214; c=relaxed/simple;
	bh=f9stMkzmrvcKtKEzuOo/xoollqYrTrLUow0acpr72sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7EktyJDawQA0H1OCYJetBVnmuPYHPdS8uuTi7CShX3vSwO60keH+8mkzO+7zmTgt37f+NrHyLmVx3KFDEmjtGvVXstiiKB+f+L7SabzsIbDgS1aYlQifdl/m9/dN9YDgjMtI8Y6bUfuDkG8g7Xtt4sD9ovC/sJpYtGH/mwADQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E42++2eu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E42++2eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D22A1F000E9;
	Tue, 21 Jul 2026 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649212;
	bh=KdYrEfXtkRS6JaWLNjEQnUcR9tOmia35endlZq8hykQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E42++2euhINM8wirG5g0vW5trh0JDxwKo46kyOw59C48nFB5QuDXikUXatufe/Wyd
	 aDNK/N2OdyJATKSX8VvxqaBRFEXijuoOuqJdkL00majXTwTmws/5n+fTR96RCA9GZT
	 1AYQHTUblbGj0SgnaePLW5CHX+e9pWO1jiWF5EcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengming Hu <hu.shengming@zte.com.cn>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0492/2077] mm/slub: preserve original size in _kmalloc_nolock_noprof retry path
Date: Tue, 21 Jul 2026 17:02:45 +0200
Message-ID: <20260721152604.414015379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengming Hu <hu.shengming@zte.com.cn>

[ Upstream commit 19b206b9534a85266efa78febeb4ae185e75bccd ]

_kmalloc_nolock_noprof() retries from the next kmalloc bucket when the
initial allocation fails. The retry currently reuses `size` as the
bucket selector and overwrites it with s->object_size + 1.

That value is later passed as the original allocation size to
__slab_alloc_node(), slab_post_alloc_hook() and kasan_kmalloc(). On a
successful retry this makes KASAN/slub-debug observe the retry bucket
selector rather than the caller requested size, potentially widening the
valid kmalloc range and hiding overflows.

Keep the caller requested size separately as orig_size and pass it to
the allocation/debug/KASAN paths. Continue using `size` as the retry cache
selector.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock()")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Link: https://patch.msgid.link/202606042027323804pk3MRY42Jy7y42OHAhQZ@zte.com.cn
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9365501d0df148..eed3251eb7d0cc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5325,6 +5325,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
 void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
+	size_t orig_size = size;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
@@ -5373,7 +5374,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
+	ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, orig_size);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -5397,9 +5398,9 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 success:
 	maybe_wipe_obj_freeptr(s, ret);
 	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
-			     slab_want_init_on_alloc(alloc_gfp, s), size);
+			     slab_want_init_on_alloc(alloc_gfp, s), orig_size);
 
-	ret = kasan_kmalloc(s, ret, size, alloc_gfp);
+	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kmalloc_nolock_noprof);
-- 
2.53.0



