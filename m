Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D095A318EC4;
	Mon, 13 Apr 2026 16:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098763; cv=none; b=l2x4wOeQpCE4uRXQhY9wZxP1X9Ks+XTPGscLnhKqYqi/PNViedo9B1cp/vgtBilqzLunIYTbpO7382v5ClPItlzuQzLYtY1k6x32j3tVc+pEKCyQIHxJSoxkaQ4qSBATbh23Wx/txi25jJgilp+tGLfII+nZLYnUlUqCPE+Q/Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098763; c=relaxed/simple;
	bh=riDxBGEQJkpRM0AT6ckRGZTWzoNKYZpz38zHk2bkBiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqVSao4Fq2sFedsM+SRHqLMJ9H3Ufmm0kTrgqZM1/XGcbHRZX4niYf9brY7hWtBGFtsINOYRwsyS6ybRZRSxG1gd+6nhzVUABcmGmZGfQTITUhyxJiT5LC8/q5skpjsSQTfQn96cBiO2xwhHXr25zs4X08zOzScaSy4L33K5EHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqz6Y5ZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqz6Y5ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664FAC2BCB3;
	Mon, 13 Apr 2026 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098763;
	bh=riDxBGEQJkpRM0AT6ckRGZTWzoNKYZpz38zHk2bkBiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqz6Y5ZNq/DroLBP3L6nRpROCkkZFrpfijcwacBXyGyRbsc9kMweBgWh3jYWigMuJ
	 HKOEXes5eQ/zuv87DY/kKllM6tVtMvh7uLgYxgJoxho0RCd83GDuxVL9Mh6VomdJae
	 XiM+XefLP/l9hBUg6uMAhZZYBjt7wyBKoD5Ki1IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/491] regulator: pca9450: Make IRQ optional
Date: Mon, 13 Apr 2026 17:55:25 +0200
Message-ID: <20260413155822.039941229@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b3d206ebb2894..6ec2ad5b9efcc 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -704,11 +704,6 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 	unsigned int device_id, i;
 	int ret;
 
-	if (!i2c->irq) {
-		dev_err(&i2c->dev, "No IRQ configured?\n");
-		return -EINVAL;
-	}
-
 	pca9450 = devm_kzalloc(&i2c->dev, sizeof(struct pca9450), GFP_KERNEL);
 	if (!pca9450)
 		return -ENOMEM;
@@ -775,23 +770,25 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
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



