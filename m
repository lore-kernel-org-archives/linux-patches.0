Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E341F4628;
	Mon, 23 Jun 2025 21:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715457; cv=none; b=tT3/ysXRvJqd+BKc0qEbo5rqzGqZamydETFlZfNypr4yU1lyHLwE3pw9QsDrZa7Fkmd4gcDHDn209aoK1xZ+iD1GPS2JkXElhne5K2ztDz2a5HYf9LIdvgTVkHFuWaGmQ8YvX1JlzpYHhTZLiW4hcxWatJGWeDzi9imVV3pKhK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715457; c=relaxed/simple;
	bh=H0pdb09Pr1KauIxf6kggPe2uqV++eI4keTuQIU6rdbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGvI/MpvdOEaTa693LLoQ9zMi8ocILuaF0intj7cdgNhjoqEQS727Y4lJACBiszTuiRJ8d/wI4QJALKjRg30TnUa6W7ZOHE55pUy/GuPXwtiLdSswoF90DFAx8+5D6xyJYrNn9gJ4Ib+h85lX4QuhqE2Q6Op+kLbJx5E+k7zaWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4CzA8EG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4CzA8EG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DFDC4CEEA;
	Mon, 23 Jun 2025 21:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715457;
	bh=H0pdb09Pr1KauIxf6kggPe2uqV++eI4keTuQIU6rdbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4CzA8EGz/5qb9wr724luaMHnfyO/lCGTZI+dUEBqFnKRSQI6tY4RB7rQvug5Ku+a
	 CStax/La2s9ChV3g8WdPYD76KtwCrX+qf42EzqCWzF8OAtewBXTh8g18OzerND/5qj
	 7aAwd/gOtIkfufuuX01A7zz8vCVFSpMOM9fAnWH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sukrut Bellary <sbellary@baylibre.com>,
	Judith Mendez <jm@ti.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/355] ARM: OMAP2+: Fix l4ls clk domain handling in STANDBY
Date: Mon, 23 Jun 2025 15:07:57 +0200
Message-ID: <20250623130635.071650024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 68550b23c938d..eb6ca2ea80679 100644
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
index b4d5144df4454..c53df9d42ecf8 100644
--- a/arch/arm/mach-omap2/clockdomains33xx_data.c
+++ b/arch/arm/mach-omap2/clockdomains33xx_data.c
@@ -27,7 +27,7 @@ static struct clockdomain l4ls_am33xx_clkdm = {
 	.pwrdm		= { .name = "per_pwrdm" },
 	.cm_inst	= AM33XX_CM_PER_MOD,
 	.clkdm_offs	= AM33XX_CM_PER_L4LS_CLKSTCTRL_OFFSET,
-	.flags		= CLKDM_CAN_SWSUP,
+	.flags		= CLKDM_CAN_SWSUP | CLKDM_STANDBY_FORCE_WAKEUP,
 };
 
 static struct clockdomain l3s_am33xx_clkdm = {
diff --git a/arch/arm/mach-omap2/cm33xx.c b/arch/arm/mach-omap2/cm33xx.c
index ac4882ebdca33..be84c6750026e 100644
--- a/arch/arm/mach-omap2/cm33xx.c
+++ b/arch/arm/mach-omap2/cm33xx.c
@@ -28,6 +28,9 @@
 #include "cm-regbits-34xx.h"
 #include "cm-regbits-33xx.h"
 #include "prm33xx.h"
+#if IS_ENABLED(CONFIG_SUSPEND)
+#include <linux/suspend.h>
+#endif
 
 /*
  * CLKCTRL_IDLEST_*: possible values for the CM_*_CLKCTRL.IDLEST bitfield:
@@ -336,8 +339,17 @@ static int am33xx_clkdm_clk_disable(struct clockdomain *clkdm)
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



