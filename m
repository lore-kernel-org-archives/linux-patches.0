Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E741F64AB0;
	Tue, 23 Jan 2024 01:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975054; cv=none; b=gbOsdFfjBsxStjuHM4qkOcuNw8fEC7NVE69CWmT0ciM66IqpWsrx/H+GfgEvLtt8dE7TWFuAFg60yJKkmOh00rs8VUVhHfMrhAyQUBWXPmaMhAfRFCrPtks4kqS6oZc9TJXR/1K/7KYjP5a22j9/FceFt5DGk/CK1iT+OKfdQtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975054; c=relaxed/simple;
	bh=5r2z2HeRP/WhLTxa+enQC853bz6Go9lHd1MB8nLtN4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wad4lMpmqYOWpGYnhZ2G0rSVB5N4OIi7Ze1Smrfn/vGpuF/UWMJc4MF4q/ScGFsMJjo2oLMNGwUULq1FEl70BGoS5AwSGLhPu9lr8aJFvpgkfuUOUgqiEjrpNCYcQPmyD5jV+PSxtpuNLXxoGt48Xy5DQYSZDRoL7LAwSBIAJkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHMU7cdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHMU7cdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C60C433C7;
	Tue, 23 Jan 2024 01:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975053;
	bh=5r2z2HeRP/WhLTxa+enQC853bz6Go9lHd1MB8nLtN4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHMU7cdWCPmoNBn16ePcCp4LeScInkCm+0dU0UlJ/3m5l9g5pKxAx5hEG/R7/IEpY
	 mglHpnfCU6dZ0HwY9L9XxZ/uzr9AkaPNmGTi66ThbG4Ee4aki/9hk+ZcyqIz818p4Y
	 txnLA+bRWrBnfFlhiPyAWR0ADqTkG9uCZvwUlo1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/374] bpf: Reject variable offset alu on PTR_TO_FLOW_KEYS
Date: Mon, 22 Jan 2024 15:59:58 -0800
Message-ID: <20240122235756.819083650@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Sun <sunhao.th@gmail.com>

[ Upstream commit 22c7fa171a02d310e3a3f6ed46a698ca8a0060ed ]

For PTR_TO_FLOW_KEYS, check_flow_keys_access() only uses fixed off
for validation. However, variable offset ptr alu is not prohibited
for this ptr kind. So the variable offset is not checked.

The following prog is accepted:

  func#0 @0
  0: R1=ctx() R10=fp0
  0: (bf) r6 = r1                       ; R1=ctx() R6_w=ctx()
  1: (79) r7 = *(u64 *)(r6 +144)        ; R6_w=ctx() R7_w=flow_keys()
  2: (b7) r8 = 1024                     ; R8_w=1024
  3: (37) r8 /= 1                       ; R8_w=scalar()
  4: (57) r8 &= 1024                    ; R8_w=scalar(smin=smin32=0,
  smax=umax=smax32=umax32=1024,var_off=(0x0; 0x400))
  5: (0f) r7 += r8
  mark_precise: frame0: last_idx 5 first_idx 0 subseq_idx -1
  mark_precise: frame0: regs=r8 stack= before 4: (57) r8 &= 1024
  mark_precise: frame0: regs=r8 stack= before 3: (37) r8 /= 1
  mark_precise: frame0: regs=r8 stack= before 2: (b7) r8 = 1024
  6: R7_w=flow_keys(smin=smin32=0,smax=umax=smax32=umax32=1024,var_off
  =(0x0; 0x400)) R8_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=1024,
  var_off=(0x0; 0x400))
  6: (79) r0 = *(u64 *)(r7 +0)          ; R0_w=scalar()
  7: (95) exit

This prog loads flow_keys to r7, and adds the variable offset r8
to r7, and finally causes out-of-bounds access:

  BUG: unable to handle page fault for address: ffffc90014c80038
  [...]
  Call Trace:
   <TASK>
   bpf_dispatcher_nop_func include/linux/bpf.h:1231 [inline]
   __bpf_prog_run include/linux/filter.h:651 [inline]
   bpf_prog_run include/linux/filter.h:658 [inline]
   bpf_prog_run_pin_on_cpu include/linux/filter.h:675 [inline]
   bpf_flow_dissect+0x15f/0x350 net/core/flow_dissector.c:991
   bpf_prog_test_run_flow_dissector+0x39d/0x620 net/bpf/test_run.c:1359
   bpf_prog_test_run kernel/bpf/syscall.c:4107 [inline]
   __sys_bpf+0xf8f/0x4560 kernel/bpf/syscall.c:5475
   __do_sys_bpf kernel/bpf/syscall.c:5561 [inline]
   __se_sys_bpf kernel/bpf/syscall.c:5559 [inline]
   __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:5559
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0x3f/0x110 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x63/0x6b

Fix this by rejecting ptr alu with variable offset on flow_keys.
Applying the patch rejects the program with "R7 pointer arithmetic
on flow_keys prohibited".

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20240115082028.9992-1-sunhao.th@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c2ecf349523d..88a468cc0510 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7295,6 +7295,10 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	}
 
 	switch (base_type(ptr_reg->type)) {
+	case PTR_TO_FLOW_KEYS:
+		if (known)
+			break;
+		fallthrough;
 	case CONST_PTR_TO_MAP:
 		/* smin_val represents the known value */
 		if (known && smin_val == 0 && opcode == BPF_ADD)
-- 
2.43.0



