Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1156F1E2834;
	Wed, 25 Feb 2026 01:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983622; cv=none; b=ud7UaMsKmu7jHrmUKWpFwb7zpUB2Zu+4DroweM+BTKrNsCpHbHToMqIkNdj4GSkahcWF6+2Do2goKqjyxpVXvseEfsIFWn8yAUtGyfwP2A5j1mn/DP3hOhh0ezj8rI1hhD/T+dScTgFudWfnNDtWRiDuFlmtv5b07ifoRtzjNi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983622; c=relaxed/simple;
	bh=QL4y8vYouebnyklMjaG1sXFfekzFiRdRpHP+wk7TfHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdIsnwReCLA1iIYmT8iECECZdAuvORzUqlSbMvAhcukseWGoai4PV46g+d48+sZkNcDabaBK72/iOaM9PXUz8+yPzUx5me0G9GnYQz/ANVUZSaTRNUpzaQ/2KJz5ix/rAsooCWfvoSHafbepKd+RKgxPsQZ4FnKUSRwtSNdrA6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfD2agCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfD2agCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D9CC116D0;
	Wed, 25 Feb 2026 01:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983622;
	bh=QL4y8vYouebnyklMjaG1sXFfekzFiRdRpHP+wk7TfHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfD2agCnTYAiuy6+RcSt7ll8Wuojd2w1Tzhv4XbCeLAM8F+7Rol2KHG0TEJ+GBCPN
	 8q6Js4OfXcWtPR+yfJ6onQNRyI8K3V7d1fRoNNkWM3PGgJgvHZBLQf9y49aVh6eAef
	 q8TPX2b/qL46wZDYJ2TdCNrKIlyRG6m/xcZMOWJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 714/781] regulator: mt6363: Fix interrmittent timeout
Date: Tue, 24 Feb 2026 17:23:43 -0800
Message-ID: <20260225012417.255707796@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 1a4b0c999101b2532723f9bd9818b70ffa7580f4 ]

Sometimes, the mt6363 regulator would fail to initialize and return with
a TIMEOUT error, so add an extra instruction to wake up the bus before
issuing the commands.

Fixes: 3c36965df808 ("regulator: Add support for MediaTek MT6363 SPMI PMIC Regulators")
Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://patch.msgid.link/20260210053708.17239-4-aford173@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6363-regulator.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/mt6363-regulator.c b/drivers/regulator/mt6363-regulator.c
index e0fbf92e76851..03af5fa536007 100644
--- a/drivers/regulator/mt6363-regulator.c
+++ b/drivers/regulator/mt6363-regulator.c
@@ -861,7 +861,7 @@ static int mt6363_regulator_probe(struct platform_device *pdev)
 	struct irq_domain *domain;
 	struct irq_fwspec fwspec;
 	struct spmi_device *sdev;
-	int i, ret;
+	int i, ret, val;
 
 	config.regmap = mt6363_spmi_register_regmap(dev);
 	if (IS_ERR(config.regmap))
@@ -870,6 +870,13 @@ static int mt6363_regulator_probe(struct platform_device *pdev)
 	config.dev = dev;
 	sdev = to_spmi_device(dev->parent);
 
+	/*
+	 * The first read may fail if the bootloader sets sleep mode: wake up
+	 * this PMIC with W/R on the SPMI bus and ignore the first result.
+	 * This matches the MT6373 driver behavior.
+	 */
+	regmap_read(config.regmap, MT6363_TOP_TRAP, &val);
+
 	interrupt_parent = of_irq_find_parent(dev->of_node);
 	if (!interrupt_parent)
 		return dev_err_probe(dev, -EINVAL, "Cannot find IRQ parent\n");
-- 
2.51.0



