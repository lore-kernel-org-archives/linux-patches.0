Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE04C168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDE4C433EF;
	Mon,  8 May 2023 11:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545280;
	bh=ejZU+TywqRMZyglDQurYcz11UInfWEFzAjV+rxE1pQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P80Lm/Por1hrjQ2ANNSULXrnjaJ+XQPdOdH5yBsGuRSntnrQKpmhjGqgux7Bl9ubF
	 3rfxFwGrzNOm+0KixlnchpttcEl0f3dkiiAwjA/hMTz2NeYMz0wSRmPBzgfNso8sNv
	 4vp5c83n0Eciepqawtl10S3MJUfaTIMhv3WQXny0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	kernel test robot <oliver.sang@intel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 676/694] mm/mempolicy: correctly update prev when policy is equal on mbind
Date: Mon,  8 May 2023 11:48:31 +0200
Message-Id: <20230508094458.157724198@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Stoakes <lstoakes@gmail.com>

commit 00ca0f2e86bf40b016a646e6323a8941a09cf106 upstream.

The refactoring in commit f4e9e0e69468 ("mm/mempolicy: fix use-after-free
of VMA iterator") introduces a subtle bug which arises when attempting to
apply a new NUMA policy across a range of VMAs in mbind_range().

The refactoring passes a **prev pointer to keep track of the previous VMA
in order to reduce duplication, and in all but one case it keeps this
correctly updated.

The bug arises when a VMA within the specified range has an equivalent
policy as determined by mpol_equal() - which unlike other cases, does not
update prev.

This can result in a situation where, later in the iteration, a VMA is
found whose policy does need to change.  At this point, vma_merge() is
invoked with prev pointing to a VMA which is before the previous VMA.

Since vma_merge() discovers the curr VMA by looking for the one
immediately after prev, it will now be in a situation where this VMA is
incorrect and the merge will not proceed correctly.

This is checked in the VM_WARN_ON() invariant case with end >
curr->vm_end, which, if a merge is possible, results in a warning (if
CONFIG_DEBUG_VM is specified).

I note that vma_merge() performs these invariant checks only after
merge_prev/merge_next are checked, which is debatable as it hides this
issue if no merge is possible even though a buggy situation has arisen.

The solution is simply to update the prev pointer even when policies are
equal.

This caused a bug to arise in the 6.2.y stable tree, and this patch
resolves this bug.

Link: https://lkml.kernel.org/r/83f1d612acb519d777bebf7f3359317c4e7f4265.1682866629.git.lstoakes@gmail.com
Fixes: f4e9e0e69468 ("mm/mempolicy: fix use-after-free of VMA iterator")
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
  Link: https://lore.kernel.org/oe-lkp/202304292203.44ddeff6-oliver.sang@intel.com
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -808,8 +808,10 @@ static int mbind_range(struct vma_iterat
 		vmstart = vma->vm_start;
 	}
 
-	if (mpol_equal(vma_policy(vma), new_pol))
+	if (mpol_equal(vma_policy(vma), new_pol)) {
+		*prev = vma;
 		return 0;
+	}
 
 	pgoff = vma->vm_pgoff + ((vmstart - vma->vm_start) >> PAGE_SHIFT);
 	merged = vma_merge(vmi, vma->vm_mm, *prev, vmstart, vmend, vma->vm_flags,


