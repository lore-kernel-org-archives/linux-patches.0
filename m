Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF68196DA8;
	Thu,  6 Jun 2024 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683022; cv=none; b=imzivfKk+fTKOOuFeOr6z2q0v7z3FpHkMuMezVHRrBh5hhzej/a/35b+nCxSQnzYedi+uuwu7x4DjY6H32ClB9lRF6EV3n8jzNozSNmScUkbw4xQ5dgXWqtPYTuYxEk5OE4csNKDHEG4B/mJl9UdxzDqxq1u3SuCpCTv8JUq4b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683022; c=relaxed/simple;
	bh=kYd6Hle+YGzyPUVWdr1Lp2YJEebm2FNuNw093jScmiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWXLXeuMbwGTUknxMFaR8LaY4HWA7yD1FhaMZmvO08xjN1XNelBqDjekTTBWTiP2OIRNnEITy4t16kR6SmhFVc34cQXulKOVKeCidq4ujA8a3NbvWFTvnPippQZL+RI0+rT7lbQfpEXW+kNIP4SaRmrwjDMPdHSwu6PuyvpgM4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knwbhKJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knwbhKJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C250BC2BD10;
	Thu,  6 Jun 2024 14:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683021;
	bh=kYd6Hle+YGzyPUVWdr1Lp2YJEebm2FNuNw093jScmiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knwbhKJ1dOC/jtjklu+cA9hsSHWyTtDc7V0Hu9ifr+eINhN+ps2jX3zegNaJaqG9y
	 Gfzp3Cdz0aLSP3Lcd90vH1NpaLMstUlWEMKNeKpav3s80LeBDhazs/FNjH1UvNgwDm
	 1GRyp9GxgELUJR/hftvKg5Hk0RlMNCNoVGr2ewUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 243/374] regulator: pickable ranges: dont always cache vsel
Date: Thu,  6 Jun 2024 16:03:42 +0200
Message-ID: <20240606131659.958527754@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit f4f4276f985a5aac7b310a4ed040b47e275e7591 ]

Some PMICs treat the vsel_reg same as apply-bit. Eg, when voltage range
is changed, the new voltage setting is not taking effect until the vsel
register is written.

Add a flag 'range_applied_by_vsel' to the regulator desc to indicate this
behaviour and to force the vsel value to be written to hardware if range
was changed, even if the old selector was same as the new one.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://msgid.link/r/ZktCpcGZdgHWuN_L@fedora
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1ace99d7c7c4 ("regulator: tps6287x: Force writing VSEL bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/helpers.c      | 43 ++++++++++++++++++++++----------
 include/linux/regulator/driver.h |  3 +++
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/helpers.c b/drivers/regulator/helpers.c
index d492683365532..6e1ace660b8cf 100644
--- a/drivers/regulator/helpers.c
+++ b/drivers/regulator/helpers.c
@@ -161,6 +161,32 @@ int regulator_get_voltage_sel_pickable_regmap(struct regulator_dev *rdev)
 }
 EXPORT_SYMBOL_GPL(regulator_get_voltage_sel_pickable_regmap);
 
+static int write_separate_vsel_and_range(struct regulator_dev *rdev,
+					 unsigned int sel, unsigned int range)
+{
+	bool range_updated;
+	int ret;
+
+	ret = regmap_update_bits_base(rdev->regmap, rdev->desc->vsel_range_reg,
+				      rdev->desc->vsel_range_mask,
+				      range, &range_updated, false, false);
+	if (ret)
+		return ret;
+
+	/*
+	 * Some PMICs treat the vsel_reg same as apply-bit. Force it to be
+	 * written if the range changed, even if the old selector was same as
+	 * the new one
+	 */
+	if (rdev->desc->range_applied_by_vsel && range_updated)
+		return regmap_write_bits(rdev->regmap,
+					rdev->desc->vsel_reg,
+					rdev->desc->vsel_mask, sel);
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->vsel_reg,
+				  rdev->desc->vsel_mask, sel);
+}
+
 /**
  * regulator_set_voltage_sel_pickable_regmap - pickable range set_voltage_sel
  *
@@ -199,21 +225,12 @@ int regulator_set_voltage_sel_pickable_regmap(struct regulator_dev *rdev,
 	range = rdev->desc->linear_range_selectors_bitfield[i];
 	range <<= ffs(rdev->desc->vsel_range_mask) - 1;
 
-	if (rdev->desc->vsel_reg == rdev->desc->vsel_range_reg) {
-		ret = regmap_update_bits(rdev->regmap,
-					 rdev->desc->vsel_reg,
+	if (rdev->desc->vsel_reg == rdev->desc->vsel_range_reg)
+		ret = regmap_update_bits(rdev->regmap, rdev->desc->vsel_reg,
 					 rdev->desc->vsel_range_mask |
 					 rdev->desc->vsel_mask, sel | range);
-	} else {
-		ret = regmap_update_bits(rdev->regmap,
-					 rdev->desc->vsel_range_reg,
-					 rdev->desc->vsel_range_mask, range);
-		if (ret)
-			return ret;
-
-		ret = regmap_update_bits(rdev->regmap, rdev->desc->vsel_reg,
-				  rdev->desc->vsel_mask, sel);
-	}
+	else
+		ret = write_separate_vsel_and_range(rdev, sel, range);
 
 	if (ret)
 		return ret;
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 22a07c0900a41..f230a472ccd35 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -299,6 +299,8 @@ enum regulator_type {
  * @vsel_range_reg: Register for range selector when using pickable ranges
  *		    and ``regulator_map_*_voltage_*_pickable`` functions.
  * @vsel_range_mask: Mask for register bitfield used for range selector
+ * @range_applied_by_vsel: A flag to indicate that changes to vsel_range_reg
+ *			   are only effective after vsel_reg is written
  * @vsel_reg: Register for selector when using ``regulator_map_*_voltage_*``
  * @vsel_mask: Mask for register bitfield used for selector
  * @vsel_step: Specify the resolution of selector stepping when setting
@@ -389,6 +391,7 @@ struct regulator_desc {
 
 	unsigned int vsel_range_reg;
 	unsigned int vsel_range_mask;
+	bool range_applied_by_vsel;
 	unsigned int vsel_reg;
 	unsigned int vsel_mask;
 	unsigned int vsel_step;
-- 
2.43.0



