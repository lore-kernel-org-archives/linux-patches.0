Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B87E471417;
	Tue, 21 Jul 2026 20:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664135; cv=none; b=VSWi5XYDrzAeVEETkYp66oHXfu1LIMCcvmM/pm5HRrylBLGbeVoAXe7c9Ifj+xZHyiIjJadjxhPMsby7GGt0SxS4bPQVEdMaYdV5rD8BtdrN74E+0oLC1y5QAbdjuNxHZFg0VuHOT/AHUGmazV9gF3MTYZAO9LKH/s2KR2yuAoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664135; c=relaxed/simple;
	bh=e6LFVf2Ybgp3i1M101SmgsNy1KqIMRwjA0zzLqPX1p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNyCbV7feBHPvPM/S8j9CXt2MN84oK1ypu4LUzdlUg1HKFUurlE08cfbNSPcT0ynYASuEb93DWD2nsevMO5N+5P8conCXyQiMLpJQ06Fwnx3I1y9fX+2u4QNXhV1sl9NTkEZR1/NUULc4cqg4MePn/0F31RlqDjW4FP4zRwx7e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxHd9Y4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxHd9Y4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4531F00A3A;
	Tue, 21 Jul 2026 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664133;
	bh=byEmMTuo6xAK47hnrDZGNBpk2RMv7cc/rDgX7yJ9Egg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yxHd9Y4KoUio+7j4+RMemhCd3UmUNdgcSzdKVhQoiQ+r6Uha99G4NSBKCDZ3FbhDz
	 PpaJGeYQ6KQsHJqmAwh9O6j6wTopO8+x6NaVLJAbr7SSVOihchf0plSMaNfSq3wnpI
	 wAC7cAoqym0ABzdcWCXMCptW77GOZsP7J8gig2+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 1085/1276] riscv: probes: save original sp in rethook trampoline
Date: Tue, 21 Jul 2026 17:25:28 +0200
Message-ID: <20260721152510.263118766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


