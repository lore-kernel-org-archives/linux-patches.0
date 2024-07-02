Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E981315218A;
	Tue,  2 Jul 2024 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941026; cv=none; b=nH+WROoOa+2WYjEVthgEg+1df8GqOEWve3/TOF58akXuB3NdD9JgLP2bEa6uhkLxrwrGl2Vwmw457hwGxvgV9sevk33x08dhW3AjsyRkmLFPBtTjnrWlfco3GSP6fmE1y4MVj44bwURvegqXvQxHgPUGnynQrj1avdLq8qxpfAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941026; c=relaxed/simple;
	bh=FZmY6GBQSCRcBdEFYlED591hKOgEK+aw72XH6ifq+10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXkFpXuLkB0ejR+CV6+/ivI+ZUrClhb/vIzx5g7Mt4pUIeaDCb/ynsoLiwNkuS3ASAN4d3IQl/HEamwvip1S2xcoAiXnG/KpLuNgGEhWU+c+2oXLoA/TnJtqPCV7TMLC5t4t5IQru9fmMQep9r10hMw05FvdqUrR3MwuFLGq3jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DK90Lzjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DK90Lzjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD87C116B1;
	Tue,  2 Jul 2024 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941025;
	bh=FZmY6GBQSCRcBdEFYlED591hKOgEK+aw72XH6ifq+10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DK90Lzjt2Q0lhmULwhsSphsQXBiFsV0M76iAfLplwCTvN9alVhLjU9grEj46lfxGj
	 N2/K9tGpxeuIl5ww9n/ab1/X0nebuflm3YbJOpxYPv+oyYmQOSVmvFK+GJHuoJegSY
	 34VuZxTLWidq39eoJAASpn5cnf5LymaRpMccpGv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <andy.chiu@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/163] riscv: stacktrace: convert arch_stack_walk() to noinstr
Date: Tue,  2 Jul 2024 19:03:09 +0200
Message-ID: <20240702170235.903655943@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Andy Chiu <andy.chiu@sifive.com>

[ Upstream commit 23b2188920a25e88d447dd7d819a0b0f62fb4455 ]

arch_stack_walk() is called intensively in function_graph when the
kernel is compiled with CONFIG_TRACE_IRQFLAGS. As a result, the kernel
logs a lot of arch_stack_walk and its sub-functions into the ftrace
buffer. However, these functions should not appear on the trace log
because they are part of the ftrace itself. This patch references what
arm64 does for the smae function. So it further prevent the re-enter
kprobe issue, which is also possible on riscv.

Related-to: commit 0fbcd8abf337 ("arm64: Prohibit instrumentation on arch_stack_walk()")
Fixes: 680341382da5 ("riscv: add CALLER_ADDRx support")
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240613-dev-andyc-dyn-ftrace-v4-v1-1-1a538e12c01e@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 528ec7cc9a622..0d3f00eb0baee 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -156,7 +156,7 @@ unsigned long __get_wchan(struct task_struct *task)
 	return pc;
 }
 
-noinline void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
+noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 		     struct task_struct *task, struct pt_regs *regs)
 {
 	walk_stackframe(task, regs, consume_entry, cookie);
-- 
2.43.0



