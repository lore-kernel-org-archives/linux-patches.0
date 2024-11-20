Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E23A1A704B;
	Wed, 20 Nov 2024 13:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107712; cv=none; b=amr6wYWAzbmksv4yzxX7ysUbRPTpLnzZP4NEJtKRWMuJmHxMKTBS1GRfrc7a+gaWOdXbjtyQ8fBpJKlCHaaVEmwMrtZ6E/2MhLJ1gWTGENqDpTtWtYVevQkqXtRWaLU0SjKN0dLoz8tW4my+fEgK7NilOc3nvNqdTLhuWCfQUbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107712; c=relaxed/simple;
	bh=sXDVvjEkr5frXIYRcJudEFHlvtkpKatK7KF2QP6jna0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cki27Z5Y9OA9h2gQIKWjK9L1gwu5mC9m2Wfa2x++BPFyknBrNH9Pgqduk7F4rzmk1O0w/668YwOjOu9Fb0YuujSpGFAWHsajJPI7Tm2gHj6FCLXydkJ2w/P54dKY+bX754l7any4QizymK7MpICjgg2psQxYLtNBFNYMLnYLGIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FV4GFaDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FV4GFaDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FE8C4CED2;
	Wed, 20 Nov 2024 13:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107712;
	bh=sXDVvjEkr5frXIYRcJudEFHlvtkpKatK7KF2QP6jna0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FV4GFaDqk93n9928vL3RrsnPoAzwgdxq6kQ1XhjI6iFR/YqzBNXA4WoLU71rMDkrR
	 pGyVxN95YVDi/9XUrl2m+yvpJP7rB+ChffAWQckyjeF+atICm1mbxnQyN358UFLaYn
	 Ov6A7BE8Hd9ufy3Dt6gn7e30jFhbzhcTQ41Yxoes=
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
Subject: [PATCH 6.1 63/73] mm: unconditionally close VMAs on error
Date: Wed, 20 Nov 2024 13:58:49 +0100
Message-ID: <20241120125811.119859175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 mm/mmap.c     |   12 ++++--------
 mm/nommu.c    |    3 +--
 mm/util.c     |   15 +++++++++++++++
 4 files changed, 27 insertions(+), 10 deletions(-)

--- a/mm/internal.h
+++ b/mm/internal.h
@@ -64,6 +64,13 @@ void page_writeback_init(void);
  */
 int mmap_file(struct file *file, struct vm_area_struct *vma);
 
+/*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+void vma_close(struct vm_area_struct *vma);
+
 static inline void *folio_raw_mapping(struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -136,8 +136,7 @@ void unlink_file_vma(struct vm_area_stru
 static void remove_vma(struct vm_area_struct *vma)
 {
 	might_sleep();
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
@@ -2388,8 +2387,7 @@ int __split_vma(struct mm_struct *mm, st
 	new->vm_start = new->vm_end;
 	new->vm_pgoff = 0;
 	/* Clean everything up if vma_adjust failed. */
-	if (new->vm_ops && new->vm_ops->close)
-		new->vm_ops->close(new);
+	vma_close(new);
 	if (new->vm_file)
 		fput(new->vm_file);
 	unlink_anon_vmas(new);
@@ -2885,8 +2883,7 @@ expanded:
 	return addr;
 
 close_and_free_vma:
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 unmap_and_free_vma:
 	fput(vma->vm_file);
 	vma->vm_file = NULL;
@@ -3376,8 +3373,7 @@ struct vm_area_struct *copy_vma(struct v
 	return new_vma;
 
 out_vma_link:
-	if (new_vma->vm_ops && new_vma->vm_ops->close)
-		new_vma->vm_ops->close(new_vma);
+	vma_close(new_vma);
 
 	if (new_vma->vm_file)
 		fput(new_vma->vm_file);
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -650,8 +650,7 @@ static int delete_vma_from_mm(struct vm_
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
@@ -1121,6 +1121,21 @@ int mmap_file(struct file *file, struct
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


