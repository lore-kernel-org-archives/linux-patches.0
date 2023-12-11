Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4FF55766;
	Mon, 11 Dec 2023 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3XRvYky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A967EC433C7;
	Mon, 11 Dec 2023 18:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319690;
	bh=j1cD+Cw8P+z3iPPqGURt6dhxmwGfvSfMFarDAG1zyIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3XRvYkyFDW/z+3KU4pVSZHmgQ2CDxkdSVKYzUPfTZL9lpvB8x8KKYYhNL7OqOJHE
	 gULJX9tunJ6XzNZFdB8WYpCGCeMdRQv294uMNHxsWhAyLPuwgarYKuMX9TNlXcsQfM
	 DzpviSp+rpnpgIyogE7araPaK9xO75Uc1RGlKCWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/244] LoongArch: BPF: Dont sign extend memory load operand
Date: Mon, 11 Dec 2023 19:21:31 +0100
Message-ID: <20231211182054.830378771@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

[ Upstream commit fe5757553bf9ebe45ae8ecab5922f6937c8d8dfc ]

The `cgrp_local_storage` test triggers a kernel panic like:

  # ./test_progs -t cgrp_local_storage
  Can't find bpf_testmod.ko kernel module: -2
  WARNING! Selftests relying on bpf_testmod.ko will be skipped.
  [  550.930632] CPU 1 Unable to handle kernel paging request at virtual address 0000000000000080, era == ffff80000200be34, ra == ffff80000200be00
  [  550.931781] Oops[#1]:
  [  550.931966] CPU: 1 PID: 1303 Comm: test_progs Not tainted 6.7.0-rc2-loong-devel-g2f56bb0d2327 #35 a896aca3f4164f09cc346f89f2e09832e07be5f6
  [  550.932215] Hardware name: QEMU QEMU Virtual Machine, BIOS unknown 2/2/2022
  [  550.932403] pc ffff80000200be34 ra ffff80000200be00 tp 9000000108350000 sp 9000000108353dc0
  [  550.932545] a0 0000000000000000 a1 0000000000000517 a2 0000000000000118 a3 00007ffffbb15558
  [  550.932682] a4 00007ffffbb15620 a5 90000001004e7700 a6 0000000000000021 a7 0000000000000118
  [  550.932824] t0 ffff80000200bdc0 t1 0000000000000517 t2 0000000000000517 t3 00007ffff1c06ee0
  [  550.932961] t4 0000555578ae04d0 t5 fffffffffffffff8 t6 0000000000000004 t7 0000000000000020
  [  550.933097] t8 0000000000000040 u0 00000000000007b8 s9 9000000108353e00 s0 90000001004e7700
  [  550.933241] s1 9000000004005000 s2 0000000000000001 s3 0000000000000000 s4 0000555555eb2ec8
  [  550.933379] s5 00007ffffbb15bb8 s6 00007ffff1dafd60 s7 000055555663f610 s8 00007ffff1db0050
  [  550.933520]    ra: ffff80000200be00 bpf_prog_98f1b9e767be2a84_on_enter+0x40/0x200
  [  550.933911]   ERA: ffff80000200be34 bpf_prog_98f1b9e767be2a84_on_enter+0x74/0x200
  [  550.934105]  CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
  [  550.934596]  PRMD: 00000004 (PPLV0 +PIE -PWE)
  [  550.934712]  EUEN: 00000003 (+FPE +SXE -ASXE -BTE)
  [  550.934836]  ECFG: 00071c1c (LIE=2-4,10-12 VS=7)
  [  550.934976] ESTAT: 00010000 [PIL] (IS= ECode=1 EsubCode=0)
  [  550.935097]  BADV: 0000000000000080
  [  550.935181]  PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
  [  550.935291] Modules linked in:
  [  550.935391] Process test_progs (pid: 1303, threadinfo=000000006c3b1c41, task=0000000061f84a55)
  [  550.935643] Stack : 00007ffffbb15bb8 0000555555eb2ec8 0000000000000000 0000000000000001
  [  550.935844]         9000000004005000 ffff80001b864000 00007ffffbb15450 90000000029aa034
  [  550.935990]         0000000000000000 9000000108353ec0 0000000000000118 d07d9dfb09721a09
  [  550.936175]         0000000000000001 0000000000000000 9000000108353ec0 0000000000000118
  [  550.936314]         9000000101d46ad0 900000000290abf0 000055555663f610 0000000000000000
  [  550.936479]         0000000000000003 9000000108353ec0 00007ffffbb15450 90000000029d7288
  [  550.936635]         00007ffff1dafd60 000055555663f610 0000000000000000 0000000000000003
  [  550.936779]         9000000108353ec0 90000000035dd1f0 00007ffff1dafd58 9000000002841c5c
  [  550.936939]         0000000000000119 0000555555eea5a8 00007ffff1d78780 00007ffffbb153e0
  [  550.937083]         ffffffffffffffda 00007ffffbb15518 0000000000000040 00007ffffbb15558
  [  550.937224]         ...
  [  550.937299] Call Trace:
  [  550.937521] [<ffff80000200be34>] bpf_prog_98f1b9e767be2a84_on_enter+0x74/0x200
  [  550.937910] [<90000000029aa034>] bpf_trace_run2+0x90/0x154
  [  550.938105] [<900000000290abf0>] syscall_trace_enter.isra.0+0x1cc/0x200
  [  550.938224] [<90000000035dd1f0>] do_syscall+0x48/0x94
  [  550.938319] [<9000000002841c5c>] handle_syscall+0xbc/0x158
  [  550.938477]
  [  550.938607] Code: 580009ae  50016000  262402e4 <28c20085> 14092084  03a00084  16000024  03240084  00150006
  [  550.938851]
  [  550.939021] ---[ end trace 0000000000000000 ]---

Further investigation shows that this panic is triggered by memory
load operations:

  ptr = bpf_cgrp_storage_get(&map_a, task->cgroups->dfl_cgrp, 0,
                             BPF_LOCAL_STORAGE_GET_F_CREATE);

The expression `task->cgroups->dfl_cgrp` involves two memory load.
Since the field offset fits in imm12 or imm14, we use ldd or ldptrd
instructions. But both instructions have the side effect that it will
signed-extended the imm operand. Finally, we got the wrong addresses
and panics is inevitable.

Use a generic ldxd instruction to avoid this kind of issues.

With this change, we have:

  # ./test_progs -t cgrp_local_storage
  Can't find bpf_testmod.ko kernel module: -2
  WARNING! Selftests relying on bpf_testmod.ko will be skipped.
  test_cgrp_local_storage:PASS:join_cgroup /cgrp_local_storage 0 nsec
  #48/1    cgrp_local_storage/tp_btf:OK
  test_attach_cgroup:PASS:skel_open 0 nsec
  test_attach_cgroup:PASS:prog_attach 0 nsec
  test_attach_cgroup:PASS:prog_attach 0 nsec
  libbpf: prog 'update_cookie_tracing': failed to attach: ERROR: strerror_r(-524)=22
  test_attach_cgroup:FAIL:prog_attach unexpected error: -524
  #48/2    cgrp_local_storage/attach_cgroup:FAIL
  test_recursion:PASS:skel_open_and_load 0 nsec
  libbpf: prog 'on_lookup': failed to attach: ERROR: strerror_r(-524)=22
  libbpf: prog 'on_lookup': failed to auto-attach: -524
  test_recursion:FAIL:skel_attach unexpected error: -524 (errno 524)
  #48/3    cgrp_local_storage/recursion:FAIL
  #48/4    cgrp_local_storage/negative:OK
  #48/5    cgrp_local_storage/cgroup_iter_sleepable:OK
  test_yes_rcu_lock:PASS:skel_open 0 nsec
  test_yes_rcu_lock:PASS:skel_load 0 nsec
  libbpf: prog 'yes_rcu_lock': failed to attach: ERROR: strerror_r(-524)=22
  libbpf: prog 'yes_rcu_lock': failed to auto-attach: -524
  test_yes_rcu_lock:FAIL:skel_attach unexpected error: -524 (errno 524)
  #48/6    cgrp_local_storage/yes_rcu_lock:FAIL
  #48/7    cgrp_local_storage/no_rcu_lock:OK
  #48      cgrp_local_storage:FAIL

  All error logs:
  test_cgrp_local_storage:PASS:join_cgroup /cgrp_local_storage 0 nsec
  test_attach_cgroup:PASS:skel_open 0 nsec
  test_attach_cgroup:PASS:prog_attach 0 nsec
  test_attach_cgroup:PASS:prog_attach 0 nsec
  libbpf: prog 'update_cookie_tracing': failed to attach: ERROR: strerror_r(-524)=22
  test_attach_cgroup:FAIL:prog_attach unexpected error: -524
  #48/2    cgrp_local_storage/attach_cgroup:FAIL
  test_recursion:PASS:skel_open_and_load 0 nsec
  libbpf: prog 'on_lookup': failed to attach: ERROR: strerror_r(-524)=22
  libbpf: prog 'on_lookup': failed to auto-attach: -524
  test_recursion:FAIL:skel_attach unexpected error: -524 (errno 524)
  #48/3    cgrp_local_storage/recursion:FAIL
  test_yes_rcu_lock:PASS:skel_open 0 nsec
  test_yes_rcu_lock:PASS:skel_load 0 nsec
  libbpf: prog 'yes_rcu_lock': failed to attach: ERROR: strerror_r(-524)=22
  libbpf: prog 'yes_rcu_lock': failed to auto-attach: -524
  test_yes_rcu_lock:FAIL:skel_attach unexpected error: -524 (errno 524)
  #48/6    cgrp_local_storage/yes_rcu_lock:FAIL
  #48      cgrp_local_storage:FAIL
  Summary: 0/4 PASSED, 0 SKIPPED, 1 FAILED

No panics any more (The test still failed because lack of BPF trampoline
which I am actively working on).

Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index db9342b2d0e66..5d02bc6acec2e 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -907,14 +907,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			}
 			break;
 		case BPF_DW:
-			if (is_signed_imm12(off)) {
-				emit_insn(ctx, ldd, dst, src, off);
-			} else if (is_signed_imm14(off)) {
-				emit_insn(ctx, ldptrd, dst, src, off);
-			} else {
-				move_imm(ctx, t1, off, is32);
-				emit_insn(ctx, ldxd, dst, src, t1);
-			}
+			move_imm(ctx, t1, off, is32);
+			emit_insn(ctx, ldxd, dst, src, t1);
 			break;
 		}
 
-- 
2.42.0



