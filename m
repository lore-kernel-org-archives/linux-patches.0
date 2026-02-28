Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6803C375AC8;
	Sat, 28 Feb 2026 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301679; cv=none; b=s7/Rsk2wNw0RjyGF9LtOa75sPtLhpOFlr4cy9yRKPSTbjaTEs4Ohvhw0X2tOxOYvI7a/jQ1nNBofDiDKoKHM2k2d6l0gSvJF93OkDUSVDhS1kgvC2LsZ0sgumZs1bnVN1nChRmuv+47BpOuKvqTJttDWI5g0alaf8pvwUGqK6Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301679; c=relaxed/simple;
	bh=fI3fM7eEEsrwPdfPhe7XoS3lGIbnoRgCeTQIUTkw7sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tq3MsfYzJ7b+hzS8Mv7a6jd8J7LQTt35VzIayr4CCCDsT8ASmzabUeWncxfHvkIp9mv8VXAccfLva+1bDO/zePr58V336n3QbUlP5OIi0gHKw9MsUh+83qygrlXvQbOT7b4FQo/jYLxR03NXfS98i60mCZXnPKRfm631fxx6ui8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpTfEvi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpTfEvi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5B2C116D0;
	Sat, 28 Feb 2026 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301679;
	bh=fI3fM7eEEsrwPdfPhe7XoS3lGIbnoRgCeTQIUTkw7sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpTfEvi/6HfJp3Bg5vbEJkpfZmqq5LsaVKEOX9xJ4KVh8N7zsYhDh77MLRRTFyMuo
	 89Fqu73/EeL/tPFzUeZpGCbudKJ2fIipAdyt6bxLf85CW0UbPUBc1pd/g5gugnfGqC
	 PXE4wVD+nLEP5Wy88csN1kkFlzsyMTzetZLlK9x20To9GPKrimDlM1LBPr/LisyS78
	 mx1QD9Hkp03Sqpwwd2C9ISLE5yVN2P+wD+OAwfxgbw1ZNQ2AcY9t+vxLMioosCXcca
	 t9Y9ikgqzlq08XKl2xQbVZ/P+7f69Y8seXg5FTzl9bE1apG5XT5iU9sVSyZAIeMNGD
	 v6MQqNy2oZttA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Florent Revest <revest@chromium.org>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf <bpf@vger.kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/385] tracing: Add ftrace_partial_regs() for converting ftrace_regs to pt_regs
Date: Sat, 28 Feb 2026 12:54:52 -0500
Message-ID: <20260228180011.1568201-70-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit b9b55c8912ce1e5555715d126486bdd63ddfeaec ]

Add ftrace_partial_regs() which converts the ftrace_regs to pt_regs.
This is for the eBPF which needs this to keep the same pt_regs interface
to access registers.
Thus when replacing the pt_regs with ftrace_regs in fprobes (which is
used by kprobe_multi eBPF event), this will be used.

If the architecture defines its own ftrace_regs, this copies partial
registers to pt_regs and returns it. If not, ftrace_regs is the same as
pt_regs and ftrace_partial_regs() will return ftrace_regs::regs.

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Florent Revest <revest@chromium.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: bpf <bpf@vger.kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alan Maguire <alan.maguire@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Link: https://lore.kernel.org/173518996761.391279.4987911298206448122.stgit@devnote2
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: aea251799998 ("x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/ftrace.h | 13 +++++++++++++
 arch/riscv/include/asm/ftrace.h | 14 ++++++++++++++
 include/linux/ftrace.h          | 17 +++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index b5fa57b61378e..09210f853f12d 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -135,6 +135,19 @@ ftrace_regs_get_frame_pointer(const struct ftrace_regs *fregs)
 	return arch_ftrace_regs(fregs)->fp;
 }
 
+static __always_inline struct pt_regs *
+ftrace_partial_regs(const struct ftrace_regs *fregs, struct pt_regs *regs)
+{
+	struct __arch_ftrace_regs *afregs = arch_ftrace_regs(fregs);
+
+	memcpy(regs->regs, afregs->regs, sizeof(afregs->regs));
+	regs->sp = afregs->sp;
+	regs->pc = afregs->pc;
+	regs->regs[29] = afregs->fp;
+	regs->regs[30] = afregs->lr;
+	return regs;
+}
+
 int ftrace_regs_query_register_offset(const char *name);
 
 int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec);
diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
index d9b80a42fa4df..6c3ae13d1514c 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -197,6 +197,20 @@ static __always_inline void ftrace_override_function_with_return(struct ftrace_r
 	arch_ftrace_regs(fregs)->epc = arch_ftrace_regs(fregs)->ra;
 }
 
+static __always_inline struct pt_regs *
+ftrace_partial_regs(const struct ftrace_regs *fregs, struct pt_regs *regs)
+{
+	struct __arch_ftrace_regs *afregs = arch_ftrace_regs(fregs);
+
+	memcpy(&regs->a0, afregs->args, sizeof(afregs->args));
+	regs->epc = afregs->epc;
+	regs->ra = afregs->ra;
+	regs->sp = afregs->sp;
+	regs->s0 = afregs->s0;
+	regs->t1 = afregs->t1;
+	return regs;
+}
+
 int ftrace_regs_query_register_offset(const char *name);
 
 void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index b71ad5c04f482..c912798ec61d5 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -184,6 +184,23 @@ static __always_inline struct pt_regs *ftrace_get_regs(struct ftrace_regs *fregs
 	return arch_ftrace_get_regs(fregs);
 }
 
+#if !defined(CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS) || \
+	defined(CONFIG_HAVE_FTRACE_REGS_HAVING_PT_REGS)
+
+static __always_inline struct pt_regs *
+ftrace_partial_regs(struct ftrace_regs *fregs, struct pt_regs *regs)
+{
+	/*
+	 * If CONFIG_HAVE_FTRACE_REGS_HAVING_PT_REGS=y, ftrace_regs memory
+	 * layout is including pt_regs. So always returns that address.
+	 * Since arch_ftrace_get_regs() will check some members and may return
+	 * NULL, we can not use it.
+	 */
+	return &arch_ftrace_regs(fregs)->regs;
+}
+
+#endif /* !CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS || CONFIG_HAVE_FTRACE_REGS_HAVING_PT_REGS */
+
 /*
  * When true, the ftrace_regs_{get,set}_*() functions may be used on fregs.
  * Note: this can be true even when ftrace_get_regs() cannot provide a pt_regs.
-- 
2.51.0

