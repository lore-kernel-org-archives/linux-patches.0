Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF8D340D93;
	Tue, 26 Aug 2025 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214493; cv=none; b=qAq/U9QgVXAP4Ll9hlMeBgLb8yroqyFZ2xbVbICyOVA1Mg6/Ow4dSCtGXXcOfhIq6DikZoQvRaihyDF4+ysgCGBRqdEs1QcwV224ncTFEz/xjxXhodnS+CJjFVBcS/g3bWUCWCjpAQ2jNW9fqalvMipHaek9E4d+eklEdHF+C3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214493; c=relaxed/simple;
	bh=eT8tWcepzU8zOlWvv/p1ckc6toVPHGsOVqPtHCy5ukk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqBeGj41M3dd7z60gNS/G7xZdjjPjxs5e+zv95H/r9ByHI4Nukg882rSW98FBfKK8sD3ErjcqVOldzHMxjEjjCWRnGBr4XFWYB9G4YaeYOOsEQ/1Waka/Mhd24s+WmpJX7MIxC9825YI31RiTxZxrbz9v5xrstlyN6oWAvJ/Aok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+H46zlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+H46zlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56DFC4CEF1;
	Tue, 26 Aug 2025 13:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214493;
	bh=eT8tWcepzU8zOlWvv/p1ckc6toVPHGsOVqPtHCy5ukk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+H46zlPT+YzsldO9JiBr9MFQbPY8/hdVB9b77m9WtGj7SPi1fd02GDiZaoYI0r2Z
	 tCwjLYifJMBYf6H7jiiBtxAjrksJhpo/w/mvS79IRpFaxODOur0opOr84271Vxmfbi
	 WZiGAIMYlO93C+Clrm3ri99eDPN57N3V+ad/c7yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/482] net: dsa: b53: prevent GMII_PORT_OVERRIDE_CTRL access on BCM5325
Date: Tue, 26 Aug 2025 13:06:52 +0200
Message-ID: <20250826110934.740219501@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 37883bbc45a8555d6eca88d3a9730504d2dac86c ]

BCM5325 doesn't implement GMII_PORT_OVERRIDE_CTRL register so we should
avoid reading or writing it.
PORT_OVERRIDE_RX_FLOW and PORT_OVERRIDE_TX_FLOW aren't defined on BCM5325
and we should use PORT_OVERRIDE_LP_FLOW_25 instead.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://patch.msgid.link/20250614080000.1884236-12-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 21 +++++++++++++++++----
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ecc887b5c8c0..6bd7ed19ce28 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1167,6 +1167,8 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
 	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
+	} else if (is5325(dev)) {
+		return;
 	} else {
 		off = B53_GMII_PORT_OVERRIDE_CTRL(port);
 		val = GMII_PO_EN;
@@ -1191,6 +1193,8 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
+	} else if (is5325(dev)) {
+		return;
 	} else {
 		off = B53_GMII_PORT_OVERRIDE_CTRL(port);
 		val = GMII_PO_EN;
@@ -1221,10 +1225,19 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 		return;
 	}
 
-	if (rx_pause)
-		reg |= PORT_OVERRIDE_RX_FLOW;
-	if (tx_pause)
-		reg |= PORT_OVERRIDE_TX_FLOW;
+	if (rx_pause) {
+		if (is5325(dev))
+			reg |= PORT_OVERRIDE_LP_FLOW_25;
+		else
+			reg |= PORT_OVERRIDE_RX_FLOW;
+	}
+
+	if (tx_pause) {
+		if (is5325(dev))
+			reg |= PORT_OVERRIDE_LP_FLOW_25;
+		else
+			reg |= PORT_OVERRIDE_TX_FLOW;
+	}
 
 	b53_write8(dev, B53_CTRL_PAGE, off, reg);
 }
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index b2c539a42154..e5776545a8a0 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -92,6 +92,7 @@
 #define   PORT_OVERRIDE_SPEED_10M	(0 << PORT_OVERRIDE_SPEED_S)
 #define   PORT_OVERRIDE_SPEED_100M	(1 << PORT_OVERRIDE_SPEED_S)
 #define   PORT_OVERRIDE_SPEED_1000M	(2 << PORT_OVERRIDE_SPEED_S)
+#define   PORT_OVERRIDE_LP_FLOW_25	BIT(3) /* BCM5325 only */
 #define   PORT_OVERRIDE_RV_MII_25	BIT(4) /* BCM5325 only */
 #define   PORT_OVERRIDE_RX_FLOW		BIT(4)
 #define   PORT_OVERRIDE_TX_FLOW		BIT(5)
-- 
2.39.5



