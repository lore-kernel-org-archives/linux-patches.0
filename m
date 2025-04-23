Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2374C293B42;
	Wed, 23 Apr 2025 15:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421189; cv=none; b=DkAt/oB8Wqp52CtKjhXQC3K84juPIRMfVFAr4V+KIdOYdjcDDv54DmJkwQKlEQtKpjI2ofR+BsMolBeXZ52fSba/6wk+dBbLOaA2ryqo85pal25PvZEzxyKQ4kdjE1lIKlr3vVzupTa1aYK8fgavWX8JRNC3zIE1pnDg+8kSKaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421189; c=relaxed/simple;
	bh=Ahu1KzaGytbxBss0fNyFckjfo8NKkXI/KHcmaFkfiB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnBTbCd1hQRMw2rsjag+XeH9tfgrDmbDP6i3ZyGyHLqp43DIlHwJkey1cUOr61qhS+TiUAllTCpca6QGUcsFyalOt7mUtpnDVpdXu1pYBHsNVHjLRKrSHS+9grpSNyhvVYtKJi+Psr0xDF3u/LCwmNa4pCWmyxrjzC715cR5xjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6luzvjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6luzvjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA961C4CEE2;
	Wed, 23 Apr 2025 15:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421189;
	bh=Ahu1KzaGytbxBss0fNyFckjfo8NKkXI/KHcmaFkfiB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6luzvjO3ZxuxIQfiB+B0CwCP77gx/64RXYa4W5QoZNXsVQlLDJIMit4p5YEBlbko
	 FCz7VfE/Cmm4HR1TtX4DJMvuXS428bfWC9+hpxSQ0QqdeocKqFHZ/+XLabhuKJ2YBu
	 8FD0ndja9LmxE+lgYT3sGkfQSMq2wFZlMtDoLQV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 199/223] selftests/bpf: Fix raw_tp null handling test
Date: Wed, 23 Apr 2025 16:44:31 +0200
Message-ID: <20250423142625.276327128@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

Commit b2fc4b17fc13, backport of upstream commit 838a10bd2ebf ("bpf:
Augment raw_tp arguments with PTR_MAYBE_NULL"), was missing the changes
to tools/testing/selftests/bpf/progs/raw_tp_null.c, and cause the test
to fail with the following error (see link below for the complete log)

  Error: #205 raw_tp_null
  libbpf: prog 'test_raw_tp_null': BPF program load failed: Permission denied
  libbpf: prog 'test_raw_tp_null': -- BEGIN PROG LOAD LOG --
  0: R1=ctx() R10=fp0
  ; int BPF_PROG(test_raw_tp_null, struct sk_buff *skb) @ raw_tp_null.c:13
  0: (79) r6 = *(u64 *)(r1 +0)
  func 'bpf_testmod_test_raw_tp_null' arg0 has btf_id 2081 type STRUCT 'sk_buff'
  1: R1=ctx() R6_w=trusted_ptr_or_null_sk_buff(id=1)
  ; struct task_struct *task = bpf_get_current_task_btf(); @ raw_tp_null.c:15
  1: (85) call bpf_get_current_task_btf#158     ; R0_w=trusted_ptr_task_struct()
  ; if (task->pid != tid) @ raw_tp_null.c:17
  2: (61) r1 = *(u32 *)(r0 +1416)       ; R0_w=trusted_ptr_task_struct() R1_w=scalar(smin=0,smax=umax=0xffffffff,var_off=(0x0; 0xffffffff))
  3: (18) r2 = 0xffffa3bb801c6000       ; R2_w=map_value(map=raw_tp_n.bss,ks=4,vs=8)
  5: (61) r2 = *(u32 *)(r2 +0)          ; R2_w=scalar(smin=0,smax=umax=0xffffffff,var_off=(0x0; 0xffffffff))
  6: (5e) if w1 != w2 goto pc+11        ; R1_w=scalar(smin=0,smax=umax=0xffffffff,var_off=(0x0; 0xffffffff)) R2_w=scalar(smin=0,smax=umax=0xffffffff,var_off=(0x0; 0xffffffff))
  ; i = i + skb->mark + 1; @ raw_tp_null.c:20
  7: (61) r2 = *(u32 *)(r6 +164)
  R6 invalid mem access 'trusted_ptr_or_null_'
  processed 7 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
  -- END PROG LOAD LOG --
  libbpf: prog 'test_raw_tp_null': failed to load: -13
  libbpf: failed to load object 'raw_tp_null'
  libbpf: failed to load BPF skeleton 'raw_tp_null': -13
  test_raw_tp_null:FAIL:raw_tp_null__open_and_load unexpected error: -13

Bring the missing changes in to fix the test failure.

Link: https://github.com/shunghsiyu/libbpf/actions/runs/14522396622/job/40766998873
Fixes: b2fc4b17fc13 ("bpf: Augment raw_tp arguments with PTR_MAYBE_NULL")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/raw_tp_null.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/bpf/progs/raw_tp_null.c
+++ b/tools/testing/selftests/bpf/progs/raw_tp_null.c
@@ -3,6 +3,7 @@
 
 #include <vmlinux.h>
 #include <bpf/bpf_tracing.h>
+#include "bpf_misc.h"
 
 char _license[] SEC("license") = "GPL";
 
@@ -17,16 +18,14 @@ int BPF_PROG(test_raw_tp_null, struct sk
 	if (task->pid != tid)
 		return 0;
 
-	i = i + skb->mark + 1;
-	/* The compiler may move the NULL check before this deref, which causes
-	 * the load to fail as deref of scalar. Prevent that by using a barrier.
+	/* If dead code elimination kicks in, the increment +=2 will be
+	 * removed. For raw_tp programs attaching to tracepoints in kernel
+	 * modules, we mark input arguments as PTR_MAYBE_NULL, so branch
+	 * prediction should never kick in.
 	 */
-	barrier();
-	/* If dead code elimination kicks in, the increment below will
-	 * be removed. For raw_tp programs, we mark input arguments as
-	 * PTR_MAYBE_NULL, so branch prediction should never kick in.
-	 */
-	if (!skb)
-		i += 2;
+	asm volatile ("%[i] += 1; if %[ctx] != 0 goto +1; %[i] += 2;"
+			: [i]"+r"(i)
+			: [ctx]"r"(skb)
+			: "memory");
 	return 0;
 }


