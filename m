Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA0D17B51F;
	Wed,  3 Jul 2024 11:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006004; cv=none; b=nHi98iLOpWKxMJjeAXcwUvUMlDFTARJG95IBNph5KVtNZCMnkdse9DnKiLy4+Jrey6iPTIBSUCwoNsHUxHh02KZdm/uqFu5sFe5i/AbmgocpNlKsFOcIJp08tKEEaqHCpsStzM68k9PjlDkgqfyY+DuOns6WnaOrlKU5Dka6fe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006004; c=relaxed/simple;
	bh=r5bLIATfS70mNEf5PUJVZHNiCcAqzhy/0OJ1X5AQoNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwJyzEuy08sIxVOsGffzoKeO1uTAmbEEAhaaJjRPwJLlu71cEOVWsinqOOHkTzEz2rWeuwf7Sub/iCWJUmSTuTAPYwHq/5wbrvzhn4O3Tv8WUEt1dvarZrqkBjXzoKqoLptquEkw9INfc8S1mXNZnAzmRG9dJXpcp+5aVROrZX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Olz3DqUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Olz3DqUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69409C2BD10;
	Wed,  3 Jul 2024 11:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006003;
	bh=r5bLIATfS70mNEf5PUJVZHNiCcAqzhy/0OJ1X5AQoNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Olz3DqUlUKYFXG1rq/OKltuBAcX/S2EtHjJoxfbM/2fZgl3Vz937CG/xheM6GTVeK
	 HWJpV0sMYq4VpTpfC2W0rK0ccJjf5VN4D/26pQOECYxEAGy8uFNmVsJpgWwff5+G87
	 VwS6CzTKxFQlsjappg/Qf9BSIjV3PxTfmIcPtJ3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/356] net: mdio: add helpers to extract clause 45 regad and devad fields
Date: Wed,  3 Jul 2024 12:40:04 +0200
Message-ID: <20240703102923.255373706@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit c6af53f038aa32cec12e8a305ba07c7ef168f1b0 ]

Add a couple of helpers and definitions to extract the clause 45 regad
and devad fields from the regnum passed into MDIO drivers.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 8851346912a1 ("net: stmmac: Assign configured channel value to EXTTS event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mdio.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 5e6dc38f418e4..3a6ff4e7284a8 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -7,6 +7,7 @@
 #define __LINUX_MDIO_H__
 
 #include <uapi/linux/mdio.h>
+#include <linux/bitfield.h>
 #include <linux/mod_devicetable.h>
 
 /* Or MII_ADDR_C45 into regnum for read/write on mii_bus to enable the 21 bit
@@ -14,6 +15,7 @@
  */
 #define MII_ADDR_C45		(1<<30)
 #define MII_DEVADDR_C45_SHIFT	16
+#define MII_DEVADDR_C45_MASK	GENMASK(20, 16)
 #define MII_REGADDR_C45_MASK	GENMASK(15, 0)
 
 struct gpio_desc;
@@ -355,6 +357,16 @@ static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
 	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
 }
 
+static inline u16 mdiobus_c45_regad(u32 regnum)
+{
+	return FIELD_GET(MII_REGADDR_C45_MASK, regnum);
+}
+
+static inline u16 mdiobus_c45_devad(u32 regnum)
+{
+	return FIELD_GET(MII_DEVADDR_C45_MASK, regnum);
+}
+
 static inline int __mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
 				     u16 regnum)
 {
-- 
2.43.0



