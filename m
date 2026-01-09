Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3453B33B6E8;
	Fri,  9 Jan 2026 12:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962058; cv=none; b=PBjGBUD35pTpjdHK6/Qz/++R/6Wu08jXE3yHNENrMdNjyVl3ZrstWXK5z9AfCA+AxVGn1W1l6ZFBmRjMNdLqFIxmqdl/2vbdOH2rbe2WGe1PqxnZBZaPt3RQnneRB9fAlaLuomaqFUhqu7VZ+Yd924q0nJZtLdW50xGMj3sznk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962058; c=relaxed/simple;
	bh=BtcPqBE/Pyar9IOAf/sl5qvXcUXoPvBDjOgvwHrLm7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DglQwHswmxVQscadRthElVAOb9ZU53+mXx9hn/3tZpEK0T/DyuHZkxoAoMioY+dW57naRhwV+Z7qqJZ/yI9Ht60rTkRgm5MAAiWBfyq4L7Q6VYDWCCRffaBdXstMI0l/l3LITyCaOGFM69g/lzRxbSdvm1hcQaNBU8bXkQjGNy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0wHQ+hi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0wHQ+hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC76C4CEF1;
	Fri,  9 Jan 2026 12:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962057;
	bh=BtcPqBE/Pyar9IOAf/sl5qvXcUXoPvBDjOgvwHrLm7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0wHQ+hiBRMmxmu0NGI7sayEDwUQLz+zMCv/fwkNcGAjlpgc2OtPh268/zXeaWX2r
	 GPBvs+sL2uTZ8Ao5ieSTBjEWsaMdQ/RnvzlYLngLYuwB7i56ifLeNR3tDV6nY+7U6/
	 VsvanU5Z6IU3o3zET1X5DDcB4l9QOBMvgREyQaAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 231/634] x86/ptrace: Always inline trivial accessors
Date: Fri,  9 Jan 2026 12:38:29 +0100
Message-ID: <20260109112126.121972748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f4db78b09c8f0..87d8f3c492c19 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -109,12 +109,12 @@ convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
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
@@ -199,34 +199,34 @@ static __always_inline bool ip_within_syscall_gap(struct pt_regs *regs)
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



