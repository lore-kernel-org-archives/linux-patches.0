Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDF6313550;
	Thu, 28 May 2026 20:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000422; cv=none; b=nJftX7Nm9vpzx8TKAtCNs1tz4J1hRPlZEa00fxkWbSLI5y7pBx5HBIac4V59DP9G0KpK1vDXev8Xh2OKiJryIss7NJiHVvv0HCgTOvT4jSm1PEXtlcVrdh22xdstmvXHKYHMHlFjGf4cUAcyqfsHbG2408VZViF+MawOKFM17dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000422; c=relaxed/simple;
	bh=LmdadW29mgFb2XF3Dnm3Iq41pTkvaqUxO5VgdcQLd60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpQN4RIB5y6Wv0im2XEeircNlBKWJ6x7jwQd5eOfiSjz5J+Gxu9C4NSckPRT11WhCn1XtJipvrcw7Mb03azlPYmuBY9pRqCBveze/W56nn4kfnl1dYFxbC0sYlAAaamoXm6kzATOFAUcxp+/EkCzoSvOreIgc0nlx0q/cj4YQEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9zR6L2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9zR6L2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DE21F000E9;
	Thu, 28 May 2026 20:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000421;
	bh=uiJdDZ9kZK2ol57u5dqaZ9jZCTqLkjSGk13/xCt4aiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9zR6L2xeccEEytjXtSPSaZphN2RGKO3zzcCv4CDnI/0zbY3NS+2ebOqgquNuxrn+
	 +M3hVGQtb0TaH78z+oW9uQewd74zj/PN2Nu6+0AsFHbmiI756q/FlX0khgABtl7TI1
	 qYgWppXqIThstrQvcsx4Gji/nJSCur0Ifa4KaGJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Pu Lehui <pulehui@huawei.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Gyokhan Kochmarla <gyokhan@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/272] riscv: fgraph: Fix stack layout to match __arch_ftrace_regs argument of ftrace_return_to_handler
Date: Thu, 28 May 2026 21:46:52 +0200
Message-ID: <20260528194630.451178441@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

commit 67a5ba8f742f247bc83e46dd2313c142b1383276 upstream.

Naresh Kamboju reported a "Bad frame pointer" kernel warning while
running LTP trace ftrace_stress_test.sh in riscv. We can reproduce the
same issue with the following command:

```
$ cd /sys/kernel/debug/tracing
$ echo 'f:myprobe do_nanosleep%return args1=$retval' > dynamic_events
$ echo 1 > events/fprobes/enable
$ echo 1 > tracing_on
$ sleep 1
```

And we can get the following kernel warning:

[  127.692888] ------------[ cut here ]------------
[  127.693755] Bad frame pointer: expected ff2000000065be50, received ba34c141e9594000
[  127.693755]   from func do_nanosleep return to ffffffff800ccb16
[  127.698699] WARNING: CPU: 1 PID: 129 at kernel/trace/fgraph.c:755 ftrace_return_to_handler+0x1b2/0x1be
[  127.699894] Modules linked in:
[  127.700908] CPU: 1 UID: 0 PID: 129 Comm: sleep Not tainted 6.14.0-rc3-g0ab191c74642 #32
[  127.701453] Hardware name: riscv-virtio,qemu (DT)
[  127.701859] epc : ftrace_return_to_handler+0x1b2/0x1be
[  127.702032]  ra : ftrace_return_to_handler+0x1b2/0x1be
[  127.702151] epc : ffffffff8013b5e0 ra : ffffffff8013b5e0 sp : ff2000000065bd10
[  127.702221]  gp : ffffffff819c12f8 tp : ff60000080853100 t0 : 6e00000000000000
[  127.702284]  t1 : 0000000000000020 t2 : 6e7566206d6f7266 s0 : ff2000000065bd80
[  127.702346]  s1 : ff60000081262000 a0 : 000000000000007b a1 : ffffffff81894f20
[  127.702408]  a2 : 0000000000000010 a3 : fffffffffffffffe a4 : 0000000000000000
[  127.702470]  a5 : 0000000000000000 a6 : 0000000000000008 a7 : 0000000000000038
[  127.702530]  s2 : ba34c141e9594000 s3 : 0000000000000000 s4 : ff2000000065bdd0
[  127.702591]  s5 : 00007fff8adcf400 s6 : 000055556dc1d8c0 s7 : 0000000000000068
[  127.702651]  s8 : 00007fff8adf5d10 s9 : 000000000000006d s10: 0000000000000001
[  127.702710]  s11: 00005555737377c8 t3 : ffffffff819d899e t4 : ffffffff819d899e
[  127.702769]  t5 : ffffffff819d89a0 t6 : ff2000000065bb18
[  127.702826] status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
[  127.703292] [<ffffffff8013b5e0>] ftrace_return_to_handler+0x1b2/0x1be
[  127.703760] [<ffffffff80017bce>] return_to_handler+0x16/0x26
[  127.704009] [<ffffffff80017bb8>] return_to_handler+0x0/0x26
[  127.704057] [<ffffffff800d3352>] common_nsleep+0x42/0x54
[  127.704117] [<ffffffff800d44a2>] __riscv_sys_clock_nanosleep+0xba/0x10a
[  127.704176] [<ffffffff80901c56>] do_trap_ecall_u+0x188/0x218
[  127.704295] [<ffffffff8090cc3e>] handle_exception+0x14a/0x156
[  127.705436] ---[ end trace 0000000000000000 ]---

The reason is that the stack layout for constructing argument for the
ftrace_return_to_handler in the return_to_handler does not match the
__arch_ftrace_regs structure of riscv, leading to unexpected results.

Fixes: a3ed4157b7d8 ("fgraph: Replace fgraph_ret_regs with ftrace_regs")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/all/CA+G9fYvp_oAxeDFj88Tk2rfEZ7jtYKAKSwfYS66=57Db9TBdyA@mail.gmail.com
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20250317031214.4138436-2-pulehui@huaweicloud.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/mcount.S | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/kernel/mcount.S b/arch/riscv/kernel/mcount.S
index 068168046e0ef..da4a4000e57ea 100644
--- a/arch/riscv/kernel/mcount.S
+++ b/arch/riscv/kernel/mcount.S
@@ -12,8 +12,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/ftrace.h>
 
-#define ABI_SIZE_ON_STACK	80
-
 	.text
 
 	.macro SAVE_ABI_STATE
@@ -28,12 +26,12 @@
 	 * register if a0 was not saved.
 	 */
 	.macro SAVE_RET_ABI_STATE
-	addi	sp, sp, -ABI_SIZE_ON_STACK
-	REG_S	ra, 1*SZREG(sp)
-	REG_S	s0, 8*SZREG(sp)
-	REG_S	a0, 10*SZREG(sp)
-	REG_S	a1, 11*SZREG(sp)
-	addi	s0, sp, ABI_SIZE_ON_STACK
+	addi	sp, sp, -FREGS_SIZE_ON_STACK
+	REG_S	ra, FREGS_RA(sp)
+	REG_S	s0, FREGS_S0(sp)
+	REG_S	a0, FREGS_A0(sp)
+	REG_S	a1, FREGS_A1(sp)
+	addi	s0, sp, FREGS_SIZE_ON_STACK
 	.endm
 
 	.macro RESTORE_ABI_STATE
@@ -43,11 +41,11 @@
 	.endm
 
 	.macro RESTORE_RET_ABI_STATE
-	REG_L	ra, 1*SZREG(sp)
-	REG_L	s0, 8*SZREG(sp)
-	REG_L	a0, 10*SZREG(sp)
-	REG_L	a1, 11*SZREG(sp)
-	addi	sp, sp, ABI_SIZE_ON_STACK
+	REG_L	ra, FREGS_RA(sp)
+	REG_L	s0, FREGS_S0(sp)
+	REG_L	a0, FREGS_A0(sp)
+	REG_L	a1, FREGS_A1(sp)
+	addi	sp, sp, FREGS_SIZE_ON_STACK
 	.endm
 
 SYM_TYPED_FUNC_START(ftrace_stub)
-- 
2.53.0



