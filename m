Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACE81CF5C6;
	Wed,  7 May 2025 19:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644724; cv=none; b=rd40HMaNtf+FQtDvOlhVrdlIhqZOqG0DPQCi2WzqYWMOvStaVhn7gYEVacptiXZjqWHffm9CPS7H4sGVXHycTwmcMkOD306PDtPtU/41e+PCykmDKjx7qskpJUfFIyVi1mDNSzypE2jVIAey6aUmVwvhCfvl0Ptvst0GaO12GDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644724; c=relaxed/simple;
	bh=TJUXeAejDKO7jrESi61OJ+6pHcjpMs5kA/vPU3oNSHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C30J0nCdZ3KMBdObzTS8WmNyzZPYfrXoZBGF8uuLLxdJrPEeEIaeG6G0Cy198/S7KRYdDI4FqlGWPVpePiPMMkBzm+s6aCM2g5MFRf5SccCV09GKuAWkRSo8GQ9ic824yt5L0ZrX4q7CvyPzCz2G1+4X+oEZXBqWfXfkqLSsREs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mme267KL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mme267KL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0279CC4CEE2;
	Wed,  7 May 2025 19:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644724;
	bh=TJUXeAejDKO7jrESi61OJ+6pHcjpMs5kA/vPU3oNSHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mme267KLOihLm361pw7vrs0DYHxQCC5H4sw34MG2vguYpfCInIuWOy7mwwrIQ8psX
	 ewG6AUyPgKGfQG+bbWxTwEnWbctpdgHnJuHZ5dATm45gMjZTfVtunbp89voHeXQyWw
	 JL/DH9FEkAh8909s26r5OpS8mbnb0eF9BPnK97Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	David Rientjes <rientjes@google.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 137/164] mm, slab: clean up slab->obj_exts always
Date: Wed,  7 May 2025 20:40:22 +0200
Message-ID: <20250507183826.520321014@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Zhenhua Huang <quic_zhenhuah@quicinc.com>

commit be8250786ca94952a19ce87f98ad9906448bc9ef upstream.

When memory allocation profiling is disabled at runtime or due to an
error, shutdown_mem_profiling() is called: slab->obj_exts which
previously allocated remains.
It won't be cleared by unaccount_slab() because of
mem_alloc_profiling_enabled() not true. It's incorrect, slab->obj_exts
should always be cleaned up in unaccount_slab() to avoid following error:

[...]BUG: Bad page state in process...
..
[...]page dumped because: page still charged to cgroup

[andriy.shevchenko@linux.intel.com: fold need_slab_obj_ext() into its only user]
Fixes: 21c690a349ba ("mm: introduce slabobj_ext to support slab object extensions")
Cc: stable@vger.kernel.org
Signed-off-by: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20250421075232.2165527-1-quic_zhenhuah@quicinc.com
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
[surenb: fixed trivial merge conflict in alloc_tagging_slab_alloc_hook(),
skipped inlining free_slab_obj_exts() as it's already inline in 6.12]
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2035,18 +2035,6 @@ static inline void free_slab_obj_exts(st
 	slab->obj_exts = 0;
 }
 
-static inline bool need_slab_obj_ext(void)
-{
-	if (mem_alloc_profiling_enabled())
-		return true;
-
-	/*
-	 * CONFIG_MEMCG creates vector of obj_cgroup objects conditionally
-	 * inside memcg_slab_post_alloc_hook. No other users for now.
-	 */
-	return false;
-}
-
 #else /* CONFIG_SLAB_OBJ_EXT */
 
 static inline void init_slab_obj_exts(struct slab *slab)
@@ -2063,11 +2051,6 @@ static inline void free_slab_obj_exts(st
 {
 }
 
-static inline bool need_slab_obj_ext(void)
-{
-	return false;
-}
-
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
@@ -2099,7 +2082,7 @@ prepare_slab_obj_exts_hook(struct kmem_c
 static inline void
 alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 {
-	if (need_slab_obj_ext()) {
+	if (mem_alloc_profiling_enabled()) {
 		struct slabobj_ext *obj_exts;
 
 		obj_exts = prepare_slab_obj_exts_hook(s, flags, object);
@@ -2577,8 +2560,12 @@ static __always_inline void account_slab
 static __always_inline void unaccount_slab(struct slab *slab, int order,
 					   struct kmem_cache *s)
 {
-	if (memcg_kmem_online() || need_slab_obj_ext())
-		free_slab_obj_exts(slab);
+	/*
+	 * The slab object extensions should now be freed regardless of
+	 * whether mem_alloc_profiling_enabled() or not because profiling
+	 * might have been disabled after slab->obj_exts got allocated.
+	 */
+	free_slab_obj_exts(slab);
 
 	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
 			    -(PAGE_SIZE << order));


