Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740421714A1;
	Thu, 15 Aug 2024 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729929; cv=none; b=oCQmwfSTvrBoO5f0GOUlwPsD9ee4PaQLfGsmUsGSr8q6/82YvIPbS3npkM+hia1ny8U2lqyOw+6kwZ6AnwBT9LhQPJN4YVcBSn+iguYQYJdVBUq9k7iGdLgKjHO/DlYW+LKqg9QkJy/P35GlU3ycoPlRFLrbbd9gwcsXUGzCbJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729929; c=relaxed/simple;
	bh=3fn7zE18ha115YChRPAsAJ+GlyIu4+4WX6F4XRwqnpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHNgMJRcuRmAGmdkoQO0oEXZXZH54Mb6ExpcqtcmXvwqCncuhQ4YC0BAVLj05QXe+pCr/s0g9ysilmLsLw6UIMZJTkabC/rYaYWXJ2LKKKGmt0MeU1T5dvEAEN56jUuDv1GdKkIHRI4iNoSyDL2yJ9qOiwCDnbzTQOoVzw6Dn08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4gf1Pr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4gf1Pr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE52EC32786;
	Thu, 15 Aug 2024 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729929;
	bh=3fn7zE18ha115YChRPAsAJ+GlyIu4+4WX6F4XRwqnpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4gf1Pr0EUSSgLLk10Oe16RURWRIasaYcq7uf3KtoV3MCeWM3aQQrn+hOcNggD8t0
	 wVXrwVliDUu80R2xTSZzmuPpmV5W4dxMPqGpMmcE4hPpUHwydnFyp901AsC945kLvV
	 StNehzlRNk8Pyywym1esggm+wMbISq44F0vUe8dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 251/484] MIPS: Loongson64: Test register availability before use
Date: Thu, 15 Aug 2024 15:21:49 +0200
Message-ID: <20240815131951.094974023@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit c04366b1207a036b7de02dfcc1ac7138d3343c9b upstream.

Some global register address variable may be missing on
specific CPU type, test them before use them.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/loongson64/smp.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/arch/mips/loongson64/smp.c
+++ b/arch/mips/loongson64/smp.c
@@ -479,12 +479,25 @@ static void loongson3_smp_finish(void)
 static void __init loongson3_smp_setup(void)
 {
 	int i = 0, num = 0; /* i: physical id, num: logical id */
+	int max_cpus = 0;
 
 	init_cpu_possible(cpu_none_mask);
 
+	for (i = 0; i < ARRAY_SIZE(smp_group); i++) {
+		if (!smp_group[i])
+			break;
+		max_cpus += loongson_sysconf.cores_per_node;
+	}
+
+	if (max_cpus < loongson_sysconf.nr_cpus) {
+		pr_err("SMP Groups are less than the number of CPUs\n");
+		loongson_sysconf.nr_cpus = max_cpus ? max_cpus : 1;
+	}
+
 	/* For unified kernel, NR_CPUS is the maximum possible value,
 	 * loongson_sysconf.nr_cpus is the really present value
 	 */
+	i = 0;
 	while (i < loongson_sysconf.nr_cpus) {
 		if (loongson_sysconf.reserved_cpus_mask & (1<<i)) {
 			/* Reserved physical CPU cores */
@@ -505,14 +518,14 @@ static void __init loongson3_smp_setup(v
 		__cpu_logical_map[num] = -1;
 		num++;
 	}
-
 	csr_ipi_probe();
 	ipi_set0_regs_init();
 	ipi_clear0_regs_init();
 	ipi_status0_regs_init();
 	ipi_en0_regs_init();
 	ipi_mailbox_buf_init();
-	ipi_write_enable(0);
+	if (smp_group[0])
+		ipi_write_enable(0);
 
 	cpu_set_core(&cpu_data[0],
 		     cpu_logical_map(0) % loongson_sysconf.cores_per_package);
@@ -830,6 +843,9 @@ static int loongson3_disable_clock(unsig
 	uint64_t core_id = cpu_core(&cpu_data[cpu]);
 	uint64_t package_id = cpu_data[cpu].package;
 
+	if (!loongson_chipcfg[package_id] || !loongson_freqctrl[package_id])
+		return 0;
+
 	if ((read_c0_prid() & PRID_REV_MASK) == PRID_REV_LOONGSON3A_R1) {
 		LOONGSON_CHIPCFG(package_id) &= ~(1 << (12 + core_id));
 	} else {
@@ -844,6 +860,9 @@ static int loongson3_enable_clock(unsign
 	uint64_t core_id = cpu_core(&cpu_data[cpu]);
 	uint64_t package_id = cpu_data[cpu].package;
 
+	if (!loongson_chipcfg[package_id] || !loongson_freqctrl[package_id])
+		return 0;
+
 	if ((read_c0_prid() & PRID_REV_MASK) == PRID_REV_LOONGSON3A_R1) {
 		LOONGSON_CHIPCFG(package_id) |= 1 << (12 + core_id);
 	} else {


