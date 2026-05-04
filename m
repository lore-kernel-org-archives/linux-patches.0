Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9D23D5254;
	Mon,  4 May 2026 14:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904000; cv=none; b=OXNonqnQyMNVlVn1tEqVt95KbDE9SFj/d8eOB7cG9IFOJ3neFxYwDPPyLoFQxGyQf43eve2bEDezGWV0ZWFheNmlIRm6VsQlHiadBG8VTxtUAL6Mx9R1XRbb30ML+WzO+SylBWmO1x2eZSzdxcZlGL6t61xP3vJo2lZd82O4pc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904000; c=relaxed/simple;
	bh=UX/BOTN5O/w/vUkhPB9Vkqy4gKiHjuxuLeyCzdtC8cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlgyZTZA5GbVw5hyA7wNRK6uXQgTxFW5iNmXdY2cz42zDRNVqkIIlc4hb5/l2vxVgegHeyed6VExk1gD4+Tx1EeHATK8zZcwF+fg1A6j+wTwtxXlV00ZO6M1Vu4l0Vh7gIPO5C2vZubBbobzprinXLRdfuVxXa1pX5uzATOlQ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whvhPZyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whvhPZyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC76CC2BCC4;
	Mon,  4 May 2026 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904000;
	bh=UX/BOTN5O/w/vUkhPB9Vkqy4gKiHjuxuLeyCzdtC8cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whvhPZyNO9dHrjXeNaVFXAz9wdI+zb8apEjAuTAg5dxvvb2Rg9ipaLksE1Y/PNypO
	 hQcDRcKyIlyHgYBO/GUUyHDZORKk+75e2xAXL6NIGIN0H5+zOR5DkLIU3CST+yvRUL
	 JQxySWS3qlkMlOiyE6sTzybCk1iE7fjbBf6LqjHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.18 144/275] randomize_kstack: Maintain kstack_offset per task
Date: Mon,  4 May 2026 15:51:24 +0200
Message-ID: <20260504135148.272045724@linuxfoundation.org>
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

From: Ryan Roberts <ryan.roberts@arm.com>

commit 37beb42560165869838e7d91724f3e629db64129 upstream.

kstack_offset was previously maintained per-cpu, but this caused a
couple of issues. So let's instead make it per-task.

Issue 1: add_random_kstack_offset() and choose_random_kstack_offset()
expected and required to be called with interrupts and preemption
disabled so that it could manipulate per-cpu state. But arm64, loongarch
and risc-v are calling them with interrupts and preemption enabled. I
don't _think_ this causes any functional issues, but it's certainly
unexpected and could lead to manipulating the wrong cpu's state, which
could cause a minor performance degradation due to bouncing the cache
lines. By maintaining the state per-task those functions can safely be
called in preemptible context.

Issue 2: add_random_kstack_offset() is called before executing the
syscall and expands the stack using a previously chosen random offset.
choose_random_kstack_offset() is called after executing the syscall and
chooses and stores a new random offset for the next syscall. With
per-cpu storage for this offset, an attacker could force cpu migration
during the execution of the syscall and prevent the offset from being
updated for the original cpu such that it is predictable for the next
syscall on that cpu. By maintaining the state per-task, this problem
goes away because the per-task random offset is updated after the
syscall regardless of which cpu it is executing on.

Fixes: 39218ff4c625 ("stack: Optionally randomize kernel stack offset each syscall")
Closes: https://lore.kernel.org/all/dd8c37bc-795f-4c7a-9086-69e584d8ab24@arm.com/
Cc: stable@vger.kernel.org
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Link: https://patch.msgid.link/20260303150840.3789438-2-ryan.roberts@arm.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/randomize_kstack.h |   26 +++++++++++++++-----------
 include/linux/sched.h            |    4 ++++
 init/main.c                      |    1 -
 kernel/fork.c                    |    2 ++
 4 files changed, 21 insertions(+), 12 deletions(-)

--- a/include/linux/randomize_kstack.h
+++ b/include/linux/randomize_kstack.h
@@ -9,7 +9,6 @@
 
 DECLARE_STATIC_KEY_MAYBE(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,
 			 randomize_kstack_offset);
-DECLARE_PER_CPU(u32, kstack_offset);
 
 /*
  * Do not use this anywhere else in the kernel. This is used here because
@@ -50,15 +49,14 @@ DECLARE_PER_CPU(u32, kstack_offset);
  * add_random_kstack_offset - Increase stack utilization by previously
  *			      chosen random offset
  *
- * This should be used in the syscall entry path when interrupts and
- * preempt are disabled, and after user registers have been stored to
- * the stack. For testing the resulting entropy, please see:
- * tools/testing/selftests/lkdtm/stack-entropy.sh
+ * This should be used in the syscall entry path after user registers have been
+ * stored to the stack. Preemption may be enabled. For testing the resulting
+ * entropy, please see: tools/testing/selftests/lkdtm/stack-entropy.sh
  */
 #define add_random_kstack_offset() do {					\
 	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
 				&randomize_kstack_offset)) {		\
-		u32 offset = raw_cpu_read(kstack_offset);		\
+		u32 offset = current->kstack_offset;			\
 		u8 *ptr = __kstack_alloca(KSTACK_OFFSET_MAX(offset));	\
 		/* Keep allocation even after "ptr" loses scope. */	\
 		asm volatile("" :: "r"(ptr) : "memory");		\
@@ -69,9 +67,9 @@ DECLARE_PER_CPU(u32, kstack_offset);
  * choose_random_kstack_offset - Choose the random offset for the next
  *				 add_random_kstack_offset()
  *
- * This should only be used during syscall exit when interrupts and
- * preempt are disabled. This position in the syscall flow is done to
- * frustrate attacks from userspace attempting to learn the next offset:
+ * This should only be used during syscall exit. Preemption may be enabled. This
+ * position in the syscall flow is done to frustrate attacks from userspace
+ * attempting to learn the next offset:
  * - Maximize the timing uncertainty visible from userspace: if the
  *   offset is chosen at syscall entry, userspace has much more control
  *   over the timing between choosing offsets. "How long will we be in
@@ -85,14 +83,20 @@ DECLARE_PER_CPU(u32, kstack_offset);
 #define choose_random_kstack_offset(rand) do {				\
 	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
 				&randomize_kstack_offset)) {		\
-		u32 offset = raw_cpu_read(kstack_offset);		\
+		u32 offset = current->kstack_offset;			\
 		offset = ror32(offset, 5) ^ (rand);			\
-		raw_cpu_write(kstack_offset, offset);			\
+		current->kstack_offset = offset;			\
 	}								\
 } while (0)
+
+static inline void random_kstack_task_init(struct task_struct *tsk)
+{
+	tsk->kstack_offset = 0;
+}
 #else /* CONFIG_RANDOMIZE_KSTACK_OFFSET */
 #define add_random_kstack_offset()		do { } while (0)
 #define choose_random_kstack_offset(rand)	do { } while (0)
+#define random_kstack_task_init(tsk)		do { } while (0)
 #endif /* CONFIG_RANDOMIZE_KSTACK_OFFSET */
 
 #endif
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1614,6 +1614,10 @@ struct task_struct {
 	unsigned long			prev_lowest_stack;
 #endif
 
+#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
+	u32				kstack_offset;
+#endif
+
 #ifdef CONFIG_X86_MCE
 	void __user			*mce_vaddr;
 	__u64				mce_kflags;
--- a/init/main.c
+++ b/init/main.c
@@ -830,7 +830,6 @@ static inline void initcall_debug_enable
 #ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
 DEFINE_STATIC_KEY_MAYBE_RO(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,
 			   randomize_kstack_offset);
-DEFINE_PER_CPU(u32, kstack_offset);
 
 static int __init early_randomize_kstack_offset(char *buf)
 {
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -95,6 +95,7 @@
 #include <linux/thread_info.h>
 #include <linux/kstack_erase.h>
 #include <linux/kasan.h>
+#include <linux/randomize_kstack.h>
 #include <linux/scs.h>
 #include <linux/io_uring.h>
 #include <linux/bpf.h>
@@ -2191,6 +2192,7 @@ __latent_entropy struct task_struct *cop
 	if (retval)
 		goto bad_fork_cleanup_io;
 
+	random_kstack_task_init(p);
 	stackleak_task_init(p);
 
 	if (pid != &init_struct_pid) {


