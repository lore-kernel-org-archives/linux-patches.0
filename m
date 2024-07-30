Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE1A1A76B7;
	Tue, 30 Jul 2024 17:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359677; cv=none; b=iN7JMh3Prv3krQUoEjiWfBkc0PLKuONgtYl2Y6m7M4tYY0hdOTuuaPuFn0ATkwwh/UPvOy2qZYANQMHgUFNTFuasJ8SxueNm848bYWLSzvpNUIrodkrvFvVQm16pOfnNqhF+FxniV3aR6rSPB6YdCzdOHUBkcUudhLdpFrET/fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359677; c=relaxed/simple;
	bh=ZNMy+QmuWKm4XsIFJxTSQspvYqACQyWp9aVbyWQCc2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPS2/S+BAYPFyjyicbcZM1sb+ttwUyAyWwvYV9hsvj3q50fJv31QYWeqg43Ol/OALh2Vpl1RXmKKHnU7aWrQvOtWc08+CaczfY6ettmEPXZZwTTbRBZBt1K76vXe1aQ5PeOHNEHvaHTjKbvNeNPIZpHOkcKayk+LWqNmA2WETf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxF4LxME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxF4LxME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FB0C32782;
	Tue, 30 Jul 2024 17:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359677;
	bh=ZNMy+QmuWKm4XsIFJxTSQspvYqACQyWp9aVbyWQCc2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxF4LxMEEyMQrwBQ/2vm6SU2V3mycnH9OWMg15gQhpVSoJal6aJ4YCe0VH6YAT1RH
	 rQkFCKWQGZAxzOj2lav88kh800/wRPZdCJOCfWj0WNONN6851VCb3yPwvG8xLzrWVv
	 o/C9jh8f3xz/1399/5rJZYkVMjiL7AyY/jIRart4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 521/568] phy: zynqmp: Enable reference clock correctly
Date: Tue, 30 Jul 2024 17:50:28 +0200
Message-ID: <20240730151700.519603947@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 687d6bccb28238fcfa65f7c1badfdfeac498c428 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index 2559c6594cea2..0cb5088e460b5 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -80,7 +80,8 @@
 
 /* Reference clock selection parameters */
 #define L0_Ln_REF_CLK_SEL(n)		(0x2860 + (n) * 4)
-#define L0_REF_CLK_SEL_MASK		0x8f
+#define L0_REF_CLK_LCL_SEL		BIT(7)
+#define L0_REF_CLK_SEL_MASK		0x9f
 
 /* Calibration digital logic parameters */
 #define L3_TM_CALIB_DIG19		0xec4c
@@ -349,11 +350,12 @@ static void xpsgtr_configure_pll(struct xpsgtr_phy *gtr_phy)
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
@@ -573,7 +575,7 @@ static int xpsgtr_phy_init(struct phy *phy)
 	mutex_lock(&gtr_dev->gtr_mutex);
 
 	/* Configure and enable the clock when peripheral phy_init call */
-	if (clk_prepare_enable(gtr_dev->clk[gtr_phy->lane]))
+	if (clk_prepare_enable(gtr_dev->clk[gtr_phy->refclk]))
 		goto out;
 
 	/* Skip initialization if not required. */
@@ -625,7 +627,7 @@ static int xpsgtr_phy_exit(struct phy *phy)
 	gtr_phy->skip_phy_init = false;
 
 	/* Ensure that disable clock only, which configure for lane */
-	clk_disable_unprepare(gtr_dev->clk[gtr_phy->lane]);
+	clk_disable_unprepare(gtr_dev->clk[gtr_phy->refclk]);
 
 	return 0;
 }
-- 
2.43.0



