Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813E51C7B92;
	Tue, 27 Aug 2024 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770312; cv=none; b=qVNNW9mH2E5rBlA03uuQA5uPrkBV7jQWdgPnguUDh85yBRrXzgybYolpMYvJtLtiMZM0kbt4JiRjobr8nDYZtbVRarz8LJhvOOUHlPdQ0+W7mtEzNRCH43QP4Zff3auVheK3KI5MFC7XHQVVU4wYbZfWBtUSaRSjjofKzAOGseU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770312; c=relaxed/simple;
	bh=wVTSHXcjhM1RR8VqmByMHMJdgMVcR3p3nsjJ0BPD+gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xxyb59HNOw6zjHeLTbeQLxFbkwseS90Wu7B/v3F77C7iiKd+4Kjtb9IyseFqotjygf6N38xfUTWjS46y8F0ePov/cXoWFZldOrc0f3t7LWcUbViOQZREe3ZTcLBhFbSscfp8Rc5fhHoWerO8xZXMG+f0j9mDaU1E4TtNmHUGpCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9PZ+HYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9PZ+HYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA808C4DE0F;
	Tue, 27 Aug 2024 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770312;
	bh=wVTSHXcjhM1RR8VqmByMHMJdgMVcR3p3nsjJ0BPD+gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9PZ+HYRfkYxhCINbp6TMjOJvmwmJvJUEi4320yIXbxjbazIgeXrfHnhOdHUj3K6y
	 jesl6eb6MSjICOQzpKCY1OUwRQPVOv6FBPFUJLNhEjr1otbnLYIP8MGlaUhuTZBeWF
	 CESoJAIayRHmDXwj7e+tURihkXniyy4LQqdVruMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/341] riscv: blacklist assembly symbols for kprobe
Date: Tue, 27 Aug 2024 16:36:31 +0200
Message-ID: <20240827143849.504335749@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 5014396af9bbac0f28d9afee7eae405206d01ee7 ]

Adding kprobes on some assembly functions (mainly exception handling)
will result in crashes (either recursive trap or panic). To avoid such
errors, add ASM_NOKPROBE() macro which allow adding specific symbols
into the __kprobe_blacklist section and use to blacklist the following
symbols that showed to be problematic:
- handle_exception()
- ret_from_exception()
- handle_kernel_stack_overflow()

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20231004131009.409193-1-cleger@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/asm.h | 10 ++++++++++
 arch/riscv/kernel/entry.S    |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
index bfb4c26f113c4..b5b84c6be01e1 100644
--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -164,6 +164,16 @@
 	REG_L x31, PT_T6(sp)
 	.endm
 
+/* Annotate a function as being unsuitable for kprobes. */
+#ifdef CONFIG_KPROBES
+#define ASM_NOKPROBE(name)				\
+	.pushsection "_kprobe_blacklist", "aw";		\
+	RISCV_PTR name;					\
+	.popsection
+#else
+#define ASM_NOKPROBE(name)
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_RISCV_ASM_H */
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 278d01d2911fd..ed7baf2cf7e87 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -105,6 +105,7 @@ _save_context:
 1:
 	tail do_trap_unknown
 SYM_CODE_END(handle_exception)
+ASM_NOKPROBE(handle_exception)
 
 /*
  * The ret_from_exception must be called with interrupt disabled. Here is the
@@ -171,6 +172,7 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 	sret
 #endif
 SYM_CODE_END(ret_from_exception)
+ASM_NOKPROBE(ret_from_exception)
 
 #ifdef CONFIG_VMAP_STACK
 SYM_CODE_START_LOCAL(handle_kernel_stack_overflow)
@@ -206,6 +208,7 @@ SYM_CODE_START_LOCAL(handle_kernel_stack_overflow)
 	move a0, sp
 	tail handle_bad_stack
 SYM_CODE_END(handle_kernel_stack_overflow)
+ASM_NOKPROBE(handle_kernel_stack_overflow)
 #endif
 
 SYM_CODE_START(ret_from_fork)
-- 
2.43.0



