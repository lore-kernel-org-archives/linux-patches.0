Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27308339BE;
	Fri, 24 Nov 2023 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="io2tJ2nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EADBC433C8;
	Fri, 24 Nov 2023 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851974;
	bh=G099dHh1SHjM2CE0M0PPjujOmDX7la0ngG7khHwQnCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=io2tJ2nvQcLTNggGgv17JWic4ryirVDAo0cmtY9f8drxj/RVSfnx8jVWZTiMmed4X
	 cj+hf+ETa+R4CP4qrQMNiy2rcLaib7HZaFHpu2K4M4YiQuNlK2rAFTncN4+Lo779eK
	 JwUXiv0dT1siRSEbUyGEvqOdJdXWCZ7Sgga4NI5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 162/372] drivers: perf: Check find_first_bit() return value
Date: Fri, 24 Nov 2023 17:49:09 +0000
Message-ID: <20231124172015.883008311@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit c6e316ac05532febb0c966fa9b55f5258ed037be upstream.

We must check the return value of find_first_bit() before using the
return value as an index array since it happens to overflow the array
and then panic:

[  107.318430] Kernel BUG [#1]
[  107.319434] CPU: 3 PID: 1238 Comm: kill Tainted: G            E      6.6.0-rc6ubuntu-defconfig #2
[  107.319465] Hardware name: riscv-virtio,qemu (DT)
[  107.319551] epc : pmu_sbi_ovf_handler+0x3a4/0x3ae
[  107.319840]  ra : pmu_sbi_ovf_handler+0x52/0x3ae
[  107.319868] epc : ffffffff80a0a77c ra : ffffffff80a0a42a sp : ffffaf83fecda350
[  107.319884]  gp : ffffffff823961a8 tp : ffffaf8083db1dc0 t0 : ffffaf83fecda480
[  107.319899]  t1 : ffffffff80cafe62 t2 : 000000000000ff00 s0 : ffffaf83fecda520
[  107.319921]  s1 : ffffaf83fecda380 a0 : 00000018fca29df0 a1 : ffffffffffffffff
[  107.319936]  a2 : 0000000001073734 a3 : 0000000000000004 a4 : 0000000000000000
[  107.319951]  a5 : 0000000000000040 a6 : 000000001d1c8774 a7 : 0000000000504d55
[  107.319965]  s2 : ffffffff82451f10 s3 : ffffffff82724e70 s4 : 000000000000003f
[  107.319980]  s5 : 0000000000000011 s6 : ffffaf8083db27c0 s7 : 0000000000000000
[  107.319995]  s8 : 0000000000000001 s9 : 00007fffb45d6558 s10: 00007fffb45d81a0
[  107.320009]  s11: ffffaf7ffff60000 t3 : 0000000000000004 t4 : 0000000000000000
[  107.320023]  t5 : ffffaf7f80000000 t6 : ffffaf8000000000
[  107.320037] status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
[  107.320081] [<ffffffff80a0a77c>] pmu_sbi_ovf_handler+0x3a4/0x3ae
[  107.320112] [<ffffffff800b42d0>] handle_percpu_devid_irq+0x9e/0x1a0
[  107.320131] [<ffffffff800ad92c>] generic_handle_domain_irq+0x28/0x36
[  107.320148] [<ffffffff8065f9f8>] riscv_intc_irq+0x36/0x4e
[  107.320166] [<ffffffff80caf4a0>] handle_riscv_irq+0x54/0x86
[  107.320189] [<ffffffff80cb0036>] do_irq+0x64/0x96
[  107.320271] Code: 85a6 855e b097 ff7f 80e7 9220 b709 9002 4501 bbd9 (9002) 6097
[  107.320585] ---[ end trace 0000000000000000 ]---
[  107.320704] Kernel panic - not syncing: Fatal exception in interrupt
[  107.320775] SMP: stopping secondary CPUs
[  107.321219] Kernel Offset: 0x0 from 0xffffffff80000000
[  107.333051] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20231109082128.40777-1-alexghiti@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/riscv_pmu_sbi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -578,6 +578,11 @@ static irqreturn_t pmu_sbi_ovf_handler(i
 
 	/* Firmware counter don't support overflow yet */
 	fidx = find_first_bit(cpu_hw_evt->used_hw_ctrs, RISCV_MAX_COUNTERS);
+	if (fidx == RISCV_MAX_COUNTERS) {
+		csr_clear(CSR_SIP, BIT(riscv_pmu_irq_num));
+		return IRQ_NONE;
+	}
+
 	event = cpu_hw_evt->events[fidx];
 	if (!event) {
 		csr_clear(CSR_SIP, SIP_LCOFIP);


