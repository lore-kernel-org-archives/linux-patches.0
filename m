Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2D3449B2A;
	Tue, 21 Jul 2026 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655133; cv=none; b=kRPvwteRZqDjSz3Z18zo30SnSVqbZCZ5IeWH4le+PlhueAkIXrrlTCz2fz8D0SGhaFIcAnb+6/GgWhjEl5ed+k/LCAFRYKlm86UfxOvgc+ey1QkCC9UrfdSX9/K2jDf00OBnaJo2zouLiPhcqBtVTxW0gasyh3nKv+A1x1gVBtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655133; c=relaxed/simple;
	bh=abNvgy2aAVtZ2fb/nJv2naojIl82kPIgVoWWECEDmuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTITJh8ChwNWK+gMGD7eLH2PjTRcjIh6lT/ZfGS/L84LFBUUxmc33ur1FS9a9ZQ5NU5aWzD1YfMqNDDG3NqyZPwJu8XiQRCsyaP1CwPWki1fGURPWROGGhO4hoecAzD3rOyWEvFqVI0Agc9Jn0D3C8ao7u1T/qIc323c2jasSds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLzFD76F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLzFD76F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E523D1F000E9;
	Tue, 21 Jul 2026 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655132;
	bh=HYK1LcuW8mpxiZ34Nxr/3b15Uhr/hNxZfzeoHgO1C9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLzFD76FsqlISj0nm3NaiCdLD0iF71w0W7rIdm1bpdI/qY3cFHb8IHC+7IXHNmBrT
	 /thQ/NpWCt9WS4cHpa3xBmyC8azso4QGfDG0Pdg5Sl3gLaWLGTIAVDCJPdljaNjDTr
	 47mL08t1D5LZHzBdoOxio3NkzKM+Z7Dl2mYhIPpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.1 1967/2077] riscv: probes: save original sp in rethook trampoline
Date: Tue, 21 Jul 2026 17:27:20 +0200
Message-ID: <20260721152639.100781913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

commit bc7b086a45521a986a49045907f017e3e46c763e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/rethook_trampoline.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/riscv/kernel/probes/rethook_trampoline.S
+++ b/arch/riscv/kernel/probes/rethook_trampoline.S
@@ -41,6 +41,9 @@
 	REG_S x29, PT_T4(sp)
 	REG_S x30, PT_T5(sp)
 	REG_S x31, PT_T6(sp)
+	/* save original sp */
+	addi a0, sp, PT_SIZE_ON_STACK
+	REG_S a0, PT_SP(sp)
 	.endm
 
 	.macro restore_all_base_regs


