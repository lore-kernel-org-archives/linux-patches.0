Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B7C2AF07;
	Mon, 28 Oct 2024 06:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098527; cv=none; b=L4RwrJhrAe7Oxmc3FVTmhXQ2CRBWoqGCw8Lef4R1n5Y+DI1fkJZfQrEKdu0raBRhs3R/ntQ2IGf07dgJSdrNvl0UpgzpK38UC72+vNkykVfMjCNLf+L9cRnEvy9isoxFyui9L986xHO+yNiafZ1SCvTtFq4SZBOLJVHmE8ILJ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098527; c=relaxed/simple;
	bh=J0B+pHyok5ZKeRUSdBp6DWUxfPoVWPB2ijnHuQWmr7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVruGCHtnNXx97j4O/itxQdXn8r/cjmcgJy1v+rZ8hfxh+pljbXuTt1D88zlUIUDo8/QNFkC5oppWHs3zHLZ5NUNioLB6zP2oXmY2Bh3ueXWNBYVfh1qsbSmQ7KrIRVXfPQGzm0P7JmpJ4dXmQ7h3Z79XBXB8oWmRnXgp2ZlaH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yz7xK0Ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yz7xK0Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAD8C4CEC3;
	Mon, 28 Oct 2024 06:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098527;
	bh=J0B+pHyok5ZKeRUSdBp6DWUxfPoVWPB2ijnHuQWmr7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yz7xK0Psud2uS0gZxfePkCzL8G2JDQ4trMzoiwO0B+OjUrzH2Sxk2r8BWbCj52QjM
	 ualNILi7A18Vm+z1VpxCmuvkVsrW2jM+U7pLqGON1bFXm106Xvxe9Ho9owBdFzfSEb
	 y7twK8LPV9BGanM2ALCV9h2CcPDXZWftS12+Nbn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: [PATCH 6.11 258/261] x86: fix user address masking non-canonical speculation issue
Date: Mon, 28 Oct 2024 07:26:40 +0100
Message-ID: <20241028062318.555871906@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 86e6b1547b3d013bc392adf775b89318441403c2 upstream.

It turns out that AMD has a "Meltdown Lite(tm)" issue with non-canonical
accesses in kernel space.  And so using just the high bit to decide
whether an access is in user space or kernel space ends up with the good
old "leak speculative data" if you have the right gadget using the
result:

  CVE-2020-12965 “Transient Execution of Non-Canonical Accesses“

Now, the kernel surrounds the access with a STAC/CLAC pair, and those
instructions end up serializing execution on older Zen architectures,
which closes the speculation window.

But that was true only up until Zen 5, which renames the AC bit [1].
That improves performance of STAC/CLAC a lot, but also means that the
speculation window is now open.

Note that this affects not just the new address masking, but also the
regular valid_user_address() check used by access_ok(), and the asm
version of the sign bit check in the get_user() helpers.

It does not affect put_user() or clear_user() variants, since there's no
speculative result to be used in a gadget for those operations.

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Link: https://lore.kernel.org/all/80d94591-1297-4afb-b510-c665efd37f10@citrix.com/
Link: https://lore.kernel.org/all/20241023094448.GAZxjFkEOOF_DM83TQ@fat_crate.local/ [1]
Link: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-1010.html
Link: https://arxiv.org/pdf/2108.10771
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com> # LAM case
Fixes: 2865baf54077 ("x86: support user address masking instead of non-speculative conditional")
Fixes: 6014bc27561f ("x86-64: make access_ok() independent of LAM")
Fixes: b19b74bc99b1 ("x86/mm: Rework address range check in get_user() and put_user()")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/uaccess_64.h |   43 +++++++++++++++++++++-----------------
 arch/x86/kernel/cpu/common.c      |   10 ++++++++
 arch/x86/kernel/vmlinux.lds.S     |    1 
 arch/x86/lib/getuser.S            |    9 ++++++-
 4 files changed, 42 insertions(+), 21 deletions(-)

--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -12,6 +12,13 @@
 #include <asm/cpufeatures.h>
 #include <asm/page.h>
 #include <asm/percpu.h>
+#include <asm/runtime-const.h>
+
+/*
+ * Virtual variable: there's no actual backing store for this,
+ * it can purely be used as 'runtime_const_ptr(USER_PTR_MAX)'
+ */
+extern unsigned long USER_PTR_MAX;
 
 #ifdef CONFIG_ADDRESS_MASKING
 /*
@@ -46,19 +53,24 @@ static inline unsigned long __untagged_a
 
 #endif
 
-/*
- * The virtual address space space is logically divided into a kernel
- * half and a user half.  When cast to a signed type, user pointers
- * are positive and kernel pointers are negative.
- */
-#define valid_user_address(x) ((__force long)(x) >= 0)
+#define valid_user_address(x) \
+	((__force unsigned long)(x) <= runtime_const_ptr(USER_PTR_MAX))
 
 /*
  * Masking the user address is an alternative to a conditional
  * user_access_begin that can avoid the fencing. This only works
  * for dense accesses starting at the address.
  */
-#define mask_user_address(x) ((typeof(x))((long)(x)|((long)(x)>>63)))
+static inline void __user *mask_user_address(const void __user *ptr)
+{
+	unsigned long mask;
+	asm("cmp %1,%0\n\t"
+	    "sbb %0,%0"
+		:"=r" (mask)
+		:"r" (ptr),
+		 "0" (runtime_const_ptr(USER_PTR_MAX)));
+	return (__force void __user *)(mask | (__force unsigned long)ptr);
+}
 #define masked_user_access_begin(x) ({ __uaccess_begin(); mask_user_address(x); })
 
 /*
@@ -66,23 +78,16 @@ static inline unsigned long __untagged_a
  * arbitrary values in those bits rather then masking them off.
  *
  * Enforce two rules:
- * 1. 'ptr' must be in the user half of the address space
+ * 1. 'ptr' must be in the user part of the address space
  * 2. 'ptr+size' must not overflow into kernel addresses
  *
- * Note that addresses around the sign change are not valid addresses,
- * and will GP-fault even with LAM enabled if the sign bit is set (see
- * "CR3.LAM_SUP" that can narrow the canonicality check if we ever
- * enable it, but not remove it entirely).
- *
- * So the "overflow into kernel addresses" does not imply some sudden
- * exact boundary at the sign bit, and we can allow a lot of slop on the
- * size check.
+ * Note that we always have at least one guard page between the
+ * max user address and the non-canonical gap, allowing us to
+ * ignore small sizes entirely.
  *
  * In fact, we could probably remove the size check entirely, since
  * any kernel accesses will be in increasing address order starting
- * at 'ptr', and even if the end might be in kernel space, we'll
- * hit the GP faults for non-canonical accesses before we ever get
- * there.
+ * at 'ptr'.
  *
  * That's a separate optimization, for now just handle the small
  * constant case.
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -69,6 +69,7 @@
 #include <asm/sev.h>
 #include <asm/tdx.h>
 #include <asm/posted_intr.h>
+#include <asm/runtime-const.h>
 
 #include "cpu.h"
 
@@ -2371,6 +2372,15 @@ void __init arch_cpu_finalize_init(void)
 	alternative_instructions();
 
 	if (IS_ENABLED(CONFIG_X86_64)) {
+		unsigned long USER_PTR_MAX = TASK_SIZE_MAX-1;
+
+		/*
+		 * Enable this when LAM is gated on LASS support
+		if (cpu_feature_enabled(X86_FEATURE_LAM))
+			USER_PTR_MAX = (1ul << 63) - PAGE_SIZE - 1;
+		 */
+		runtime_const_init(ptr, USER_PTR_MAX);
+
 		/*
 		 * Make sure the first 2MB area is not mapped by huge pages
 		 * There are typically fixed size MTRRs in there and overlapping
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -359,6 +359,7 @@ SECTIONS
 
 	RUNTIME_CONST(shift, d_hash_shift)
 	RUNTIME_CONST(ptr, dentry_hashtable)
+	RUNTIME_CONST(ptr, USER_PTR_MAX)
 
 	. = ALIGN(PAGE_SIZE);
 
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -39,8 +39,13 @@
 
 .macro check_range size:req
 .if IS_ENABLED(CONFIG_X86_64)
-	mov %rax, %rdx
-	sar $63, %rdx
+	movq $0x0123456789abcdef,%rdx
+  1:
+  .pushsection runtime_ptr_USER_PTR_MAX,"a"
+	.long 1b - 8 - .
+  .popsection
+	cmp %rax, %rdx
+	sbb %rdx, %rdx
 	or %rdx, %rax
 .else
 	cmp $TASK_SIZE_MAX-\size+1, %eax


