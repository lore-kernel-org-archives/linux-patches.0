Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC77146D53;
	Wed, 28 Jan 2026 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616173; cv=none; b=DBYzWzVhIbsRulECdifZRJp5vcfpKmFCtpo0gxvHmkyl/badbVpHgKyUClVZ5GRFwjHvALcjbCEsGxHb/87LDdouXNdCgcfwGzW2/ZsOyfT7tSDgTDsFFBQ6yrS8HFoYLsLmIDoqkT7nlK9amy4npRaIFbQVRo4gbyDuBS0wFoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616173; c=relaxed/simple;
	bh=rJ6oMLNI0mowSxB58Dzgw/xDwAlu329sTIZmLfKO2m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lw+0dfgisNKYzHFpUByfDktYMobd47rO4OAjMP7Vk90jpHzMULA237lkL9RHGtNyrIl4mkPwM3hYLTBRTRrP9tstPXX4twNL5ruORbi0AgJAMcSmoEpWvuxsVnenbObFojAueVs9fy1ElhgLXfZC2pWJ+6DVkYFTLxPrhEezqb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWtq8H1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWtq8H1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D621C4CEF1;
	Wed, 28 Jan 2026 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616172;
	bh=rJ6oMLNI0mowSxB58Dzgw/xDwAlu329sTIZmLfKO2m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWtq8H1e53JLHllNEhyXGj8yrAN/U/fjquOuH89q3ftzcZWlRP1fzRxCjk6memyhk
	 vBXSjXV58w8cWk6e2XQQ2Kxh34gkXg+y8Kjc0rMUL6c0EDjLPPeXs7ECzdhfOTVK6A
	 fSjtonCf4z52ofQbLckz31JK6oxyaXodyr6f++rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Jeongjun Park <aha310510@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 227/227] mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
Date: Wed, 28 Jan 2026 16:24:32 +0100
Message-ID: <20260128145352.606287876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 3b617fd3d317bf9dd7e2c233e56eafef05734c9d ]

The is_mergeable_anon_vma() function uses vmg->middle as the source VMA.
However when merging a new VMA, this field is NULL.

In all cases except mremap(), the new VMA will either be newly established
and thus lack an anon_vma, or will be an expansion of an existing VMA thus
we do not care about whether VMA is CoW'd or not.

In the case of an mremap(), we can end up in a situation where we can
accidentally allow an unfaulted/faulted merge with a VMA that has been
forked, violating the general rule that we do not permit this for reasons
of anon_vma lock scalability.

Now we have the ability to be aware of the fact we are copying a VMA and
also know which VMA that is, we can explicitly check for this, so do so.

This is pertinent since commit 879bca0a2c4f ("mm/vma: fix incorrectly
disallowed anonymous VMA merges"), as this patch permits unfaulted/faulted
merges that were previously disallowed running afoul of this issue.

While we are here, vma_had_uncowed_parents() is a confusing name, so make
it simple and rename it to vma_is_fork_child().

Link: https://lkml.kernel.org/r/6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Jeongjun Park <aha310510@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ with upstream commit 61f67c230a5e backported, this simply applied correctly. Built + tested ]
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vma.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/vma.c
+++ b/mm/vma.c
@@ -65,18 +65,13 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
-/*
- * If, at any point, the VMA had unCoW'd mappings from parents, it will maintain
- * more than one anon_vma_chain connecting it to more than one anon_vma. A merge
- * would mean a wider range of folios sharing the root anon_vma lock, and thus
- * potential lock contention, we do not wish to encourage merging such that this
- * scales to a problem.
- */
-static bool vma_had_uncowed_parents(struct vm_area_struct *vma)
+/* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
+static bool vma_is_fork_child(struct vm_area_struct *vma)
 {
 	/*
 	 * The list_is_singular() test is to avoid merging VMA cloned from
-	 * parents. This can improve scalability caused by anon_vma lock.
+	 * parents. This can improve scalability caused by the anon_vma root
+	 * lock.
 	 */
 	return vma && vma->anon_vma && !list_is_singular(&vma->anon_vma_chain);
 }
@@ -121,11 +116,19 @@ static bool is_mergeable_anon_vma(struct
 	VM_WARN_ON(src && src_anon != src->anon_vma);
 
 	/* Case 1 - we will dup_anon_vma() from src into tgt. */
-	if (!tgt_anon && src_anon)
-		return !vma_had_uncowed_parents(src);
+	if (!tgt_anon && src_anon) {
+		struct vm_area_struct *copied_from = vmg->copied_from;
+
+		if (vma_is_fork_child(src))
+			return false;
+		if (vma_is_fork_child(copied_from))
+			return false;
+
+		return true;
+	}
 	/* Case 2 - we will simply use tgt's anon_vma. */
 	if (tgt_anon && !src_anon)
-		return !vma_had_uncowed_parents(tgt);
+		return !vma_is_fork_child(tgt);
 	/* Case 3 - the anon_vma's are already shared. */
 	return src_anon == tgt_anon;
 }


