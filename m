Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302DE31CA5B;
	Mon, 18 Aug 2025 13:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522220; cv=none; b=JoWM8W0vHSH8E5pgHu5Gau0HJJT5J6aoYeTkCE/Wuzk8CboEdrcGbvhKg9oPATqn39YQoEBQWi72frQyX0Hi2RFfzFC7c6OlYhy5lZACVZs3Q7JsvzcY2DV2tf/JFfEUbDWsoKbjNw08g60StKA/hgcZYNVzZNpb/xaJpCqdKo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522220; c=relaxed/simple;
	bh=N2HcmzkmbczfQNgHUweHntGUvyPs+McS0umDHdntPHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SdYO2XCOwMJGIOFFdegC7DKsZSbNGdIi+JBHLb7yzdNHlVum38+J/0QxVLuQvqXzO/ASOeWuDLertp2SGvWVve7Z6MtAuBxLUkBtPpoVlgrxWgbV6mTXK/TD3CymgHXTAn2Gip3C3UUd6Ej5uU0rb2+xBjgS8nppF7mNyQvEgEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ws0kecRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ws0kecRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E986C4CEF1;
	Mon, 18 Aug 2025 13:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522219;
	bh=N2HcmzkmbczfQNgHUweHntGUvyPs+McS0umDHdntPHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ws0kecRrgxAUz6w/qeIzNp0DXhHgy00HQ0YtY0n+VnJjltXvcLPUKQ/EnTiLVFmH5
	 I8kXPsuO5zcGyQS8mak+26zpK/57r3uvMbFiRkeVLsz+2AK+TZqVJQrmm+oIYMhFBQ
	 3N09WYS28UlKGQkVyqUgPB5egr7friGyg6oRPXDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/444] net: dsa: b53: prevent GMII_PORT_OVERRIDE_CTRL access on BCM5325
Date: Mon, 18 Aug 2025 14:44:36 +0200
Message-ID: <20250818124458.197395738@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fef265521e8a..0085adecaf2d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1269,6 +1269,8 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
 	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
+	} else if (is5325(dev)) {
+		return;
 	} else {
 		off = B53_GMII_PORT_OVERRIDE_CTRL(port);
 		val = GMII_PO_EN;
@@ -1293,6 +1295,8 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
+	} else if (is5325(dev)) {
+		return;
 	} else {
 		off = B53_GMII_PORT_OVERRIDE_CTRL(port);
 		val = GMII_PO_EN;
@@ -1323,10 +1327,19 @@ static void b53_force_port_config(struct b53_device *dev, int port,
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
index d8900aa433e5..719c2ac94a4f 100644
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



