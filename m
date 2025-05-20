Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC79F243367;
	Tue, 20 May 2025 14:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750796; cv=none; b=kr3zZ2uSCWi79Bx5SUZKod2E1t9k7Fb5fi2BQT+kkfPygOLFrQ8BL73u0pDwoP8/0nlqMG5cLfUClH9rJlvWH41DeYwkcN42i+AexSwEUTaY5jepCDol9/Q5tsYHnIz6QOtyf00LhuXkPqk45C+Z7iU0CIx9gZqS3+O5LfP9WVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750796; c=relaxed/simple;
	bh=7AoaKXSWAsbkTsSIwl/frO0QG/wf9plvTPKdptWlexc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHU/jhv9OFo6znYzczUzQLiJ8VRYSMzbVAeuZfizANK32nsXbT9NI/tTe1h8gIGdO14z0fowDr4D4h+BAGOfo2u8JADonSn7xpGU/Il8AP56O8UuzhSm3DOpaAXzER4bJAVS9MVjXq8f09iom53PzEM5c6xPJAhocJRYsZm8ifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTMTN7YV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTMTN7YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA61C4CEE9;
	Tue, 20 May 2025 14:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750795;
	bh=7AoaKXSWAsbkTsSIwl/frO0QG/wf9plvTPKdptWlexc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTMTN7YVf7YQVu3SQO5ynfRZnRLwyCk2EVrQ2kB+IAFxNBx9YfuEUTw6WEqz1bu/t
	 MlWyww4+eacLbmEeHIE+tfWPiiDKUlKHXF3IXstLZVgEH0UUUxPgUBNVmaZ8vs6sN2
	 6JeW8gqkz3KE/rHeMrlrhvpfgYNwIwCESxIG0e7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 124/145] mm: userfaultfd: correct dirty flags set for both present and swap pte
Date: Tue, 20 May 2025 15:51:34 +0200
Message-ID: <20250520125815.404506488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barry Song <v-songbaohua@oppo.com>

commit 75cb1cca2c880179a11c7dd9380b6f14e41a06a4 upstream.

As David pointed out, what truly matters for mremap and userfaultfd move
operations is the soft dirty bit.  The current comment and
implementation—which always sets the dirty bit for present PTEs and
fails to set the soft dirty bit for swap PTEs—are incorrect.  This could
break features like Checkpoint-Restore in Userspace (CRIU).

This patch updates the behavior to correctly set the soft dirty bit for
both present and swap PTEs in accordance with mremap.

Link: https://lkml.kernel.org/r/20250508220912.7275-1-21cnbao@gmail.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: David Hildenbrand <david@redhat.com>
Closes: https://lore.kernel.org/linux-mm/02f14ee1-923f-47e3-a994-4950afb9afcc@redhat.com/
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1068,8 +1068,13 @@ static int move_present_pte(struct mm_st
 	src_folio->index = linear_page_index(dst_vma, dst_addr);
 
 	orig_dst_pte = mk_pte(&src_folio->page, dst_vma->vm_page_prot);
-	/* Follow mremap() behavior and treat the entry dirty after the move */
-	orig_dst_pte = pte_mkwrite(pte_mkdirty(orig_dst_pte), dst_vma);
+	/* Set soft dirty bit so userspace can notice the pte was moved */
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
+#endif
+	if (pte_dirty(orig_src_pte))
+		orig_dst_pte = pte_mkdirty(orig_dst_pte);
+	orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
 
 	set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 out:
@@ -1104,6 +1109,9 @@ static int move_swap_pte(struct mm_struc
 	}
 
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+#endif
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 


