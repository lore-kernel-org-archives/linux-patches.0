Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8897569F3C;
	Wed,  9 Sep 2026 14:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962730; cv=none; b=u3U/tRSyB0tL9WIRe1kiJnzytI2w1ZhbESMDLjRk7NWVmgIAq1uS5DHigj7cDo2HePN4cQV+SlHudu0rAAG1RSnxujoMFpmEWQycsZJ9guV8wE3KW8fpXBwmdPioa/vNIfPAA3PPmKRgViKLVFaGmb9JErbW3JZRjj1/p8gcAqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962730; c=relaxed/simple;
	bh=Jq7J0HdFfSVnSdrvP0pdPhbmP3Y/4gS08EIUo/3BTws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqK+1COgxcwk2Z36lQgx/Ip+sPLQAtbugX7cyJPXNM2nL4WfwYbabrDBcqDwWdhu4BC02MIG0s2y5EAOwGyMOzn/6TdvrI82tqpGsPcsnUt2KV9G+qOTduakoEvCCAJsvPeRl+eNmndFJFIQosLDMofU4ezFu/EoQxWGUAHPAjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GM6doVHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GM6doVHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8501F00A3A;
	Wed,  9 Sep 2026 14:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962728;
	bh=Vdg8QjQfiKJVKvF8eMapJSjxd/IpWqGWI/O04GwiXDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GM6doVHZdJYa6G+C0bWVoctm911CpqPc7999v2t3oJ9Vut1TWFfnj5oXw4KHLSMy3
	 Xh0yTMkAdqpQxdt5ZegvaEptOfc9AXCbZCc7f6pgIZEKP/w4rCKEtjHRqfmb7JEkR7
	 DmniSj+RKcaPPrYogyLuvhZS6AINqTiozN5BcMPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 343/556] LoongArch: Do not save/restore percpu base register in rethook trampoline
Date: Wed,  9 Sep 2026 15:40:23 +0200
Message-ID: <20260909134242.721057855@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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


