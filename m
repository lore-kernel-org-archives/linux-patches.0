Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C2F216E3B;
	Thu, 12 Dec 2024 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024523; cv=none; b=nWJ/Vglm7V2l1ZJhf/zLbpnMXSmZ1iZyBTsD0dEakVVpzf16y4q9kjP9woMU2q72IbdbxlV3AcdxSLOUAW1fOGulUtukdzXF3mWWRAq77QCpt5VY+fJoiQvRXdJAYTpFdf69BD1aACGuPF+UmwKIhi67E9AJE7mx4tJ3KotELO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024523; c=relaxed/simple;
	bh=jjawJkUTeHLTc7VwnKKLcZsiWs/Dmjm7vGM0LBKxPio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9uaKtPZAHAR9Wm32r4mwtBdhZHzQM5vZ6SRZcC3fAzS4dI6DG7WlnwWTS1w/2fp61XevLbZ6SJ9BBtIUMVmo1KdIp+u5evA2j1jKbBmPLDo5tiJ9We8Tt5zdwqJYH0eoJZi5K0NDYMOXyKxy33xp/rstMNnh/GQ/Dryx7mh9Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rg2oQ9sK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rg2oQ9sK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01108C4CED0;
	Thu, 12 Dec 2024 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024523;
	bh=jjawJkUTeHLTc7VwnKKLcZsiWs/Dmjm7vGM0LBKxPio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rg2oQ9sKmrmfy6jCdbu0buHtTv9yQtX5rMSxQj6jALbUAb55keNFjJhqmo/NR7coI
	 BUWVnsul7+UOSkQf2xSjL5kfypEYUTm4aAOZoIkcGxcz2k3Wjx+EM+t2RfvcCkjqL8
	 j41+8qAq4RvU4phy5VhTtdNZHNCGbEraT82hEfvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Ocheretnyi <oocheret@cisco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/459] iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call
Date: Thu, 12 Dec 2024 16:01:03 +0100
Message-ID: <20241212144306.499456188@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 50c874d488607..5f5586b0dd676 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -84,6 +84,13 @@
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
@@ -222,13 +229,23 @@ static int update_no_reboot_bit_cnt(void *priv, bool set)
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



