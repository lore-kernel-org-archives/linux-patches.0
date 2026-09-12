Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F6424CEEA;
	Sat, 12 Sep 2026 11:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213718; cv=none; b=hfbZdqxWZwH3ULlJRVYdNzoiFZNCvGqlybn5i4vQjy2daBcBAT2bgNl7TirrbyU61IPYyZuI80PTblNGz7eCY73qkRdn0tLWV4KxlADvEXEGIXuR3f70TZk6tlg0Wyg0rvcOqKPNyTNHfI8/eW7kanPOt64N9l2HMk/jcCgwBA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213718; c=relaxed/simple;
	bh=fh+2kyoenkMMUxb3797zRptsOuEjrTD0QnH8sZdXgss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3flKqZq4mwVubHtvHUU86Vk+EnPK+T3P+jRlg8U4kPnYC/Y8BMfcXSUEpS1brRzHdCoNxUtl2RwoxcjOgt13Q7ys3CseK6xBtbvHdpFtHiIxXZlsc5xE+ypT6JJmZ5pzjJ9cd6ghcdI8ldwGmsxw5XJrb8VLsmTssLW5KH38yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbHGdhq8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbHGdhq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078D31F000FF;
	Sat, 12 Sep 2026 11:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213717;
	bh=oAg9iJwGNTfFiOuyV1j/BFnc2K4wn4Vp+ggYTRyeybI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbHGdhq8Tfgdl36yLmhbY2+8QupkmcnSCmU0SkhZXLp6imPibXcUcfhTUt3W0LB9q
	 IxfwcSQzCceuYvD0U0Z25erRygQ7yRHT+CepXRq4KZHgRoFnELUGwO0U5QoAmPl2KY
	 TlgwIhadRXUkqdASxQozIjhJFb06ByKkm4XKOxhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0177/1376] LoongArch: Do not save/restore percpu base register in rethook trampoline
Date: Sat, 12 Sep 2026 08:43:23 +0200
Message-ID: <20260912065611.494522846@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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


