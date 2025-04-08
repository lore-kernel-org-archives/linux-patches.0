Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42EF264A70;
	Tue,  8 Apr 2025 11:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112340; cv=none; b=Url9qDr4/+FeVnpM+TS3LzqrF9H1qmDo4n1eeE40Js5gOAfjJYWyRFHaT5Kn3zd/kTMXRCx+HakP8s4QaoSGKGfyTyVPY/XOBCu623UIxv+lfh9BL5UaFA8c3zLDWFWGqq6y2ov0GXjPNMhl7gkA1hxJy61vymWRtoU3/aiykvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112340; c=relaxed/simple;
	bh=uYO3TBS2u3VUwSdOakaYQsbKQGuOgiJKdCyCymhph7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7X7oQPKzPDNDCCBbnVnyOYe3+sBfD58MDDzM+iT37C158GDGFLMh1h4H4RzhQRHrqPaZguwy5rkF7pVUC+Vkx6vw3PBcRah8n1d6OnNzOLhitcJIMjjuHOvnQvojSJfHX5RsiergAzt6zNjdO/3hYBiWVg+Sku1JOLP9ZS1EsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrbLA1bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrbLA1bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73025C4CEE7;
	Tue,  8 Apr 2025 11:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112339;
	bh=uYO3TBS2u3VUwSdOakaYQsbKQGuOgiJKdCyCymhph7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrbLA1btjJUOywK2yqerwzDiF0GiXcM0xKFqxIUl+O0UKFttqIIbvxtUz131p+1w6
	 NfkFT7rlzwK8kYqmPjj0L5CGHfLcr1Qwb4hH0IKj+pVeOjc9xKQy2X4ZyDAe1DN0Az
	 GIc6gIyqCRwhn+W5FMsALTxjmzT/va1aOrpovEcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/279] alpha/elf: Fix misc/setarch test of util-linux by removing 32bit support
Date: Tue,  8 Apr 2025 12:46:54 +0200
Message-ID: <20250408104827.223187325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit b029628be267cba3c7684ec684749fe3e4372398 ]

Richard Henderson <richard.henderson@linaro.org> writes[1]:

> There was a Spec benchmark (I forget which) which was memory bound and ran
> twice as fast with 32-bit pointers.
>
> I copied the idea from DEC to the ELF abi, but never did all the other work
> to allow the toolchain to take advantage.
>
> Amusingly, a later Spec changed the benchmark data sets to not fit into a
> 32-bit address space, specifically because of this.
>
> I expect one could delete the ELF bit and personality and no one would
> notice. Not even the 10 remaining Alpha users.

In [2] it was pointed out that parts of setarch weren't working
properly on alpha because it has it's own SET_PERSONALITY
implementation.  In the discussion that followed Richard Henderson
pointed out that the 32bit pointer support for alpha was never
completed.

Fix this by removing alpha's 32bit pointer support.

As a bit of paranoia refuse to execute any alpha binaries that have
the EF_ALPHA_32BIT flag set.  Just in case someone somewhere has
binaries that try to use alpha's 32bit pointer support.

Link: https://lkml.kernel.org/r/CAFXwXrkgu=4Qn-v1PjnOR4SG0oUb9LSa0g6QXpBq4ttm52pJOQ@mail.gmail.com [1]
Link: https://lkml.kernel.org/r/20250103140148.370368-1-glaubitz@physik.fu-berlin.de [2]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/87y0zfs26i.fsf_-_@email.froward.int.ebiederm.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/elf.h       |  6 +-----
 arch/alpha/include/asm/pgtable.h   |  2 +-
 arch/alpha/include/asm/processor.h |  8 ++------
 arch/alpha/kernel/osf_sys.c        | 11 ++---------
 4 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/alpha/include/asm/elf.h b/arch/alpha/include/asm/elf.h
index 8049997fa372a..2039a8c8d5473 100644
--- a/arch/alpha/include/asm/elf.h
+++ b/arch/alpha/include/asm/elf.h
@@ -74,7 +74,7 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
 /*
  * This is used to ensure we don't load something for the wrong architecture.
  */
-#define elf_check_arch(x) ((x)->e_machine == EM_ALPHA)
+#define elf_check_arch(x) (((x)->e_machine == EM_ALPHA) && !((x)->e_flags & EF_ALPHA_32BIT))
 
 /*
  * These are used to set parameters in the core dumps.
@@ -145,10 +145,6 @@ extern int dump_elf_task_fp(elf_fpreg_t *dest, struct task_struct *task);
 	: amask (AMASK_CIX) ? "ev6" : "ev67");	\
 })
 
-#define SET_PERSONALITY(EX)					\
-	set_personality(((EX).e_flags & EF_ALPHA_32BIT)		\
-	   ? PER_LINUX_32BIT : PER_LINUX)
-
 extern int alpha_l1i_cacheshape;
 extern int alpha_l1d_cacheshape;
 extern int alpha_l2_cacheshape;
diff --git a/arch/alpha/include/asm/pgtable.h b/arch/alpha/include/asm/pgtable.h
index 02f0429f1068a..8e3cf3c9f913d 100644
--- a/arch/alpha/include/asm/pgtable.h
+++ b/arch/alpha/include/asm/pgtable.h
@@ -340,7 +340,7 @@ extern inline pte_t mk_swap_pte(unsigned long type, unsigned long offset)
 
 extern void paging_init(void);
 
-/* We have our own get_unmapped_area to cope with ADDR_LIMIT_32BIT.  */
+/* We have our own get_unmapped_area */
 #define HAVE_ARCH_UNMAPPED_AREA
 
 #endif /* _ALPHA_PGTABLE_H */
diff --git a/arch/alpha/include/asm/processor.h b/arch/alpha/include/asm/processor.h
index 6100431da07a3..d27db62c3247d 100644
--- a/arch/alpha/include/asm/processor.h
+++ b/arch/alpha/include/asm/processor.h
@@ -8,23 +8,19 @@
 #ifndef __ASM_ALPHA_PROCESSOR_H
 #define __ASM_ALPHA_PROCESSOR_H
 
-#include <linux/personality.h>	/* for ADDR_LIMIT_32BIT */
-
 /*
  * We have a 42-bit user address space: 4TB user VM...
  */
 #define TASK_SIZE (0x40000000000UL)
 
-#define STACK_TOP \
-  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
+#define STACK_TOP (0x00120000000UL)
 
 #define STACK_TOP_MAX	0x00120000000UL
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
-#define TASK_UNMAPPED_BASE \
-  ((current->personality & ADDR_LIMIT_32BIT) ? 0x40000000 : TASK_SIZE / 2)
+#define TASK_UNMAPPED_BASE (TASK_SIZE / 2)
 
 typedef struct {
 	unsigned long seg;
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 8bbeebb73cf03..2dfb69a2ae43a 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1212,8 +1212,7 @@ SYSCALL_DEFINE1(old_adjtimex, struct timex32 __user *, txc_p)
 	return ret;
 }
 
-/* Get an address range which is currently unmapped.  Similar to the
-   generic version except that we know how to honor ADDR_LIMIT_32BIT.  */
+/* Get an address range which is currently unmapped. */
 
 static unsigned long
 arch_get_unmapped_area_1(unsigned long addr, unsigned long len,
@@ -1235,13 +1234,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		       unsigned long len, unsigned long pgoff,
 		       unsigned long flags)
 {
-	unsigned long limit;
-
-	/* "32 bit" actually means 31 bit, since pointers sign extend.  */
-	if (current->personality & ADDR_LIMIT_32BIT)
-		limit = 0x80000000;
-	else
-		limit = TASK_SIZE;
+	unsigned long limit = TASK_SIZE;
 
 	if (len > limit)
 		return -ENOMEM;
-- 
2.39.5



