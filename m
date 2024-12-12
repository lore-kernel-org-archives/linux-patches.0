Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAB72139C9;
	Thu, 12 Dec 2024 16:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021735; cv=none; b=f5DrOwdD3NU+r8kuM/G+3fRrFxLJWHk1REx+nsgsRMfywPODO0Sr7bvzTHztA8YAsaiK7dPbJlx19dMjk/mier9YnQUV2bbIFL30UQtbr8aVQ8xFZI6BPb1M42EGTEBCGipr+IqJu5C2MoJULZ6qpo26XWIXwItvypVS1dWVgdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021735; c=relaxed/simple;
	bh=fwbg6tJJNZPKpyKQn8N0P6Qa16nZ9iWm2xyNedAKA3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNe0247zJiSPBeoJVo6kYYgz21C4EDnOuQuoU/wuWMGedF8bU+L8m9FX4odAlqIo1a1WVIgM/2jIChKDUNM3xkmNECo7Aezw9yoTNqFB7Xi7UdH0gHBCQctV73uKrK2j0/QN4bED6CS7zhXPFawu0chyF6rZRMZt32ImCUgx/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGDTh+lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGDTh+lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54785C4CED0;
	Thu, 12 Dec 2024 16:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021735;
	bh=fwbg6tJJNZPKpyKQn8N0P6Qa16nZ9iWm2xyNedAKA3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGDTh+lj6AN3MqiPcBYLg6t3pe0vP6gnWadNNl00xX7+xg7hXx6YCKar3j1WBfcD0
	 RR9ZpUgLa7ghh5DKyfH/GnjYe0BGW3gQMdLY40ai2URk/WBdJK6J7pBZyUVFzJ8Oko
	 lzrFc1DK59ISdWhPAMKall4SLjX9cLFLCu7G8DlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jann Horn <jannh@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Helge Deller <deller@gmx.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Brown <broonie@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 047/565] mm: unconditionally close VMAs on error
Date: Thu, 12 Dec 2024 15:54:02 +0100
Message-ID: <20241212144313.348452562@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 4080ef1579b2413435413988d14ac8c68e4d42c8 ]

Incorrect invocation of VMA callbacks when the VMA is no longer in a
consistent state is bug prone and risky to perform.

With regards to the important vm_ops->close() callback We have gone to
great lengths to try to track whether or not we ought to close VMAs.

Rather than doing so and risking making a mistake somewhere, instead
unconditionally close and reset vma->vm_ops to an empty dummy operations
set with a NULL .close operator.

We introduce a new function to do so - vma_close() - and simplify existing
vms logic which tracked whether we needed to close or not.

This simplifies the logic, avoids incorrect double-calling of the .close()
callback and allows us to update error paths to simply call vma_close()
unconditionally - making VMA closure idempotent.

Link: https://lkml.kernel.org/r/28e89dda96f68c505cb6f8e9fc9b57c3e9f74b42.1730224667.git.lorenzo.stoakes@oracle.com
Fixes: deb0f6562884 ("mm/mmap: undo ->mmap() when arch_validate_flags() fails")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/internal.h |    7 +++++++
 mm/mmap.c     |    9 +++------
 mm/nommu.c    |    3 +--
 mm/util.c     |   15 +++++++++++++++
 4 files changed, 26 insertions(+), 8 deletions(-)

--- a/mm/internal.h
+++ b/mm/internal.h
@@ -46,6 +46,13 @@ void page_writeback_init(void);
  */
 int mmap_file(struct file *file, struct vm_area_struct *vma);
 
+/*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+void vma_close(struct vm_area_struct *vma);
+
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -180,8 +180,7 @@ static struct vm_area_struct *remove_vma
 	struct vm_area_struct *next = vma->vm_next;
 
 	might_sleep();
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
@@ -1877,8 +1876,7 @@ out:
 	return addr;
 
 close_and_free_vma:
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 unmap_and_free_vma:
 	fput(vma->vm_file);
 	vma->vm_file = NULL;
@@ -2762,8 +2760,7 @@ int __split_vma(struct mm_struct *mm, st
 		return 0;
 
 	/* Clean everything up if vma_adjust failed. */
-	if (new->vm_ops && new->vm_ops->close)
-		new->vm_ops->close(new);
+	vma_close(new);
 	if (new->vm_file)
 		fput(new->vm_file);
 	unlink_anon_vmas(new);
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -652,8 +652,7 @@ static void delete_vma_from_mm(struct vm
  */
 static void delete_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	put_nommu_region(vma->vm_region);
--- a/mm/util.c
+++ b/mm/util.c
@@ -1104,6 +1104,21 @@ int mmap_file(struct file *file, struct
 	return err;
 }
 
+void vma_close(struct vm_area_struct *vma)
+{
+	static const struct vm_operations_struct dummy_vm_ops = {};
+
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &dummy_vm_ops;
+	}
+}
+
 #ifdef CONFIG_PRINTK
 /**
  * mem_dump_obj - Print available provenance information


