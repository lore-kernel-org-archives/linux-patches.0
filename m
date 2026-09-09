Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA98251475A;
	Wed,  9 Sep 2026 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962615; cv=none; b=YcUKg89PdT8py64ENAOsY07rJo3IwWYtCOfzcxLSma+B9MMRJOFNA3vBkA9GoGGBQ5XY5rguXaMb5d+0OQL0TSyvK/UN/9gCsNsbtz5I4gS9S9vZSasVZCwMo/mcqfDy+Dme4Pol/9ta1e5u6Bqib2Uc2nAktjp+sHHc1K58vNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962615; c=relaxed/simple;
	bh=KSDwuCrTgUO4cmVPKPalJaAfPpHxaOrdXkAeWDivbNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A/A9115ItzQKU4bI7JfWv4rSm5wFwua6d60g8RdaIZUrBmlB4sKmLX9Ubfv2fo6OY9uFDhNlwS6ql8ir40iwUcsNACK3h8/l/pZQ8Sia3D2lc8fDTOFkEjP3fzm/ZWn2vJyTSVn4N4UEZJrNTBy6OfUWEvxMRK2+oI2DlEgFmB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGqhJPNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGqhJPNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302921F00A3A;
	Wed,  9 Sep 2026 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962613;
	bh=PLqYMblsz5rDu6nr0ah6kZv8bXMI1VR6MMgexdMIOZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGqhJPNL420NLCDd+hfYx04T6ojdjdExZ07/8i1kqz7OvheIwwLqfUCbx+pzP1RPT
	 LEpuDGF+0PoFB2K5M2mrdI80npFvdyOubTRMBxpd/rtt4/NNomJQoSdkX6ppk+089C
	 YeLiPwgVQ4KsyrSkME4nTdPxaU6iYnCnspV+324c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 344/556] LoongArch: Avoid preempt count underflow without probe
Date: Wed,  9 Sep 2026 15:40:24 +0200
Message-ID: <20260909134242.757009355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 72ce4b24676e8b3b75376c4c559dd81c1ac52d5a upstream.

LoongArch uses break 11 for the breakpoint placed after an instruction
that Kprobes executes out of line. Since userspace can issue the same
break instruction, do_bp() can reach kprobe_singlestep_handler() when
there is no current probe.

The handler actually returns false in this case, but it first calls
preempt_enable_no_resched(). The corresponding preempt_disable() is done
by kprobe_breakpoint_handler() on a real Kprobe hit, so it has not run
here. As a result, an ordinary userspace breakpoint (code 11) underflows
the current task's preempt count.

This also makes in_interrupt() return true until the task schedules. One
visible consequence is the socket cgroup attribution: cgroup_sk_alloc()
treats the allocation as interrupt context and assigns the socket to the
root cgroup. A socket opened from the SIGTRAP handler can then avoid a
BPF_CGROUP_INET_SOCK_CREATE policy attached to the task's own cgroup.

Return as soon as kprobe_running() reports no active probe.

The same check has appeared in [PATCH v10 2/4] of the original LoongArch
Kprobes series, but was dropped before the feature reached mainline.

Cc: stable@vger.kernel.org
Fixes: 6d4cc40fb5f5 ("LoongArch: Add kprobes support")
Link: https://lore.kernel.org/loongarch/1670575981-14389-3-git-send-email-yangtiezhu@loongson.cn/
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/kprobes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/kernel/kprobes.c
+++ b/arch/loongarch/kernel/kprobes.c
@@ -275,6 +275,9 @@ bool kprobe_singlestep_handler(struct pt
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	unsigned long addr = instruction_pointer(regs);
 
+	if (!cur)
+		return false;
+
 	if (cur && (kcb->kprobe_status & (KPROBE_HIT_SS | KPROBE_REENTER)) &&
 	    ((unsigned long)&cur->ainsn.insn[1] == addr)) {
 		restore_local_irqflag(kcb, regs);


