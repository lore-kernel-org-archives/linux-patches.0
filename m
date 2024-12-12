Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944492248A4;
	Thu, 12 Dec 2024 17:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025585; cv=none; b=Wlj4cDdBIesImh3+AvadXpJdMBB2MciKn8Twja2Httzc7u7ae5yVsd0ztHtseZf7jccBcF7kbwmUtxsX5YKz8EisU7W7kzHdAr2SjjEgwz0M6RFyA30EaCJuulW0RnWj1GIqmRmgWQtLPX7+fteG+bzEekSq2CSMwmNxDLDX9JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025585; c=relaxed/simple;
	bh=hP7hW1cYSLGnEkYC/FiOhuAg6eLTTnWNwfdr1Z9Y02I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1Ksr7fFpRhkUED1PP4MAndmj4qzX9yx6cRRGV0Q14Lf1DM7bgVHnLRZWenn7rF35FuEAk/KlKzPx+G3G86Np1ngEGNEvPTxkchfMRIwzN1lOx6zCD20j1pk0iQZtk43uVKoUYOpSpNCGEaxJWhICDcHU13hTDlWRpYjS2qzw3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Voi5lIEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Voi5lIEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B5DC4CECE;
	Thu, 12 Dec 2024 17:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025585;
	bh=hP7hW1cYSLGnEkYC/FiOhuAg6eLTTnWNwfdr1Z9Y02I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Voi5lIEiqDa3FsksIjztXWOE7pW7tc6bLlClPF2cBBF7PHvg1DNMhxqG5lfFCfzpN
	 Rui/yIG+VUE3TdGNK9SPiW9KDbu5N0pv5+W8B2kYPiPm9tRgZVo2lMXjBW10UxUJA6
	 +k+jXjHlcjVCOE0u6Wd3A3J9Hn3PVWEMWlX4R8Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Ocheretnyi <oocheret@cisco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 219/321] iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call
Date: Thu, 12 Dec 2024 16:02:17 +0100
Message-ID: <20241212144238.631484417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksandr Ocheretnyi <oocheret@cisco.com>

[ Upstream commit daa814d784ac034c62ab3fb0ef83daeafef527e2 ]

Commit da23b6faa8bf ("watchdog: iTCO: Add support for Cannon Lake
PCH iTCO") does not mask NMI_NOW bit during TCO1_CNT register's
value comparison for update_no_reboot_bit() call causing following
failure:

   ...
   iTCO_vendor_support: vendor-support=0
   iTCO_wdt iTCO_wdt: unable to reset NO_REBOOT flag, device
                                    disabled by hardware/BIOS
   ...

and this can lead to unexpected NMIs later during regular
crashkernel's workflow because of watchdog probe call failures.

This change masks NMI_NOW bit for TCO1_CNT register values to
avoid unexpected NMI_NOW bit inversions.

Fixes: da23b6faa8bf ("watchdog: iTCO: Add support for Cannon Lake PCH iTCO")
Signed-off-by: Oleksandr Ocheretnyi <oocheret@cisco.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20240913191403.2560805-1-oocheret@cisco.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/iTCO_wdt.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 134237d8b8fca..c03df400ffb90 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -83,6 +83,13 @@
 #define TCO2_CNT(p)	(TCOBASE(p) + 0x0a) /* TCO2 Control Register	*/
 #define TCOv2_TMR(p)	(TCOBASE(p) + 0x12) /* TCOv2 Timer Initial Value*/
 
+/*
+ * NMI_NOW is bit 8 of TCO1_CNT register
+ * Read/Write
+ * This bit is implemented as RW but has no effect on HW.
+ */
+#define NMI_NOW		BIT(8)
+
 /* internal variables */
 struct iTCO_wdt_private {
 	struct watchdog_device wddev;
@@ -221,13 +228,23 @@ static int update_no_reboot_bit_cnt(void *priv, bool set)
 	struct iTCO_wdt_private *p = priv;
 	u16 val, newval;
 
-	val = inw(TCO1_CNT(p));
+	/*
+	 * writing back 1b1 to NMI_NOW of TCO1_CNT register
+	 * causes NMI_NOW bit inversion what consequently does
+	 * not allow to perform the register's value comparison
+	 * properly.
+	 *
+	 * NMI_NOW bit masking for TCO1_CNT register values
+	 * helps to avoid possible NMI_NOW bit inversions on
+	 * following write operation.
+	 */
+	val = inw(TCO1_CNT(p)) & ~NMI_NOW;
 	if (set)
 		val |= BIT(0);
 	else
 		val &= ~BIT(0);
 	outw(val, TCO1_CNT(p));
-	newval = inw(TCO1_CNT(p));
+	newval = inw(TCO1_CNT(p)) & ~NMI_NOW;
 
 	/* make sure the update is successful */
 	return val != newval ? -EIO : 0;
-- 
2.43.0



