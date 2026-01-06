Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B6E340A49;
	Tue,  6 Jan 2026 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719694; cv=none; b=W2e+5ba11gAz13nbVxwCxL81ppZzU9XJnDJYcR9LakwMWI+gVfSZJ5CJ4mo+aOA19YsKMOg9k5kpMqEmkWLI53JGWkCOgwxr1NpawjoZfQhcn6LUWXx5Cj3zoaHijN3xXuIL7Tw4UeWQS3ocCpQMEge/xNnwMq4nAI3+m9Pq294=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719694; c=relaxed/simple;
	bh=35RYveYGyfuCM9KCq19wGY/I9dXwQKB7bq1Fz+Qer6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L11u09IwdnRDlIND3GkAfJRvtZOU1hWN1nWPJQml9D5N6JljWdk9eAQ5tmpx8ANMtLgzur1ddu48/SF+XDBVchunNq4l2hYMCZK1XERoctOfpcqMRbBBLKaqeIPFMymHGp3xQKmdt8k7Wezu7q/kRtYq45jxIpEmY1fNb2PEjhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxoKaK/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxoKaK/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FB7C116C6;
	Tue,  6 Jan 2026 17:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719693;
	bh=35RYveYGyfuCM9KCq19wGY/I9dXwQKB7bq1Fz+Qer6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxoKaK/vB1bYQijsXxRgbCJ7GqbnLQYtDfekalujNnwID96zKP5YS3EnVockd+D1A
	 pYHVS3+uOMG0bV0enGCxoMi9s4ELOTbP8VN3RDAPopmqOXj/RVI6TFlpG06umnkoRd
	 gXyocFJLImNEZ8Z0A3FZ3gwaIJ7Wjf9mG0lZrm2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/567] x86/ptrace: Always inline trivial accessors
Date: Tue,  6 Jan 2026 17:56:34 +0100
Message-ID: <20260106170451.797032395@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1fe4002cf7f23d70c79bda429ca2a9423ebcfdfa ]

A KASAN build bloats these single load/store helpers such that
it fails to inline them:

  vmlinux.o: error: objtool: irqentry_exit+0x5e8: call to instruction_pointer_set() with UACCESS enabled

Make sure the compiler isn't allowed to do stupid.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251031105435.GU4068168@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/ptrace.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 5a83fbd9bc0b4..eb5b1e2aa7000 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -187,12 +187,12 @@ convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 extern void send_sigtrap(struct pt_regs *regs, int error_code, int si_code);
 
 
-static inline unsigned long regs_return_value(struct pt_regs *regs)
+static __always_inline unsigned long regs_return_value(struct pt_regs *regs)
 {
 	return regs->ax;
 }
 
-static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
+static __always_inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
 {
 	regs->ax = rc;
 }
@@ -277,34 +277,34 @@ static __always_inline bool ip_within_syscall_gap(struct pt_regs *regs)
 }
 #endif
 
-static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
+static __always_inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
 {
 	return regs->sp;
 }
 
-static inline unsigned long instruction_pointer(struct pt_regs *regs)
+static __always_inline unsigned long instruction_pointer(struct pt_regs *regs)
 {
 	return regs->ip;
 }
 
-static inline void instruction_pointer_set(struct pt_regs *regs,
-		unsigned long val)
+static __always_inline
+void instruction_pointer_set(struct pt_regs *regs, unsigned long val)
 {
 	regs->ip = val;
 }
 
-static inline unsigned long frame_pointer(struct pt_regs *regs)
+static __always_inline unsigned long frame_pointer(struct pt_regs *regs)
 {
 	return regs->bp;
 }
 
-static inline unsigned long user_stack_pointer(struct pt_regs *regs)
+static __always_inline unsigned long user_stack_pointer(struct pt_regs *regs)
 {
 	return regs->sp;
 }
 
-static inline void user_stack_pointer_set(struct pt_regs *regs,
-		unsigned long val)
+static __always_inline
+void user_stack_pointer_set(struct pt_regs *regs, unsigned long val)
 {
 	regs->sp = val;
 }
-- 
2.51.0



