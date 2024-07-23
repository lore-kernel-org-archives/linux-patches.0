Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2819D156F29;
	Tue, 23 Jul 2024 18:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759368; cv=none; b=bDhdCYdcfXlu54zoa/lhLFCHGXrvZXj2ugBCLHaHPolrvfuj6+10QAAgQ8z4bi8nT70MMYZ9gQKiltw+eD1AiHoFjJnC2iVUZcwWs9dXTPPvfqC63bswDjtEqkXmKRd+lq2tsg7ZH8hxSYYnnaAcO0+N4694cbcKZx4JNqZ9oww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759368; c=relaxed/simple;
	bh=vg//bSqi8TBZRi+wQUkSkT82AI8LbWCSWhAqT1CdkZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ad5vGOUYNNxdrZw2ZUzfEcTm6pufSUuKlYORIV7ZQuLXUihbAz4MdfIIZMpgOg/2yI4F55imbyZhtdNinv4CepwtLPRDSAkOBO5dlFapmirs+4n5HLtpeIyrzxft/1HPTPOlMl1UWYRiHD38PZwt7NIYPMpVtcYdGjjH8LIibns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIJjMaYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIJjMaYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A372CC4AF0A;
	Tue, 23 Jul 2024 18:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759368;
	bh=vg//bSqi8TBZRi+wQUkSkT82AI8LbWCSWhAqT1CdkZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIJjMaYHEbXuzExADA0c5mNvO2dTJYRRYKAMORG19b/vzAMhm/xBeuE1RfCQHEfy4
	 t/2gxbPeEfyBRJXOEFha5zxTPAqDV0QHNMhcq5beavc4rfnU7G4sNO3oPF17ZmhGUP
	 CyCHPEVsYEN3Mx2eXeCdCjWiDIEyonMrmP0KSSpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/105] riscv: stacktrace: fix usage of ftrace_graph_ret_addr()
Date: Tue, 23 Jul 2024 20:24:08 +0200
Message-ID: <20240723180406.754408918@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 393da6cbb2ff89aadc47683a85269f913aa1c139 ]

ftrace_graph_ret_addr() takes an `idx` integer pointer that is used to
optimize the stack unwinding. Pass it a valid pointer to utilize the
optimizations that might be available in the future.

The commit is making riscv's usage of ftrace_graph_ret_addr() match
x86_64.

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20240618145820.62112-1-puranjay@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 0d3f00eb0baee..10e311b2759d3 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -32,6 +32,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			     bool (*fn)(void *, unsigned long), void *arg)
 {
 	unsigned long fp, sp, pc;
+	int graph_idx = 0;
 	int level = 0;
 
 	if (regs) {
@@ -68,7 +69,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			pc = regs->ra;
 		} else {
 			fp = frame->fp;
-			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
+			pc = ftrace_graph_ret_addr(current, &graph_idx, frame->ra,
 						   &frame->ra);
 			if (pc == (unsigned long)ret_from_exception) {
 				if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
-- 
2.43.0



