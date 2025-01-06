Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB9113AD11;
	Mon,  6 Jan 2025 15:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178806; cv=none; b=tC4O2vxfHKfqMTzbPgl1SG/F/WWB6clgM0GmRq9KUr7Rv2U9/mjdLuer0GNibpr5QExh6+4o6k9vkFmgZm9P6O0BF30Usg9nf//bJi4XNOTuYI0Xg7+QkE0ZlklwH2B+06lv/K+vkIoDl0ojSEjt0k5Fq+ZIsH/QtHBmHW8y1pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178806; c=relaxed/simple;
	bh=zvX/N77nNMchI2DoUwbEKz/Rys6AivIX7Bbu4MruDME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auDcmeSCfaqSj8HCmRNjdqo++eOKjO3v5MNjjjvM50xJ3m+jkTmLRDTi0BW1UfRqARqeA+jebaZOyRz49F8z9EE3g0O/CUH21tzG7PvG0womRCyqN4k2mCRoJgKR7ICQZ4kLCgps9TMTwWgJFNOhnUkNukcgnLUDg8yc18lmZ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVNoW06C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVNoW06C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD33C4CED2;
	Mon,  6 Jan 2025 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178805;
	bh=zvX/N77nNMchI2DoUwbEKz/Rys6AivIX7Bbu4MruDME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVNoW06CvVE1nprfsiH0mL/nqos1MmDWNl8hO2O+wH67l1QbWBbYUlJgmPfHuiQ1z
	 N6woEGb8/5gqbbYSuAiGZ3PvQl+ICMrJWX6B/Nvb/Zwx7Gd5dF6iSaqQfGVwClI/Pt
	 Oi/gy9VhVsgfB5D+mrOHhJr8wgAB4k/f6LUhJHrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/168] riscv: Fix IPIs usage in kfence_protect_page()
Date: Mon,  6 Jan 2025 16:16:45 +0100
Message-ID: <20250106151142.127570645@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit b3431a8bb336cece8adc452437befa7d4534b2fd ]

flush_tlb_kernel_range() may use IPIs to flush the TLBs of all the
cores, which triggers the following warning when the irqs are disabled:

[    3.455330] WARNING: CPU: 1 PID: 0 at kernel/smp.c:815 smp_call_function_many_cond+0x452/0x520
[    3.456647] Modules linked in:
[    3.457218] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 6.12.0-rc7-00010-g91d3de7240b8 #1
[    3.457416] Hardware name: QEMU QEMU Virtual Machine, BIOS
[    3.457633] epc : smp_call_function_many_cond+0x452/0x520
[    3.457736]  ra : on_each_cpu_cond_mask+0x1e/0x30
[    3.457786] epc : ffffffff800b669a ra : ffffffff800b67c2 sp : ff2000000000bb50
[    3.457824]  gp : ffffffff815212b8 tp : ff6000008014f080 t0 : 000000000000003f
[    3.457859]  t1 : ffffffff815221e0 t2 : 000000000000000f s0 : ff2000000000bc10
[    3.457920]  s1 : 0000000000000040 a0 : ffffffff815221e0 a1 : 0000000000000001
[    3.457953]  a2 : 0000000000010000 a3 : 0000000000000003 a4 : 0000000000000000
[    3.458006]  a5 : 0000000000000000 a6 : ffffffffffffffff a7 : 0000000000000000
[    3.458042]  s2 : ffffffff815223be s3 : 00fffffffffff000 s4 : ff600001ffe38fc0
[    3.458076]  s5 : ff600001ff950d00 s6 : 0000000200000120 s7 : 0000000000000001
[    3.458109]  s8 : 0000000000000001 s9 : ff60000080841ef0 s10: 0000000000000001
[    3.458141]  s11: ffffffff81524812 t3 : 0000000000000001 t4 : ff60000080092bc0
[    3.458172]  t5 : 0000000000000000 t6 : ff200000000236d0
[    3.458203] status: 0000000200000100 badaddr: ffffffff800b669a cause: 0000000000000003
[    3.458373] [<ffffffff800b669a>] smp_call_function_many_cond+0x452/0x520
[    3.458593] [<ffffffff800b67c2>] on_each_cpu_cond_mask+0x1e/0x30
[    3.458625] [<ffffffff8000e4ca>] __flush_tlb_range+0x118/0x1ca
[    3.458656] [<ffffffff8000e6b2>] flush_tlb_kernel_range+0x1e/0x26
[    3.458683] [<ffffffff801ea56a>] kfence_protect+0xc0/0xce
[    3.458717] [<ffffffff801e9456>] kfence_guarded_free+0xc6/0x1c0
[    3.458742] [<ffffffff801e9d6c>] __kfence_free+0x62/0xc6
[    3.458764] [<ffffffff801c57d8>] kfree+0x106/0x32c
[    3.458786] [<ffffffff80588cf2>] detach_buf_split+0x188/0x1a8
[    3.458816] [<ffffffff8058708c>] virtqueue_get_buf_ctx+0xb6/0x1f6
[    3.458839] [<ffffffff805871da>] virtqueue_get_buf+0xe/0x16
[    3.458880] [<ffffffff80613d6a>] virtblk_done+0x5c/0xe2
[    3.458908] [<ffffffff8058766e>] vring_interrupt+0x6a/0x74
[    3.458930] [<ffffffff800747d8>] __handle_irq_event_percpu+0x7c/0xe2
[    3.458956] [<ffffffff800748f0>] handle_irq_event+0x3c/0x86
[    3.458978] [<ffffffff800786cc>] handle_simple_irq+0x9e/0xbe
[    3.459004] [<ffffffff80073934>] generic_handle_domain_irq+0x1c/0x2a
[    3.459027] [<ffffffff804bf87c>] imsic_handle_irq+0xba/0x120
[    3.459056] [<ffffffff80073934>] generic_handle_domain_irq+0x1c/0x2a
[    3.459080] [<ffffffff804bdb76>] riscv_intc_aia_irq+0x24/0x34
[    3.459103] [<ffffffff809d0452>] handle_riscv_irq+0x2e/0x4c
[    3.459133] [<ffffffff809d923e>] call_on_irq_stack+0x32/0x40

So only flush the local TLB and let the lazy kfence page fault handling
deal with the faults which could happen when a core has an old protected
pte version cached in its TLB. That leads to potential inaccuracies which
can be tolerated when using kfence.

Fixes: 47513f243b45 ("riscv: Enable KFENCE for riscv64")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241209074125.52322-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/kfence.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kfence.h b/arch/riscv/include/asm/kfence.h
index d887a54042aa..5d013dc52c0b 100644
--- a/arch/riscv/include/asm/kfence.h
+++ b/arch/riscv/include/asm/kfence.h
@@ -55,7 +55,9 @@ static inline bool kfence_protect_page(unsigned long addr, bool protect)
 	else
 		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
 
-	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+	preempt_disable();
+	local_flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+	preempt_enable();
 
 	return true;
 }
-- 
2.39.5



