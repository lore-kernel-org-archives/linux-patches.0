Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1DA1E04B8;
	Wed, 19 Feb 2025 09:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956301; cv=none; b=ezXTNmzSpbwjVFuwsaSaFrz/RmHYa9TyuuyZiXmFIoF9Z0JBQvvx/HpB3YzvIQ2G2ZY79tESccXYoBxV7ciAOM9r8HIFo9G4wMt+xyBCugRoPHBf9WN9V+yPzPDiF7qDv3C17HwMbHkc+HY4yzX2p0WwiveA9WTlrUIjEbWHkoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956301; c=relaxed/simple;
	bh=1b2zgfAk8amWlrXjLhGNXUofs9YO2ciz/l/MIOmZ8UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdifai9U84XY+89y4d4R/djCwe8ai9h8LRBb8+Gdf/+SAuqFrgbX4lRd/C117cAR2mtsYAs9OU3z0LLZ/GVefPnpJxO4Vjpnzy4Uvtyq32rMoY/xVqopslbUxsALttnwUqeAod7009bROyQpq9M+MkOv+Cn/XURID07H3UFAJTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekUbh0gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekUbh0gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E736C4CED1;
	Wed, 19 Feb 2025 09:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956300;
	bh=1b2zgfAk8amWlrXjLhGNXUofs9YO2ciz/l/MIOmZ8UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekUbh0gsBWk5wZIi6F/yeV0xCDH//FLgovYP1ZfyrD/7i6LSLBWqF6mG6TFjrMbQP
	 whAtFciYIU7AL0NGO9WvWSJz3J1i8AEdrGJEamh8kRuiNTFnIWyA4gUuhAETgj7I0h
	 /ekO6xv66Fjp9BXQA6PRYom+JzWw6RS5aKNKvfJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/578] ARM: at91: pm: change BU Power Switch to automatic mode
Date: Wed, 19 Feb 2025 09:22:17 +0100
Message-ID: <20250219082658.221243004@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 6fc5bdfa872b7da51b5507a1327a17c3db2fcf95 ]

Change how the Backup Unit Power is configured and force the
automatic/hardware mode.
This change eliminates the need for software management of the power
switch, ensuring it transitions to the backup power source before
entering low power modes.

This is done in the only location where this switch was configured. It's
usually done in the bootloader.

Previously, the loss of the VDDANA (or VDDIN33) power source was not
automatically compensated by an alternative power source. This resulted
in the loss of Backup Unit content, including Backup Self-refresh low
power mode information, OTP emulation configuration, and boot
configuration, for instance.

Fixes: ac809e7879b1 ("ARM: at91: pm: switch backup area to vbat in backup mode")
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20241125165648.509162-1-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 437dd0352fd44..4d0d0d49a7442 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -590,7 +590,21 @@ static int at91_suspend_finish(unsigned long val)
 	return 0;
 }
 
-static void at91_pm_switch_ba_to_vbat(void)
+/**
+ * at91_pm_switch_ba_to_auto() - Configure Backup Unit Power Switch
+ * to automatic/hardware mode.
+ *
+ * The Backup Unit Power Switch can be managed either by software or hardware.
+ * Enabling hardware mode allows the automatic transition of power between
+ * VDDANA (or VDDIN33) and VDDBU (or VBAT, respectively), based on the
+ * availability of these power sources.
+ *
+ * If the Backup Unit Power Switch is already in automatic mode, no action is
+ * required. If it is in software-controlled mode, it is switched to automatic
+ * mode to enhance safety and eliminate the need for toggling between power
+ * sources.
+ */
+static void at91_pm_switch_ba_to_auto(void)
 {
 	unsigned int offset = offsetof(struct at91_pm_sfrbu_regs, pswbu);
 	unsigned int val;
@@ -601,24 +615,19 @@ static void at91_pm_switch_ba_to_vbat(void)
 
 	val = readl(soc_pm.data.sfrbu + offset);
 
-	/* Already on VBAT. */
-	if (!(val & soc_pm.sfrbu_regs.pswbu.state))
+	/* Already on auto/hardware. */
+	if (!(val & soc_pm.sfrbu_regs.pswbu.ctrl))
 		return;
 
-	val &= ~soc_pm.sfrbu_regs.pswbu.softsw;
-	val |= soc_pm.sfrbu_regs.pswbu.key | soc_pm.sfrbu_regs.pswbu.ctrl;
+	val &= ~soc_pm.sfrbu_regs.pswbu.ctrl;
+	val |= soc_pm.sfrbu_regs.pswbu.key;
 	writel(val, soc_pm.data.sfrbu + offset);
-
-	/* Wait for update. */
-	val = readl(soc_pm.data.sfrbu + offset);
-	while (val & soc_pm.sfrbu_regs.pswbu.state)
-		val = readl(soc_pm.data.sfrbu + offset);
 }
 
 static void at91_pm_suspend(suspend_state_t state)
 {
 	if (soc_pm.data.mode == AT91_PM_BACKUP) {
-		at91_pm_switch_ba_to_vbat();
+		at91_pm_switch_ba_to_auto();
 
 		cpu_suspend(0, at91_suspend_finish);
 
-- 
2.39.5



