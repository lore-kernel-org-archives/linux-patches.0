Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E793A3E7A;
	Fri,  7 Aug 2026 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117024; cv=none; b=ZZ8owlIDAHeOkZ3qNbcmtxHUGxXj1c/ajiP1k2t8e3kH6XCaG7JT6nlBvn1GlA8XMV+1o1JD59iMzDRKKrAXxomM3GCZ8/yyW+bttuHiKqgUHqGY6M8rmSpMgEt39beR3BQav7Jjczljw626Dl8kkkGDQb8LmJ4q+jSyXPWDAlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117024; c=relaxed/simple;
	bh=6MeyMgE3/K6Aj3C8ocaeUvfvWnI4Fq2ZfkXy7HSjMtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmLsNF9dq+CYorhXmEqAtneI012xnlDI7xCQLaCFYI3QxQ2mlKMRPq4KaXSgGUlrjjeTlGS73U2YuYf6xV8OEDUM9Rgen0N+JYlZL/Ulf/e/6Rrzg6M7v4yoeNu6onDURDpe+aGuo06946iuQdKQF8mFna2oRhvblQJ5lU2NWC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY99aN9+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY99aN9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B625E1F000E9;
	Fri,  7 Aug 2026 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117022;
	bh=aIO558YPJ9wvKT/YPtYu9PffgcboiRGALv02jVdh+qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mY99aN9+D+fK7C8ljSETCrB9B2DdZJbNMpn0MdXj8TOlXHFLroNyB/OQXu5QPqBpY
	 HbmyymKeBCE6+mp+8iA9Hiqaju74PDgfzXgqKWUXVhNURVSU5Skp49QSqGc9vZyCwy
	 YdIXSM7W7B86lcTwP9yT1ecOMtH0guaPf0MFTZMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 174/438] net: dsa: mt7530: check bus->read() errors in the MDIO regmap backend
Date: Fri,  7 Aug 2026 16:36:10 +0200
Message-ID: <20260807143431.745917844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 11ea924a9f357..784dd58a71589 100644
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



