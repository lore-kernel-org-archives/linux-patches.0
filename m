Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13CB2E762C;
	Mon, 17 Aug 2026 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979784; cv=none; b=m8+mYBlVjZOA+GyskIyIvK16MZvxwMFm0TLcua3B4T8bbiLUYIFstym2Fag2AZIFoep8YE5uUymOxP1trAfj4x3hmIjr3c4hOKdEgikO9dNptveylhednBEz63ML9N5DbYCs0yc6hlPaYILieRqGS/YArtbIwa3eYjMBcmowo1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979784; c=relaxed/simple;
	bh=4KQGDkWLR3PjmQ6fKlj/qaewd5k/scCTJYlS/YqUvb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPxd9cg6d0ITALvVPQmadg4b+iV3rKSjO6ADD9V48+Q2SYiOpVl9HcXO0fwmCvACRPdageZMS7hJxKP9PMWurMZaKdrh37nn99IYq7CF1u4Z352+1LJniqEzP1V1d2EHzlTOJyi8HNLn9OlKnHPXbWZQFZtiTicFYcYLWOFEHSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAteXOLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAteXOLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D6A1F00A3D;
	Mon, 17 Aug 2026 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979782;
	bh=67GFxPlZt9bR7setpLBH7vstJ9UQY8W0K3PvFU7TTts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAteXOLN6B8YUG2vNoEfrx2AaXlyg7ppFWKJkEnzUFe2LcUscm1sSMxm2UegFfkC9
	 dCQWDtTCDdmSaPQtL3feDoX21q2FFcAe/figEXuA2gbjqupneXbE4IfyKD4XLATs7v
	 QsFpmkq8uydoVZpY8lcfLXCaF8g5C9K7CnmA3t7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 319/609] phy: zynqmp: fix clock error handling in xpsgtr_phy_init()
Date: Mon, 17 Aug 2026 15:30:15 +0200
Message-ID: <20260817132554.910097549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit e4779e2a16d600892aaf743438f6ce8cc4eb3c4c ]

Propagate clk_prepare_enable() failures to the caller instead of
returning success, and disable the reference clock on initialization
error paths to avoid leaking clock references when phy_exit() is not
called.

Fixes: 25d700833513 ("phy: xilinx: phy-zynqmp: dynamic clock support for power-save")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260720153832.1130006-2-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index 61dc831f778dd..517855fea8920 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -644,12 +644,13 @@ static int xpsgtr_phy_init(struct phy *phy)
 {
 	struct xpsgtr_phy *gtr_phy = phy_get_drvdata(phy);
 	struct xpsgtr_dev *gtr_dev = gtr_phy->dev;
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&gtr_dev->gtr_mutex);
 
 	/* Configure and enable the clock when peripheral phy_init call */
-	if (clk_prepare_enable(gtr_dev->clk[gtr_phy->refclk]))
+	ret = clk_prepare_enable(gtr_dev->clk[gtr_phy->refclk]);
+	if (ret)
 		goto out;
 
 	/* Skip initialization if not required. */
@@ -659,7 +660,7 @@ static int xpsgtr_phy_init(struct phy *phy)
 	if (gtr_dev->tx_term_fix) {
 		ret = xpsgtr_phy_tx_term_fix(gtr_phy);
 		if (ret < 0)
-			goto out;
+			goto out_disable_clk;
 
 		gtr_dev->tx_term_fix = false;
 	}
@@ -673,7 +674,7 @@ static int xpsgtr_phy_init(struct phy *phy)
 	 */
 	ret = xpsgtr_configure_pll(gtr_phy);
 	if (ret)
-		goto out;
+		goto out_disable_clk;
 
 	xpsgtr_lane_set_protocol(gtr_phy);
 
@@ -691,6 +692,10 @@ static int xpsgtr_phy_init(struct phy *phy)
 		break;
 	}
 
+	goto out;
+
+out_disable_clk:
+	clk_disable_unprepare(gtr_dev->clk[gtr_phy->refclk]);
 out:
 	mutex_unlock(&gtr_dev->gtr_mutex);
 	return ret;
-- 
2.53.0



