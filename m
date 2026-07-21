Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFCF35C6AC;
	Tue, 21 Jul 2026 22:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673633; cv=none; b=Ns1Z9Qh6VmNFTsHk0gYt62IyJtu391EoMg38xtVANcIlHB1hY56tuwIIOrzpWVsbQ86VjmBfC1mm1Mk1r4gfwdutnkv+YTo3gMcg+NoGVw9rx2mxjJSVBREH4G/tG4UR8Db4Moj2IKTWrSPQE2Siy33dXjBoWmXmMTja3jZsFc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673633; c=relaxed/simple;
	bh=FGka1slvlHK4yNy2yvyXjnAcztbCkqGKFFFQjCmMhW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF/h947CPiBZUjDxOMKIOetJXtB/OrtunqmcRY38hUmQdIi/5xUFfMAeHdLFXbJTcxPJz91hxNDKhHbaeSvmfl5lTa8uiPoMqKDSAb4ei3/1VopjBQgfaYOzz5z+KusmzxqKrDnojlzMhMKvJ1DWGKWmFmy5jgm5JpNjpnBsAZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvcdnnwH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvcdnnwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191AF1F000E9;
	Tue, 21 Jul 2026 22:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673632;
	bh=FJgTHmVTL9awWQiAbLdVK4k6ys0oZoY/DRjTRRPtjt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvcdnnwHuE6/cWf7makd47HFHCAmN/ceHa5u8L8jbgWYUPCdMjjmpGUeYgV+MlsV4
	 MEPd+TmNFakPZ06dTKq9HgHjMKxZCUGjN6AivL4MUBrN6PfT7+V0F38u04U0oDLtVl
	 iukq/zDSLq6R+pxSzAcOh9VBFST3P2MnWaloVQbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/699] riscv: stacktrace: Remove bogus -0x4 offset in non-FP walk_stackframe
Date: Tue, 21 Jul 2026 17:19:56 +0200
Message-ID: <20260721152401.045487005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit 8ac35bac70e7e581d673b76878f7691cdadc33b8 ]

In the non-frame-pointer version of walk_stackframe, each value read
from the stack is treated as a potential return address and has 0x4
subtracted before being used as the program counter. This was intended
to convert the return address (the instruction after a call) back to
the call site, but it is incorrect:

1. RISC-V has variable-length instructions due to the RVC (compressed
   instruction) extension. A call instruction can be either 4 bytes
   (regular) or 2 bytes (compressed, e.g. c.jal). Subtracting a fixed
   0x4 assumes all call instructions are 4 bytes, which is wrong for
   compressed instructions.

2. Stack traces conventionally report return addresses, not call sites.
   Other architectures (ARM64, x86, ARM) do not subtract instruction
   size from return addresses in their stack unwinding code.

3. The frame-pointer version of walk_stackframe already dropped the
   -0x4 offset. Commit b785ec129bd9 ("riscv/ftrace: Add
   HAVE_FUNCTION_GRAPH_RET_ADDR_PTR support") replaced "pc =
   frame->ra - 0x4" with ftrace_graph_ret_addr(), and the commit
   message explicitly noted that "the original calculation, pc =
   frame->ra - 4, is buggy when the instruction at the return address
   happened to be a compressed inst." The non-FP version was simply
   overlooked.

Remove the bogus -0x4 offset to match the FP version and the
conventions used by other architectures.

Fixes: 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Link: https://patch.msgid.link/20260603115329.791603-2-qirui.001@bytedance.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 9c34735c1e771d..6905f396640562 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -96,7 +96,7 @@ void notrace walk_stackframe(struct task_struct *task,
 	while (!kstack_end(ksp)) {
 		if (__kernel_text_address(pc) && unlikely(fn(pc, arg)))
 			break;
-		pc = READ_ONCE_NOCHECK(*ksp++) - 0x4;
+		pc = READ_ONCE_NOCHECK(*ksp++);
 	}
 }
 
-- 
2.53.0



