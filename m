Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC531B424F;
	Sun,  7 Sep 2025 20:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276420; cv=none; b=DF95bn+HuLcOyk0resydnXUVP54nas6frK69/dSLpCkyKLTul/qpl0tgP63mw7FPU5ZC1xC0PXrsMoi3dJBXjY7qIKRE9PkQ3vCOM6gKRijQ7QZOz3BRpQdlwm96AXlqqEVKjG5cKuaOJKD2eQmqfINnuZclV/I5J/VTz8OsR00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276420; c=relaxed/simple;
	bh=0kSSfDF1/2HmgJjZTS4zsgqH5epobYJchujoneG/3wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHSm5ukEa/8al2naQ+r5sNzpZXsn1u/7cbGaHZA5GbdYyJPp+3l2ryKmBxVJtAO8FxOmHFcqfQtMSO1Qc3z/WClxv7ltXvtKPurELTyz9R4DeTLl0c4l1Cm40AlmC2sFp7axVRWra28+QvkE4qwNt9Yk0lK2ysvPAOk6WH+u6f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzsa2Yn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzsa2Yn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10C4C4CEF0;
	Sun,  7 Sep 2025 20:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276420;
	bh=0kSSfDF1/2HmgJjZTS4zsgqH5epobYJchujoneG/3wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzsa2Yn5dMAwNfITH3mn20UvMtK46TA4kmrCFk9M4ebTxOG75cqt4pT7kkKfoL58W
	 QruP3gc+vvAOVudqExXTOOjoPH+cVGgmqF3mPKZ6INYMHv05MZ34RXpo7nXssJKQCl
	 650KrX5nPEltypQAWbxfJpRvwEvbxV8HzTExOukg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/104] slub: Reflow ___slab_alloc()
Date: Sun,  7 Sep 2025 21:58:55 +0200
Message-ID: <20250907195610.203682363@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit 24c6a097b5a270e05c6e99a99da66b91be81fd7d ]

The get_partial() interface used in ___slab_alloc() may return a single
object in the "kmem_cache_debug(s)" case, in which we will just return
the "freelist" object.

Move this handling up to prepare for later changes.

And the "pfmemalloc_match()" part is not needed for node partial slab,
since we already check this in the get_partial_node().

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Stable-dep-of: 850470a8413a ("mm: slub: avoid wake up kswapd in set_track_prepare")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3129,8 +3129,21 @@ new_objects:
 	pc.slab = &slab;
 	pc.orig_size = orig_size;
 	freelist = get_partial(s, node, &pc);
-	if (freelist)
-		goto check_new_slab;
+	if (freelist) {
+		if (kmem_cache_debug(s)) {
+			/*
+			 * For debug caches here we had to go through
+			 * alloc_single_from_partial() so just store the
+			 * tracking info and return the object.
+			 */
+			if (s->flags & SLAB_STORE_USER)
+				set_track(s, freelist, TRACK_ALLOC, addr);
+
+			return freelist;
+		}
+
+		goto retry_load_slab;
+	}
 
 	slub_put_cpu_ptr(s->cpu_slab);
 	slab = new_slab(s, gfpflags, node);
@@ -3166,20 +3179,6 @@ new_objects:
 
 	inc_slabs_node(s, slab_nid(slab), slab->objects);
 
-check_new_slab:
-
-	if (kmem_cache_debug(s)) {
-		/*
-		 * For debug caches here we had to go through
-		 * alloc_single_from_partial() so just store the tracking info
-		 * and return the object
-		 */
-		if (s->flags & SLAB_STORE_USER)
-			set_track(s, freelist, TRACK_ALLOC, addr);
-
-		return freelist;
-	}
-
 	if (unlikely(!pfmemalloc_match(slab, gfpflags))) {
 		/*
 		 * For !pfmemalloc_match() case we don't load freelist so that


