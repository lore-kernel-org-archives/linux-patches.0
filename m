Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399BF149C53;
	Wed,  5 Feb 2025 14:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764823; cv=none; b=AWwIhYxrJNBuRAwZ2xO+fMVcStgPuye8AWZkDlQVfWI3uMAMFWPVw2QWgVGxLfbc1+7rP2zheI/M9KaLT8MelT/Bv3FVvvKjch0CjWcLIXd7kmPE/ca5g0TEHgBWtAna4krOOF4xGCjwHGOY8iTZjteNjoVUrzxIXcpQ24qnTS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764823; c=relaxed/simple;
	bh=enOz12LOQi6k7KXCOk7VymQG/HHu9fLZH83YeMbH4j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqXx9bD8B6cHyv2YYBGHMuh+FmQkcp/PZzR5Qn8RHWUy/GRYrKtxLny0GY4p3KcSxA02eMAlvJIH5Ve0KtymHiI/rhXQ0PlIrkwYRg2C0oM8bn+OhgRHFuszw0By7b18oOqbn0UhKSq8DUg7fLyiV8Jtu7ZeTiRcT0KgXa3XWFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8pifTxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8pifTxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C601C4CED1;
	Wed,  5 Feb 2025 14:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764823;
	bh=enOz12LOQi6k7KXCOk7VymQG/HHu9fLZH83YeMbH4j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8pifTxtngimNStfOtlN7AOdp0rastpqM7SYJ3ZAGuODCeXf0iED1LqLkD59vHFHC
	 cACwkC4ddLPkGASZCocB0da7u2WPTNhmyC3rXkbNm1hiZmb1rFthwNB0eAybSR1FpQ
	 wJskkfBPxlMDtuQZLC67V20HEoLOeb88Rvo8lYb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/393] ARM: at91: pm: change BU Power Switch to automatic mode
Date: Wed,  5 Feb 2025 14:41:54 +0100
Message-ID: <20250205134427.754738783@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1a26af0fabc71..22ecaf09d00f9 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -591,7 +591,21 @@ static int at91_suspend_finish(unsigned long val)
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
@@ -602,24 +616,19 @@ static void at91_pm_switch_ba_to_vbat(void)
 
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



