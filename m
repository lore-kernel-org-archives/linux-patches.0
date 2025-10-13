Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E655430BF71;
	Mon, 13 Oct 2025 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368756; cv=none; b=K1OWV5YvBpnFLwiGDQ0+tbMeOvjjDqQ6Kztk3Sj76i2c8kdIUDBiRCfGJCKmgDZbRAVXpdAjfisDLnflRdAq6dsOB35ydQQ/UpoYpYWLb0iyWZpPwMPoxlUGEWN2BKHUUMuwvnfP853mG8KchxsgiMokjfxWq1XsF4OoJdz54DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368756; c=relaxed/simple;
	bh=OLf2O4yw11047mCotEOLN0Pfyy46wZhLqNlbiU8QwuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FubA8ALQgoijdwGT0Db7VGgDTFMmEhX61iB6RhkITizo3TUwGO4qXgI/VLS3g1OlxkwcSzHqSRV4UORAyzbqwB9hLoI2TZ+m6ip4v5ZGcCJPO9Fxv+hIzqYKbGLOlK9pKmDCn4+2BVGuuR14EjMLUrGPOUfstDtnS68etDgW0rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAsqUWev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAsqUWev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34057C4CEE7;
	Mon, 13 Oct 2025 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368755;
	bh=OLf2O4yw11047mCotEOLN0Pfyy46wZhLqNlbiU8QwuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAsqUWevEbdb1/aMwpA5SWZ3ff3oT5j6m4p1kMH5SQ3E2H9tmLTcCTYYrokEZS+Mg
	 uW2R2QXCdNOvWCDKNbLUN0nlxJEfJac+PdGnR2wG1zapnhhRk/RPPXwD0LtCIa5twX
	 teCGSOX3ekIZmDqQFUb2HTxW2jQtGaTaknaEGfyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"Guo Ren (Alibaba Damo Academy)" <guoren@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 6.17 001/563] arch: copy_thread: pass clone_flags as u64
Date: Mon, 13 Oct 2025 16:37:42 +0200
Message-ID: <20251013144411.336371281@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Schuster <schuster.simon@siemens-energy.com>

[ Upstream commit bbc46b23af5bb934cd1cf066ef4342cee457a24e ]

With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
clone3") the effective bit width of clone_flags on all architectures was
increased from 32-bit to 64-bit, with a new type of u64 for the flags.
However, for most consumers of clone_flags the interface was not
changed from the previous type of unsigned long.

While this works fine as long as none of the new 64-bit flag bits
(CLONE_CLEAR_SIGHAND and CLONE_INTO_CGROUP) are evaluated, this is still
undesirable in terms of the principle of least surprise.

Thus, this commit fixes all relevant interfaces of the copy_thread
function that is called from copy_process to consistently pass
clone_flags as u64, so that no truncation to 32-bit integers occurs on
32-bit architectures.

Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
Link: https://lore.kernel.org/20250901-nios2-implement-clone3-v2-3-53fcf5577d57@siemens-energy.com
Fixes: c5febea0956fd387 ("fork: Pass struct kernel_clone_args into copy_thread")
Acked-by: Guo Ren (Alibaba Damo Academy) <guoren@kernel.org>
Acked-by: Andreas Larsson <andreas@gaisler.com> # sparc
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/process.c      | 2 +-
 arch/arc/kernel/process.c        | 2 +-
 arch/arm/kernel/process.c        | 2 +-
 arch/arm64/kernel/process.c      | 2 +-
 arch/csky/kernel/process.c       | 2 +-
 arch/hexagon/kernel/process.c    | 2 +-
 arch/loongarch/kernel/process.c  | 2 +-
 arch/m68k/kernel/process.c       | 2 +-
 arch/microblaze/kernel/process.c | 2 +-
 arch/mips/kernel/process.c       | 2 +-
 arch/nios2/kernel/process.c      | 2 +-
 arch/openrisc/kernel/process.c   | 2 +-
 arch/parisc/kernel/process.c     | 2 +-
 arch/powerpc/kernel/process.c    | 2 +-
 arch/riscv/kernel/process.c      | 2 +-
 arch/s390/kernel/process.c       | 2 +-
 arch/sh/kernel/process_32.c      | 2 +-
 arch/sparc/kernel/process_32.c   | 2 +-
 arch/sparc/kernel/process_64.c   | 2 +-
 arch/um/kernel/process.c         | 2 +-
 arch/x86/include/asm/fpu/sched.h | 2 +-
 arch/x86/include/asm/shstk.h     | 4 ++--
 arch/x86/kernel/fpu/core.c       | 2 +-
 arch/x86/kernel/process.c        | 2 +-
 arch/x86/kernel/shstk.c          | 2 +-
 arch/xtensa/kernel/process.c     | 2 +-
 26 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 582d96548385d..06522451f018f 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -231,7 +231,7 @@ flush_thread(void)
  */
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	extern void ret_from_fork(void);
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index 186ceab661eb0..8166d09087130 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -166,7 +166,7 @@ asmlinkage void ret_from_fork(void);
  */
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct pt_regs *c_regs;        /* child's pt_regs */
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index e16ed102960cb..d7aa95225c70b 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -234,7 +234,7 @@ asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long stack_start = args->stack;
 	unsigned long tls = args->tls;
 	struct thread_info *thread = task_thread_info(p);
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 96482a1412c6a..fba7ca102a8c4 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -409,7 +409,7 @@ asmlinkage void ret_from_fork(void) asm("ret_from_fork");
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long stack_start = args->stack;
 	unsigned long tls = args->tls;
 	struct pt_regs *childregs = task_pt_regs(p);
diff --git a/arch/csky/kernel/process.c b/arch/csky/kernel/process.c
index 0c6e4b17fe00f..a7a90340042a5 100644
--- a/arch/csky/kernel/process.c
+++ b/arch/csky/kernel/process.c
@@ -32,7 +32,7 @@ void flush_thread(void){}
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct switch_stack *childstack;
diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index 2a77bfd756945..15b4992bfa298 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -52,7 +52,7 @@ void arch_cpu_idle(void)
  */
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct thread_info *ti = task_thread_info(p);
diff --git a/arch/loongarch/kernel/process.c b/arch/loongarch/kernel/process.c
index 3582f591bab28..efd9edf65603c 100644
--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -167,7 +167,7 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 	unsigned long childksp;
 	unsigned long tls = args->tls;
 	unsigned long usp = args->stack;
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	struct pt_regs *childregs, *regs = current_pt_regs();
 
 	childksp = (unsigned long)task_stack_page(p) + THREAD_SIZE;
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index fda7eac23f872..f5a07a70e9385 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -141,7 +141,7 @@ asmlinkage int m68k_clone3(struct pt_regs *regs)
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct fork_frame {
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 56342e11442d2..6cbf642d7b801 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -54,7 +54,7 @@ void flush_thread(void)
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct pt_regs *childregs = task_pt_regs(p);
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 02aa6a04a21da..29191fa1801e2 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -107,7 +107,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
  */
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct thread_info *ti = task_thread_info(p);
diff --git a/arch/nios2/kernel/process.c b/arch/nios2/kernel/process.c
index f84021303f6a8..151404139085c 100644
--- a/arch/nios2/kernel/process.c
+++ b/arch/nios2/kernel/process.c
@@ -101,7 +101,7 @@ void flush_thread(void)
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct pt_regs *childregs = task_pt_regs(p);
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index eef99fee2110c..73ffb9fa3118b 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -165,7 +165,7 @@ extern asmlinkage void ret_from_fork(void);
 int
 copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct pt_regs *userregs;
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index ed93bd8c15453..e64ab5d2a40d6 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -201,7 +201,7 @@ arch_initcall(parisc_idle_init);
 int
 copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct pt_regs *cregs = &(p->thread.regs);
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 855e098865032..eb23966ac0a9f 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1805,7 +1805,7 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 			f = ret_from_kernel_user_thread;
 		} else {
 			struct pt_regs *regs = current_pt_regs();
-			unsigned long clone_flags = args->flags;
+			u64 clone_flags = args->flags;
 			unsigned long usp = args->stack;
 
 			/* Copy registers */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index a0a40889d79a5..31a392993cb45 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -223,7 +223,7 @@ asmlinkage void ret_from_fork_user(struct pt_regs *regs)
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct pt_regs *childregs = task_pt_regs(p);
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index f55f09cda6f88..b107dbca4ed7d 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -106,7 +106,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long new_stackp = args->stack;
 	unsigned long tls = args->tls;
 	struct fake_frame
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 92b6649d49295..62f753a85b89c 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -89,7 +89,7 @@ asmlinkage void ret_from_kernel_thread(void);
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
 	struct thread_info *ti = task_thread_info(p);
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index 9c7c662cb5659..5a28c0e91bf15 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -260,7 +260,7 @@ extern void ret_from_kernel_thread(void);
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long sp = args->stack;
 	unsigned long tls = args->tls;
 	struct thread_info *ti = task_thread_info(p);
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 529adfecd58ca..25781923788a0 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -567,7 +567,7 @@ void fault_in_user_windows(struct pt_regs *regs)
  */
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long sp = args->stack;
 	unsigned long tls = args->tls;
 	struct thread_info *t = task_thread_info(p);
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 1be644de9e41e..9c9c66dc45f05 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -143,7 +143,7 @@ static void fork_handler(void)
 
 int copy_thread(struct task_struct * p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long sp = args->stack;
 	unsigned long tls = args->tls;
 	void (*handler)(void);
diff --git a/arch/x86/include/asm/fpu/sched.h b/arch/x86/include/asm/fpu/sched.h
index c060549c6c940..89004f4ca208d 100644
--- a/arch/x86/include/asm/fpu/sched.h
+++ b/arch/x86/include/asm/fpu/sched.h
@@ -11,7 +11,7 @@
 
 extern void save_fpregs_to_fpstate(struct fpu *fpu);
 extern void fpu__drop(struct task_struct *tsk);
-extern int  fpu_clone(struct task_struct *dst, unsigned long clone_flags, bool minimal,
+extern int  fpu_clone(struct task_struct *dst, u64 clone_flags, bool minimal,
 		      unsigned long shstk_addr);
 extern void fpu_flush_thread(void);
 
diff --git a/arch/x86/include/asm/shstk.h b/arch/x86/include/asm/shstk.h
index ba6f2fe438488..0f50e01259430 100644
--- a/arch/x86/include/asm/shstk.h
+++ b/arch/x86/include/asm/shstk.h
@@ -16,7 +16,7 @@ struct thread_shstk {
 
 long shstk_prctl(struct task_struct *task, int option, unsigned long arg2);
 void reset_thread_features(void);
-unsigned long shstk_alloc_thread_stack(struct task_struct *p, unsigned long clone_flags,
+unsigned long shstk_alloc_thread_stack(struct task_struct *p, u64 clone_flags,
 				       unsigned long stack_size);
 void shstk_free(struct task_struct *p);
 int setup_signal_shadow_stack(struct ksignal *ksig);
@@ -28,7 +28,7 @@ static inline long shstk_prctl(struct task_struct *task, int option,
 			       unsigned long arg2) { return -EINVAL; }
 static inline void reset_thread_features(void) {}
 static inline unsigned long shstk_alloc_thread_stack(struct task_struct *p,
-						     unsigned long clone_flags,
+						     u64 clone_flags,
 						     unsigned long stack_size) { return 0; }
 static inline void shstk_free(struct task_struct *p) {}
 static inline int setup_signal_shadow_stack(struct ksignal *ksig) { return 0; }
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index aefd412a23dc2..1f71cc135e9ad 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -631,7 +631,7 @@ static int update_fpu_shstk(struct task_struct *dst, unsigned long ssp)
 }
 
 /* Clone current's FPU state on fork */
-int fpu_clone(struct task_struct *dst, unsigned long clone_flags, bool minimal,
+int fpu_clone(struct task_struct *dst, u64 clone_flags, bool minimal,
 	      unsigned long ssp)
 {
 	/*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1b7960cf6eb0c..e3a3987b0c4fb 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -159,7 +159,7 @@ __visible void ret_from_fork(struct task_struct *prev, struct pt_regs *regs,
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long sp = args->stack;
 	unsigned long tls = args->tls;
 	struct inactive_task_frame *frame;
diff --git a/arch/x86/kernel/shstk.c b/arch/x86/kernel/shstk.c
index 2ddf23387c7ef..5eba6c5a67757 100644
--- a/arch/x86/kernel/shstk.c
+++ b/arch/x86/kernel/shstk.c
@@ -191,7 +191,7 @@ void reset_thread_features(void)
 	current->thread.features_locked = 0;
 }
 
-unsigned long shstk_alloc_thread_stack(struct task_struct *tsk, unsigned long clone_flags,
+unsigned long shstk_alloc_thread_stack(struct task_struct *tsk, u64 clone_flags,
 				       unsigned long stack_size)
 {
 	struct thread_shstk *shstk = &tsk->thread.shstk;
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 7bd66677f7b6d..94d43f44be131 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -267,7 +267,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 {
-	unsigned long clone_flags = args->flags;
+	u64 clone_flags = args->flags;
 	unsigned long usp_thread_fn = args->stack;
 	unsigned long tls = args->tls;
 	struct pt_regs *childregs = task_pt_regs(p);
-- 
2.51.0



