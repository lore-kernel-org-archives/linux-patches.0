Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110057C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68785C433EF;
	Mon, 24 Apr 2023 13:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342782;
	bh=7Tai9VoDSP3fnzBapK+Q5uGS9uodF8uxdlqNPTTUOZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBWfuolH0xFItfGTUIHBtVMgN58r/Z8X8ifW2XR7YUq8Aq69avY7QaT9O40TXOoyS
	 TEecXNCtALwXqqDZu5f/piiVw3cLs7SeBOLAjjit2b62c0iuugienjIs2uZz6ahP0P
	 KGM/DfZIFZSF1GAfE717kdYIU/JfD6xduRlDPP/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 56/98] LoongArch: Fix probing of the CRC32 feature
Date: Mon, 24 Apr 2023 15:17:19 +0200
Message-Id: <20230424131136.033362305@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
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

commit df830336045db1246d3245d3737fee9939c5f731 upstream.

Not all LoongArch processors support CRC32 instructions. This feature
is indicated by CPUCFG1.CRC32 (Bit25) but it is wrongly defined in the
previous versions of the ISA manual (and so does in loongarch.h). The
CRC32 feature is set unconditionally now, so fix it.

BTW, expose the CRC32 feature in /proc/cpuinfo.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/cpu-features.h |    1 
 arch/loongarch/include/asm/cpu.h          |   40 +++++++++++++++---------------
 arch/loongarch/include/asm/loongarch.h    |    2 -
 arch/loongarch/kernel/cpu-probe.c         |    7 ++++-
 arch/loongarch/kernel/proc.c              |    1 
 5 files changed, 30 insertions(+), 21 deletions(-)

--- a/arch/loongarch/include/asm/cpu-features.h
+++ b/arch/loongarch/include/asm/cpu-features.h
@@ -42,6 +42,7 @@
 #define cpu_has_fpu		cpu_opt(LOONGARCH_CPU_FPU)
 #define cpu_has_lsx		cpu_opt(LOONGARCH_CPU_LSX)
 #define cpu_has_lasx		cpu_opt(LOONGARCH_CPU_LASX)
+#define cpu_has_crc32		cpu_opt(LOONGARCH_CPU_CRC32)
 #define cpu_has_complex		cpu_opt(LOONGARCH_CPU_COMPLEX)
 #define cpu_has_crypto		cpu_opt(LOONGARCH_CPU_CRYPTO)
 #define cpu_has_lvz		cpu_opt(LOONGARCH_CPU_LVZ)
--- a/arch/loongarch/include/asm/cpu.h
+++ b/arch/loongarch/include/asm/cpu.h
@@ -78,25 +78,26 @@ enum cpu_type_enum {
 #define CPU_FEATURE_FPU			3	/* CPU has FPU */
 #define CPU_FEATURE_LSX			4	/* CPU has LSX (128-bit SIMD) */
 #define CPU_FEATURE_LASX		5	/* CPU has LASX (256-bit SIMD) */
-#define CPU_FEATURE_COMPLEX		6	/* CPU has Complex instructions */
-#define CPU_FEATURE_CRYPTO		7	/* CPU has Crypto instructions */
-#define CPU_FEATURE_LVZ			8	/* CPU has Virtualization extension */
-#define CPU_FEATURE_LBT_X86		9	/* CPU has X86 Binary Translation */
-#define CPU_FEATURE_LBT_ARM		10	/* CPU has ARM Binary Translation */
-#define CPU_FEATURE_LBT_MIPS		11	/* CPU has MIPS Binary Translation */
-#define CPU_FEATURE_TLB			12	/* CPU has TLB */
-#define CPU_FEATURE_CSR			13	/* CPU has CSR */
-#define CPU_FEATURE_WATCH		14	/* CPU has watchpoint registers */
-#define CPU_FEATURE_VINT		15	/* CPU has vectored interrupts */
-#define CPU_FEATURE_CSRIPI		16	/* CPU has CSR-IPI */
-#define CPU_FEATURE_EXTIOI		17	/* CPU has EXT-IOI */
-#define CPU_FEATURE_PREFETCH		18	/* CPU has prefetch instructions */
-#define CPU_FEATURE_PMP			19	/* CPU has perfermance counter */
-#define CPU_FEATURE_SCALEFREQ		20	/* CPU supports cpufreq scaling */
-#define CPU_FEATURE_FLATMODE		21	/* CPU has flat mode */
-#define CPU_FEATURE_EIODECODE		22	/* CPU has EXTIOI interrupt pin decode mode */
-#define CPU_FEATURE_GUESTID		23	/* CPU has GuestID feature */
-#define CPU_FEATURE_HYPERVISOR		24	/* CPU has hypervisor (running in VM) */
+#define CPU_FEATURE_CRC32		6	/* CPU has CRC32 instructions */
+#define CPU_FEATURE_COMPLEX		7	/* CPU has Complex instructions */
+#define CPU_FEATURE_CRYPTO		8	/* CPU has Crypto instructions */
+#define CPU_FEATURE_LVZ			9	/* CPU has Virtualization extension */
+#define CPU_FEATURE_LBT_X86		10	/* CPU has X86 Binary Translation */
+#define CPU_FEATURE_LBT_ARM		11	/* CPU has ARM Binary Translation */
+#define CPU_FEATURE_LBT_MIPS		12	/* CPU has MIPS Binary Translation */
+#define CPU_FEATURE_TLB			13	/* CPU has TLB */
+#define CPU_FEATURE_CSR			14	/* CPU has CSR */
+#define CPU_FEATURE_WATCH		15	/* CPU has watchpoint registers */
+#define CPU_FEATURE_VINT		16	/* CPU has vectored interrupts */
+#define CPU_FEATURE_CSRIPI		17	/* CPU has CSR-IPI */
+#define CPU_FEATURE_EXTIOI		18	/* CPU has EXT-IOI */
+#define CPU_FEATURE_PREFETCH		19	/* CPU has prefetch instructions */
+#define CPU_FEATURE_PMP			20	/* CPU has perfermance counter */
+#define CPU_FEATURE_SCALEFREQ		21	/* CPU supports cpufreq scaling */
+#define CPU_FEATURE_FLATMODE		22	/* CPU has flat mode */
+#define CPU_FEATURE_EIODECODE		23	/* CPU has EXTIOI interrupt pin decode mode */
+#define CPU_FEATURE_GUESTID		24	/* CPU has GuestID feature */
+#define CPU_FEATURE_HYPERVISOR		25	/* CPU has hypervisor (running in VM) */
 
 #define LOONGARCH_CPU_CPUCFG		BIT_ULL(CPU_FEATURE_CPUCFG)
 #define LOONGARCH_CPU_LAM		BIT_ULL(CPU_FEATURE_LAM)
@@ -104,6 +105,7 @@ enum cpu_type_enum {
 #define LOONGARCH_CPU_FPU		BIT_ULL(CPU_FEATURE_FPU)
 #define LOONGARCH_CPU_LSX		BIT_ULL(CPU_FEATURE_LSX)
 #define LOONGARCH_CPU_LASX		BIT_ULL(CPU_FEATURE_LASX)
+#define LOONGARCH_CPU_CRC32		BIT_ULL(CPU_FEATURE_CRC32)
 #define LOONGARCH_CPU_COMPLEX		BIT_ULL(CPU_FEATURE_COMPLEX)
 #define LOONGARCH_CPU_CRYPTO		BIT_ULL(CPU_FEATURE_CRYPTO)
 #define LOONGARCH_CPU_LVZ		BIT_ULL(CPU_FEATURE_LVZ)
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -117,7 +117,7 @@ static inline u32 read_cpucfg(u32 reg)
 #define  CPUCFG1_EP			BIT(22)
 #define  CPUCFG1_RPLV			BIT(23)
 #define  CPUCFG1_HUGEPG			BIT(24)
-#define  CPUCFG1_IOCSRBRD		BIT(25)
+#define  CPUCFG1_CRC32			BIT(25)
 #define  CPUCFG1_MSGINT			BIT(26)
 
 #define LOONGARCH_CPUCFG2		0x2
--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -94,13 +94,18 @@ static void cpu_probe_common(struct cpui
 	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
 		     LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
 
-	elf_hwcap = HWCAP_LOONGARCH_CPUCFG | HWCAP_LOONGARCH_CRC32;
+	elf_hwcap = HWCAP_LOONGARCH_CPUCFG;
 
 	config = read_cpucfg(LOONGARCH_CPUCFG1);
 	if (config & CPUCFG1_UAL) {
 		c->options |= LOONGARCH_CPU_UAL;
 		elf_hwcap |= HWCAP_LOONGARCH_UAL;
 	}
+	if (config & CPUCFG1_CRC32) {
+		c->options |= LOONGARCH_CPU_CRC32;
+		elf_hwcap |= HWCAP_LOONGARCH_CRC32;
+	}
+
 
 	config = read_cpucfg(LOONGARCH_CPUCFG2);
 	if (config & CPUCFG2_LAM) {
--- a/arch/loongarch/kernel/proc.c
+++ b/arch/loongarch/kernel/proc.c
@@ -76,6 +76,7 @@ static int show_cpuinfo(struct seq_file
 	if (cpu_has_fpu)	seq_printf(m, " fpu");
 	if (cpu_has_lsx)	seq_printf(m, " lsx");
 	if (cpu_has_lasx)	seq_printf(m, " lasx");
+	if (cpu_has_crc32)	seq_printf(m, " crc32");
 	if (cpu_has_complex)	seq_printf(m, " complex");
 	if (cpu_has_crypto)	seq_printf(m, " crypto");
 	if (cpu_has_lvz)	seq_printf(m, " lvz");


