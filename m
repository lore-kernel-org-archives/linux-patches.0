Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A141A76C6;
	Wed, 20 Nov 2024 13:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107632; cv=none; b=LryeKRkx10GHedk+PzAJDctopR+chg5r/8DzmUOoyGDKPUdyBR9/Mo0RLR2Ep5kR3dNcjfZioeQdncECLrpSUOr41wYKFirTVYoWG9EJrUSnVGyIXqyajmyNY6n6+rEKFWBEvHwOOSpVbkzqvEftKJcNwMYXRXEvb0FnviUJY8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107632; c=relaxed/simple;
	bh=W1FDxheENMxddUaKNpBfjqayyKzlbx/rFQN9owHgMWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJrf01vs43OlBbngGMy1eY+0GFJoIM8lDiNYbZtQR9e6LGKhe4xnyrXElwlrXnQ/r0kauOOtcZxZEO7jZSqdbp7K7R/WEwQvodAht5oDA4+I5fMeiN/UY4NNsxa+BcMqceOh3j8kUjes65SR+f3ajTbD41gqVBFHSYB5gN9nHhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOtR/hMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOtR/hMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B31BC4CECD;
	Wed, 20 Nov 2024 13:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107632;
	bh=W1FDxheENMxddUaKNpBfjqayyKzlbx/rFQN9owHgMWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOtR/hMV7v7EcPB7hh16AD1WSKB8C0oF8e++h8H8ao1M7/3SWu1fJnP0si4Knq4QQ
	 4B3heQ7wwla+j/qYaxVDHfltQQd/ll4WLtkKQxjnYbdoZ0isYRCd7VxWu6AqS3YriX
	 3ri0qgpKl0flRn9g4wLBT7ULmpP95QHuF2uZp/i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jann Horn <jannh@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	Helge Deller <deller@gmx.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Brown <broonie@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 78/82] mm: refactor arch_calc_vm_flag_bits() and arm64 MTE handling
Date: Wed, 20 Nov 2024 13:57:28 +0100
Message-ID: <20241120125631.374743159@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 5baf8b037debf4ec60108ccfeccb8636d1dbad81 ]

Currently MTE is permitted in two circumstances (desiring to use MTE
having been specified by the VM_MTE flag) - where MAP_ANONYMOUS is
specified, as checked by arch_calc_vm_flag_bits() and actualised by
setting the VM_MTE_ALLOWED flag, or if the file backing the mapping is
shmem, in which case we set VM_MTE_ALLOWED in shmem_mmap() when the mmap
hook is activated in mmap_region().

The function that checks that, if VM_MTE is set, VM_MTE_ALLOWED is also
set is the arm64 implementation of arch_validate_flags().

Unfortunately, we intend to refactor mmap_region() to perform this check
earlier, meaning that in the case of a shmem backing we will not have
invoked shmem_mmap() yet, causing the mapping to fail spuriously.

It is inappropriate to set this architecture-specific flag in general mm
code anyway, so a sensible resolution of this issue is to instead move the
check somewhere else.

We resolve this by setting VM_MTE_ALLOWED much earlier in do_mmap(), via
the arch_calc_vm_flag_bits() call.

This is an appropriate place to do this as we already check for the
MAP_ANONYMOUS case here, and the shmem file case is simply a variant of
the same idea - we permit RAM-backed memory.

This requires a modification to the arch_calc_vm_flag_bits() signature to
pass in a pointer to the struct file associated with the mapping, however
this is not too egregious as this is only used by two architectures anyway
- arm64 and parisc.

So this patch performs this adjustment and removes the unnecessary
assignment of VM_MTE_ALLOWED in shmem_mmap().

[akpm@linux-foundation.org: fix whitespace, per Catalin]
Link: https://lkml.kernel.org/r/ec251b20ba1964fb64cf1607d2ad80c47f3873df.1730224667.git.lorenzo.stoakes@oracle.com
Fixes: deb0f6562884 ("mm/mmap: undo ->mmap() when arch_validate_flags() fails")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mman.h  |   10 +++++++---
 arch/parisc/include/asm/mman.h |    5 +++--
 include/linux/mman.h           |    7 ++++---
 mm/mmap.c                      |    2 +-
 mm/nommu.c                     |    2 +-
 mm/shmem.c                     |    3 ---
 6 files changed, 16 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/mman.h
+++ b/arch/arm64/include/asm/mman.h
@@ -3,6 +3,8 @@
 #define __ASM_MMAN_H__
 
 #include <linux/compiler.h>
+#include <linux/fs.h>
+#include <linux/shmem_fs.h>
 #include <linux/types.h>
 #include <uapi/asm/mman.h>
 
@@ -21,19 +23,21 @@ static inline unsigned long arch_calc_vm
 }
 #define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
 
-static inline unsigned long arch_calc_vm_flag_bits(unsigned long flags)
+static inline unsigned long arch_calc_vm_flag_bits(struct file *file,
+						   unsigned long flags)
 {
 	/*
 	 * Only allow MTE on anonymous mappings as these are guaranteed to be
 	 * backed by tags-capable memory. The vm_flags may be overridden by a
 	 * filesystem supporting MTE (RAM-based).
 	 */
-	if (system_supports_mte() && (flags & MAP_ANONYMOUS))
+	if (system_supports_mte() &&
+	    ((flags & MAP_ANONYMOUS) || shmem_file(file)))
 		return VM_MTE_ALLOWED;
 
 	return 0;
 }
-#define arch_calc_vm_flag_bits(flags) arch_calc_vm_flag_bits(flags)
+#define arch_calc_vm_flag_bits(file, flags) arch_calc_vm_flag_bits(file, flags)
 
 static inline bool arch_validate_prot(unsigned long prot,
 	unsigned long addr __always_unused)
--- a/arch/parisc/include/asm/mman.h
+++ b/arch/parisc/include/asm/mman.h
@@ -2,6 +2,7 @@
 #ifndef __ASM_MMAN_H__
 #define __ASM_MMAN_H__
 
+#include <linux/fs.h>
 #include <uapi/asm/mman.h>
 
 /* PARISC cannot allow mdwe as it needs writable stacks */
@@ -11,7 +12,7 @@ static inline bool arch_memory_deny_writ
 }
 #define arch_memory_deny_write_exec_supported arch_memory_deny_write_exec_supported
 
-static inline unsigned long arch_calc_vm_flag_bits(unsigned long flags)
+static inline unsigned long arch_calc_vm_flag_bits(struct file *file, unsigned long flags)
 {
 	/*
 	 * The stack on parisc grows upwards, so if userspace requests memory
@@ -23,6 +24,6 @@ static inline unsigned long arch_calc_vm
 
 	return 0;
 }
-#define arch_calc_vm_flag_bits(flags) arch_calc_vm_flag_bits(flags)
+#define arch_calc_vm_flag_bits(file, flags) arch_calc_vm_flag_bits(file, flags)
 
 #endif /* __ASM_MMAN_H__ */
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MMAN_H
 #define _LINUX_MMAN_H
 
+#include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/percpu_counter.h>
 
@@ -94,7 +95,7 @@ static inline void vm_unacct_memory(long
 #endif
 
 #ifndef arch_calc_vm_flag_bits
-#define arch_calc_vm_flag_bits(flags) 0
+#define arch_calc_vm_flag_bits(file, flags) 0
 #endif
 
 #ifndef arch_validate_prot
@@ -151,12 +152,12 @@ calc_vm_prot_bits(unsigned long prot, un
  * Combine the mmap "flags" argument into "vm_flags" used internally.
  */
 static inline unsigned long
-calc_vm_flag_bits(unsigned long flags)
+calc_vm_flag_bits(struct file *file, unsigned long flags)
 {
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
-	       arch_calc_vm_flag_bits(flags);
+		arch_calc_vm_flag_bits(file, flags);
 }
 
 unsigned long vm_commit_limit(void);
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1273,7 +1273,7 @@ unsigned long do_mmap(struct file *file,
 	 * to. we assume access permissions have been handled by the open
 	 * of the memory object, so we don't do any here.
 	 */
-	vm_flags |= calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(flags) |
+	vm_flags |= calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(file, flags) |
 			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 
 	if (flags & MAP_LOCKED)
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -853,7 +853,7 @@ static unsigned long determine_vm_flags(
 {
 	unsigned long vm_flags;
 
-	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(flags);
+	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(file, flags);
 
 	if (!file) {
 		/*
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2400,9 +2400,6 @@ static int shmem_mmap(struct file *file,
 	if (ret)
 		return ret;
 
-	/* arm64 - allow memory tagging on RAM-based files */
-	vm_flags_set(vma, VM_MTE_ALLOWED);
-
 	file_accessed(file);
 	/* This is anonymous shared memory if it is unlinked at the time of mmap */
 	if (inode->i_nlink)


