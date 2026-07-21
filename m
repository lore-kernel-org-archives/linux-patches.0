Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452E046D566;
	Tue, 21 Jul 2026 18:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659241; cv=none; b=rXszdF4dDhASyJ6ovSwKFGPQaIfxk1qvKnNwy/OX+bO6ZkxfVx29yZ01IuJ4tYmjxYy620Ckj3UG14GvmWdmR91qYkyfCvUHZrCdrqK8Yiajx62H47KaFcBI7QchUOUrVLn25h8JYioMwdcStx+M88ByP/vQw/jKV04vmp1oEMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659241; c=relaxed/simple;
	bh=4jNB9ZKlhnP92uTuWWwnDzP2Aif13ukIuOwkHhhquwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ag6Bt0sM4klwXCaQxgitC+fNjZpFDSZNwoLY5rK6iaFak2yC1tAk79exSU1R/EAXe/0vEbgcbNyrR8R7YbH7oDXhMJdF4tzybEotlTWoTsA/Zbl4h7YdCeZu8NaJQZ6xvYP0oyHGQudFiVhUGbDGGbi2fsuFQd2n7ZQEwV6x5Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pie+JBVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pie+JBVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703DD1F000E9;
	Tue, 21 Jul 2026 18:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659239;
	bh=pUYQBvi0JF2gZCGsneEFVkejUNhsrJrXnbKNhtTBhX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pie+JBVXSWJoDVam8JBJlSc8RIBfuNsoFjst5/iZBmJAO75FxcFOi6D9c8ytm5Le4
	 b56n+5zoNeXHYIYESl/wPsEmWTtGb9xVh2opihVUYBq7JwD3a4q5Z0HKg3UtQYYiD/
	 9zl6R0N6ByNSwvvezN1dAuD+5eCpTUxQ90CD+2X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 1447/1611] riscv: probes: save original sp in rethook trampoline
Date: Tue, 21 Jul 2026 17:26:03 +0200
Message-ID: <20260721152547.997424501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


