Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7256143894;
	Sun,  1 Sep 2024 16:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209401; cv=none; b=NjKQCkA+wnbwtr1n4kB7TyG+eEcSLIzsnoY/5UmAPdSi1G4Z4QWMfoGkPubrN7x/bVsY1NxU6k16XdEwxMZ/P6IamGpBxcjgUbuHlKEz8M2p1bBx9LV76X3EVy3+gZKAOwSfl9O8Gw4RRB9nVgLMQuPiKVg0dF4E3wzh1klogfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209401; c=relaxed/simple;
	bh=Q6BtjSxvGalxtHEh6qbXqQGwgTX5llt6/IpqdoQWYSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTiyTR0v5VQJjRWOfeWYCKthb9Wj4Cs/+uSek1ciPzDaszAOyDaA3+/RlYUt3SF/YbksXnex1u2Amha0HoLo/nPfJFyex3SxKtUfsBSEAAcTBgoWvWWifHJMR0guebzNbvDhe+rmIBgIX64O+Ga0vVG+9m0vjyP6oD2p8JNAVh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGa5bP60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGa5bP60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A05C4CEC3;
	Sun,  1 Sep 2024 16:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209401;
	bh=Q6BtjSxvGalxtHEh6qbXqQGwgTX5llt6/IpqdoQWYSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGa5bP60vwFL/V2Oys5LWoGKseZGCjy8RynWSFlwCXKl4ffbdKOMlhKOcPEHuBG7P
	 FQR3svGisCdGikA84bxrkADyWKXXURb9FoEhgh/tVcA936qb+ycAq0s5+dDGRX0/ug
	 qCGhLptDFNv1uWy/yn1jhF3F1584cvtQ+FuOQhA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <linux@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/151] net: dsa: vsc73xx: use read_poll_timeout instead delay loop
Date: Sun,  1 Sep 2024 18:16:24 +0200
Message-ID: <20240901160815.007752313@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

From: Pawel Dembicki <paweldembicki@gmail.com>

[ Upstream commit eb7e33d01db3aec128590391b2397384bab406b6 ]

Switch the delay loop during the Arbiter empty check from
vsc73xx_adjust_link() to use read_poll_timeout(). Functionally,
one msleep() call is eliminated at the end of the loop in the timeout
case.

As Russell King suggested:

"This [change] avoids the issue that on the last iteration, the code reads
the register, tests it, finds the condition that's being waiting for is
false, _then_ waits and end up printing the error message - that last
wait is rather useless, and as the arbiter state isn't checked after
waiting, it could be that we had success during the last wait."

Suggested-by: Russell King <linux@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Link: https://lore.kernel.org/r/20240417205048.3542839-2-paweldembicki@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: fa63c6434b6f ("net: dsa: vsc73xx: check busy flag in MDIO operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 30 ++++++++++++++------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 55c1063327a8f..d050dfaf327cc 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/iopoll.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
@@ -269,6 +270,9 @@
 #define IS_7398(a) ((a)->chipid == VSC73XX_CHIPID_ID_7398)
 #define IS_739X(a) (IS_7395(a) || IS_7398(a))
 
+#define VSC73XX_POLL_SLEEP_US		1000
+#define VSC73XX_POLL_TIMEOUT_US		10000
+
 struct vsc73xx_counter {
 	u8 counter;
 	const char *name;
@@ -780,7 +784,7 @@ static void vsc73xx_adjust_link(struct dsa_switch *ds, int port,
 	 * after a PHY or the CPU port comes up or down.
 	 */
 	if (!phydev->link) {
-		int maxloop = 10;
+		int ret, err;
 
 		dev_dbg(vsc->dev, "port %d: went down\n",
 			port);
@@ -795,19 +799,17 @@ static void vsc73xx_adjust_link(struct dsa_switch *ds, int port,
 				    VSC73XX_ARBDISC, BIT(port), BIT(port));
 
 		/* Wait until queue is empty */
-		vsc73xx_read(vsc, VSC73XX_BLOCK_ARBITER, 0,
-			     VSC73XX_ARBEMPTY, &val);
-		while (!(val & BIT(port))) {
-			msleep(1);
-			vsc73xx_read(vsc, VSC73XX_BLOCK_ARBITER, 0,
-				     VSC73XX_ARBEMPTY, &val);
-			if (--maxloop == 0) {
-				dev_err(vsc->dev,
-					"timeout waiting for block arbiter\n");
-				/* Continue anyway */
-				break;
-			}
-		}
+		ret = read_poll_timeout(vsc73xx_read, err,
+					err < 0 || (val & BIT(port)),
+					VSC73XX_POLL_SLEEP_US,
+					VSC73XX_POLL_TIMEOUT_US, false,
+					vsc, VSC73XX_BLOCK_ARBITER, 0,
+					VSC73XX_ARBEMPTY, &val);
+		if (ret)
+			dev_err(vsc->dev,
+				"timeout waiting for block arbiter\n");
+		else if (err < 0)
+			dev_err(vsc->dev, "error reading arbiter\n");
 
 		/* Put this port into reset */
 		vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG,
-- 
2.43.0



