Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA781FC0F3;
	Tue,  8 Jul 2025 16:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993196; cv=none; b=ApGSwKe6lW27WLBk7ZOVRDBr1e8D7mXKJDn3CzfsDdNyR5xWDqB8QkPsf5oueoWmDOcqh1HVv1PQQw1tC9bJYbTPA5xUMUTm97uaVSEG1SrF0YwP5tsvmmNUEwDWUwBIXbTUMaGF9xfDmPLTgNGHgqbUgA9Jwdhkn7RFmp7dr4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993196; c=relaxed/simple;
	bh=MinnXOqRHscRa/kaj7h6/hjWYHoGYZV3ia8KmmnsRB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkKJuIpoyMJNg8Q5shLGEfi6IZ4rQockPZ0Bv6OJCM9cGpR5gmwBo5CuieAet5UBFNt6V0Dakvgk0sToUd/cUJv26XnSaQSUYzLg6oNYOeGTc3nDJ/rd7oqCd5uJPkwJ/NnsdM2fhU8iYqCcXWVBNQaZEOzys7okw8nbjkSz8/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5z1PyWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5z1PyWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD5FC4CEED;
	Tue,  8 Jul 2025 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993195;
	bh=MinnXOqRHscRa/kaj7h6/hjWYHoGYZV3ia8KmmnsRB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5z1PyWO8iqVGzWCdKM12taa+gn/jD0YQvGGxu/y5AcVW+YvM9cYP9mnHJuuHrvbH
	 vIbfxukY7aCzyCbGbgEJbCYepNgIC4FkfOY6FFg07Dx4flAZkgUvnUctWaOeB2N77r
	 2i2GoF6RJ76vf9SWXyeo5Pvpotq8gpG7EFoeZkYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <rabenda.cn@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>
Subject: [PATCH 6.12 220/232] riscv: cpu_ops_sbi: Use static array for boot_data
Date: Tue,  8 Jul 2025 18:23:36 +0200
Message-ID: <20250708162247.191578475@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit 2b29be967ae456fc09c320d91d52278cf721be1e upstream.

Since commit 6b9f29b81b15 ("riscv: Enable pcpu page first chunk
allocator"), if NUMA is enabled, the page percpu allocator may be used
on very sparse configurations, or when requested on boot with
percpu_alloc=page.

In that case, percpu data gets put in the vmalloc area. However,
sbi_hsm_hart_start() needs the physical address of a sbi_hart_boot_data,
and simply assumes that __pa() would work. This causes the just started
hart to immediately access an invalid address and hang.

Fortunately, struct sbi_hart_boot_data is not too large, so we can
simply allocate an array for boot_data statically, putting it in the
kernel image.

This fixes NUMA=y SMP boot on Sophgo SG2042.

To reproduce on QEMU: Set CONFIG_NUMA=y and CONFIG_DEBUG_VIRTUAL=y, then
run with:

  qemu-system-riscv64 -M virt -smp 2 -nographic \
    -kernel arch/riscv/boot/Image \
    -append "percpu_alloc=page"

Kernel output:

[    0.000000] Booting Linux on hartid 0
[    0.000000] Linux version 6.16.0-rc1 (dram@sakuya) (riscv64-unknown-linux-gnu-gcc (GCC) 14.2.1 20250322, GNU ld (GNU Binutils) 2.44) #11 SMP Tue Jun 24 14:56:22 CST 2025
...
[    0.000000] percpu: 28 4K pages/cpu s85784 r8192 d20712
...
[    0.083192] smp: Bringing up secondary CPUs ...
[    0.086722] ------------[ cut here ]------------
[    0.086849] virt_to_phys used for non-linear address: (____ptrval____) (0xff2000000001d080)
[    0.088001] WARNING: CPU: 0 PID: 1 at arch/riscv/mm/physaddr.c:14 __virt_to_phys+0xae/0xe8
[    0.088376] Modules linked in:
[    0.088656] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.16.0-rc1 #11 NONE
[    0.088833] Hardware name: riscv-virtio,qemu (DT)
[    0.088948] epc : __virt_to_phys+0xae/0xe8
[    0.089001]  ra : __virt_to_phys+0xae/0xe8
[    0.089037] epc : ffffffff80021eaa ra : ffffffff80021eaa sp : ff2000000004bbc0
[    0.089057]  gp : ffffffff817f49c0 tp : ff60000001d60000 t0 : 5f6f745f74726976
[    0.089076]  t1 : 0000000000000076 t2 : 705f6f745f747269 s0 : ff2000000004bbe0
[    0.089095]  s1 : ff2000000001d080 a0 : 0000000000000000 a1 : 0000000000000000
[    0.089113]  a2 : 0000000000000000 a3 : 0000000000000000 a4 : 0000000000000000
[    0.089131]  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000000
[    0.089155]  s2 : ffffffff8130dc00 s3 : 0000000000000001 s4 : 0000000000000001
[    0.089174]  s5 : ffffffff8185eff8 s6 : ff2000007f1eb000 s7 : ffffffff8002a2ec
[    0.089193]  s8 : 0000000000000001 s9 : 0000000000000001 s10: 0000000000000000
[    0.089211]  s11: 0000000000000000 t3 : ffffffff8180a9f7 t4 : ffffffff8180a9f7
[    0.089960]  t5 : ffffffff8180a9f8 t6 : ff2000000004b9d8
[    0.089984] status: 0000000200000120 badaddr: ffffffff80021eaa cause: 0000000000000003
[    0.090101] [<ffffffff80021eaa>] __virt_to_phys+0xae/0xe8
[    0.090228] [<ffffffff8001d796>] sbi_cpu_start+0x6e/0xe8
[    0.090247] [<ffffffff8001a5da>] __cpu_up+0x1e/0x8c
[    0.090260] [<ffffffff8002a32e>] bringup_cpu+0x42/0x258
[    0.090277] [<ffffffff8002914c>] cpuhp_invoke_callback+0xe0/0x40c
[    0.090292] [<ffffffff800294e0>] __cpuhp_invoke_callback_range+0x68/0xfc
[    0.090320] [<ffffffff8002a96a>] _cpu_up+0x11a/0x244
[    0.090334] [<ffffffff8002aae6>] cpu_up+0x52/0x90
[    0.090384] [<ffffffff80c09350>] bringup_nonboot_cpus+0x78/0x118
[    0.090411] [<ffffffff80c11060>] smp_init+0x34/0xb8
[    0.090425] [<ffffffff80c01220>] kernel_init_freeable+0x148/0x2e4
[    0.090442] [<ffffffff80b83802>] kernel_init+0x1e/0x14c
[    0.090455] [<ffffffff800124ca>] ret_from_fork_kernel+0xe/0xf0
[    0.090471] [<ffffffff80b8d9c2>] ret_from_fork_kernel_asm+0x16/0x18
[    0.090560] ---[ end trace 0000000000000000 ]---
[    1.179875] CPU1: failed to come online
[    1.190324] smp: Brought up 1 node, 1 CPU

Cc: stable@vger.kernel.org
Reported-by: Han Gao <rabenda.cn@gmail.com>
Fixes: 6b9f29b81b15 ("riscv: Enable pcpu page first chunk allocator")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Link: https://lore.kernel.org/r/20250624-riscv-hsm-boot-data-array-v1-1-50b5eeafbe61@iscas.ac.cn
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/cpu_ops_sbi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/riscv/kernel/cpu_ops_sbi.c
+++ b/arch/riscv/kernel/cpu_ops_sbi.c
@@ -18,10 +18,10 @@ const struct cpu_operations cpu_ops_sbi;
 
 /*
  * Ordered booting via HSM brings one cpu at a time. However, cpu hotplug can
- * be invoked from multiple threads in parallel. Define a per cpu data
+ * be invoked from multiple threads in parallel. Define an array of boot data
  * to handle that.
  */
-static DEFINE_PER_CPU(struct sbi_hart_boot_data, boot_data);
+static struct sbi_hart_boot_data boot_data[NR_CPUS];
 
 static int sbi_hsm_hart_start(unsigned long hartid, unsigned long saddr,
 			      unsigned long priv)
@@ -67,7 +67,7 @@ static int sbi_cpu_start(unsigned int cp
 	unsigned long boot_addr = __pa_symbol(secondary_start_sbi);
 	unsigned long hartid = cpuid_to_hartid_map(cpuid);
 	unsigned long hsm_data;
-	struct sbi_hart_boot_data *bdata = &per_cpu(boot_data, cpuid);
+	struct sbi_hart_boot_data *bdata = &boot_data[cpuid];
 
 	/* Make sure tidle is updated */
 	smp_mb();


