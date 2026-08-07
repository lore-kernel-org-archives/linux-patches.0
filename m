Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E57429CE0;
	Fri,  7 Aug 2026 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114039; cv=none; b=AdpD2yKL0WBlXEOXmji3knwBWHw4HecccPRQaoJlT/a8BE0gOEpqMjjdx7NBq1XX9dgdn0tnZts3QWY++7ujDGpwIVAdpk7tK1l7KgAK4c/c7458r5zVpUSXxWJIDxzm/Oy2c1jwXEUoprNQ/oYkF0RbBCdATEKC/UwLpXIQkV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114039; c=relaxed/simple;
	bh=nP/DlsTZj+PYGLPvpdJbHaaunBKerQwkwhOm8r5SIAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWLSxGFAGUhjhmH0dG2qw3k/t1DAT9f1hOiwaJEN/YJUxSD8/KSd7K0kfhNY6AXoSh6I4qEaByKUmGET+60nejXlKZf7abHQwTRTzDLqiThsntQJ2+esr2ZeynrKGTsv0Mn10Gs48xVih9IhVg3skbJoR0ajLjA59tvxu8l3qhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4/yPeK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4/yPeK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FCD1F00A3A;
	Fri,  7 Aug 2026 14:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114037;
	bh=Dn+qK0rjlzVuicZeaRXBskZvmc6LTFkgBlzeOdeNfl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4/yPeK/kBWDlMOFIWAUZjvGjjwxL5ql1IIy3oUb9XYRiMPM3r6C4EmeJeTIrwfVH
	 GubNmfDYZdWtTgLe3lHgxnpGfdPK56+FmRr/00xRo2WMNf/cpZjAMl9Jo/mRjHUwc3
	 M/0vNXABPVd2bdvEe0UkQ0oFnY+uJwgbQPHI1+X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/337] net: dsa: mt7530: check bus->read() errors in the MDIO regmap backend
Date: Fri,  7 Aug 2026 16:35:23 +0200
Message-ID: <20260807143421.132624785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit b4ce102b2cd88424c5860fbbb20b9eb343a93bf4 ]

bus->read() returns a negative errno on failure, but
mt7530_regmap_read() assigns it to a u16, truncating e.g. -ETIMEDOUT
into 0xff92, and returns success. The garbage word is then consumed as
register data, and read-modify-write cycles write it back to the
switch. Check both reads and propagate their errors.

The same defect existed in mt7530_mii_read() since the driver was
introduced and moved into the regmap backend unchanged.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/3c628e48276c2e5522c8795a6be60d11c7a76a7d.1785213071.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530-mdio.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
index 51df42ccdbe62..e19b46449ffe6 100644
--- a/drivers/net/dsa/mt7530-mdio.c
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -55,8 +55,15 @@ mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
 	if (ret < 0)
 		return ret;
 
-	lo = bus->read(bus, priv->mdiodev->addr, r);
-	hi = bus->read(bus, priv->mdiodev->addr, 0x10);
+	ret = bus->read(bus, priv->mdiodev->addr, r);
+	if (ret < 0)
+		return ret;
+	lo = ret;
+
+	ret = bus->read(bus, priv->mdiodev->addr, 0x10);
+	if (ret < 0)
+		return ret;
+	hi = ret;
 
 	*val = (hi << 16) | (lo & 0xffff);
 
-- 
2.53.0



