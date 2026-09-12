Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDA337757A;
	Sat, 12 Sep 2026 07:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197485; cv=none; b=VwvKEIpg0bRHWoN++tt0lRNlp8KiCkWVIHZVdB4VvKPOuM3qzPqHaSBBL5/wVCaE/cBWnbftUwNOZCRFH4NXzLg+6SlOgzeQ2OaJ182ZGmKhGs3VBPiXeJNTMxMtMZjIS8YQXy1U9UMcUiIY4L6tq8zlb/i18bfhtVdww4gy5WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197485; c=relaxed/simple;
	bh=Jmt3DaW63opsSXLxU0pVhwpUijfAQz1LJkqmM8XpiSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2X9jZ0+TyB9ozcmSJNitDvPqOzfdfOwLAwtUbpq8exS+TShbYhYqYxsGSKBg+61Xp9nBfQuwUcusifw8Mmp4l/2M9aEPzRl21LOLuTIYCr5fg9W8dsBKDQV437TH2ghLVIi71X9aB/42jW79Bqm2G/KS/M9CIWJd48xxyMwN9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGf9pNen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGf9pNen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEA81F000FF;
	Sat, 12 Sep 2026 07:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197484;
	bh=YRJHR+MueyCcJUz77elyM4LnVY5liFJQEtE9/zpnJ0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGf9pNenuONQ2to86uCm3/cybwPDi/sMo/ilMkCWCp7NRocZYqQRfmpnhnkMrNqE4
	 HsCWnTFBoOWlw5aTT9UosNnakzHMLtR5EonzmxTt6Vy/XcugdNZktp5xHFcoASlnus
	 ufHkOsFSOcQZEpcfyx6QYO+iNvEtUDTUiPrdDcm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0141/1815] regulator: tps6594: Fix device node reference leaks in multiphase loop
Date: Sat, 12 Sep 2026 08:31:31 +0200
Message-ID: <20260912065652.324227093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit 7fd28093b3effc4f92566466df364622830ec608 ]

In tps6594_regulator_probe(), the multi-phase configuration loop calls
of_find_node_by_name() to find buck nodes by name, and of_get_parent()
twice to navigate to the PMIC parent node. None of the acquired node
references (np, intermediate parent, np_pmic_parent) are ever released
via of_node_put(), causing a reference leak on every loop iteration.

Additionally, of_find_node_by_name() can return NULL, but the result was
immediately passed to of_node_full_name() and of_get_parent() without a
NULL check, which could lead to a NULL pointer dereference.

Fix this by:
- Adding a NULL check for np after of_find_node_by_name()
- Storing the intermediate parent node in a local variable np_parent
- Calling of_node_put() on np, np_parent and np_pmic_parent at the
  end of each loop iteration

Fixes: f17ccc5deb4d ("regulator: tps6594-regulator: Add driver for TI TPS6594 regulators")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://patch.msgid.link/20260618132327.11529-1-udaykhare77@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6594-regulator.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps6594-regulator.c b/drivers/regulator/tps6594-regulator.c
index 645e83462c645..31a5218d55105 100644
--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -669,13 +669,20 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 	 * buck_configured to avoid creating bucks for every buck in multiphase
 	 */
 	for (multi = 0; multi < desc->num_multi_phase_regs; multi++) {
+		struct device_node *np_parent;
+
 		multi_regs = &desc->multi_phase_regs[multi];
 		np = of_find_node_by_name(tps->dev->of_node, multi_regs->supply_name);
-		npname = of_node_full_name(np);
-		np_pmic_parent = of_get_parent(of_get_parent(np));
-		if (of_node_cmp(of_node_full_name(np_pmic_parent), tps->dev->of_node->full_name))
+		if (!np)
 			continue;
-		if (strcmp(npname, multi_regs->supply_name) == 0) {
+
+		npname = of_node_full_name(np);
+		np_parent = of_get_parent(np);
+		np_pmic_parent = of_get_parent(np_parent);
+
+		if (np_pmic_parent &&
+		    !of_node_cmp(of_node_full_name(np_pmic_parent), tps->dev->of_node->full_name) &&
+		    strcmp(npname, multi_regs->supply_name) == 0) {
 			switch (multi) {
 			case MULTI_BUCK12:
 				buck_multi[0] = true;
@@ -706,6 +713,10 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 				break;
 			}
 		}
+
+		of_node_put(np_pmic_parent);
+		of_node_put(np_parent);
+		of_node_put(np);
 	}
 
 	reg_irq_nb = desc->num_irq_types * (desc->num_buck_regs + desc->num_ldo_regs);
-- 
2.53.0



