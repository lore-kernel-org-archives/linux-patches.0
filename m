Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB3717BB21;
	Sun,  7 Sep 2025 20:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276798; cv=none; b=KkvbzZL7S3UuCj+fOAEQbzBuTfsnYEMbjFPPndMd385L2Ba2lCCehesEB2EvuysHp/y17dqg+D7F4IvtUsZ/FoUzZKsTFXQLGRLb5SOh3kJL8Mh+H6BnExnP4c7i/eYH+WXxw+1Ik9BlIJs7sulkxtl/6HBVCnux/bn1klLC9l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276798; c=relaxed/simple;
	bh=G8YVOyjo7Bq/Quixix5IRVjG9zeuxlzyiR4KKaRwVh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l70KrKG7k8TEPwd0ZchvJwX3nsK65PYJjXl/zrxYsVlllA21+AV6E8+OjzLBtYAOstzHHHEC94Heerry6zWEBtI7nTT3Ez9DttfY75JkVn7CZyM2i4+r1U0P5lSTiKHNMPtQeuJW5DIUdOflupWEaxuaFn8veTx+ZAAt58A+2Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhDSdQXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhDSdQXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651F0C4CEF0;
	Sun,  7 Sep 2025 20:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276798;
	bh=G8YVOyjo7Bq/Quixix5IRVjG9zeuxlzyiR4KKaRwVh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhDSdQXRUgf+BfmT1z8QBNXF9BFn7i3ElFJm62f+N2e+4vxIDGcRmGgt85QHcAwgU
	 yA0JuD84gD5fqXZKAPdweZGKzkOa+iKmpZOfPxZiy81WfUYXuXgVjDvU7OY+vaHYT4
	 5VRlzXkrMPI6uUevknv9l1KOz5NXz26Rh1u8w/5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/121] slub: Reflow ___slab_alloc()
Date: Sun,  7 Sep 2025 21:59:10 +0200
Message-ID: <20250907195612.771347336@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3228,8 +3228,21 @@ new_objects:
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
@@ -3265,20 +3278,6 @@ new_objects:
 
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


