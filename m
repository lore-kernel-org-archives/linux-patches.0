Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEE435A3AD;
	Mon,  4 May 2026 14:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904167; cv=none; b=IKjC6MhLFyxlcQOGUA2t90FwUIeXZl/PlCRqoaZFTnJvJzHibnKiDEEYFd8jAAixKudu9ilC9OBC1DaWzaYIquNWd+4ZXv7yxqsRUI19iF4IGoz3vOuouVC/1O06Pkw2oRtz/bI9Cwy3fNaY0HrZQr/qyoVM9FxX5A1VTUsLRf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904167; c=relaxed/simple;
	bh=1gGwr/3Hz/axfbVjX3aTw+Xb8EkqYFJTct/gE1feWkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLnTR1KPRGxePai9hC6F9QfjpGZ3O5QPGeD5myaHb/d1GBBCdYmGUx66cRaG5HBRQMPj/UoJlxSUpcY+HRKC1dpSCXZkxXIL2gfzzxkCiTk/Aipewr6e3rPGJOVPWGioHJnC9K2LKLUZqGfKY2nWXjEXkKUluGAEXoV4xBqIF+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkSzMPQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkSzMPQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F6AC2BCB8;
	Mon,  4 May 2026 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904167;
	bh=1gGwr/3Hz/axfbVjX3aTw+Xb8EkqYFJTct/gE1feWkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkSzMPQcSKlfEpefwmxbOxwJWenEIatDp2V1jBbCHhY8U9/2eNN4ntgevbmE8iV3Y
	 9DyuZ9nvmdh0YsREfo2yoVd0WgbTwiZEUaXM0TP0CNogUOX5A7jFL4jJDYWWbLwg3T
	 bQWFQQEdtQGHZXS3xFWNIFHa+HUuKhtubZgvaKJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH 6.18 210/275] x86/shstk: Prevent deadlock during shstk sigreturn
Date: Mon,  4 May 2026 15:52:30 +0200
Message-ID: <20260504135150.878028914@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

commit 9874b2917b9fbc30956fee209d3c4aa47201c64e upstream.

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

Fix this by not holding mmap lock during the read access to userspace.

Instead use mmap_lock_speculate_...() to watch for changes between dropping
mmap lock and the userspace access. Retry if anything grabbed an mmap write
lock in between and could have changed the VMA.

These mmap_lock_speculate_...() helpers use mm::mm_lock_seq, which is only
available when PER_VMA_LOCK is configured. So make X86_USER_SHADOW_STACK
depend on it. On x86, PER_VMA_LOCK is a default configuration for SMP
kernels. So drop support for the other configs under the assumption that
the !SMP shadow stack user base does not exist.

Currently there is a check that skips the lookup work when the SSP can be
assumed to be on a shadow stack. While reorganizing the function, remove
the optimization to make the tricky code flows more common, such that
issues like this cannot escape detection for so long.

Fixes: 7fad2a432cd3 ("x86/shstk: Check that signal frame is shadow stack mem")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig        |    1 +
 arch/x86/kernel/shstk.c |   42 +++++++++++++++++++++++-------------------
 2 files changed, 24 insertions(+), 19 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1877,6 +1877,7 @@ config X86_USER_SHADOW_STACK
 	bool "X86 userspace shadow stack"
 	depends on AS_WRUSS
 	depends on X86_64
+	depends on PER_VMA_LOCK
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_USER_SHADOW_STACK
 	select X86_CET
--- a/arch/x86/kernel/shstk.c
+++ b/arch/x86/kernel/shstk.c
@@ -334,10 +334,8 @@ static int shstk_push_sigframe(unsigned
 
 static int shstk_pop_sigframe(unsigned long *ssp)
 {
-	struct vm_area_struct *vma;
 	unsigned long token_addr;
-	bool need_to_check_vma;
-	int err = 1;
+	unsigned int seq;
 
 	/*
 	 * It is possible for the SSP to be off the end of a shadow stack by 4
@@ -348,25 +346,35 @@ static int shstk_pop_sigframe(unsigned l
 	if (!IS_ALIGNED(*ssp, 8))
 		return -EINVAL;
 
-	need_to_check_vma = PAGE_ALIGN(*ssp) == *ssp;
+	do {
+		struct vm_area_struct *vma;
+		bool valid_vma;
+		int err;
 
-	if (need_to_check_vma)
 		if (mmap_read_lock_killable(current->mm))
 			return -EINTR;
 
-	err = get_shstk_data(&token_addr, (unsigned long __user *)*ssp);
-	if (unlikely(err))
-		goto out_err;
-
-	if (need_to_check_vma) {
 		vma = find_vma(current->mm, *ssp);
-		if (!vma || !(vma->vm_flags & VM_SHADOW_STACK)) {
-			err = -EFAULT;
-			goto out_err;
-		}
+		valid_vma = vma && (vma->vm_flags & VM_SHADOW_STACK);
 
+		/*
+		 * VMAs can change between get_shstk_data() and find_vma().
+		 * Watch for changes and ensure that 'token_addr' comes from
+		 * 'vma' by recording a seqcount.
+		 *
+		 * Ignore the return value of mmap_lock_speculate_try_begin()
+		 * because the mmap lock excludes the possibility of writers.
+		 */
+		mmap_lock_speculate_try_begin(current->mm, &seq);
 		mmap_read_unlock(current->mm);
-	}
+
+		if (!valid_vma)
+			return -EINVAL;
+
+		err = get_shstk_data(&token_addr, (unsigned long __user *)*ssp);
+		if (err)
+			return err;
+	} while (mmap_lock_speculate_retry(current->mm, seq));
 
 	/* Restore SSP aligned? */
 	if (unlikely(!IS_ALIGNED(token_addr, 8)))
@@ -379,10 +387,6 @@ static int shstk_pop_sigframe(unsigned l
 	*ssp = token_addr;
 
 	return 0;
-out_err:
-	if (need_to_check_vma)
-		mmap_read_unlock(current->mm);
-	return err;
 }
 
 int setup_signal_shadow_stack(struct ksignal *ksig)


