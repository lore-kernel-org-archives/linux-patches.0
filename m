Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E334F2882A6;
	Mon, 13 Oct 2025 15:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370327; cv=none; b=iFyyCgrmgHwn/R3ogse3SmzpDmParfvHIf3eEzZa4WCKcX2ONGCYBmhAy0jtNix3VhFxE3KC92jRGx6W/FJxLizIo0aDw4DhYveE5/FKVyezBp0J1f9s8pMTuGbvWNA8ekuM39yY+mwvWQmSexHjtuHTCGfpM7H5dK3X2Y04J6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370327; c=relaxed/simple;
	bh=opPWC18r+B8zcOQR07yd6oeM5V0lhZ2bs9AddiTexBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0R3T6IKG7PIdBS6INjXJ2ARi5Wfhb9IQFJMOApw4YlXiMxmtEcnT39Y7pA7W3D28JBoD13iSHh1QembQ20HHeE/lk5MQWlNzkCpGLtC6NrAzQMxSOjGhZxUmiY7LP7MhskuypiIwVfnWX01TTj3q0DQ90uULAKKrKTVRAA6k/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsSYF4oH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsSYF4oH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABA7C4CEE7;
	Mon, 13 Oct 2025 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370326;
	bh=opPWC18r+B8zcOQR07yd6oeM5V0lhZ2bs9AddiTexBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsSYF4oHE9sr/Lla6rF5rDgElG3cezRDZuV70Wnxxh7s/YSyi7fhRR7u7CpFlK28z
	 46s5dvyV2t7pEsZWUXv+pb+2ZrgyZi1cOhJMlxPyo3nuRCBXCk9al/al7PiNuRvgEz
	 lwl0M3d3pTPo9GgU45yPj0OyDJBpZw3GgjwbyCqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 524/563] LoongArch: BPF: No support of struct argument in trampoline programs
Date: Mon, 13 Oct 2025 16:46:25 +0200
Message-ID: <20251013144430.294570562@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

commit e82406c7cbdd368c5459b8a45e118811d2ba0794 upstream.

The current implementation does not support struct argument. This causes
a oops when running bpf selftest:

  $ ./test_progs -a tracing_struct
  Oops[#1]:
  CPU -1 Unable to handle kernel paging request at virtual address 0000000000000018, era == 9000000085bef268, ra == 90000000844f3938
  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu:     1-...0: (19 ticks this GP) idle=1094/1/0x4000000000000000 softirq=1380/1382 fqs=801
  rcu:     (detected by 0, t=5252 jiffies, g=1197, q=52 ncpus=4)
  Sending NMI from CPU 0 to CPUs 1:
  rcu: rcu_preempt kthread starved for 2495 jiffies! g1197 f0x0 RCU_GP_DOING_FQS(6) ->state=0x0 ->cpu=2
  rcu:     Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
  rcu: RCU grace-period kthread stack dump:
  task:rcu_preempt     state:I stack:0     pid:15    tgid:15    ppid:2      task_flags:0x208040 flags:0x00000800
  Stack : 9000000100423e80 0000000000000402 0000000000000010 90000001003b0680
          9000000085d88000 0000000000000000 0000000000000040 9000000087159350
          9000000085c2b9b0 0000000000000001 900000008704a000 0000000000000005
          00000000ffff355b 00000000ffff355b 0000000000000000 0000000000000004
          9000000085d90510 0000000000000000 0000000000000002 7b5d998f8281e86e
          00000000ffff355c 7b5d998f8281e86e 000000000000003f 9000000087159350
          900000008715bf98 0000000000000005 9000000087036000 900000008704a000
          9000000100407c98 90000001003aff80 900000008715c4c0 9000000085c2b9b0
          00000000ffff355b 9000000085c33d3c 00000000000000b4 0000000000000000
          9000000007002150 00000000ffff355b 9000000084615480 0000000007000002
          ...
  Call Trace:
  [<9000000085c2a868>] __schedule+0x410/0x1520
  [<9000000085c2b9ac>] schedule+0x34/0x190
  [<9000000085c33d38>] schedule_timeout+0x98/0x140
  [<90000000845e9120>] rcu_gp_fqs_loop+0x5f8/0x868
  [<90000000845ed538>] rcu_gp_kthread+0x260/0x2e0
  [<900000008454e8a4>] kthread+0x144/0x238
  [<9000000085c26b60>] ret_from_kernel_thread+0x28/0xc8
  [<90000000844f20e4>] ret_from_kernel_thread_asm+0xc/0x88

  rcu: Stack dump where RCU GP kthread last ran:
  Sending NMI from CPU 0 to CPUs 2:
  NMI backtrace for cpu 2 skipped: idling at idle_exit+0x0/0x4

Reject it for now.

Cc: stable@vger.kernel.org
Fixes: f9b6b41f0cf3 ("LoongArch: BPF: Add basic bpf trampoline support")
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1526,6 +1526,12 @@ static int __arch_prepare_bpf_trampoline
 	if (m->nr_args > LOONGARCH_MAX_REG_ARGS)
 		return -ENOTSUPP;
 
+	/* FIXME: No support of struct argument */
+	for (i = 0; i < m->nr_args; i++) {
+		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG)
+			return -ENOTSUPP;
+	}
+
 	if (flags & (BPF_TRAMP_F_ORIG_STACK | BPF_TRAMP_F_SHARE_IPMODIFY))
 		return -ENOTSUPP;
 


