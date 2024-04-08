Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383CB7E59F;
	Mon,  8 Apr 2024 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583538; cv=none; b=HIHLiwjWRoWkUOHNlDQD72R1aEQqU1bIr4NB5YZnSmuT6D8JhFOK68AEJmXs7a4cvOBiDNWaBo6uvrRtR7ufPaPCLFNzZhhivktbknkvU9JMVoWPbog2bh0wUQNPCDAarVV3IoXZPVq9Pu6Mxw7SvWj15D0R1XBTdfUhdNph7Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583538; c=relaxed/simple;
	bh=1vHkyJmymOjHYBPjR5N81jgk4LF031+xjQmU/HpjmOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b81n+Rlo4CBBohMvV75A5X8bYdX2rZuda2zi7Xpd6KaXfQp+msmmUauZ7LaPKc6A8Af1kD9r0mRf7Z6AQckHKAkuj4bJftSNq5wX4/JFXWY968aJPLBc/O1uKeJ257gRSVKZmSpmefCs2mu78EbHjwywjxGSOJoDHM1rKbnTTPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l59vbWZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l59vbWZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB1CC433C7;
	Mon,  8 Apr 2024 13:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583538;
	bh=1vHkyJmymOjHYBPjR5N81jgk4LF031+xjQmU/HpjmOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l59vbWZyA0QkWVilsxelJVJDUDzRA5KOYRxGc3LLHfYauUbCElzth01m2F+z6UGQY
	 lKBL2c1s4lBe5Fu5OhVrTkcLMAbT4Yncl0XiucwaV3BXdGsuzJukhKvku8V9ANrG8S
	 4PSDfUEbtLryBFGFuU5oAKnbL7QYYekSbVDydpkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Shatokhin <e.shatokhin@yadro.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andy Chiu <andy.chiu@sifive.com>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 189/273] riscv: Fix warning by declaring arch_cpu_idle() as noinstr
Date: Mon,  8 Apr 2024 14:57:44 +0200
Message-ID: <20240408125315.160075198@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 8a48ea87ce89fb701624f4b9e82556c81f30c7dc ]

The following warning appears when using ftrace:

[89855.443413] RCU not on for: arch_cpu_idle+0x0/0x1c
[89855.445640] WARNING: CPU: 5 PID: 0 at include/linux/trace_recursion.h:162 arch_ftrace_ops_list_func+0x208/0x228
[89855.445824] Modules linked in: xt_conntrack(E) nft_chain_nat(E) xt_MASQUERADE(E) nf_conntrack_netlink(E) xt_addrtype(E) nft_compat(E) nf_tables(E) nfnetlink(E) br_netfilter(E) cfg80211(E) nls_iso8859_1(E) ofpart(E) redboot(E) cmdlinepart(E) cfi_cmdset_0001(E) virtio_net(E) cfi_probe(E) cfi_util(E) 9pnet_virtio(E) gen_probe(E) net_failover(E) virtio_rng(E) failover(E) 9pnet(E) physmap(E) map_funcs(E) chipreg(E) mtd(E) uio_pdrv_genirq(E) uio(E) dm_multipath(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) drm(E) efi_pstore(E) backlight(E) ip_tables(E) x_tables(E) raid10(E) raid456(E) async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E) xor(E) async_tx(E) raid6_pq(E) raid1(E) raid0(E) virtio_blk(E)
[89855.451563] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G            E      6.8.0-rc6ubuntu-defconfig #2
[89855.451726] Hardware name: riscv-virtio,qemu (DT)
[89855.451899] epc : arch_ftrace_ops_list_func+0x208/0x228
[89855.452016]  ra : arch_ftrace_ops_list_func+0x208/0x228
[89855.452119] epc : ffffffff8016b216 ra : ffffffff8016b216 sp : ffffaf808090fdb0
[89855.452171]  gp : ffffffff827c7680 tp : ffffaf808089ad40 t0 : ffffffff800c0dd8
[89855.452216]  t1 : 0000000000000001 t2 : 0000000000000000 s0 : ffffaf808090fe30
[89855.452306]  s1 : 0000000000000000 a0 : 0000000000000026 a1 : ffffffff82cd6ac8
[89855.452423]  a2 : ffffffff800458c8 a3 : ffffaf80b1870640 a4 : 0000000000000000
[89855.452646]  a5 : 0000000000000000 a6 : 00000000ffffffff a7 : ffffffffffffffff
[89855.452698]  s2 : ffffffff82766872 s3 : ffffffff80004caa s4 : ffffffff80ebea90
[89855.452743]  s5 : ffffaf808089bd40 s6 : 8000000a00006e00 s7 : 0000000000000008
[89855.452787]  s8 : 0000000000002000 s9 : 0000000080043700 s10: 0000000000000000
[89855.452831]  s11: 0000000000000000 t3 : 0000000000100000 t4 : 0000000000000064
[89855.452874]  t5 : 000000000000000c t6 : ffffaf80b182dbfc
[89855.452929] status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
[89855.453053] [<ffffffff8016b216>] arch_ftrace_ops_list_func+0x208/0x228
[89855.453191] [<ffffffff8000e082>] ftrace_call+0x8/0x22
[89855.453265] [<ffffffff800a149c>] do_idle+0x24c/0x2ca
[89855.453357] [<ffffffff8000da54>] return_to_handler+0x0/0x26
[89855.453429] [<ffffffff8000b716>] smp_callin+0x92/0xb6
[89855.453785] ---[ end trace 0000000000000000 ]---

To fix this, mark arch_cpu_idle() as noinstr, like it is done in commit
a9cbc1b471d2 ("s390/idle: mark arch_cpu_idle() noinstr").

Reported-by: Evgenii Shatokhin <e.shatokhin@yadro.com>
Closes: https://lore.kernel.org/linux-riscv/51f21b87-ebed-4411-afbc-c00d3dea2bab@yadro.com/
Fixes: cfbc4f81c9d0 ("riscv: Select ARCH_WANTS_NO_INSTR")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andy Chiu <andy.chiu@sifive.com>
Tested-by: Andy Chiu <andy.chiu@sifive.com>
Acked-by: Puranjay Mohan <puranjay12@gmail.com>
Link: https://lore.kernel.org/r/20240326203017.310422-2-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 92922dbd5b5c1..6abeecbfc51d0 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -37,7 +37,7 @@ EXPORT_SYMBOL(__stack_chk_guard);
 
 extern asmlinkage void ret_from_fork(void);
 
-void arch_cpu_idle(void)
+void noinstr arch_cpu_idle(void)
 {
 	cpu_do_idle();
 }
-- 
2.43.0



