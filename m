Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279172080FC;
	Thu, 12 Dec 2024 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015749; cv=none; b=JBzCA835LcMzalKfxGTLAug2+dsjAFa4nlKqB3xmWGznswcj6IdktTorXL+pNV3bm7J+YPMy0ijJkVp92VAqFTuUm4Q55VkyWJNDUbC7TtJ4cBLWyYM3PtrePgFP6nyvTKcFN36nzIuUcEyKlk4yNkAhXxuaIv7zgXXuAddIj74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015749; c=relaxed/simple;
	bh=yA2gsTYoOiyuMWGihVxbon3gNPRBsQnLiy0Lr03d0/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgHinEOjVisKNMFQT4/h0l84r5B1mt6bKwA5+PzMCxEl6/YTulNNfSTOyLX5olD4hCUytAy8Ugfe56W1MVzgttqOx2VKtJsI1llFUe5+4fvcZ2VSasULFYn7a4vriPDmFNY8KmIjI+S6/anl3+0FZPAZoTOuNHH/C+2XAFWp0FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzS5n1dZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzS5n1dZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9FEC4CECE;
	Thu, 12 Dec 2024 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015746;
	bh=yA2gsTYoOiyuMWGihVxbon3gNPRBsQnLiy0Lr03d0/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzS5n1dZISp2CHYRbieu1POjd01T+IYcTdUi2eMzoXcfuiWl8utAbLkzFHt9dMhNO
	 AjwukmjRdMHQrG9TxorZsRFLSIiMssSwhQZjQZnTxiLBICmJ2zvv7kOAQ58M2RGASd
	 Asqz/KURuvm8HlGgGkkE1bU1KHkBiIGi53gwf95E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Ocheretnyi <oocheret@cisco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/466] iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call
Date: Thu, 12 Dec 2024 15:52:50 +0100
Message-ID: <20241212144306.714925079@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 35b358bcf94ce..f01ed38aba675 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -82,6 +82,13 @@
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
@@ -219,13 +226,23 @@ static int update_no_reboot_bit_cnt(void *priv, bool set)
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



