Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407F01494AB;
	Tue, 23 Apr 2024 21:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908661; cv=none; b=jVg6xgVw0xNjFyNyGjtmE+LpuufYluohUX4VdZ65ri1QQacSs26hxaGAxAP+CsfaTcXtjeLslKUbWIfmrf3ChFLGXQKzNnEv/5R2AVSjze6WrQj7Tcf18IsmFE9L69LaZ+UuJJu53xLepvRS886krQ2vVmQfmvXaybur3tU8DuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908661; c=relaxed/simple;
	bh=bAfjdAhelqTs2MV08l/LiUV6RuLq+xiT9K8pZlKe9XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+kVglAgSpSOLN8rR5jH8br18vMh8HhQPIIEXQiliqhBELDg5z109FSi2KTQCFbLAgWuWFmAFhH630MHELN+DhYF95RBmdy8cePASmyG4qRrfusbC8OD1lp1d+46kUTp7/FDCr3Exgw5bzs2h9Wl66hQiTwzkc8TVjiSdc1gXe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCv6KSmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCv6KSmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F95C4AF0C;
	Tue, 23 Apr 2024 21:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908661;
	bh=bAfjdAhelqTs2MV08l/LiUV6RuLq+xiT9K8pZlKe9XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCv6KSmHwx/aIgExliVTLmYm+UdAdMNDoyu+AqskvhtD3oGyWlswSRCX247dPMNkA
	 25N7b7eyhWvllks6T3GS+KORK5CJIYV1GH8tGeJWMdDo/Hes/84uqeOkGExsrx3yL6
	 ZSblk8IqR8o1WBrDQ5CHn1x73iMJxK9P3FK53ZdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Naveen N Rao <naveen@kernel.org>,
	Benjamin Gray <bgray@linux.ibm.com>
Subject: [PATCH 6.6 153/158] powerpc/ftrace: Ignore ftrace locations in exit text sections
Date: Tue, 23 Apr 2024 14:39:50 -0700
Message-ID: <20240423213900.639120233@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Naveen N Rao <naveen@kernel.org>

commit ea73179e64131bcd29ba6defd33732abdf8ca14b upstream.

Michael reported that we are seeing an ftrace bug on bootup when KASAN
is enabled and we are using -fpatchable-function-entry:

  ftrace: allocating 47780 entries in 18 pages
  ftrace-powerpc: 0xc0000000020b3d5c: No module provided for non-kernel address
  ------------[ ftrace bug ]------------
  ftrace faulted on modifying
  [<c0000000020b3d5c>] 0xc0000000020b3d5c
  Initializing ftrace call sites
  ftrace record flags: 0
   (0)
   expected tramp: c00000000008cef4
  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 0 at kernel/trace/ftrace.c:2180 ftrace_bug+0x3c0/0x424
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper Not tainted 6.5.0-rc3-00120-g0f71dcfb4aef #860
  Hardware name: IBM pSeries (emulated by qemu) POWER9 (raw) 0x4e1202 0xf000005 of:SLOF,HEAD hv:linux,kvm pSeries
  NIP:  c0000000003aa81c LR: c0000000003aa818 CTR: 0000000000000000
  REGS: c0000000033cfab0 TRAP: 0700   Not tainted  (6.5.0-rc3-00120-g0f71dcfb4aef)
  MSR:  8000000002021033 <SF,VEC,ME,IR,DR,RI,LE>  CR: 28028240  XER: 00000000
  CFAR: c0000000002781a8 IRQMASK: 3
  ...
  NIP [c0000000003aa81c] ftrace_bug+0x3c0/0x424
  LR [c0000000003aa818] ftrace_bug+0x3bc/0x424
  Call Trace:
   ftrace_bug+0x3bc/0x424 (unreliable)
   ftrace_process_locs+0x5f4/0x8a0
   ftrace_init+0xc0/0x1d0
   start_kernel+0x1d8/0x484

With CONFIG_FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY=y and
CONFIG_KASAN=y, compiler emits nops in functions that it generates for
registering and unregistering global variables (unlike with -pg and
-mprofile-kernel where calls to _mcount() are not generated in those
functions). Those functions then end up in INIT_TEXT and EXIT_TEXT
respectively. We don't expect to see any profiled functions in
EXIT_TEXT, so ftrace_init_nop() assumes that all addresses that aren't
in the core kernel text belongs to a module. Since these functions do
not match that criteria, we see the above bug.

Address this by having ftrace ignore all locations in the text exit
sections of vmlinux.

Fixes: 0f71dcfb4aef ("powerpc/ftrace: Add support for -fpatchable-function-entry")
Cc: stable@vger.kernel.org # v6.6+
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Naveen N Rao <naveen@kernel.org>
Reviewed-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240213175410.1091313-1-naveen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ftrace.h        |   10 ++--------
 arch/powerpc/include/asm/sections.h      |    1 +
 arch/powerpc/kernel/trace/ftrace.c       |   12 ++++++++++++
 arch/powerpc/kernel/trace/ftrace_64_pg.c |    5 +++++
 arch/powerpc/kernel/vmlinux.lds.S        |    2 ++
 5 files changed, 22 insertions(+), 8 deletions(-)

--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -20,14 +20,6 @@
 #ifndef __ASSEMBLY__
 extern void _mcount(void);
 
-static inline unsigned long ftrace_call_adjust(unsigned long addr)
-{
-	if (IS_ENABLED(CONFIG_ARCH_USING_PATCHABLE_FUNCTION_ENTRY))
-		addr += MCOUNT_INSN_SIZE;
-
-       return addr;
-}
-
 unsigned long prepare_ftrace_return(unsigned long parent, unsigned long ip,
 				    unsigned long sp);
 
@@ -142,8 +134,10 @@ static inline u8 this_cpu_get_ftrace_ena
 #ifdef CONFIG_FUNCTION_TRACER
 extern unsigned int ftrace_tramp_text[], ftrace_tramp_init[];
 void ftrace_free_init_tramp(void);
+unsigned long ftrace_call_adjust(unsigned long addr);
 #else
 static inline void ftrace_free_init_tramp(void) { }
+static inline unsigned long ftrace_call_adjust(unsigned long addr) { return addr; }
 #endif
 #endif /* !__ASSEMBLY__ */
 
--- a/arch/powerpc/include/asm/sections.h
+++ b/arch/powerpc/include/asm/sections.h
@@ -14,6 +14,7 @@ typedef struct func_desc func_desc_t;
 
 extern char __head_end[];
 extern char __srwx_boundary[];
+extern char __exittext_begin[], __exittext_end[];
 
 /* Patch sites */
 extern s32 patch__call_flush_branch_caches1;
--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -27,10 +27,22 @@
 #include <asm/ftrace.h>
 #include <asm/syscall.h>
 #include <asm/inst.h>
+#include <asm/sections.h>
 
 #define	NUM_FTRACE_TRAMPS	2
 static unsigned long ftrace_tramps[NUM_FTRACE_TRAMPS];
 
+unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	if (addr >= (unsigned long)__exittext_begin && addr < (unsigned long)__exittext_end)
+		return 0;
+
+	if (IS_ENABLED(CONFIG_ARCH_USING_PATCHABLE_FUNCTION_ENTRY))
+		addr += MCOUNT_INSN_SIZE;
+
+	return addr;
+}
+
 static ppc_inst_t ftrace_create_branch_inst(unsigned long ip, unsigned long addr, int link)
 {
 	ppc_inst_t op;
--- a/arch/powerpc/kernel/trace/ftrace_64_pg.c
+++ b/arch/powerpc/kernel/trace/ftrace_64_pg.c
@@ -37,6 +37,11 @@
 #define	NUM_FTRACE_TRAMPS	8
 static unsigned long ftrace_tramps[NUM_FTRACE_TRAMPS];
 
+unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	return addr;
+}
+
 static ppc_inst_t
 ftrace_call_replace(unsigned long ip, unsigned long addr, int link)
 {
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -281,7 +281,9 @@ SECTIONS
 	 * to deal with references from __bug_table
 	 */
 	.exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
+		__exittext_begin = .;
 		EXIT_TEXT
+		__exittext_end = .;
 	}
 
 	. = ALIGN(PAGE_SIZE);


