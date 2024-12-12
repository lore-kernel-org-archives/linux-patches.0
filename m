Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5A42153F0;
	Thu, 12 Dec 2024 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017424; cv=none; b=ZyFZ6BtXoaESa635RpVB7TpSJ3et0tmGUqGlwh5tV1XBs061k03cmgTNmpI1X+CJI5Wa/921AukJY5t6faTfmV+g2E3p7ee/zF2k/68FE6xeazRVQp4LCqQLEFHgImv1eo6qddMme1GzBY6NLESVSAQa32SlWLDwrj7M8dqYUO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017424; c=relaxed/simple;
	bh=w6fAE0lHvRP6rPNNndR56I6Dj6X2BQdLYTDjPi0E/7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/044OxjqNOwzzcJ3E/BtQIX6KJ9vp1zY00lzAycdtZIws88ImhWpqKlyGps7oyfwRy9/tmxry45ld6FH0JkVyDTvHStp/1P+GbIESida2vYPK4iK0SlblTnWnOe8yl+SsDNMBSanwnX6ptJeF369YRvR4FIlD3+n279GT4VBhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrpzMhRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrpzMhRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA21C4CECE;
	Thu, 12 Dec 2024 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017423;
	bh=w6fAE0lHvRP6rPNNndR56I6Dj6X2BQdLYTDjPi0E/7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrpzMhRaTH02JwDICQIz9QDS3K9WCf+BaFgZAbERrR5wkRPEcqMiQ3olOJTUiZWOc
	 JQTbpcF2nYe39HVWbQ6V9J7LZqqWDA0FOVzhRPH+7KLIBGZBECFm2C5Z/Mld2F3wnJ
	 P/KH5W1witW72OQpKCsHfwVKKTiH+Jd/cVFB7j2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Ocheretnyi <oocheret@cisco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/356] iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call
Date: Thu, 12 Dec 2024 15:55:20 +0100
Message-ID: <20241212144244.666739043@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 264857d314da8..dd297dcd524c9 100644
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



