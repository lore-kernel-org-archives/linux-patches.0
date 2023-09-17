Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE876FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311FDC433C8;
	Sun, 17 Sep 2023 19:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980275;
	bh=5rWvPxY4VFOqW+S6+yCNwhClFr9qMokkirstouey+NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9ZQoY/izbmMdhLjrRF2eqaLfxbNP2jCmdbea1dHD5l+dYWDUcBsx53BRmc9x0sp/
	 tuKWJPIYHjIZ+eoXT8q9tX+Q4dx26mm4YjQnO4fLurWeBmcYF1lDLyScfwwDgu6/bT
	 Qz324YxJU2Ewq7pYOreNvuURnh2KWDqStctICaeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>,
	Jerome Neanne <jneanne@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 145/285] regulator: tps6594-regulator: Fix random kernel crash
Date: Sun, 17 Sep 2023 21:12:25 +0200
Message-ID: <20230917191056.703460957@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Neanne <jneanne@baylibre.com>

[ Upstream commit ca0e36e3e39a4e8b5a4b647dff8c5938ca6ccbec ]

Random kernel crash detected in TI CICD when regulator driver is added.
This is root caused to irq index increment being done twice causing
irq_data being allocated outside of the range.

- Rework tps6594_request_reg_irqs with correct index increment
- Adjust irq_data kmalloc size to the exact size needed for the device

This has been reported on TI mainline. No public bug report associated.

Reported-by: Udit Kumar <u-kumar1@ti.com>
Fixes: f17ccc5deb4d ("regulator: tps6594-regulator: Add driver for TI TPS6594 regulators")
Signed-off-by: Jerome Neanne <jneanne@baylibre.com>
Link: https://lore.kernel.org/r/20230828-tps6594_random_boot_crash_fix-v1-1-f29cbf9ddb37@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6594-regulator.c | 31 +++++++++++++--------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/tps6594-regulator.c b/drivers/regulator/tps6594-regulator.c
index d5a574ec6d12f..47c3b7efe145e 100644
--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -384,21 +384,19 @@ static int tps6594_request_reg_irqs(struct platform_device *pdev,
 		if (irq < 0)
 			return -EINVAL;
 
-		irq_data[*irq_idx + j].dev = tps->dev;
-		irq_data[*irq_idx + j].type = irq_type;
-		irq_data[*irq_idx + j].rdev = rdev;
+		irq_data[*irq_idx].dev = tps->dev;
+		irq_data[*irq_idx].type = irq_type;
+		irq_data[*irq_idx].rdev = rdev;
 
 		error = devm_request_threaded_irq(tps->dev, irq, NULL,
-						  tps6594_regulator_irq_handler,
-						  IRQF_ONESHOT,
-						  irq_type->irq_name,
-						  &irq_data[*irq_idx]);
-		(*irq_idx)++;
+						  tps6594_regulator_irq_handler, IRQF_ONESHOT,
+						  irq_type->irq_name, &irq_data[*irq_idx]);
 		if (error) {
 			dev_err(tps->dev, "tps6594 failed to request %s IRQ %d: %d\n",
 				irq_type->irq_name, irq, error);
 			return error;
 		}
+		(*irq_idx)++;
 	}
 	return 0;
 }
@@ -420,8 +418,8 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 	int error, i, irq, multi, delta;
 	int irq_idx = 0;
 	int buck_idx = 0;
-	int ext_reg_irq_nb = 2;
-
+	size_t ext_reg_irq_nb = 2;
+	size_t reg_irq_nb;
 	enum {
 		MULTI_BUCK12,
 		MULTI_BUCK123,
@@ -484,15 +482,16 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (tps->chip_id == LP8764)
+	if (tps->chip_id == LP8764) {
 		/* There is only 4 buck on LP8764 */
 		buck_configured[4] = 1;
+		reg_irq_nb = size_mul(REGS_INT_NB, (BUCK_NB - 1));
+	} else {
+		reg_irq_nb = size_mul(REGS_INT_NB, (size_add(BUCK_NB, LDO_NB)));
+	}
 
-	irq_data = devm_kmalloc_array(tps->dev,
-				REGS_INT_NB * sizeof(struct tps6594_regulator_irq_data),
-				ARRAY_SIZE(tps6594_bucks_irq_types) +
-				ARRAY_SIZE(tps6594_ldos_irq_types),
-				GFP_KERNEL);
+	irq_data = devm_kmalloc_array(tps->dev, reg_irq_nb,
+				      sizeof(struct tps6594_regulator_irq_data), GFP_KERNEL);
 	if (!irq_data)
 		return -ENOMEM;
 
-- 
2.40.1



