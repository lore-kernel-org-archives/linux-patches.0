Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBD942882B;
	Sat, 12 Sep 2026 11:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213723; cv=none; b=f2yWVlhCI7ffD1oOIh4nJvpBCyf0dGJqQ58psN+9vNmk1eMswebVeAMul+38r39BRMqcQ08ZryKXMq5AewlhIjy/yKmyGmxnq6rnp/6KicRqVvUkze8uTYcWCV88q4ttn6nHhUogKpXYdZvGM0rdXFzwY7x51lXIW9/nm5rP3Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213723; c=relaxed/simple;
	bh=uWT4ZF6gXaSjVG/1bKCi3hEWPPSaOlB2tabSqLd2Smk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dw+ZJSwySJIJVPrXIiLh/f3NpY5bHGhJIR+CuVgVH6BtH0onBxNDUWg/sBLLkFlTZ4ez02UUU5BDFh+23hewacV+nJ1GSkav7P/3ME4EjK/+3CUAZfnMUwF/CeEzSm460rEsSVxeMryNxnYcaBJqvUklA+TpNf82KzxHOcxBnxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of6UGiqF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of6UGiqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2331F000FF;
	Sat, 12 Sep 2026 11:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213722;
	bh=tsyPwWuX6Tj0GJCOAMZXlEyBw2/yZoIT5tqRlZlxVl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=of6UGiqFkJ84UcglUkekJr9XfrU/mHXI/nATVN/avCpYLWRPKYRw5kK0xM99buqZ0
	 g4d1lrgxC6tQFkAQJJnzAOsKmwIVquYXelbFHeSvOKtaQVRiVKp/N3xz4CTrqx5fzn
	 cpxgDBMB/dy33rO+7gPtQsSW4jcG+MEnI3V/mNWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0178/1376] LoongArch: Avoid preempt count underflow without probe
Date: Sat, 12 Sep 2026 08:43:24 +0200
Message-ID: <20260912065611.517826735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -273,6 +273,9 @@ bool kprobe_singlestep_handler(struct pt
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	unsigned long addr = instruction_pointer(regs);
 
+	if (!cur)
+		return false;
+
 	if (cur && (kcb->kprobe_status & (KPROBE_HIT_SS | KPROBE_REENTER)) &&
 	    ((unsigned long)&cur->ainsn.insn[1] == addr)) {
 		restore_local_irqflag(kcb, regs);


