Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BB8183CBD;
	Sun,  1 Sep 2024 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209305; cv=none; b=CORtkj1E2EK3kChrwzsfBNjgiOaND3frun0/9RCRAk/NSNNRh1+xvE+0/KhbwRqCjSy2d2J9BvQw3LyjmpvHreILvrDy3GZNfEdO+v6Jm0JaAA3VuFCO3yG29Qx3FCGFfmfIpSXZ/6PbbCZhuVqPd0qtYbMZVtg7oBWF7f4pexU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209305; c=relaxed/simple;
	bh=VPP4fNpO0iOZ48N9jdgM5W7n4AR25413wWNr9PSIQak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0ZpJvcB2Bs68WBZ+WdbF2cWfViygtqf6jtZPSJjq9nRGLY1V3zxtOtUSp124JDC7CaXbCS9b3fJIKxFsakU4LBIegnt/+fkkQXSh1lpMj1jLgu46Os2es/mwlZWSoF1GUoCXNPOuQL0ZerxDV1xn5fPGTjubBZRltysCAigGNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIe3VnzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIe3VnzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B452FC4CEC3;
	Sun,  1 Sep 2024 16:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209305;
	bh=VPP4fNpO0iOZ48N9jdgM5W7n4AR25413wWNr9PSIQak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIe3VnzXpM67mxRDFMLVHf0qolcGaVrvoc0xEDabqp2qyFRK0J0hC/O2HFDYJkVl+
	 /yt1AhDORaZmWnZKCo1kS6siqfK5TFyKp3eaT+OF8IVdCfszhNR26Ah6UQCi23P1ij
	 Eexviwj1lBKPRlh4ZHsD7I0P6W5wQPTn/OU2hi0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 66/71] phy: zynqmp: Enable reference clock correctly
Date: Sun,  1 Sep 2024 18:18:11 +0200
Message-ID: <20240901160804.377391752@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

commit 687d6bccb28238fcfa65f7c1badfdfeac498c428 upstream.

Lanes can use other lanes' reference clocks, as determined by refclk.
Use refclk to determine the clock to enable/disable instead of always
using the lane's own reference clock. This ensures the clock selected in
xpsgtr_configure_pll is the one enabled.

For the other half of the equation, always program REF_CLK_SEL even when
we are selecting the lane's own clock. This ensures that Linux's idea of
the reference clock matches the hardware. We use the "local" clock mux
for this instead of going through the ref clock network.

Fixes: 25d700833513 ("phy: xilinx: phy-zynqmp: dynamic clock support for power-save")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://lore.kernel.org/r/20240628205540.3098010-2-sean.anderson@linux.dev
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/xilinx/phy-zynqmp.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -81,7 +81,8 @@
 
 /* Reference clock selection parameters */
 #define L0_Ln_REF_CLK_SEL(n)		(0x2860 + (n) * 4)
-#define L0_REF_CLK_SEL_MASK		0x8f
+#define L0_REF_CLK_LCL_SEL		BIT(7)
+#define L0_REF_CLK_SEL_MASK		0x9f
 
 /* Calibration digital logic parameters */
 #define L3_TM_CALIB_DIG19		0xec4c
@@ -396,11 +397,12 @@ static void xpsgtr_configure_pll(struct
 		       PLL_FREQ_MASK, ssc->pll_ref_clk);
 
 	/* Enable lane clock sharing, if required */
-	if (gtr_phy->refclk != gtr_phy->lane) {
-		/* Lane3 Ref Clock Selection Register */
+	if (gtr_phy->refclk == gtr_phy->lane)
+		xpsgtr_clr_set(gtr_phy->dev, L0_Ln_REF_CLK_SEL(gtr_phy->lane),
+			       L0_REF_CLK_SEL_MASK, L0_REF_CLK_LCL_SEL);
+	else
 		xpsgtr_clr_set(gtr_phy->dev, L0_Ln_REF_CLK_SEL(gtr_phy->lane),
 			       L0_REF_CLK_SEL_MASK, 1 << gtr_phy->refclk);
-	}
 
 	/* SSC step size [7:0] */
 	xpsgtr_clr_set_phy(gtr_phy, L0_PLL_SS_STEP_SIZE_0_LSB,
@@ -620,7 +622,7 @@ static int xpsgtr_phy_init(struct phy *p
 	mutex_lock(&gtr_dev->gtr_mutex);
 
 	/* Configure and enable the clock when peripheral phy_init call */
-	if (clk_prepare_enable(gtr_dev->clk[gtr_phy->lane]))
+	if (clk_prepare_enable(gtr_dev->clk[gtr_phy->refclk]))
 		goto out;
 
 	/* Skip initialization if not required. */
@@ -672,7 +674,7 @@ static int xpsgtr_phy_exit(struct phy *p
 	gtr_phy->skip_phy_init = false;
 
 	/* Ensure that disable clock only, which configure for lane */
-	clk_disable_unprepare(gtr_dev->clk[gtr_phy->lane]);
+	clk_disable_unprepare(gtr_dev->clk[gtr_phy->refclk]);
 
 	return 0;
 }


