Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6151DDC04;
	Mon, 23 Jun 2025 21:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715004; cv=none; b=Dk3/EwvWEUloecBRGTcBsMmCO8CmjDfMTfJZ11xLZN1uOYC+1wbi4I9qrhjVQrSoTtRcM04nqqZdk08rxiUXooKMXqwb2KSb3yU+JN8H5Vb/N5YqHUM/7sXRaazDl2PwLUMZiO7nN/L2sdbip2utSYWG2qcZI3/L2nW2TU7qhnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715004; c=relaxed/simple;
	bh=rw/z9NhhNP5etsRWjAUArgncQDKcgK715g0Jp5/7DTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSwnG+HraIFWWnHq3NZRqRdN3QzWK/vrIErAewnhc1LQI6oEah92+iX0mVme99F2YxoNGuWUU42XU4iP5hu0s3aDvF+OREwgWQKzwOa4nTDzd2xVNrkifXW4UliTiC5GW5rBQhMfvxc2kVOCgbi9eAlOX0DswSU+1HKnPGxpcGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0Tj4R3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0Tj4R3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F3BC4CEEA;
	Mon, 23 Jun 2025 21:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715004;
	bh=rw/z9NhhNP5etsRWjAUArgncQDKcgK715g0Jp5/7DTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0Tj4R3YZTIrJrmgCK9Dmsew7mMU4BYOmB8I5APxu1cJRvi4RjrYk79lNV5Ubx3wP
	 V0rV5dxzFNNsopFb/ujV09G9rx4s3FqvbezXBf12xXyTQygTOej9WsCWCFg/PTgOXf
	 mms8+BQLKeiug6F2IdRU+akS+XJawyrnuASVs9p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sukrut Bellary <sbellary@baylibre.com>,
	Judith Mendez <jm@ti.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 431/592] ARM: OMAP2+: Fix l4ls clk domain handling in STANDBY
Date: Mon, 23 Jun 2025 15:06:29 +0200
Message-ID: <20250623130710.687405434@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sukrut Bellary <sbellary@baylibre.com>

[ Upstream commit 47fe74098f3dadba2f9cc1e507d813a4aa93f5f3 ]

Don't put the l4ls clk domain to sleep in case of standby.
Since CM3 PM FW[1](ti-v4.1.y) doesn't wake-up/enable the l4ls clk domain
upon wake-up, CM3 PM FW fails to wake-up the MPU.

[1] https://git.ti.com/cgit/processor-firmware/ti-amx3-cm3-pm-firmware/

Signed-off-by: Sukrut Bellary <sbellary@baylibre.com>
Tested-by: Judith Mendez <jm@ti.com>
Link: https://lore.kernel.org/r/20250318230042.3138542-2-sbellary@baylibre.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/clockdomain.h           |  1 +
 arch/arm/mach-omap2/clockdomains33xx_data.c |  2 +-
 arch/arm/mach-omap2/cm33xx.c                | 14 +++++++++++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/clockdomain.h b/arch/arm/mach-omap2/clockdomain.h
index c36fb27212615..86a2f9e5d0ef9 100644
--- a/arch/arm/mach-omap2/clockdomain.h
+++ b/arch/arm/mach-omap2/clockdomain.h
@@ -48,6 +48,7 @@
 #define CLKDM_NO_AUTODEPS			(1 << 4)
 #define CLKDM_ACTIVE_WITH_MPU			(1 << 5)
 #define CLKDM_MISSING_IDLE_REPORTING		(1 << 6)
+#define CLKDM_STANDBY_FORCE_WAKEUP		BIT(7)
 
 #define CLKDM_CAN_HWSUP		(CLKDM_CAN_ENABLE_AUTO | CLKDM_CAN_DISABLE_AUTO)
 #define CLKDM_CAN_SWSUP		(CLKDM_CAN_FORCE_SLEEP | CLKDM_CAN_FORCE_WAKEUP)
diff --git a/arch/arm/mach-omap2/clockdomains33xx_data.c b/arch/arm/mach-omap2/clockdomains33xx_data.c
index 87f4e927eb183..c05a3c07d4486 100644
--- a/arch/arm/mach-omap2/clockdomains33xx_data.c
+++ b/arch/arm/mach-omap2/clockdomains33xx_data.c
@@ -19,7 +19,7 @@ static struct clockdomain l4ls_am33xx_clkdm = {
 	.pwrdm		= { .name = "per_pwrdm" },
 	.cm_inst	= AM33XX_CM_PER_MOD,
 	.clkdm_offs	= AM33XX_CM_PER_L4LS_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
+	.flags		= CLKDM_CAN_SWSUP | CLKDM_STANDBY_FORCE_WAKEUP,
 };
 
 static struct clockdomain l3s_am33xx_clkdm = {
diff --git a/arch/arm/mach-omap2/cm33xx.c b/arch/arm/mach-omap2/cm33xx.c
index acdf72a541c02..a4dd42abda89b 100644
--- a/arch/arm/mach-omap2/cm33xx.c
+++ b/arch/arm/mach-omap2/cm33xx.c
@@ -20,6 +20,9 @@
 #include "cm-regbits-34xx.h"
 #include "cm-regbits-33xx.h"
 #include "prm33xx.h"
+#if IS_ENABLED(CONFIG_SUSPEND)
+#include <linux/suspend.h>
+#endif
 
 /*
  * CLKCTRL_IDLEST_*: possible values for the CM_*_CLKCTRL.IDLEST bitfield:
@@ -328,8 +331,17 @@ static int am33xx_clkdm_clk_disable(struct clockdomain *clkdm)
 {
 	bool hwsup = false;
 
+#if IS_ENABLED(CONFIG_SUSPEND)
+	/*
+	 * In case of standby, Don't put the l4ls clk domain to sleep.
+	 * Since CM3 PM FW doesn't wake-up/enable the l4ls clk domain
+	 * upon wake-up, CM3 PM FW fails to wake-up th MPU.
+	 */
+	if (pm_suspend_target_state == PM_SUSPEND_STANDBY &&
+	    (clkdm->flags & CLKDM_STANDBY_FORCE_WAKEUP))
+		return 0;
+#endif
 	hwsup = am33xx_cm_is_clkdm_in_hwsup(clkdm->cm_inst, clkdm->clkdm_offs);
-
 	if (!hwsup && (clkdm->flags & CLKDM_CAN_FORCE_SLEEP))
 		am33xx_clkdm_sleep(clkdm);
 
-- 
2.39.5



