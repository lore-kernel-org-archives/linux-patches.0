Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AEF22B5AD;
	Mon, 10 Mar 2025 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628872; cv=none; b=K6hLM/fXV+/ydFjMibKS4PwvmrXn0lcm5PH7qkU+ea1cTrxvFR8oPq4nXZPixU68XKJJ2irUMNZRgQiAvKw4Ly9e+dpSPPseCyggyObrdB7sOBbJMWhipgKEGcX56y51Rx14xEh6psLC3MOcd1uLdFeWWfmAdyAzwg38rt98uS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628872; c=relaxed/simple;
	bh=BubPlfCpChbVtKfCxymN9B0MsUDv1tpetQ8sv2WaYOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjiUc2edU2kk7ykpvK+kAb83dTed3VdyI26DA4ez62hLCdPNSwE/NeePtsHpvI9VqLwizNnFq9vuwB+fVMjA1hrNGlnKZMDfaHCHtfjmRr+0WkvY8f+62iVoRcv38KnOihGxc7pX5ydCtwLyOgmmnu5v02+ycRFg9Mll4bIvn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pptg9Ihb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pptg9Ihb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A429C4CEE5;
	Mon, 10 Mar 2025 17:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628872;
	bh=BubPlfCpChbVtKfCxymN9B0MsUDv1tpetQ8sv2WaYOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pptg9IhbEiuL04sKOBQ2pithA5dw/XK8UWCoxglZ2dU509dPGtb1U2o/DT7fkZFF3
	 wey3juOGbm2XhUB946sFaWaBoSew19DpI3auHaXC0D8nUy1JAayhP5GCh8AHqwB++x
	 i5SX1TeHJ1oJyaqEvlFqKAxmwdGrtOj1yBfTXfwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/620] ARM: at91: pm: change BU Power Switch to automatic mode
Date: Mon, 10 Mar 2025 17:59:04 +0100
Message-ID: <20250310170549.447129827@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c8cc993ca8ca1..91efc3d4de61d 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -403,7 +403,21 @@ static int at91_suspend_finish(unsigned long val)
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
@@ -414,24 +428,19 @@ static void at91_pm_switch_ba_to_vbat(void)
 
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



