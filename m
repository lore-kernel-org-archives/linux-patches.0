Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F98264A92;
	Mon,  1 Dec 2025 11:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588755; cv=none; b=U80O8gXuAmD1PdpnDB5IjuzK99l6WVZqC9EeVe/jLUtNFm58CXZE+c15ClF/6LMcHD+v6l1ocA1Hie2NeGvKUjUtv80EEbkQixhHVnh7y154EjxDs/lSpmzDUI8BHORIiuYLB3sVZYUNP+i6j9r2isyOszU+jzvyaa1su9oZnOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588755; c=relaxed/simple;
	bh=V7q9v3JAlOyLYXKxL077BZkaqlajfyNKumir4zAtG7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f6dqt6LGfWjtm0jV0A8IsxPFtI+xise2wxOQbbdB2CllUOkHC4wMunE/OMo59R04liBLbBTFnFIeJzndla+8OCCBiGfJ22fRKqiFAue3W34b108dtGa7Ina4+rmUkducI5OrjgKfAWim5CW3Vv0quM8xdMVrvUGPSZG0utzxwCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TySYqNZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TySYqNZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43BCC4CEF1;
	Mon,  1 Dec 2025 11:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588755;
	bh=V7q9v3JAlOyLYXKxL077BZkaqlajfyNKumir4zAtG7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TySYqNZVxSjaS4YDXl++hnz0ChBH1EbCvos23NaMspqV/Lnb+eWw9Fwqk0fEaK/BZ
	 JrZYMwWgqabDqYnEy4yiR3a0psckdKiHOmZXb2cSV8gx84/mcIUBxdgVDEcGNhLdXR
	 3l+5WZlYnU+yFfu+NGhpfiEp979hWJ9A2ZuO9GAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/187] net: dsa: b53: prevent GMII_PORT_OVERRIDE_CTRL access on BCM5325
Date: Mon,  1 Dec 2025 12:23:44 +0100
Message-ID: <20251201112245.421320820@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: b6a8a5477fe9 ("net: dsa: b53: fix resetting speed and pause on forced link")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 21 +++++++++++++++++----
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 4de302f20e4f3..dca23e0edb9a8 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1026,6 +1026,8 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
 	if (port == dev->cpu_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
+	} else if (is5325(dev)) {
+		return;
 	} else {
 		off = B53_GMII_PORT_OVERRIDE_CTRL(port);
 		val = GMII_PO_EN;
@@ -1050,6 +1052,8 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	if (port == dev->cpu_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
+	} else if (is5325(dev)) {
+		return;
 	} else {
 		off = B53_GMII_PORT_OVERRIDE_CTRL(port);
 		val = GMII_PO_EN;
@@ -1080,10 +1084,19 @@ static void b53_force_port_config(struct b53_device *dev, int port,
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
index ea6897c3f6f76..77fb7ae660b8c 100644
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
2.51.0



