Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52CC385D85;
	Tue, 12 May 2026 17:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607851; cv=none; b=Zxy6Fgj7saLyESn6xSJuQNZLM5RlJX4uAXdJCW6dIthUwgbkKsaZoJUi265Bo0fTzXeSeS9nLXtcUC0NTHnBK5xGgzertKMrGWwnVrK1YScOB4VbHpyserBPY6PxD4LjgAMZKB4N19ej2FC2B3NFxFooFKXF27qM+9boSlVNaRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607851; c=relaxed/simple;
	bh=a7pnDQBddgO+VlUoE4BD0uai40YUmqRxGh4G9ueWWU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XopZmgswIVEy9EbYY93Q5LsEStDnirCsY/8jbBwXtzMvFY7SJ16BCLnDjhiJ/JWL6TRo4Kt75Z3bFwugeo9jHujgsohEToInZJEt6xSpOr5wU+DZFzzpxtqRydVBs0VHAh+3iFldi4xqKMqStG5Ist3NcKxGXFMTRImeLHE1Caw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXXgDJ8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXXgDJ8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3F5C2BCB0;
	Tue, 12 May 2026 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607851;
	bh=a7pnDQBddgO+VlUoE4BD0uai40YUmqRxGh4G9ueWWU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXXgDJ8jMUkyJ5hzqP3YXqoQN/0gHl7z6iLji5lyyZ4RJN2COXuIFqcSamVE84u9y
	 xBXQ1gsxPv5FCaIdnKMcIagT+oEfzdG4hpLtqVCBW4ykQcvlvp7hxT+QtmGoMNaE/7
	 39br/vRxREB7jS0m2LPrL9o1sho5EFWjcyj3it+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/206] x86/shstk: Prevent deadlock during shstk sigreturn
Date: Tue, 12 May 2026 19:37:48 +0200
Message-ID: <20260512173933.164829250@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

[ Upstream commit 9874b2917b9fbc30956fee209d3c4aa47201c64e ]

During sigreturn the shadow stack signal frame is popped. The kernel does
this by reading the shadow stack using normal read accesses. When it can't
assume the memory is shadow stack, it takes extra steps to makes sure it is
reading actual shadow stack memory and not other normal readable memory. It
does this by holding the mmap read lock while doing the access and checking
the flags of the VMA.

Unfortunately that is not safe. If the read of the shadow stack sigframe
hits a page fault, the fault handler will try to recursively grab another
mmap read lock. This normally works ok, but if a writer on another CPU is
also waiting, the second read lock could fail and cause a deadlock.

Fix this by doing the read of the userspace memory via gup. Embed it in the
get_shstk_data() helper.

Currently there is a check that skips the lookup work when the SSP can be
assumed to be on a shadow stack. While reorganizing the function, remove
the optimization to make the tricky code flows more common, such that
issues like this cannot escape detection for so long.

[Due to missing per-vma MM sequence counter, use a simpler GUP based
solution for the backport]
Cc: <stable@vger.kernel.org> # Depends on https://lore.kernel.org/all/20260504205856.536296-1-rick.p.edgecombe@intel.com/
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/shstk.c | 46 ++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/shstk.c b/arch/x86/kernel/shstk.c
index 0dc983b33b003..373a44a5c478f 100644
--- a/arch/x86/kernel/shstk.c
+++ b/arch/x86/kernel/shstk.c
@@ -18,6 +18,7 @@
 #include <linux/sizes.h>
 #include <linux/user.h>
 #include <linux/syscalls.h>
+#include <linux/highmem.h>
 #include <asm/msr.h>
 #include <asm/fpu/xstate.h>
 #include <asm/fpu/types.h>
@@ -262,11 +263,29 @@ static int put_shstk_data(u64 __user *addr, u64 data)
 	return 0;
 }
 
+/* Copy from aligned address in userspace without risk of page fault. */
+static int shstk_copy_user_gup(unsigned long *ldata, unsigned long __user *addr)
+{
+	struct page *page;
+	void *kaddr;
+
+	mmap_assert_locked(current->mm);
+	if (get_user_pages((unsigned long)addr, 1, 0, &page) != 1)
+		return -EFAULT;
+
+	kaddr = kmap_local_page(page);
+	*ldata = *(unsigned long *)(kaddr + offset_in_page(addr));
+	kunmap_local(kaddr);
+	put_page(page);
+
+	return 0;
+}
+
 static int get_shstk_data(unsigned long *data, unsigned long __user *addr)
 {
 	unsigned long ldata;
 
-	if (unlikely(get_user(ldata, addr)))
+	if (shstk_copy_user_gup(&ldata, addr))
 		return -EFAULT;
 
 	if (!(ldata & SHSTK_DATA_BIT))
@@ -296,7 +315,6 @@ static int shstk_pop_sigframe(unsigned long *ssp)
 {
 	struct vm_area_struct *vma;
 	unsigned long token_addr;
-	bool need_to_check_vma;
 	int err = 1;
 
 	/*
@@ -308,26 +326,21 @@ static int shstk_pop_sigframe(unsigned long *ssp)
 	if (!IS_ALIGNED(*ssp, 8))
 		return -EINVAL;
 
-	need_to_check_vma = PAGE_ALIGN(*ssp) == *ssp;
-
-	if (need_to_check_vma)
-		if (mmap_read_lock_killable(current->mm))
-			return -EINTR;
+	if (mmap_read_lock_killable(current->mm))
+		return -EINTR;
 
 	err = get_shstk_data(&token_addr, (unsigned long __user *)*ssp);
 	if (unlikely(err))
 		goto out_err;
 
-	if (need_to_check_vma) {
-		vma = find_vma(current->mm, *ssp);
-		if (!vma || !(vma->vm_flags & VM_SHADOW_STACK)) {
-			err = -EFAULT;
-			goto out_err;
-		}
-
-		mmap_read_unlock(current->mm);
+	vma = find_vma(current->mm, *ssp);
+	if (!vma || !(vma->vm_flags & VM_SHADOW_STACK)) {
+		err = -EFAULT;
+		goto out_err;
 	}
 
+	mmap_read_unlock(current->mm);
+
 	/* Restore SSP aligned? */
 	if (unlikely(!IS_ALIGNED(token_addr, 8)))
 		return -EINVAL;
@@ -340,8 +353,7 @@ static int shstk_pop_sigframe(unsigned long *ssp)
 
 	return 0;
 out_err:
-	if (need_to_check_vma)
-		mmap_read_unlock(current->mm);
+	mmap_read_unlock(current->mm);
 	return err;
 }
 
-- 
2.53.0



