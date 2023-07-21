Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973CA1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B999C433C8;
	Fri, 21 Jul 2023 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956232;
	bh=LN/aywqUBhqOgdNk6YnGicbSCtLVPZ6+aMOUPBvj4Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9ksKSQZ46i6Vya5birMwoiiRFNDbVDTdFz51f9gPsvAXzWoOV5EF16QwkFy1buYC
	 Z+CNbjejuUZPHU3dOtyjpqpczABBCXZvMh3pow2SdwcAN06w7LYh5oKa/OmCUFMJDz
	 8/IdHKGsREA7K/+w7kW67ZgEGiJDozN0XrlHmEx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Pei <huangpei@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.4 147/292] MIPS: Loongson: Fix cpu_probe_loongson() again
Date: Fri, 21 Jul 2023 18:04:16 +0200
Message-ID: <20230721160535.208969484@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

commit 65fee014dc41a774bcd94896f3fb380bc39d8dda upstream.

Commit 7db5e9e9e5e6c10d7d ("MIPS: loongson64: fix FTLB configuration")
move decode_configs() from the beginning of cpu_probe_loongson() to the
end in order to fix FTLB configuration. However, it breaks the CPUCFG
decoding because decode_configs() use "c->options = xxxx" rather than
"c->options |= xxxx", all information get from CPUCFG by decode_cpucfg()
is lost.

This causes error when creating a KVM guest on Loongson-3A4000:
Exception Code: 4 not handled @ PC: 0000000087ad5981, inst: 0xcb7a1898 BadVaddr: 0x0 Status: 0x0

Fix this by moving the c->cputype setting to the beginning and moving
decode_configs() after that.

Fixes: 7db5e9e9e5e6c10d7d ("MIPS: loongson64: fix FTLB configuration")
Cc: stable@vger.kernel.org
Cc: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/cpu-probe.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1677,7 +1677,10 @@ static inline void decode_cpucfg(struct
 
 static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 {
+	c->cputype = CPU_LOONGSON64;
+
 	/* All Loongson processors covered here define ExcCode 16 as GSExc. */
+	decode_configs(c);
 	c->options |= MIPS_CPU_GSEXCEX;
 
 	switch (c->processor_id & PRID_IMP_MASK) {
@@ -1687,7 +1690,6 @@ static inline void cpu_probe_loongson(st
 		case PRID_REV_LOONGSON2K_R1_1:
 		case PRID_REV_LOONGSON2K_R1_2:
 		case PRID_REV_LOONGSON2K_R1_3:
-			c->cputype = CPU_LOONGSON64;
 			__cpu_name[cpu] = "Loongson-2K";
 			set_elf_platform(cpu, "gs264e");
 			set_isa(c, MIPS_CPU_ISA_M64R2);
@@ -1700,14 +1702,12 @@ static inline void cpu_probe_loongson(st
 		switch (c->processor_id & PRID_REV_MASK) {
 		case PRID_REV_LOONGSON3A_R2_0:
 		case PRID_REV_LOONGSON3A_R2_1:
-			c->cputype = CPU_LOONGSON64;
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3a");
 			set_isa(c, MIPS_CPU_ISA_M64R2);
 			break;
 		case PRID_REV_LOONGSON3A_R3_0:
 		case PRID_REV_LOONGSON3A_R3_1:
-			c->cputype = CPU_LOONGSON64;
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3a");
 			set_isa(c, MIPS_CPU_ISA_M64R2);
@@ -1727,7 +1727,6 @@ static inline void cpu_probe_loongson(st
 		c->ases &= ~MIPS_ASE_VZ; /* VZ of Loongson-3A2000/3000 is incomplete */
 		break;
 	case PRID_IMP_LOONGSON_64G:
-		c->cputype = CPU_LOONGSON64;
 		__cpu_name[cpu] = "ICT Loongson-3";
 		set_elf_platform(cpu, "loongson3a");
 		set_isa(c, MIPS_CPU_ISA_M64R2);
@@ -1737,8 +1736,6 @@ static inline void cpu_probe_loongson(st
 		panic("Unknown Loongson Processor ID!");
 		break;
 	}
-
-	decode_configs(c);
 }
 #else
 static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu) { }


