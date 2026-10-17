Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0323AEF3F;
	Sat, 17 Oct 2026 17:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258012; cv=none; b=R5/W+fJ0+8s0XZvJ6ixSnTEgJfxRl3XyZnjCN1J0yL+8qNVPWwhmmiRGit/bsHNEKNt5EOXM/bX1U3iZxu2lZAvws7nTVV28+skBFZ/cWZTT0LD5tkbBnIU2BVELXvm7qF+QUjeqx3f35Kh239e5lg7P49MC/FLYr5llgxNvvkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258012; c=relaxed/simple;
	bh=yuXjYUgZ0/wSFip+Du0yAFmeK8UNSWt3iz8GrZFbUBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lh/Ryjz5u8Nmto8j0wqrXo46Dmseg0L+7FA5n+m+bFUXwMhz/x76aKyOgHp9HmG2Bn1UekO6U8YvckLET4T3YQeheLnWEhOYhOnN+HO6mwaYssxC3TN1Up+MNDPM5+6s/4L20dSFZuI7n2IZ2jcIlE9YFlg0Ywysm/rRR8tbIXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vre0KP+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vre0KP+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A0B1F000C4;
	Sat, 17 Oct 2026 17:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258011;
	bh=3iGre0dFjbwd8av/7dQYmvYJO/C5gTX9UIrzI7KRCmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vre0KP+6Xiz2n6fZrVoAWYWuh2AAhMc7sLkINEsru+MpkWOy9an5XDuUBsAOXFpDM
	 y1hET3D4X1NOXJdt1XeRvZCNxCcjiU8tiSMWXv06bxJ/O9EY+RtQDnoUVp6llMEIiI
	 Z8CwG49vrQ5n0UmVEKrgY/2PgYipCxeJZeu0VNio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0706/1674] RISC-V: KVM: Teardown riscv specific bits after kvm_exit
Date: Sat, 17 Oct 2026 17:49:38 +0200
Message-ID: <20261017160449.228645821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atish Patra <atishp@rivosinc.com>

[ Upstream commit 2d117e67f318303f6ab699a5511d1fac3f170545 ]

During a module removal, kvm_exit invokes arch specific disable
call which disables AIA. However, we invoke aia_exit before kvm_exit
resulting in the following warning. KVM kernel module can't be inserted
afterwards due to inconsistent state of IRQ.

[25469.031389] percpu IRQ 31 still enabled on CPU0!
[25469.031732] WARNING: CPU: 3 PID: 943 at kernel/irq/manage.c:2476 __free_percpu_irq+0xa2/0x150
[25469.031804] Modules linked in: kvm(-)
[25469.031848] CPU: 3 UID: 0 PID: 943 Comm: rmmod Not tainted 6.14.0-rc5-06947-g91c763118f47-dirty #2
[25469.031905] Hardware name: riscv-virtio,qemu (DT)
[25469.031928] epc : __free_percpu_irq+0xa2/0x150
[25469.031976]  ra : __free_percpu_irq+0xa2/0x150
[25469.032197] epc : ffffffff8007db1e ra : ffffffff8007db1e sp : ff2000000088bd50
[25469.032241]  gp : ffffffff8131cef8 tp : ff60000080b96400 t0 : ff2000000088baf8
[25469.032285]  t1 : fffffffffffffffc t2 : 5249207570637265 s0 : ff2000000088bd90
[25469.032329]  s1 : ff60000098b21080 a0 : 037d527a15eb4f00 a1 : 037d527a15eb4f00
[25469.032372]  a2 : 0000000000000023 a3 : 0000000000000001 a4 : ffffffff8122dbf8
[25469.032410]  a5 : 0000000000000fff a6 : 0000000000000000 a7 : ffffffff8122dc10
[25469.032448]  s2 : ff60000080c22eb0 s3 : 0000000200000022 s4 : 000000000000001f
[25469.032488]  s5 : ff60000080c22e00 s6 : ffffffff80c351c0 s7 : 0000000000000000
[25469.032582]  s8 : 0000000000000003 s9 : 000055556b7fb490 s10: 00007ffff0e12fa0
[25469.032621]  s11: 00007ffff0e13e9a t3 : ffffffff81354ac7 t4 : ffffffff81354ac7
[25469.032664]  t5 : ffffffff81354ac8 t6 : ffffffff81354ac7
[25469.032698] status: 0000000200000100 badaddr: ffffffff8007db1e cause: 0000000000000003
[25469.032738] [<ffffffff8007db1e>] __free_percpu_irq+0xa2/0x150
[25469.032797] [<ffffffff8007dbfc>] free_percpu_irq+0x30/0x5e
[25469.032856] [<ffffffff013a57dc>] kvm_riscv_aia_exit+0x40/0x42 [kvm]
[25469.033947] [<ffffffff013b4e82>] cleanup_module+0x10/0x32 [kvm]
[25469.035300] [<ffffffff8009b150>] __riscv_sys_delete_module+0x18e/0x1fc
[25469.035374] [<ffffffff8000c1ca>] syscall_handler+0x3a/0x46
[25469.035456] [<ffffffff809ec9a4>] do_trap_ecall_u+0x72/0x134
[25469.035536] [<ffffffff809f5e18>] handle_exception+0x148/0x156

Invoke aia_exit and other arch specific cleanup functions after kvm_exit
so that disable gets a chance to be called first before exit.

Fixes: 54e43320c2ba ("RISC-V: KVM: Initial skeletal support for AIA")
Fixes: eded6754f398 ("riscv: KVM: add basic support for host vs guest profiling")
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250317-kvm_exit_fix-v1-1-aa5240c5dbd2@rivosinc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 48ae0d4b39324..4c03be3038756 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -131,8 +131,8 @@ module_init(riscv_kvm_init);
 
 static void __exit riscv_kvm_exit(void)
 {
-	kvm_riscv_aia_exit();
-
 	kvm_exit();
+
+	kvm_riscv_aia_exit();
 }
 module_exit(riscv_kvm_exit);
-- 
2.53.0



