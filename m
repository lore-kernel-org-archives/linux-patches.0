Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEA320FC
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 11:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8A8C433EF;
	Tue,  7 Feb 2023 11:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675768239;
	bh=YcJYzwI6zpfhIVCWxcvN3OEi/MsECIqraQFUR0ALFGo=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=eECBTCIst+H5r4joZbCK8yYZKHGuhGT/doTQ+HoeQhsHAZ3dKXkZSkEsB3Xfc9N9m
	 FrCyA9Jwz4ElEObav2irblgTElaJOmFFYAOIbTdqRTJKMzcLVqB+okbuQp7sU37GYT
	 /AwbZw6kNCxNMZfiI9KC+cYfpt8BYjJcNp1+Dv9g=
Subject: Patch "phy: qcom-qmp-combo: fix memleak on probe deferral" has been added to the 5.15-stable tree
To: gregkh@linuxfoundation.org,johan+linaro@kernel.org,patches@lists.linux.dev,swboyd@chromium.org,vkoul@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 07 Feb 2023 12:10:29 +0100
In-Reply-To: <20230203222616.2935268-3-swboyd@chromium.org>
Message-ID: <1675768229420@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    phy: qcom-qmp-combo: fix memleak on probe deferral

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     phy-qcom-qmp-combo-fix-memleak-on-probe-deferral.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Fri Feb  3 23:27:29 2023
From: Stephen Boyd <swboyd@chromium.org>
Date: Fri,  3 Feb 2023 14:26:13 -0800
Subject: phy: qcom-qmp-combo: fix memleak on probe deferral
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Vinod Koul <vkoul@kernel.org>
Message-ID: <20230203222616.2935268-3-swboyd@chromium.org>

From: Johan Hovold <johan+linaro@kernel.org>

commit 2de8a325b1084330ae500380cc27edc39f488c30 upstream.

Switch to using the device-managed of_iomap helper to avoid leaking
memory on probe deferral and driver unbind.

Note that this helper checks for already reserved regions and may fail
if there are multiple devices claiming the same memory.

Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220916102340.11520-5-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5410,17 +5410,17 @@ int qcom_qmp_phy_create(struct device *d
 	 * For dual lane PHYs: tx2 -> 3, rx2 -> 4, pcs_misc (optional) -> 5
 	 * For single lane PHYs: pcs_misc (optional) -> 3.
 	 */
-	qphy->tx = of_iomap(np, 0);
-	if (!qphy->tx)
-		return -ENOMEM;
-
-	qphy->rx = of_iomap(np, 1);
-	if (!qphy->rx)
-		return -ENOMEM;
-
-	qphy->pcs = of_iomap(np, 2);
-	if (!qphy->pcs)
-		return -ENOMEM;
+	qphy->tx = devm_of_iomap(dev, np, 0, NULL);
+	if (IS_ERR(qphy->tx))
+		return PTR_ERR(qphy->tx);
+
+	qphy->rx = devm_of_iomap(dev, np, 1, NULL);
+	if (IS_ERR(qphy->rx))
+		return PTR_ERR(qphy->rx);
+
+	qphy->pcs = devm_of_iomap(dev, np, 2, NULL);
+	if (IS_ERR(qphy->pcs))
+		return PTR_ERR(qphy->pcs);
 
 	/*
 	 * If this is a dual-lane PHY, then there should be registers for the
@@ -5429,9 +5429,9 @@ int qcom_qmp_phy_create(struct device *d
 	 * offset from the first lane.
 	 */
 	if (cfg->is_dual_lane_phy) {
-		qphy->tx2 = of_iomap(np, 3);
-		qphy->rx2 = of_iomap(np, 4);
-		if (!qphy->tx2 || !qphy->rx2) {
+		qphy->tx2 = devm_of_iomap(dev, np, 3, NULL);
+		qphy->rx2 = devm_of_iomap(dev, np, 4, NULL);
+		if (IS_ERR(qphy->tx2) || IS_ERR(qphy->rx2)) {
 			dev_warn(dev,
 				 "Underspecified device tree, falling back to legacy register regions\n");
 
@@ -5441,15 +5441,17 @@ int qcom_qmp_phy_create(struct device *d
 			qphy->rx2 = qphy->rx + QMP_PHY_LEGACY_LANE_STRIDE;
 
 		} else {
-			qphy->pcs_misc = of_iomap(np, 5);
+			qphy->pcs_misc = devm_of_iomap(dev, np, 5, NULL);
 		}
 
 	} else {
-		qphy->pcs_misc = of_iomap(np, 3);
+		qphy->pcs_misc = devm_of_iomap(dev, np, 3, NULL);
 	}
 
-	if (!qphy->pcs_misc)
+	if (IS_ERR(qphy->pcs_misc)) {
 		dev_vdbg(dev, "PHY pcs_misc-reg not used\n");
+		qphy->pcs_misc = NULL;
+	}
 
 	/*
 	 * Get PHY's Pipe clock, if any. USB3 and PCIe are PIPE3


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.15/phy-qcom-qmp-combo-fix-broken-power-on.patch
queue-5.15/phy-qcom-qmp-combo-fix-runtime-suspend.patch
queue-5.15/phy-qcom-qmp-combo-disable-runtime-pm-on-unbind.patch
queue-5.15/phy-qcom-qmp-usb-fix-memleak-on-probe-deferral.patch
queue-5.15/phy-qcom-qmp-combo-fix-memleak-on-probe-deferral.patch
