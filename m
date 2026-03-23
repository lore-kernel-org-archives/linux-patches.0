Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8969E3B0ACB;
	Mon, 23 Mar 2026 16:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282509; cv=none; b=Y18SQ06CrcwxU5xy96PL8+TQe1lWRJQYRP3WzLf32TzHANhqgzTMjQeihYI9rEYe/grd80SoS56E/EAKvH6y0P8XcXj7aGDqh5A1uDl4rlcxQFI1+HLnmFROyD7eT/HxZvEny2xH7BFEmK8Z/KuKINfg71xI2Z4UYpSbJLyNFZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282509; c=relaxed/simple;
	bh=YpGge8H9yWOWwR4j3NHNdlLLf6I8DVUFK/g7UFp8x5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkg012fdLjvpH5luQENJP+a6MdGqx0Qr6xkVH6bHH8sVpAuMAcl6EX3mDRIDMTCDwq6cK1rTFS0zU+58qw5oNPrw9k+Xz6Y4l4FdbVcxEupPI1fFZ29/4l3E8sjJ7GOnG1/ZXkN5UUfoFFrV18VZKjVFl7Vivou653vS+0wxHAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTH56NDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTH56NDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5D2C4CEF7;
	Mon, 23 Mar 2026 16:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282509;
	bh=YpGge8H9yWOWwR4j3NHNdlLLf6I8DVUFK/g7UFp8x5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTH56NDIFWme8JbWyt8Vr+E5/57L6uiJxc4Hl2/1yUDeNt9f4t4mfmvdtYB2prs+O
	 CxxXjbFu++FDtyg+tBl9fFuslC2jardNvcTlWV6ZE22UGrikvxQVMS2VOD4Ga5KtIv
	 LItFS6iFSUki5iIFzD9xvfEFFltiiiWZ/+DDeFwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/481] regulator: pca9450: Make IRQ optional
Date: Mon, 23 Mar 2026 14:42:43 +0100
Message-ID: <20260323134529.619717780@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 83808c54064eef620ad8645dfdcaffe125551532 ]

The IRQ line might not be connected on some boards. Allow the driver
to be probed without it.

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://patch.msgid.link/20240708084107.38986-5-frieder@fris.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 5d0efaf47ee9 ("regulator: pca9450: Correct interrupt type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 41 +++++++++++++--------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 0fcda40cefa6d..8848afa48598f 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -713,11 +713,6 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 	unsigned int reset_ctrl;
 	int ret;
 
-	if (!i2c->irq) {
-		dev_err(&i2c->dev, "No IRQ configured?\n");
-		return -EINVAL;
-	}
-
 	pca9450 = devm_kzalloc(&i2c->dev, sizeof(struct pca9450), GFP_KERNEL);
 	if (!pca9450)
 		return -ENOMEM;
@@ -784,23 +779,25 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
-	ret = devm_request_threaded_irq(pca9450->dev, pca9450->irq, NULL,
-					pca9450_irq_handler,
-					(IRQF_TRIGGER_FALLING | IRQF_ONESHOT),
-					"pca9450-irq", pca9450);
-	if (ret != 0) {
-		dev_err(pca9450->dev, "Failed to request IRQ: %d\n",
-			pca9450->irq);
-		return ret;
-	}
-	/* Unmask all interrupt except PWRON/WDOG/RSVD */
-	ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_INT1_MSK,
-				IRQ_VR_FLT1 | IRQ_VR_FLT2 | IRQ_LOWVSYS |
-				IRQ_THERM_105 | IRQ_THERM_125,
-				IRQ_PWRON | IRQ_WDOGB | IRQ_RSVD);
-	if (ret) {
-		dev_err(&i2c->dev, "Unmask irq error\n");
-		return ret;
+	if (pca9450->irq) {
+		ret = devm_request_threaded_irq(pca9450->dev, pca9450->irq, NULL,
+						pca9450_irq_handler,
+						(IRQF_TRIGGER_FALLING | IRQF_ONESHOT),
+						"pca9450-irq", pca9450);
+		if (ret != 0) {
+			dev_err(pca9450->dev, "Failed to request IRQ: %d\n",
+				pca9450->irq);
+			return ret;
+		}
+		/* Unmask all interrupt except PWRON/WDOG/RSVD */
+		ret = regmap_update_bits(pca9450->regmap, PCA9450_REG_INT1_MSK,
+					IRQ_VR_FLT1 | IRQ_VR_FLT2 | IRQ_LOWVSYS |
+					IRQ_THERM_105 | IRQ_THERM_125,
+					IRQ_PWRON | IRQ_WDOGB | IRQ_RSVD);
+		if (ret) {
+			dev_err(&i2c->dev, "Unmask irq error\n");
+			return ret;
+		}
 	}
 
 	/* Clear PRESET_EN bit in BUCK123_DVS to use DVS registers */
-- 
2.51.0



