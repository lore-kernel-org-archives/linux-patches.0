Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8486A31B111;
	Mon, 29 Dec 2025 16:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024874; cv=none; b=qjdQLBUzQYbQdkWbHCiJ7WMr24CFt7cPZzXwvfv30UzjHU9N8/uIZZxf8cMFBLMspcJkMVidIXgTFP8GwwW39zDzBUBK04P0ToZuAg2U1H6ncsGkV8VH4t0WDvfaEV4jUp/lQ3/u/ZSZS9+QIFFW3SGa8AJ32hkBhfHt2o6X19k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024874; c=relaxed/simple;
	bh=Nhf3Zg0OOhWs53RVWXrvZXzo5FlRIAsqbQyED9OgsZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaJa/wYzsbZUEPJv4y2fWYbT4JfHAal9qus1IhbOfejQ1bKon7rQLtr/SNRgek/JcPJ3LhBOGaWkj4uRR0D+8cqaZogrNtBnLPJHzF4zwB5AtNg0shgpkxAQzbs2vxotT1jf8cFcPrFkiNBOdPW2AwiZUiDOtl/TMrbdDAac6ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gl2R3/R7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gl2R3/R7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6486C4CEF7;
	Mon, 29 Dec 2025 16:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024874;
	bh=Nhf3Zg0OOhWs53RVWXrvZXzo5FlRIAsqbQyED9OgsZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gl2R3/R758Kf+32hnvXvF52fieywoHHUeMvc+HENjsb9WORVp1yOOAz5n+yhRxsPX
	 6cXBK+DOAlIhuJqT0LXYI06ZQtcy7HGpaypIiLuyO/C8f0kkpSO+337inRQ3JH7Ic3
	 b/DXf5G5d7y42+VQO/dSe3NvBuzC137aI8S2qDsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/430] x86/ptrace: Always inline trivial accessors
Date: Mon, 29 Dec 2025 17:06:57 +0100
Message-ID: <20251229160724.715594959@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 50f75467f73d0..b5dec859bc75a 100644
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



