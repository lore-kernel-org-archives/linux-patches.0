Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C417BD511
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 22:26:22 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so10170435pjq.0
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 14:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EKfzPUpjx2o77cFgSD1szOPFx9p7F1YloFu6dux5jE=;
        b=Gw4s+m/hA1DCZPPOM3c5DEIsbg9ROhFB5dhZFbbcZ83eB1WBANExxiUq67Hya+PC8b
         5GiHX1VtVrhbz9Sq6u+TPRBaGvO6at/8XOSPJ/vv/MQ5j+vEJir8wYrEqKqM2yh1cjQv
         wTJJxFJ74NevdJItmXV5LMKWkLYi7eSF0+3FM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EKfzPUpjx2o77cFgSD1szOPFx9p7F1YloFu6dux5jE=;
        b=D1p5PQpdeA6BfknhVch1QHlx0JWvHXOgltDyVHwd2RYizeHjel8if0hw1WAUcFOPiF
         nDgyhey/zObgBXaMv5UADrsc2/2n7O/3bnOS9v7I5t2mbR2HBiirhzXRZJEDvplhLjlK
         zi2EyOoEvmEQUIsiJpnCiRhX6phd7iFN2khqzNdQ1IdMnY1xrlUS5cAtXpavnsJ1PDVK
         CDz1WZQCJgQ/BDVCmLYfRzWTHcJCZF79xoMeH36Yrk6QmlyYxaNIYe5SA2dQUQXqD11X
         uL8NLVj1gh0y9aNl7/UhveQPjvK5ep4XvY3Ii76q78YbQMfLBRJ6ZVmZht9gD5gU3iAg
         sIog==
X-Gm-Message-State: AO0yUKXUfYTjSI0gnfpjMyYVKuUUg3l2+YYx3qEC1Irz2Jji/lGWK/UY
	g4gnNLMSnE+wZ7VdTYEWknLBSQAHq8E1tG4t
X-Google-Smtp-Source: AK7set8JTT/1gTBVqucSjjVolyn7f7i8Pz2ho8QrjzsVT2mYw7fW7YPdQqgQl5bw4mmjzAbYYzKp7w==
X-Received: by 2002:a17:903:1246:b0:196:19af:a7f3 with SMTP id u6-20020a170903124600b0019619afa7f3mr13917540plh.39.1675463182237;
        Fri, 03 Feb 2023 14:26:22 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0019602263feesm2095071pla.90.2023.02.03.14.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:21 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v3 2/5] phy: qcom-qmp-combo: fix memleak on probe deferral
Date: Fri,  3 Feb 2023 14:26:13 -0800
Message-Id: <20230203222616.2935268-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230203222616.2935268-1-swboyd@chromium.org>
References: <20230203222616.2935268-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 32 +++++++++++++++--------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 7b7557c35af6..c6f860ce3d99 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5410,17 +5410,17 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
 	 * For dual lane PHYs: tx2 -> 3, rx2 -> 4, pcs_misc (optional) -> 5
 	 * For single lane PHYs: pcs_misc (optional) -> 3.
 	 */
-	qphy->tx = of_iomap(np, 0);
-	if (!qphy->tx)
-		return -ENOMEM;
+	qphy->tx = devm_of_iomap(dev, np, 0, NULL);
+	if (IS_ERR(qphy->tx))
+		return PTR_ERR(qphy->tx);
 
-	qphy->rx = of_iomap(np, 1);
-	if (!qphy->rx)
-		return -ENOMEM;
+	qphy->rx = devm_of_iomap(dev, np, 1, NULL);
+	if (IS_ERR(qphy->rx))
+		return PTR_ERR(qphy->rx);
 
-	qphy->pcs = of_iomap(np, 2);
-	if (!qphy->pcs)
-		return -ENOMEM;
+	qphy->pcs = devm_of_iomap(dev, np, 2, NULL);
+	if (IS_ERR(qphy->pcs))
+		return PTR_ERR(qphy->pcs);
 
 	/*
 	 * If this is a dual-lane PHY, then there should be registers for the
@@ -5429,9 +5429,9 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
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
 
@@ -5441,15 +5441,17 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id,
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
-- 
https://chromeos.dev

