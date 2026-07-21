Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD21246A5FD;
	Tue, 21 Jul 2026 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649571; cv=none; b=fAZn0UPRbQt/KiP6lxS6Lr7qYdS9LbbYg5E1kuz/QiDejOvQ3X1eT7ZiLGHLHxGaW33a4yVsUYnK0LtJ9HaoxAwVk9WEM8MCJAfx+yc4J5dyaf6Q1uRSYelXsegx2qVM9OnY8/uQAjBqTjOwFdv0CiqRyj+Mv4QMA9L2EcNZXuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649571; c=relaxed/simple;
	bh=XflBPfHU98chJ0SNlcoBysLRW5n2j7ek2lKeYhjxFE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/0gpM8CH1WzZsqe8KkkO6WALzmvKx+3uhOX1OfhpoCwa8AkWus/zCXkvosnr2J2+QM49ztALKPrP9Q+BrC9yyTpsYF/XE8zvcTcXtszxfdGpL3oDoGqGcdeCmN9E+E5bQq4DvTsBzhnfFnC/u9qlr6brw3Six1fDLurgJ/+QGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0Hc/eu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0Hc/eu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1AE1F00A3A;
	Tue, 21 Jul 2026 15:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649569;
	bh=oxpqDtumbIZoe5uJWP9Dj3RbblpAW5ZPx88WMoUZ4YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0Hc/eu7Mej/Cay3jEpyw40uGpEOrbJr6kBZpoh37WZvdKF057ImKnz/iHcJna+0L
	 s3K9OfSqBruoEDf5aUrMFxFMZkPI6lJlvdd3PsWCZ1N2JLw2FxfKSDZxwuVZ0I2O3e
	 fhtqHJ6Xyp+7TMl9LDGec/YK4mGybpUJ/mh35dJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enric Balletbo i Serra <eballetb@redhat.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0627/2077] clocksource: move NXP timer selection to drivers/clocksource
Date: Tue, 21 Jul 2026 17:05:00 +0200
Message-ID: <20260721152607.592963229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enric Balletbo i Serra <eballetb@redhat.com>

[ Upstream commit a9ac745bc320cbdc2ed3c851eb78f91f22ff975b ]

The Kconfig logic for selecting the scheduler clocksource on
NXP Vybrid (VF610) uses a `choice` block restricted to 32-bit ARM. This
prevents 64-bit architectures, such as the NXP S32 family, from enabling
the NXP Periodic Interrupt Timer (PIT) driver (CONFIG_NXP_PIT_TIMER).

Relocate the NXP clocksource selection from arch/arm/mach-imx/Kconfig to
drivers/clocksource/Kconfig. This allows the configuration to be shared
across different architectures.

Update the selection to include support for ARCH_S32 and add a "None"
option restricted to ARCH_S32, since Vybrid lacks the ARM Architected
Timer. The Vybrid Global Timer option is restricted to ARCH_MULTI_V7
SOC_VF610 platforms to prevent it from being visible on Cortex-M4 builds,
which lack the ARM Global Timer hardware.

Fixes: bee33f22d7c3 ("clocksource/drivers/nxp-pit: Add NXP Automotive s32g2 / s32g3 support")
Signed-off-by: Enric Balletbo i Serra <eballetb@redhat.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260514-fix-nxp-timer-v3-1-a3e68fdb505e@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/Kconfig   | 21 ---------------------
 drivers/clocksource/Kconfig | 31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 6ea1bd55acf8de..a361840d7a0478 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -227,27 +227,6 @@ config SOC_VF610
 	help
 	  This enables support for Freescale Vybrid VF610 processor.
 
-choice
-	prompt "Clocksource for scheduler clock"
-	depends on SOC_VF610
-	default VF_USE_ARM_GLOBAL_TIMER
-
-	config VF_USE_ARM_GLOBAL_TIMER
-		bool "Use ARM Global Timer"
-		depends on ARCH_MULTI_V7
-		select ARM_GLOBAL_TIMER
-		select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
-		help
-		  Use the ARM Global Timer as clocksource
-
-	config VF_USE_PIT_TIMER
-		bool "Use PIT timer"
-		select NXP_PIT_TIMER
-		help
-		  Use SoC Periodic Interrupt Timer (PIT) as clocksource
-
-endchoice
-
 endif
 
 endif
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index d1a33a231a44c3..d9c76dd443f8ac 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -793,4 +793,35 @@ config RTK_SYSTIMER
 	  this option only when building for a Realtek platform or for compilation
 	  testing.
 
+choice
+	prompt "NXP clocksource for scheduler clock"
+	depends on SOC_VF610 || ARCH_S32
+	# Default to Global Timer for Vybrid (32-bit)
+	default VF_USE_ARM_GLOBAL_TIMER if SOC_VF610
+	# Default to None for S32 (64-bit)
+	default VF_TIMER_NONE if ARCH_S32
+
+	config VF_USE_ARM_GLOBAL_TIMER
+		bool "Use NXP Vybrid Global Timer"
+		depends on ARCH_MULTI_V7 && SOC_VF610
+		select ARM_GLOBAL_TIMER
+		select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
+		help
+		  Use the NXP Vybrid Global Timer as clocksource.
+
+	config VF_USE_PIT_TIMER
+		bool "Use NXP PIT timer"
+		select NXP_PIT_TIMER
+		help
+		  Use NXP Periodic Interrupt Timer (PIT) as clocksource.
+
+	config VF_TIMER_NONE
+		bool "None (Use standard Arch Timer)"
+		depends on ARCH_S32
+		help
+		  Do not use any specific NXP timer driver. Use the standard
+		  ARM Architected Timer instead.
+
+endchoice
+
 endmenu
-- 
2.53.0



