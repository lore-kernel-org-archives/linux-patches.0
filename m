Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215413;
	b=lN4Qcos0PMASMIjE8k8smj5YZtfN8/CweTX7KdxBp6x3x6InL4MGEbNsQVXVuFOTAV1H
	 EyhjITm6n0scRyr6VPo+fCyIsbisNpUF8KwVYELft4jXMt0TsDkW9tb68wLqKB913yqot
	 zvH3oqKFKz268lCB5xxRWuFb32qBQ7NTBQYHM2NHKUuC4ByM9Phtr10GfBXdtwlI49voF
	 kGxHdVpxR+tQtxFDqwWyHKH3i/V7oXdBkgXCzIczIuAIGOsXJ/wObpV316sqgLeyXLeW8
	 pgnHobyXC4xXucM/c3tKrXr5NVF0rkQC/+XAqDwx9umtsMeYKh/koYELIj3A54lbb9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xq9AQ2bQDE1fcP8QAZLIAlmkugTROdg9f1l42aZY8Bs=;
	b=u2s77iBqQko9KuRwzsv5aD68/06VsN3YPBjuVQzotTYkdd0Tsw17jVWuaDS0ljIM4LMJ
	 YEcaQClGYeYZ8Am7fg0SY/sHjQ0UPuwkeXiBip4estp+pQXex2HQQlfgeEppcBwRDSrXx
	 tvDdRhk9rcp8xkjOGN2FbtsM/LWk8V7P5Qg/tKYKQ4x6GcuaUVg7lmvjuMoNUIC0Bc/ym
	 zCFVfsN4ZFW6SrAHtgP8qwHMP9C5tks2pJhQtHjfERvCJoDpVE/c0FdVkApOkZfgeeAdv
	 PVDgVvTKssQiDVTfOJyxG45jGPvlKfoCjOZpdNGZLlK5oUBV93GHMy7eHh9IwXUhJLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvSF3dby;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE30606A31C;
	Wed, 28 Oct 2026 19:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvSF3dby
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45671F01825;
	Wed, 28 Oct 2026 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215413;
	bh=Xq9AQ2bQDE1fcP8QAZLIAlmkugTROdg9f1l42aZY8Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvSF3dbyPvV99Kuaxt4tP+W19PmRr68bbcyJwNDGPT7tkmvPD4QFA/8f/gL0F1Ot6
	 Di+LhKo9W89SWkI3J5txEPV5/tYFqv5yCOpwkmvVPXcfUEw+kOWkiu/h9uNeDK/bu/
	 yo006cw8i7Q8V6qpA64Q7a7s3cM5bCz2jNrKLTIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1202/1887] riscv: probes: save original sp in rethook trampoline
Date: Wed, 28 Oct 2026 17:54:58 +0100
Message-ID: <20261028170526.759088666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit bc7b086a45521a986a49045907f017e3e46c763e ]

Reading a word from the stack in a kretprobe crashes a risc-v kernel.

$ cd /sys/kernel/tracing/
$ echo 'r n_tty_write $stack0' > dynamic_events
$ echo 1 > events/kprobes/enable
Unable to handle kernel paging request at virtual address 0000000200000128
...
[<ffffffff80016d16>] regs_get_kernel_stack_nth+0x26/0x38
[<ffffffff80177196>] process_fetch_insn+0x3ee/0x760
[<ffffffff80177836>] kretprobe_trace_func+0x116/0x1f0
[<ffffffff8017795a>] kretprobe_dispatcher+0x4a/0x58
[<ffffffff8013572e>] kretprobe_rethook_handler+0x5e/0x90
[<ffffffff80180838>] rethook_trampoline_handler+0x70/0x108
[<ffffffff8001ba32>] arch_rethook_trampoline_callback+0x12/0x1c
[<ffffffff8001ba84>] arch_rethook_trampoline+0x48/0x94
[<ffffffff8067872a>] tty_write+0x1a/0x30

In regs_get_kernel_stack_nth, regs->sp contains an arbitrary value.

arch_rethook_trampoline saves the registers from the probed function in a
struct pt_regs. sp is not saved. Instead, sp is decremented for
arch_rethook_trampoline's local stack.

Fix this crash and save the original sp along with the other registers.
Use a0 as a temporary register, it is overwritten anyway.

Cc: stable@vger.kernel.org
Fixes: c22b0bcb1dd02 ("riscv: Add kprobes supported")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://patch.msgid.link/20260630194010.1824039-1-martin@kaiser.cx
[pjw@kernel.org: added Fixes tag; cc'ed stable]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/kprobes_trampoline.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/probes/kprobes_trampoline.S b/arch/riscv/kernel/probes/kprobes_trampoline.S
index 7bdb09ded39b8..b1f0fc933e0be 100644
--- a/arch/riscv/kernel/probes/kprobes_trampoline.S
+++ b/arch/riscv/kernel/probes/kprobes_trampoline.S
@@ -41,6 +41,9 @@
 	REG_S x29, PT_T4(sp)
 	REG_S x30, PT_T5(sp)
 	REG_S x31, PT_T6(sp)
+	/* save original sp */
+	addi a0, sp, PT_SIZE_ON_STACK
+	REG_S a0, PT_SP(sp)
 	.endm
 
 	.macro restore_all_base_regs
-- 
2.53.0



