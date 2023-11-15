Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14DB3C465
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhM481fG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A24C433CA;
	Wed, 15 Nov 2023 19:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077150;
	bh=GchX+jI0fJdwFtH7pwsnUqt/Jud7PPsN4OlB6yC5h8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhM481fGnr9rhZUa9M3EuD7uKcxOHpVQLbUF1RNnkXPi5UqFFbr4Oloyt36ccGtrO
	 bHd32pIpIcrikGNWEDn9srMcSBp4xtNse1G5yDZo+sZ5y/qaIKnsyy40SbfBW4PxBh
	 UX9QYh/MWCEqPWwX40Fjy4uKRTRWC/xaXOSggyOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Worth <carl@os.amperecomputing.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 537/550] arm64/arm: arm_pmuv3: perf: Dont truncate 64-bit registers
Date: Wed, 15 Nov 2023 14:18:41 -0500
Message-ID: <20231115191638.165643214@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

[ Upstream commit 403edfa436286b21f5ffe6856ae5b36396e8966c ]

The driver used to truncate several 64-bit registers such as PMCEID[n]
registers used to describe whether architectural and microarchitectural
events in range 0x4000-0x401f exist. Due to discarding the bits, the
driver made the events invisible, even if they existed.

Moreover, PMCCFILTR and PMCR registers have additional bits in the upper
32 bits. This patch makes them available although they aren't currently
used. Finally, functions handling PMXEVCNTR and PMXEVTYPER registers are
removed as they not being used at all.

Fixes: df29ddf4f04b ("arm64: perf: Abstract system register accesses away")
Reported-by: Carl Worth <carl@os.amperecomputing.com>
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Acked-by: Will Deacon <will@kernel.org>
Closes: https://lore.kernel.org/..
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20231102183012.1251410-1-ilkka@os.amperecomputing.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/arm_pmuv3.h   | 48 ++++++++++++++----------------
 arch/arm64/include/asm/arm_pmuv3.h | 25 ++++------------
 drivers/perf/arm_pmuv3.c           |  6 ++--
 3 files changed, 31 insertions(+), 48 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index f3cd04ff022df..9590dc0ba1688 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -23,6 +23,8 @@
 #define PMUSERENR		__ACCESS_CP15(c9,  0, c14, 0)
 #define PMINTENSET		__ACCESS_CP15(c9,  0, c14, 1)
 #define PMINTENCLR		__ACCESS_CP15(c9,  0, c14, 2)
+#define PMCEID2			__ACCESS_CP15(c9,  0, c14, 4)
+#define PMCEID3			__ACCESS_CP15(c9,  0, c14, 5)
 #define PMMIR			__ACCESS_CP15(c9,  0, c14, 6)
 #define PMCCFILTR		__ACCESS_CP15(c14, 0, c15, 7)
 
@@ -150,21 +152,6 @@ static inline u64 read_pmccntr(void)
 	return read_sysreg(PMCCNTR);
 }
 
-static inline void write_pmxevcntr(u32 val)
-{
-	write_sysreg(val, PMXEVCNTR);
-}
-
-static inline u32 read_pmxevcntr(void)
-{
-	return read_sysreg(PMXEVCNTR);
-}
-
-static inline void write_pmxevtyper(u32 val)
-{
-	write_sysreg(val, PMXEVTYPER);
-}
-
 static inline void write_pmcntenset(u32 val)
 {
 	write_sysreg(val, PMCNTENSET);
@@ -205,16 +192,6 @@ static inline void write_pmuserenr(u32 val)
 	write_sysreg(val, PMUSERENR);
 }
 
-static inline u32 read_pmceid0(void)
-{
-	return read_sysreg(PMCEID0);
-}
-
-static inline u32 read_pmceid1(void)
-{
-	return read_sysreg(PMCEID1);
-}
-
 static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u32 clr) {}
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
@@ -229,6 +206,7 @@ static inline bool kvm_set_pmuserenr(u64 val)
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
+#define ARMV8_PMU_DFR_VER_V3P1      0x4
 #define ARMV8_PMU_DFR_VER_V3P4      0x5
 #define ARMV8_PMU_DFR_VER_V3P5      0x6
 #define ARMV8_PMU_DFR_VER_IMP_DEF   0xF
@@ -249,4 +227,24 @@ static inline bool is_pmuv3p5(int pmuver)
 	return pmuver >= ARMV8_PMU_DFR_VER_V3P5;
 }
 
+static inline u64 read_pmceid0(void)
+{
+	u64 val = read_sysreg(PMCEID0);
+
+	if (read_pmuver() >= ARMV8_PMU_DFR_VER_V3P1)
+		val |= (u64)read_sysreg(PMCEID2) << 32;
+
+	return val;
+}
+
+static inline u64 read_pmceid1(void)
+{
+	u64 val = read_sysreg(PMCEID1);
+
+	if (read_pmuver() >= ARMV8_PMU_DFR_VER_V3P1)
+		val |= (u64)read_sysreg(PMCEID3) << 32;
+
+	return val;
+}
+
 #endif
diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 18dc2fb3d7b7b..c27404fa4418a 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -46,12 +46,12 @@ static inline u32 read_pmuver(void)
 			ID_AA64DFR0_EL1_PMUVer_SHIFT);
 }
 
-static inline void write_pmcr(u32 val)
+static inline void write_pmcr(u64 val)
 {
 	write_sysreg(val, pmcr_el0);
 }
 
-static inline u32 read_pmcr(void)
+static inline u64 read_pmcr(void)
 {
 	return read_sysreg(pmcr_el0);
 }
@@ -71,21 +71,6 @@ static inline u64 read_pmccntr(void)
 	return read_sysreg(pmccntr_el0);
 }
 
-static inline void write_pmxevcntr(u32 val)
-{
-	write_sysreg(val, pmxevcntr_el0);
-}
-
-static inline u32 read_pmxevcntr(void)
-{
-	return read_sysreg(pmxevcntr_el0);
-}
-
-static inline void write_pmxevtyper(u32 val)
-{
-	write_sysreg(val, pmxevtyper_el0);
-}
-
 static inline void write_pmcntenset(u32 val)
 {
 	write_sysreg(val, pmcntenset_el0);
@@ -106,7 +91,7 @@ static inline void write_pmintenclr(u32 val)
 	write_sysreg(val, pmintenclr_el1);
 }
 
-static inline void write_pmccfiltr(u32 val)
+static inline void write_pmccfiltr(u64 val)
 {
 	write_sysreg(val, pmccfiltr_el0);
 }
@@ -126,12 +111,12 @@ static inline void write_pmuserenr(u32 val)
 	write_sysreg(val, pmuserenr_el0);
 }
 
-static inline u32 read_pmceid0(void)
+static inline u64 read_pmceid0(void)
 {
 	return read_sysreg(pmceid0_el0);
 }
 
-static inline u32 read_pmceid1(void)
+static inline u64 read_pmceid1(void)
 {
 	return read_sysreg(pmceid1_el0);
 }
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 08b3a1bf0ef62..a50a18e009033 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -428,12 +428,12 @@ static inline bool armv8pmu_event_is_chained(struct perf_event *event)
 #define	ARMV8_IDX_TO_COUNTER(x)	\
 	(((x) - ARMV8_IDX_COUNTER0) & ARMV8_PMU_COUNTER_MASK)
 
-static inline u32 armv8pmu_pmcr_read(void)
+static inline u64 armv8pmu_pmcr_read(void)
 {
 	return read_pmcr();
 }
 
-static inline void armv8pmu_pmcr_write(u32 val)
+static inline void armv8pmu_pmcr_write(u64 val)
 {
 	val &= ARMV8_PMU_PMCR_MASK;
 	isb();
@@ -978,7 +978,7 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 static void armv8pmu_reset(void *info)
 {
 	struct arm_pmu *cpu_pmu = (struct arm_pmu *)info;
-	u32 pmcr;
+	u64 pmcr;
 
 	/* The counter and interrupt enable registers are unknown at reset. */
 	armv8pmu_disable_counter(U32_MAX);
-- 
2.42.0



