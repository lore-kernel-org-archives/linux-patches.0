Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8B6579836;
	Wed,  9 Sep 2026 14:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964046; cv=none; b=pYYA84fTTI5+t7u+goXjNa+o/bVbWbO5l0gKSo6wtp9085VjUnTiWVeILugeD9kMygb70yXfRCL0XgvCGSbpxcWZ6m9sztzgmoVZU8vZu8N56c2y8kvPTWgdHLuab80tnPZqLstL5wSnjWdLVR5XYUHrC6ms6Xf3GalKaVYjp9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964046; c=relaxed/simple;
	bh=hFLRiQUmlWsyVFkbjM3vfCR3kjPhLKrBjKzwn/ORovI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z93hW3/s7q6ekJlELOzTLAbLYe2PWR/Vku13ErsrogdNVknAGEXBqnFfOQan79jQsIY5WdXZ/uaFPh/n0/o6suWSNwcAv5/v5HxV0bk2RStekYc/Ecv8QCTyvwpBa/8d2B+i1zn57rsg+mGlONYTT1rq9rxgUslRKSMJPwT8vVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bpp1dh5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bpp1dh5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81731F00A3A;
	Wed,  9 Sep 2026 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964045;
	bh=br3itkxFOc9xPr7mgIRDTeShbfBl63vBungdtATX/5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bpp1dh5oi545cXUNiiGZ6yeKTORYMipk2wSuIzI1dcBISklV7DmUCnxRxRVoPh/v/
	 g2wYkMKKjgVsVxUH33XHarHoGXrx0ceN/UzugIiwPw2eRFNLiegWVr4vfIWiM3D6+a
	 mhhMP2nXS/AKXnFEydlVtH6aYViRNB4He//LcRwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 271/583] LoongArch: Do not save/restore percpu base register in rethook trampoline
Date: Wed,  9 Sep 2026 15:39:16 +0200
Message-ID: <20260909134247.476271842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

commit c3f2feace5e4f4b01b68b9f947b19adb4155c32e upstream.

The rethook trampoline saves $r21 ($u0), the percpu base, into its frame
at entry and restores it at exit. Inbetween rethook_trampoline_handler()
may schedule via preempt_enable_notrace().

If the task migrates to another CPU, the frame's $r21 holds the old
CPU's percpu base, and restoring it poisons $r21 on the new CPU. Until
the next user->kernel transition heals $r21, all this_cpu_*() accesses
(runqueues, RCU per-CPU data, timer tick programming, FPU ownership)
hit the wrong CPU's percpu area.

Under kretprobe-heavy preemptible load this can corrupt scheduler and
timer state: scheduling-while-atomic splats, wrong-CPU RCU warnings,
WARN_ON_ONCE(rq != this_rq()) in nohz_balance_exit_idle(), and CPUs
parking in the idle loop with the constant timer never re-armed (hard
lockup). Reproduces on a Loongson-3A6000 with kretprobes on VFS paths
plus heavy file churn (OS install / unsquashfs).

By convention $r21 always holds the current CPU's percpu base in kernel
mode: SAVE_SOME() at exception entry reloads it only when coming from
user mode, and RESTORE_SOME() restores it only when returning to user
mode; the context-switch path never writes it. Therefore the live $r21
at trampoline exit is already correct, and nothing inbetween can change
it legitimately (kernel C code cannot write a global register variable).
The same flaw existed even in the pre-rethook kretprobe trampoline since
v6.3; it was carried over when rethook replaced it. Drop both the save
and the restore here. Drop the restore is enough to solve the issue, and
drop the save is to keep the code tidy and no need to clear it.

Cc: stable@vger.kernel.org # v6.3+
Fixes: 3f5536860086d ("LoongArch: Add kretprobes support")
Assisted-by: Kimi:Kimi-K3 # debug and root-cause analysis
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/rethook_trampoline.S |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/loongarch/kernel/rethook_trampoline.S
+++ b/arch/loongarch/kernel/rethook_trampoline.S
@@ -24,7 +24,6 @@
 	cfi_st	t6, PT_R18
 	cfi_st	t7, PT_R19
 	cfi_st	t8, PT_R20
-	cfi_st	u0, PT_R21
 	cfi_st	fp, PT_R22
 	cfi_st	s0, PT_R23
 	cfi_st	s1, PT_R24
@@ -59,7 +58,6 @@
 	cfi_ld	t6, PT_R18
 	cfi_ld	t7, PT_R19
 	cfi_ld	t8, PT_R20
-	cfi_ld	u0, PT_R21
 	cfi_ld	fp, PT_R22
 	cfi_ld	s0, PT_R23
 	cfi_ld	s1, PT_R24


