Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C9249738F;
	Thu, 17 Sep 2026 18:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668998; cv=none; b=AJfI3f2KviKBhb1e+Z9jJEzXLlZANtZLOWIycHEkiBqQ0q9c7Mtg9VFbnOrxTrBoOnUCdY1qRPqP+TNHoIGAA1Wjdnltvm0k+6abv+yXIH5NQ3B3lccEWgKoty9jRRzOWtWHo8mBG6Q6TgiqCxuxYPQFbdjqY2Wzhd1R9oS7eQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668998; c=relaxed/simple;
	bh=vcFWpqlGXZan0JSWjR3YHhZ0Msm95yHu7/pdafol+As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDMkhpfxlGLr/ADgnbszQB53EOP50tbjqssRVGaIOeGcs9gLoPZFwPTAG3KTw5NUqPM8STtMukitwGEZwFe4d9RpSMhv+utcr9FteXVGt5nQbWwlVA7E3XjdeSoeSxMQzrR85nSTMrw9fTSUlh6+mHqv4AnolJ0+yAgZAxAB0Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgj6cV2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgj6cV2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED5F1F000FF;
	Thu, 17 Sep 2026 18:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668997;
	bh=6F1qhZEqqoWTj2YUudw/z9KH7xwXGXt23shCIC37pps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgj6cV2viJRVOhEwLy56x9VvW6SukU4BQCFIpgsj9kZoY0jaApxSp+YyEX6Y+EJV0
	 T3lLcL4SHXuCxCES1Tr7wbs0K746zHHxWoXkFh3kl7FCyMrCN/pJYla9sfC/RZ/s6o
	 3iqrmFsGCOmI+wtMsYQ0UlBrv756sbpi9rAPPgBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Lee Jones <lee@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0611/1102] arm: Handle KCOV __init vs inline mismatches
Date: Thu, 17 Sep 2026 16:09:14 +0100
Message-ID: <20260917151555.378072929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 2424fe1cac4fc8ea0520ba22ede7544c3ddc8dd1 ]

When KCOV is enabled all functions get instrumented, unless
the __no_sanitize_coverage attribute is used. To prepare for
__no_sanitize_coverage being applied to __init functions, we have to
handle differences in how GCC's inline optimizations get resolved. For
arm this exposed several places where __init annotations were missing
but ended up being "accidentally correct". Fix these cases and force
several functions to be inline with __always_inline.

Acked-by: Nishanth Menon <nm@ti.com>
Acked-by: Lee Jones <lee@kernel.org>
Reviewed-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20250717232519.2984886-5-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Stable-dep-of: 66ec63e7a90b ("ASoC: ux500: Deassert the MSP reset during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/cache-feroceon-l2.c   | 2 +-
 arch/arm/mm/cache-tauros2.c       | 2 +-
 drivers/clocksource/timer-orion.c | 2 +-
 drivers/soc/ti/pm33xx.c           | 2 +-
 include/linux/mfd/dbx500-prcmu.h  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/cache-feroceon-l2.c b/arch/arm/mm/cache-feroceon-l2.c
index 25dbd84a1aafa..2bfefb252ffdd 100644
--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -295,7 +295,7 @@ static inline u32 read_extra_features(void)
 	return u;
 }
 
-static inline void write_extra_features(u32 u)
+static inline void __init write_extra_features(u32 u)
 {
 	__asm__("mcr p15, 1, %0, c15, c1, 0" : : "r" (u));
 }
diff --git a/arch/arm/mm/cache-tauros2.c b/arch/arm/mm/cache-tauros2.c
index b1e1aba602f7f..bfe166ccace05 100644
--- a/arch/arm/mm/cache-tauros2.c
+++ b/arch/arm/mm/cache-tauros2.c
@@ -177,7 +177,7 @@ static inline void __init write_actlr(u32 actlr)
 	__asm__("mcr p15, 0, %0, c1, c0, 1\n" : : "r" (actlr));
 }
 
-static void enable_extra_feature(unsigned int features)
+static void __init enable_extra_feature(unsigned int features)
 {
 	u32 u;
 
diff --git a/drivers/clocksource/timer-orion.c b/drivers/clocksource/timer-orion.c
index 49e86cb70a7a8..61f1e27fc41e7 100644
--- a/drivers/clocksource/timer-orion.c
+++ b/drivers/clocksource/timer-orion.c
@@ -43,7 +43,7 @@ static struct delay_timer orion_delay_timer = {
 	.read_current_timer = orion_read_timer,
 };
 
-static void orion_delay_timer_init(unsigned long rate)
+static void __init orion_delay_timer_init(unsigned long rate)
 {
 	orion_delay_timer.freq = rate;
 	register_current_timer_delay(&orion_delay_timer);
diff --git a/drivers/soc/ti/pm33xx.c b/drivers/soc/ti/pm33xx.c
index dfdff186c805c..dc52a2197d249 100644
--- a/drivers/soc/ti/pm33xx.c
+++ b/drivers/soc/ti/pm33xx.c
@@ -145,7 +145,7 @@ static int am33xx_do_sram_idle(u32 wfi_flags)
 	return pm_ops->cpu_suspend(am33xx_do_wfi_sram, wfi_flags);
 }
 
-static int __init am43xx_map_gic(void)
+static int am43xx_map_gic(void)
 {
 	gic_dist_base = ioremap(AM43XX_GIC_DIST_BASE, SZ_4K);
 
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 98567623c9df6..828362b7860c6 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -213,7 +213,7 @@ struct prcmu_fw_version {
 
 #if defined(CONFIG_UX500_SOC_DB8500)
 
-static inline void prcmu_early_init(void)
+static inline void __init prcmu_early_init(void)
 {
 	db8500_prcmu_early_init();
 }
-- 
2.53.0



