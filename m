Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E67A189502;
	Tue, 30 Jul 2024 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359543; cv=none; b=HId1uT31r8X6iuktnge1EGIeFDoB2NG6wRJ0vfRGvipV7974eH3RtJDIAu26o5bRVvPlRfJaF2NR9eJOiY3F/p1MCpqe0o925yxc+mgGwm50Uj1fvgkrBrJwmUznMADWodS/e6kg8mWzGyJ7FF5It79C92S23SQkCV4S+FNVMaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359543; c=relaxed/simple;
	bh=zjpUQ/km2XjBLi6X+YL80mY/7Konig9Wn8viE6p3hTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDRz2CEF6GVbscHhIpynxR6BlLLcQ7d9twCsSXHVY2vjI/KuezaRmuiGysCDewMgme7uqQCz3CFqaM4GPrtynuU7PjFVaXAkCHV3eFL+eDy/gDRI0QFzGRPHXs/WkffvF3qNmOD7h1RxhNtnPEtNciNHoYIAspTM9Vx4zebL1m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nypyXQja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nypyXQja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB21DC4AF12;
	Tue, 30 Jul 2024 17:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359543;
	bh=zjpUQ/km2XjBLi6X+YL80mY/7Konig9Wn8viE6p3hTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nypyXQjaIEaUPhbrbAiT/cUQlw6Je1rdZPOACjSCXONAnd+lzUcUXfq+iesONWHey
	 dbk5IaHTTxxNK+87YU1g4qYNq03hewYiHgIXVUcIgEvEf+0WcqzShMB0OD+zODMIV4
	 HhQDvRdwQiizqsBpgXHQw0ipGQ8lovVyxmQfhIPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 499/568] MIPS: Loongson64: Test register availability before use
Date: Tue, 30 Jul 2024 17:50:06 +0200
Message-ID: <20240730151659.531635250@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
@@ -466,12 +466,25 @@ static void loongson3_smp_finish(void)
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
@@ -492,14 +505,14 @@ static void __init loongson3_smp_setup(v
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
@@ -818,6 +831,9 @@ static int loongson3_disable_clock(unsig
 	uint64_t core_id = cpu_core(&cpu_data[cpu]);
 	uint64_t package_id = cpu_data[cpu].package;
 
+	if (!loongson_chipcfg[package_id] || !loongson_freqctrl[package_id])
+		return 0;
+
 	if ((read_c0_prid() & PRID_REV_MASK) == PRID_REV_LOONGSON3A_R1) {
 		LOONGSON_CHIPCFG(package_id) &= ~(1 << (12 + core_id));
 	} else {
@@ -832,6 +848,9 @@ static int loongson3_enable_clock(unsign
 	uint64_t core_id = cpu_core(&cpu_data[cpu]);
 	uint64_t package_id = cpu_data[cpu].package;
 
+	if (!loongson_chipcfg[package_id] || !loongson_freqctrl[package_id])
+		return 0;
+
 	if ((read_c0_prid() & PRID_REV_MASK) == PRID_REV_LOONGSON3A_R1) {
 		LOONGSON_CHIPCFG(package_id) |= 1 << (12 + core_id);
 	} else {


