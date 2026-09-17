Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595AD4E4C52;
	Thu, 17 Sep 2026 15:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659688; cv=none; b=rW3j65+kyswae17fk39Cv/kK6p1slicHs5eLMBg2GI5ttzFubJwOeoR5fz8YSOzsNpBO/pIxwwOV7sjkFvzJglmGk8ta00CmDbRnXfsynkjEKzy4Lbm2moXwi4i5H3lja+4xQqWBZKumcFKYkWkjsTqT0uOZ42DvUXW1o+KhHzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659688; c=relaxed/simple;
	bh=yABeOfpDvCpmW1waiqey7534b8gEn4EB84yUcJVMup4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqYIf9pInfRStQp4V4D7QJTqSf0y1tT1sVe4q0GV9j9tonzN+xzoOYX+D2juStwcxD+j087DGmO8dxQ5Ggadwk1b8INJtfYP+fGIo8xv85FCXrneCqt813dSWnTKXejRQXvdJd0TkAekEKWnkVQQXzUfx8Kp1g3WvdYfaFi0Z5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fk5wgYmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fk5wgYmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A731F00898;
	Thu, 17 Sep 2026 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659679;
	bh=hg9YVJeppVl9Z6gUppdWXRKm/F7ulWakOUMWgcmwu2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fk5wgYmn++jd7s+hbsuMpbTdD6zscdgQb06VOCDZXQ7xM6SjWJxxdQmBL0anNaN9k
	 vckRbIKc7+hRfiNAUggZujOZlTDXyeIvZzzMw8hSkZSCj+rLYUNB1tr77XEmbSWOTu
	 cBjFGiAFPA7JbbZGGXYQDuA3QvEefnDq2k2G3IQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 338/733] regulator: pf1550: fix which regulator is notified
Date: Thu, 17 Sep 2026 16:10:46 +0100
Message-ID: <20260917151359.962993145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit f3e6ef13e24c9f26dca0d35de57fcdf04f78e378 ]

The interrupt handler distinguishes the rail that reported the fault, but
the body ignores it. Every SW interrupt walks the regulator array looking
for the name "SW3" and every LDO interrupt looks for "LDO3", so an
over-current on SW1 is reported to the consumers of SW3 while the
consumers of SW1 hear nothing.

The lookup itself is unreliable as well. rdev_get_name() returns the
device tree regulator-name property whenever the board supplies one, and
only falls back to the name in the driver descriptor when it does not.
The binding example for this device sets regulator-name to "sw3" and
"ldo3", which strcmp() does not match against the upper case literals
used here, so a board that follows the documentation gets no over-current
notification at all. A board that names its rails after the schematic
does not match either. No other driver in the tree selects a notification
target this way.

Replace the name lookup with rdev_get_id(), which returns the descriptor
id set by the driver and cannot be overridden from the device tree, and
take both the id and the event from a table indexed by the interrupt.
The die temperature interrupts keep notifying every regulator since they
report a chip wide condition.

Fixes: 7320d41c29bb ("regulator: pf1550: Add support for regulator")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Link: https://patch.msgid.link/20260904105624.48577-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pf1550-regulator.c | 82 ++++++++++++++--------------
 1 file changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/regulator/pf1550-regulator.c b/drivers/regulator/pf1550-regulator.c
index 610eac9bb9cb2..ceee553a84b23 100644
--- a/drivers/regulator/pf1550-regulator.c
+++ b/drivers/regulator/pf1550-regulator.c
@@ -283,63 +283,61 @@ static struct pf1550_desc pf1550_regulators[] = {
 	PF_LDO1(PF1550, "ldo3", LDO3, 0x1f, pf1550_ldo13_volts),
 };
 
+/*
+ * The _LS interrupts indicate an over-current event. The _HS
+ * interrupts, which are more accurate and can detect catastrophic
+ * faults, issue an error event. The current limit FAULT interrupt is
+ * similar to the _HS.
+ */
+static const struct pf1550_regulator_irq {
+	unsigned int event;
+	u8 id;
+} pf1550_regulator_irqs[] = {
+	[PF1550_PMIC_IRQ_SW1_LS]     = { REGULATOR_EVENT_OVER_CURRENT_WARN, PF1550_SW1 },
+	[PF1550_PMIC_IRQ_SW2_LS]     = { REGULATOR_EVENT_OVER_CURRENT_WARN, PF1550_SW2 },
+	[PF1550_PMIC_IRQ_SW3_LS]     = { REGULATOR_EVENT_OVER_CURRENT_WARN, PF1550_SW3 },
+	[PF1550_PMIC_IRQ_SW1_HS]     = { REGULATOR_EVENT_OVER_CURRENT, PF1550_SW1 },
+	[PF1550_PMIC_IRQ_SW2_HS]     = { REGULATOR_EVENT_OVER_CURRENT, PF1550_SW2 },
+	[PF1550_PMIC_IRQ_SW3_HS]     = { REGULATOR_EVENT_OVER_CURRENT, PF1550_SW3 },
+	[PF1550_PMIC_IRQ_LDO1_FAULT] = { REGULATOR_EVENT_OVER_CURRENT, PF1550_LDO1 },
+	[PF1550_PMIC_IRQ_LDO2_FAULT] = { REGULATOR_EVENT_OVER_CURRENT, PF1550_LDO2 },
+	[PF1550_PMIC_IRQ_LDO3_FAULT] = { REGULATOR_EVENT_OVER_CURRENT, PF1550_LDO3 },
+};
+
 static irqreturn_t pf1550_regulator_irq_handler(int irq, void *data)
 {
+	const struct pf1550_regulator_irq *map;
 	struct pf1550_regulator_info *info = data;
 	struct device *dev = info->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 	int i, irq_type = -1;
-	unsigned int event;
 
 	for (i = 0; i < PF1550_REGULATOR_IRQ_NR; i++)
 		if (irq == platform_get_irq(pdev, i))
 			irq_type = i;
 
-	switch (irq_type) {
-	/* The _LS interrupts indicate over-current event. The _HS interrupts
-	 * which are more accurate and can detect catastrophic faults, issue
-	 * an error event. The current limit FAULT interrupt is similar to the
-	 * _HS'
-	 */
-	case PF1550_PMIC_IRQ_SW1_LS:
-	case PF1550_PMIC_IRQ_SW2_LS:
-	case PF1550_PMIC_IRQ_SW3_LS:
-		event = REGULATOR_EVENT_OVER_CURRENT_WARN;
-		for (i = 0; i < PF1550_MAX_REGULATOR; i++)
-			if (!strcmp(rdev_get_name(info->rdevs[i]), "SW3"))
-				regulator_notifier_call_chain(info->rdevs[i],
-							      event, NULL);
-		break;
-	case PF1550_PMIC_IRQ_SW1_HS:
-	case PF1550_PMIC_IRQ_SW2_HS:
-	case PF1550_PMIC_IRQ_SW3_HS:
-		event = REGULATOR_EVENT_OVER_CURRENT;
-		for (i = 0; i < PF1550_MAX_REGULATOR; i++)
-			if (!strcmp(rdev_get_name(info->rdevs[i]), "SW3"))
-				regulator_notifier_call_chain(info->rdevs[i],
-							      event, NULL);
-		break;
-	case PF1550_PMIC_IRQ_LDO1_FAULT:
-	case PF1550_PMIC_IRQ_LDO2_FAULT:
-	case PF1550_PMIC_IRQ_LDO3_FAULT:
-		event = REGULATOR_EVENT_OVER_CURRENT;
-		for (i = 0; i < PF1550_MAX_REGULATOR; i++)
-			if (!strcmp(rdev_get_name(info->rdevs[i]), "LDO3"))
-				regulator_notifier_call_chain(info->rdevs[i],
-							      event, NULL);
-		break;
-	case PF1550_PMIC_IRQ_TEMP_110:
-	case PF1550_PMIC_IRQ_TEMP_125:
-		event = REGULATOR_EVENT_OVER_TEMP;
+	/* The die temperature concerns every rail. */
+	if (irq_type == PF1550_PMIC_IRQ_TEMP_110 ||
+	    irq_type == PF1550_PMIC_IRQ_TEMP_125) {
 		for (i = 0; i < PF1550_MAX_REGULATOR; i++)
 			regulator_notifier_call_chain(info->rdevs[i],
-						      event, NULL);
-		break;
-	default:
-		dev_err(dev, "regulator interrupt: irq %d occurred\n",
-			irq_type);
+						      REGULATOR_EVENT_OVER_TEMP,
+						      NULL);
+		return IRQ_HANDLED;
+	}
+
+	if (irq_type < 0 || irq_type >= (int)ARRAY_SIZE(pf1550_regulator_irqs)) {
+		dev_err(dev, "regulator interrupt: irq %d occurred\n", irq_type);
+		return IRQ_HANDLED;
 	}
 
+	map = &pf1550_regulator_irqs[irq_type];
+
+	for (i = 0; i < PF1550_MAX_REGULATOR; i++)
+		if (rdev_get_id(info->rdevs[i]) == map->id)
+			regulator_notifier_call_chain(info->rdevs[i],
+						      map->event, NULL);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



