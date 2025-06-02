Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAC4221D92;
	Mon,  2 Jun 2025 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872935; cv=none; b=V+QyMM/fB+CXcZvlqY74tT5iofkDr9NHtpKjjWsA24lWmZkNveFYQIWDLRFDj5fCOvo2Bs6rec6rXnLfGXWleBCXr0sHIZpxhVbwOE42mdfpgHj40cICJo9WL2ONSJBSfFXovM0RvEWcFEgD4kuwWEdLOBpSJ2NkPmX/Pcvk7aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872935; c=relaxed/simple;
	bh=cMxwA7LVfv7cuW4Jcg7pd0yGKvSlioL45gSjc5HJAK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unDFZ+tBG4Oj1P/xrlLDHiIlWZFTMnkhGaia1aTfYDGVC3JopLuVFluPqa9G91WfueXuGiu7dtEfNQ6fmXZZ+loLCatK9Sve5AazcoH/AlmLXfldpVFYUQ+d+1pRGhqKmTiDKGQ32UI2Uzf2/qmJwX6p6UDoWVRpUHJzU1mUlcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oq9V7XPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oq9V7XPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF86C4CEEB;
	Mon,  2 Jun 2025 14:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872934;
	bh=cMxwA7LVfv7cuW4Jcg7pd0yGKvSlioL45gSjc5HJAK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oq9V7XPx4p2DPmT5bA+cMb3IfbFW2hPAg5qqleq6fEnlnWHyoAOm8mS0JulVtRArq
	 Z6W9rs5ukidrY8TyoeanerbtgvC14J3QGUDfRF3EJOTS/EPvXqc/JJ5RHlf5wViDS9
	 pw+yM8H8dED2fcklGq+krJI0zZyzr8rgqaknHetI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 43/55] phy: starfive: jh7110-usb: Fix USB 2.0 host occasional detection failure
Date: Mon,  2 Jun 2025 15:48:00 +0200
Message-ID: <20250602134239.977516386@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hal Feng <hal.feng@starfivetech.com>

[ Upstream commit 3f097adb9b6c804636bcf8d01e0e7bc037bee0d3 ]

JH7110 USB 2.0 host fails to detect USB 2.0 devices occasionally. With a
long time of debugging and testing, we found that setting Rx clock gating
control signal to normal power consumption mode can solve this problem.

Signed-off-by: Hal Feng <hal.feng@starfivetech.com>
Link: https://lore.kernel.org/r/20250422101244.51686-1-hal.feng@starfivetech.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/starfive/phy-jh7110-usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/phy/starfive/phy-jh7110-usb.c b/drivers/phy/starfive/phy-jh7110-usb.c
index cb5454fbe2c8f..b505d89860b43 100644
--- a/drivers/phy/starfive/phy-jh7110-usb.c
+++ b/drivers/phy/starfive/phy-jh7110-usb.c
@@ -18,6 +18,8 @@
 #include <linux/usb/of.h>
 
 #define USB_125M_CLK_RATE		125000000
+#define USB_CLK_MODE_OFF		0x0
+#define USB_CLK_MODE_RX_NORMAL_PWR	BIT(1)
 #define USB_LS_KEEPALIVE_OFF		0x4
 #define USB_LS_KEEPALIVE_ENABLE		BIT(4)
 
@@ -78,6 +80,7 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
 {
 	struct jh7110_usb2_phy *phy = phy_get_drvdata(_phy);
 	int ret;
+	unsigned int val;
 
 	ret = clk_set_rate(phy->usb_125m_clk, USB_125M_CLK_RATE);
 	if (ret)
@@ -87,6 +90,10 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
 	if (ret)
 		return ret;
 
+	val = readl(phy->regs + USB_CLK_MODE_OFF);
+	val |= USB_CLK_MODE_RX_NORMAL_PWR;
+	writel(val, phy->regs + USB_CLK_MODE_OFF);
+
 	return 0;
 }
 
-- 
2.39.5



