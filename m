Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A8E33769A;
	Mon, 18 Aug 2025 14:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525665; cv=none; b=nbHePsjfPWJIKzwpxVdYVwH4OHrCiuwlpV/a2fGqRy8u0QUSje4jk/3uETRiw7R7b5aSyQZ6y2b+KxhmnfVWwf5oPPTSXF52bSqDTGbKzPwOFf/YlNw9vop/uIC54nnFOap1r7GcBmCy5uzC/4MpsfFrx8rqZi22e+Q0tkZrR+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525665; c=relaxed/simple;
	bh=db3x4Tb/up85YdTwhVlxNedjUZ8hfn+2yKQDORz0+s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aR9KxPBnuW9ig8pmaSRerGs+qfuZejUjSMFVk5CWOM1GAsJkQkmvlD5F++1+9qV3SdxR1yhX875Sp+Tb61xGDUcOhpp6LSBDwS43hAgPRF18jo++d4JTrStp6e0wgctRM+wnHLF1ugq7V0a7KGAGOXhcgPZuvYRYyGOGwBm5ntU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW+mRvB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW+mRvB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C494C4CEEB;
	Mon, 18 Aug 2025 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525665;
	bh=db3x4Tb/up85YdTwhVlxNedjUZ8hfn+2yKQDORz0+s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iW+mRvB0YoSV/aN7RBpyhanCOY52TxDw3OnhGzS+R/4lXM6uF8JKwrIAAmtG6+r9P
	 wuqI/YnLJKYb8RKeGkHNh5Ae5ZziJrXV6L2TS2WjYKboiqg5VHR+2i08vsv3X4Elpc
	 M/1hU/Ly0Ct8yX+zOPAi6tOJex00yz0Q8+60oTx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 330/570] net: dsa: b53: ensure BCM5325 PHYs are enabled
Date: Mon, 18 Aug 2025 14:45:17 +0200
Message-ID: <20250818124518.567069070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 966a83df36c6f27476ac3501771422e7852098bc ]

According to the datasheet, BCM5325 uses B53_PD_MODE_CTRL_25 register to
disable clocking to individual PHYs.
Only ports 1-4 can be enabled or disabled and the datasheet is explicit
about not toggling BIT(0) since it disables the PLL power and the switch.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250614080000.1884236-15-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 13 +++++++++++++
 drivers/net/dsa/b53/b53_regs.h   |  5 ++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index dc2f4adac9bc..184946e8cee9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -615,6 +615,19 @@ int b53_setup_port(struct dsa_switch *ds, int port)
 	if (dsa_is_user_port(ds, port))
 		b53_set_eap_mode(dev, port, EAP_MODE_SIMPLIFIED);
 
+	if (is5325(dev) &&
+	    in_range(port, 1, 4)) {
+		u8 reg;
+
+		b53_read8(dev, B53_CTRL_PAGE, B53_PD_MODE_CTRL_25, &reg);
+		reg &= ~PD_MODE_POWER_DOWN_PORT(0);
+		if (dsa_is_unused_port(ds, port))
+			reg |= PD_MODE_POWER_DOWN_PORT(port);
+		else
+			reg &= ~PD_MODE_POWER_DOWN_PORT(port);
+		b53_write8(dev, B53_CTRL_PAGE, B53_PD_MODE_CTRL_25, reg);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_setup_port);
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 1fbc5a204bc7..d31c8ad9a9b6 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -101,8 +101,11 @@
 #define   PORT_OVERRIDE_SPEED_2000M	BIT(6) /* BCM5301X only, requires setting 1000M */
 #define   PORT_OVERRIDE_EN		BIT(7) /* Use the register contents */
 
-/* Power-down mode control */
+/* Power-down mode control (8 bit) */
 #define B53_PD_MODE_CTRL_25		0x0f
+#define  PD_MODE_PORT_MASK		0x1f
+/* Bit 0 also powers down the switch. */
+#define  PD_MODE_POWER_DOWN_PORT(i)	BIT(i)
 
 /* IP Multicast control (8 bit) */
 #define B53_IP_MULTICAST_CTRL		0x21
-- 
2.39.5



