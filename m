Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB0932C944;
	Fri, 17 Oct 2025 15:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714296; cv=none; b=EWFiwzy3mcC1WOebPXJChLPZYGyef1VRP1ecNpPbSg4N/l3iSXsyAuRsb7EbvTEYE9srACxBERZGvZ86dMURwborr0MxGNgTLgQbOSgWkpL4SGPuqhDfi00SC6HJS6MYL9HqEAWz0UCksD2FksFBx+WnIBx2Lwm40iwGhbzwlDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714296; c=relaxed/simple;
	bh=km4XBRzLhW/nePTDlMZDuHDJVJTQCwgae1yU2kvkyVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBsZhpfGjZZwTuEqxp2pkg/Z6Gdn54F4djQ9fKngFaKJi7D9F3yOWGb70gMaegyGUjTgz64cBNOUb3lReTXNeU9EZDkvCWYiYpjbp2VqgbO6J3i9h6ZOgFvIkbdaDUCH+KXe5a7LUSR1C4c8JwKgFDaEwptbKNfN4yo9QAvLEmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06tuOmrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06tuOmrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8427C16AAE;
	Fri, 17 Oct 2025 15:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714296;
	bh=km4XBRzLhW/nePTDlMZDuHDJVJTQCwgae1yU2kvkyVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06tuOmrkgdv7/aTtk+xACAmAAt79Wd8LOdK9GjMn+j+QXKyQdIfQ4G29ElKHHdtoU
	 vGMT0w4wM6fA/YNLgltloCQ5iYAJ1/JhVaIY+dqPTceg8qzedbfvIIqomq3Vb0IQqI
	 2wrDngsW5mB6vqhdVXT39OhQxtcBgWjpUcJtvYo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 6.12 094/277] ARM: AM33xx: Implement TI advisory 1.0.36 (EMU0/EMU1 pins state on reset)
Date: Fri, 17 Oct 2025 16:51:41 +0200
Message-ID: <20251017145150.566289539@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 8a6506e1ba0d2b831729808d958aae77604f12f9 upstream.

There is an issue possible where TI AM33xx SoCs do not boot properly after
a reset if EMU0/EMU1 pins were used as GPIO and have been driving low level
actively prior to reset [1].

"Advisory 1.0.36 EMU0 and EMU1: Terminals Must be Pulled High Before
ICEPick Samples

The state of the EMU[1:0] terminals are latched during reset to determine
ICEPick boot mode. For normal device operation, these terminals must be
pulled up to a valid high logic level ( > VIH min) before ICEPick samples
the state of these terminals, which occurs
[five CLK_M_OSC clock cycles - 10 ns] after the falling edge of WARMRSTn.

Many applications may not require the secondary GPIO function of the
EMU[1:0] terminals. In this case, they would only be connected to pull-up
resistors, which ensures they are always high when ICEPick samples.
However, some applications may need to use these terminals as GPIO where
they could be driven low before reset is asserted. This usage of the
EMU[1:0] terminals may require special attention to ensure the terminals
are allowed to return to a valid high-logic level before ICEPick samples
the state of these terminals.

When any device reset is asserted, the pin mux mode of EMU[1:0] terminals
configured to operate as GPIO (mode 7) will change back to EMU input
(mode 0) on the falling edge of WARMRSTn. This only provides a short period
of time for the terminals to return high if driven low before reset is
asserted...

If the EMU[1:0] terminals are configured to operate as GPIO, the product
should be designed such these terminals can be pulled to a valid high-logic
level within 190 ns after the falling edge of WARMRSTn."

We've noticed this problem with custom am335x hardware in combination with
recently implemented cold reset method
(commit 6521f6a195c70 ("ARM: AM33xx: PRM: Implement REBOOT_COLD")).
It looks like the problem can affect other HW, for instance AM335x
Chiliboard, because the latter has LEDs on GPIO3_7/GPIO3_8 as well.

One option would be to check if the pins are in GPIO mode and either switch
to output active high, or switch to input and poll until the external
pull-ups have brought the pins to the desired high state. But fighting
with GPIO driver for these pins is probably not the most straight forward
approch in a reboot handler.

Fortunately we can easily control pinmuxing here and rely on the external
pull-ups. TI recommends 4k7 external pull up resistors [2] and even with
quite conservative estimation for pin capacity (1 uF should never happen)
the required delay shall not exceed 5ms.

[1] Link: https://www.ti.com/lit/pdf/sprz360
[2] Link: https://e2e.ti.com/support/processors-group/processors/f/processors-forum/866346/am3352-emu-1-0-questions

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20250717152708.487891-1-alexander.sverdlin@siemens.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap2/am33xx-restart.c |   36 +++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/arch/arm/mach-omap2/am33xx-restart.c
+++ b/arch/arm/mach-omap2/am33xx-restart.c
@@ -2,12 +2,46 @@
 /*
  * am33xx-restart.c - Code common to all AM33xx machines.
  */
+#include <dt-bindings/pinctrl/am33xx.h>
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/reboot.h>
 
 #include "common.h"
+#include "control.h"
 #include "prm.h"
 
+/*
+ * Advisory 1.0.36 EMU0 and EMU1: Terminals Must be Pulled High Before
+ * ICEPick Samples
+ *
+ * If EMU0/EMU1 pins have been used as GPIO outputs and actively driving low
+ * level, the device might not reboot in normal mode. We are in a bad position
+ * to override GPIO state here, so just switch the pins into EMU input mode
+ * (that's what reset will do anyway) and wait a bit, because the state will be
+ * latched 190 ns after reset.
+ */
+static void am33xx_advisory_1_0_36(void)
+{
+	u32 emu0 = omap_ctrl_readl(AM335X_PIN_EMU0);
+	u32 emu1 = omap_ctrl_readl(AM335X_PIN_EMU1);
+
+	/* If both pins are in EMU mode, nothing to do */
+	if (!(emu0 & 7) && !(emu1 & 7))
+		return;
+
+	/* Switch GPIO3_7/GPIO3_8 into EMU0/EMU1 modes respectively */
+	omap_ctrl_writel(emu0 & ~7, AM335X_PIN_EMU0);
+	omap_ctrl_writel(emu1 & ~7, AM335X_PIN_EMU1);
+
+	/*
+	 * Give pull-ups time to load the pin/PCB trace capacity.
+	 * 5 ms shall be enough to load 1 uF (would be huge capacity for these
+	 * pins) with TI-recommended 4k7 external pull-ups.
+	 */
+	mdelay(5);
+}
+
 /**
  * am33xx_restart - trigger a software restart of the SoC
  * @mode: the "reboot mode", see arch/arm/kernel/{setup,process}.c
@@ -18,6 +52,8 @@
  */
 void am33xx_restart(enum reboot_mode mode, const char *cmd)
 {
+	am33xx_advisory_1_0_36();
+
 	/* TODO: Handle cmd if necessary */
 	prm_reboot_mode = mode;
 


