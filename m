Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEA331AF15;
	Mon, 18 Aug 2025 13:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523892; cv=none; b=bBCznldxAilo8FUWv+wI941E/jiNnaJoKQLLrk6w44CEwDrcYt2cnEwVLBwqID93Pfmw5kAJ7J0MQC0BSpWkSI9WaoMbD/na+hSj4T63CJxbiBQ13JAFQmRngxi2iwnffwvZGIGpUWUNctnlnv8Dkn6PuMl7ObGkyqV/NOI/TP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523892; c=relaxed/simple;
	bh=HvrRzyP2k9nyn0Pmei/u2syi/dLWRlk9KB6BJIIpqKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/broJCvNlsFfesUR6ZFRRd9s0HC5SITiP2t8reAUO07LFacCGVUK7G0y8VRfD0Cq8521j9lDtV0cTexMqS7NXZlkHEkGILIbkvqz/1jMoPGLUHHNf2p+Hq2AsbfQvRav5GCe6/yWBS/ea7y54wHwWnm75bX6aX+UFjWXOmMDDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfCLeVDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfCLeVDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313B7C4CEEB;
	Mon, 18 Aug 2025 13:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523891;
	bh=HvrRzyP2k9nyn0Pmei/u2syi/dLWRlk9KB6BJIIpqKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfCLeVDI1Mv2gwxNiavQStFoTS+9mG0WR11UWESqOhd3HE2Q5n22i1enWIf1Z6+VE
	 tYgzSesKrmzQcX4P1XCn3A4G1hevwY539oo7Szua2i7ZCHdiiR3IOdxVg/DwxiGTro
	 YthKXgYAABJtaZBSiMLLdLRLe7fGQ8LjfFrphztA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 305/515] net: dsa: b53: prevent GMII_PORT_OVERRIDE_CTRL access on BCM5325
Date: Mon, 18 Aug 2025 14:44:51 +0200
Message-ID: <20250818124510.180639519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 55e1844a5e9c..8abbcc588267 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1274,6 +1274,8 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
 	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
+	} else if (is5325(dev)) {
+		return;
 	} else {
 		off = B53_GMII_PORT_OVERRIDE_CTRL(port);
 		val = GMII_PO_EN;
@@ -1298,6 +1300,8 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
+	} else if (is5325(dev)) {
+		return;
 	} else {
 		off = B53_GMII_PORT_OVERRIDE_CTRL(port);
 		val = GMII_PO_EN;
@@ -1328,10 +1332,19 @@ static void b53_force_port_config(struct b53_device *dev, int port,
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
index d31c8ad9a9b6..25d25bd1071f 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -95,6 +95,7 @@
 #define   PORT_OVERRIDE_SPEED_10M	(0 << PORT_OVERRIDE_SPEED_S)
 #define   PORT_OVERRIDE_SPEED_100M	(1 << PORT_OVERRIDE_SPEED_S)
 #define   PORT_OVERRIDE_SPEED_1000M	(2 << PORT_OVERRIDE_SPEED_S)
+#define   PORT_OVERRIDE_LP_FLOW_25	BIT(3) /* BCM5325 only */
 #define   PORT_OVERRIDE_RV_MII_25	BIT(4) /* BCM5325 only */
 #define   PORT_OVERRIDE_RX_FLOW		BIT(4)
 #define   PORT_OVERRIDE_TX_FLOW		BIT(5)
-- 
2.39.5



