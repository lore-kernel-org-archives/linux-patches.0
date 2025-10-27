Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7931DDC1B;
	Mon, 27 Oct 2025 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593354; cv=none; b=bA/pWLOQwU6HG93I0l2HqZD9Dv/O5c0brlUZPO4CSwf5vRDDPBKC9gN/HrfHag4uxFOTj+JH0vBDauPcw97nWWDIotDm8UPtG6lR3MQmZ6TZDRa13tlUfFmGuK+0MYr0mnkY7F6WOPUSOR/y3dr01+eX1Jo0N5J8oqyKPaPTC/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593354; c=relaxed/simple;
	bh=DPCdu3rey6gyzvVGCZD6zvnzjs/k56sOaawWEsxgRs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFowx7LPyVrRn27Tk+Y6mzlYB145mnuJKxlHTL668vzROaPX+dbhuC1TQf3djAXetDqYvZKAIadSoBpEA+O3asip0RXuIVOVX6nBuqqZJ3UQryohF5uLkmY6Snuhaen9P7huBCFkOg+Bmok5hrrQ/F/EEVdh8APBEQmTLGtH6Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apEy9Gdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apEy9Gdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8C0C4CEF1;
	Mon, 27 Oct 2025 19:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593353;
	bh=DPCdu3rey6gyzvVGCZD6zvnzjs/k56sOaawWEsxgRs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apEy9GdobToOLuh5PHrRnz8psjfYl81vRCjIaIqM+a1hdflIOJzF/3f1Jev/6CcxL
	 65pdXCFW6eyGjgsZkadEe5U4z3nemus7HOyga0Km5D94Lfc+y6J38zOLK/Q3tP0RmJ
	 mbNDkXBhYQouBivISfEsku3MTtWUcOwUUAoVb0X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 106/184] mm/mremap: correctly account old mapping after MREMAP_DONTUNMAP remap
Date: Mon, 27 Oct 2025 19:36:28 +0100
Message-ID: <20251027183517.773982781@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 0e59f47c15cec4cd88c51c5cda749607b719c82b upstream.

Commit b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
mistakenly introduced a new behaviour - clearing the VM_ACCOUNT flag of
the old mapping when a mapping is mremap()'d with the MREMAP_DONTUNMAP
flag set.

While we always clear the VM_LOCKED and VM_LOCKONFAULT flags for the old
mapping (the page tables have been moved, so there is no data that could
possibly be locked in memory), there is no reason to touch any other VMA
flags.

This is because after the move the old mapping is in a state as if it were
freshly mapped.  This implies that the attributes of the mapping ought to
remain the same, including whether or not the mapping is accounted.

Link: https://lkml.kernel.org/r/20251013165836.273113-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 35de0a7b910e..bd7314898ec5 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1237,10 +1237,10 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 }
 
 /*
- * Perform final tasks for MADV_DONTUNMAP operation, clearing mlock() and
- * account flags on remaining VMA by convention (it cannot be mlock()'d any
- * longer, as pages in range are no longer mapped), and removing anon_vma_chain
- * links from it (if the entire VMA was copied over).
+ * Perform final tasks for MADV_DONTUNMAP operation, clearing mlock() flag on
+ * remaining VMA by convention (it cannot be mlock()'d any longer, as pages in
+ * range are no longer mapped), and removing anon_vma_chain links from it if the
+ * entire VMA was copied over.
  */
 static void dontunmap_complete(struct vma_remap_struct *vrm,
 			       struct vm_area_struct *new_vma)
@@ -1250,11 +1250,8 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 	unsigned long old_start = vrm->vma->vm_start;
 	unsigned long old_end = vrm->vma->vm_end;
 
-	/*
-	 * We always clear VM_LOCKED[ONFAULT] | VM_ACCOUNT on the old
-	 * vma.
-	 */
-	vm_flags_clear(vrm->vma, VM_LOCKED_MASK | VM_ACCOUNT);
+	/* We always clear VM_LOCKED[ONFAULT] on the old VMA. */
+	vm_flags_clear(vrm->vma, VM_LOCKED_MASK);
 
 	/*
 	 * anon_vma links of the old vma is no longer needed after its page
-- 
2.51.1



