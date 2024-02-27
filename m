Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4117B78B61;
	Tue, 27 Feb 2024 13:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041978; cv=none; b=ccbD0facaL3wKV4SeYfoL9abQUDrVqUuPAz8URMYWosPuCBLRaoP13CEAffJ8DPEoSO4apqElaJNf0nxnn5RegRt0qU3mzM5NlLn7r2cSd8mZ1hO4hgye9O5mGl/YcXvRLRDgwUNalZ7hF1Whraavso2eIrbntAWFutgFwR2jEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041978; c=relaxed/simple;
	bh=7PB32glldZzrlXTO5mold36Utbvz4bYXzGBFlUkE+3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IId31w+w8timYlEAvpCBYf0cvwTr08VDbz2hwWOG8WKSbVe7M1701X/QRqZkGUJ0oKLpQXmssQRU7Njq7eV58/3NpMIsH1pvx5z86mXI25GgxhB9fS6WT7hRrqVc18mtpPMWoTmV896frdA9MuFbbzDINvPcI/EO/Pfulnuj6CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcEP5V4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcEP5V4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1DEC433C7;
	Tue, 27 Feb 2024 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041978;
	bh=7PB32glldZzrlXTO5mold36Utbvz4bYXzGBFlUkE+3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcEP5V4tt9kbJCbSwT67PLBqAAXOg5RzlKBZMeiO4+xjBUwm8GCPR4rmNsVI9U2rv
	 wZ5Kele3Pw/zDbRMf1OJVEQdmgFnAuIT1Vf+oGMUhz+U0ko3LOO2OZwcU+K61xrl70
	 aejoecdB3gUqf5Owq4ih1b6vMBwCh2M/e4em1wGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 137/299] LoongArch: Disable IRQ before init_fn() for nonboot CPUs
Date: Tue, 27 Feb 2024 14:24:08 +0100
Message-ID: <20240227131630.267344867@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 1001db6c42e4012b55e5ee19405490f23e033b5a upstream.

Disable IRQ before init_fn() for nonboot CPUs when hotplug, in order to
silence such warnings (and also avoid potential errors due to unexpected
interrupts):

WARNING: CPU: 1 PID: 0 at kernel/rcu/tree.c:4503 rcu_cpu_starting+0x214/0x280
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.6.17+ #1198
pc 90000000048e3334 ra 90000000047bd56c tp 900000010039c000 sp 900000010039fdd0
a0 0000000000000001 a1 0000000000000006 a2 900000000802c040 a3 0000000000000000
a4 0000000000000001 a5 0000000000000004 a6 0000000000000000 a7 90000000048e3f4c
t0 0000000000000001 t1 9000000005c70968 t2 0000000004000000 t3 000000000005e56e
t4 00000000000002e4 t5 0000000000001000 t6 ffffffff80000000 t7 0000000000040000
t8 9000000007931638 u0 0000000000000006 s9 0000000000000004 s0 0000000000000001
s1 9000000006356ac0 s2 9000000007244000 s3 0000000000000001 s4 0000000000000001
s5 900000000636f000 s6 7fffffffffffffff s7 9000000002123940 s8 9000000001ca55f8
   ra: 90000000047bd56c tlb_init+0x24c/0x528
  ERA: 90000000048e3334 rcu_cpu_starting+0x214/0x280
 CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
 PRMD: 00000000 (PPLV0 -PIE -PWE)
 EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
 ECFG: 00071000 (LIE=12 VS=7)
ESTAT: 000c0000 [BRK] (IS= ECode=12 EsubCode=0)
 PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.6.17+ #1198
Stack : 0000000000000000 9000000006375000 9000000005b61878 900000010039c000
        900000010039fa30 0000000000000000 900000010039fa38 900000000619a140
        9000000006456888 9000000006456880 900000010039f950 0000000000000001
        0000000000000001 cb0cb028ec7e52e1 0000000002b90000 9000000100348700
        0000000000000000 0000000000000001 ffffffff916d12f1 0000000000000003
        0000000000040000 9000000007930370 0000000002b90000 0000000000000004
        9000000006366000 900000000619a140 0000000000000000 0000000000000004
        0000000000000000 0000000000000009 ffffffffffc681f2 9000000002123940
        9000000001ca55f8 9000000006366000 90000000047a4828 00007ffff057ded8
        00000000000000b0 0000000000000000 0000000000000000 0000000000071000
        ...
Call Trace:
[<90000000047a4828>] show_stack+0x48/0x1a0
[<9000000005b61874>] dump_stack_lvl+0x84/0xcc
[<90000000047f60ac>] __warn+0x8c/0x1e0
[<9000000005b0ab34>] report_bug+0x1b4/0x280
[<9000000005b63110>] do_bp+0x2d0/0x480
[<90000000047a2e20>] handle_bp+0x120/0x1c0
[<90000000048e3334>] rcu_cpu_starting+0x214/0x280
[<90000000047bd568>] tlb_init+0x248/0x528
[<90000000047a4c44>] per_cpu_trap_init+0x124/0x160
[<90000000047a19f4>] cpu_probe+0x494/0xa00
[<90000000047b551c>] start_secondary+0x3c/0xc0
[<9000000005b66134>] smpboot_entry+0x50/0x58

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/smp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -334,6 +334,7 @@ void __noreturn arch_cpu_idle_dead(void)
 		addr = iocsr_read64(LOONGARCH_IOCSR_MBUF0);
 	} while (addr == 0);
 
+	local_irq_disable();
 	init_fn = (void *)TO_CACHE(addr);
 	iocsr_write32(0xffffffff, LOONGARCH_IOCSR_IPI_CLEAR);
 


