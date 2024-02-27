Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A2A13AA55;
	Tue, 27 Feb 2024 13:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041350; cv=none; b=BBIZf5dcOYrh0bTSg9DiBIoCwQChE6UzqpXG6uVUyWP4iVpVQHn0/adugA77ygyrmQB9Iemr+zn9KV8MIjHuIskX6ZLsPQdu5crihYE7P/7ZiZW7yL+k265LTYQvtJiZjNLoe+a03NddQuecrWLT/LwaHf+tbvUqrfvaAAPXpGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041350; c=relaxed/simple;
	bh=xxMvpZ8rOhxo94DDDPaJob/PysbYlM5QyrATDmwIcGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grrUB5rGLyP0/0KpdkQrd/2OOWwC11DdqJzXr0TSiTGJJ+uTWCQ61C/r01n0zRe3RNxL0HBJKRaWJFRIjaXqL5gcr0XDAuoGFoKx8S66zvgJWpnGDQKU3VVqmGQgJtsi7r19kxWqZnh9UWlYG7Zj/Q7w8PhtUPlsLyDkj2MKxQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bj0aqvop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bj0aqvop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A1BC433C7;
	Tue, 27 Feb 2024 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041350;
	bh=xxMvpZ8rOhxo94DDDPaJob/PysbYlM5QyrATDmwIcGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bj0aqvopS890ik4cRX5Ho/Ez1+2ZeSCtDXipV9xCOkmz06ns9kcPDdfycdUX/FTfU
	 0yFdyKeDpCK/1q+K1jgdkoaL9Zu7/XrDBKgKPHPkaDYwkiQFxhL/CvPR7O2nwDZehh
	 dFQ6Ica35tHDHHvZBrCkXEmH23KzsqDrHX0neGpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sven Schnelle <svens@stackframe.org>,
	John David Anglin <dave.anglin@bell.net>,
	Charlie Jenkins <charlie@rivosinc.com>,
	David Laight <David.Laight@ACULAB.COM>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 278/334] parisc: Fix stack unwinder
Date: Tue, 27 Feb 2024 14:22:16 +0100
Message-ID: <20240227131639.965122617@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 882a2a724ee964c1ebe7268a91d5c8c8ddc796bf ]

Debugging shows a large number of unaligned access traps in the unwinder
code. Code analysis reveals a number of issues with this code:

- handle_interruption is passed twice through
  dereference_kernel_function_descriptor()
- ret_from_kernel_thread, syscall_exit, intr_return,
  _switch_to_ret, and _call_on_stack are passed through
  dereference_kernel_function_descriptor() even though they are
  not declared as function pointers.

To fix the problems, drop one of the calls to
dereference_kernel_function_descriptor() for handle_interruption,
and compare the other pointers directly.

Fixes: 6414b30b39f9 ("parisc: unwind: Avoid missing prototype warning for handle_interruption()")
Fixes: 8e0ba125c2bf ("parisc/unwind: fix unwinder when CONFIG_64BIT is enabled")
Cc: Helge Deller <deller@gmx.de>
Cc: Sven Schnelle <svens@stackframe.org>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/unwind.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/parisc/kernel/unwind.c b/arch/parisc/kernel/unwind.c
index 27ae40a443b80..f7e0fee5ee55a 100644
--- a/arch/parisc/kernel/unwind.c
+++ b/arch/parisc/kernel/unwind.c
@@ -228,10 +228,8 @@ static int unwind_special(struct unwind_frame_info *info, unsigned long pc, int
 #ifdef CONFIG_IRQSTACKS
 	extern void * const _call_on_stack;
 #endif /* CONFIG_IRQSTACKS */
-	void *ptr;
 
-	ptr = dereference_kernel_function_descriptor(&handle_interruption);
-	if (pc_is_kernel_fn(pc, ptr)) {
+	if (pc_is_kernel_fn(pc, handle_interruption)) {
 		struct pt_regs *regs = (struct pt_regs *)(info->sp - frame_size - PT_SZ_ALGN);
 		dbg("Unwinding through handle_interruption()\n");
 		info->prev_sp = regs->gr[30];
@@ -239,13 +237,13 @@ static int unwind_special(struct unwind_frame_info *info, unsigned long pc, int
 		return 1;
 	}
 
-	if (pc_is_kernel_fn(pc, ret_from_kernel_thread) ||
-	    pc_is_kernel_fn(pc, syscall_exit)) {
+	if (pc == (unsigned long)&ret_from_kernel_thread ||
+	    pc == (unsigned long)&syscall_exit) {
 		info->prev_sp = info->prev_ip = 0;
 		return 1;
 	}
 
-	if (pc_is_kernel_fn(pc, intr_return)) {
+	if (pc == (unsigned long)&intr_return) {
 		struct pt_regs *regs;
 
 		dbg("Found intr_return()\n");
@@ -257,14 +255,14 @@ static int unwind_special(struct unwind_frame_info *info, unsigned long pc, int
 	}
 
 	if (pc_is_kernel_fn(pc, _switch_to) ||
-	    pc_is_kernel_fn(pc, _switch_to_ret)) {
+	    pc == (unsigned long)&_switch_to_ret) {
 		info->prev_sp = info->sp - CALLEE_SAVE_FRAME_SIZE;
 		info->prev_ip = *(unsigned long *)(info->prev_sp - RP_OFFSET);
 		return 1;
 	}
 
 #ifdef CONFIG_IRQSTACKS
-	if (pc_is_kernel_fn(pc, _call_on_stack)) {
+	if (pc == (unsigned long)&_call_on_stack) {
 		info->prev_sp = *(unsigned long *)(info->sp - FRAME_SIZE - REG_SZ);
 		info->prev_ip = *(unsigned long *)(info->sp - FRAME_SIZE - RP_OFFSET);
 		return 1;
-- 
2.43.0



