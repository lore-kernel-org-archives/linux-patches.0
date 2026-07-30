Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6AC346A18;
	Thu, 30 Jul 2026 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421944; cv=none; b=trMaEes/CkN35hpLzl+1EMElKQW9bZpHGWwO9rtBj11cfcX8ul4gPfXsfhmlcC4JGowKzEL70D9bRCGxgY54dVwg66wTdhn/JBFDT/Gp527SfdppEE5ZCUrw/fkERvjgtEKFL6GGvSjdzi7nQCtoooLdn+/IAp8A9VugZaSaGQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421944; c=relaxed/simple;
	bh=CEx8kzWi1RHEmU43mdKdrr3t3mBVx2juDEY8YYWALew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXEyJwpC26fuRi2JhEvElKI9H4v5QsHtz9CuELSu3aZZYSqbj8uWRPtZfceI4P9NLrFn1OrLQpgE0ja/lF1vXfoVFXppYcXZizB3LxpJJSPhBfooNBuazrfp7lmvhXqF5uBwoyu8e9ZayihreDPKliCkztn4mCNHCl1JZCLix7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcLxmVCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcLxmVCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29EB1F000E9;
	Thu, 30 Jul 2026 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421940;
	bh=GhxLkW2ZQrRmOVOMF0xMMsllhCwmNl/S8Ad6WzPoRcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcLxmVCA/AmvxL5TeGc6uYyJcpssKrpaogtgT5H2yhmZeObHOJZ7hr0BG7CXjaUEA
	 6pKSWRBGhZkhJWxPdUaXtVq7I+RwmR1E2CZwLTIRMpQNq9KaYDfjcUIeCBdxgajAiw
	 RxZC3GO2w1t7W8wJ6BXGDfNqQTK1VNbTtabzK3oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 227/744] regulator: mt6358: use regmap helper to read fixed LDO calibration
Date: Thu, 30 Jul 2026 16:08:20 +0200
Message-ID: <20260730141449.114812153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 1d26f125501f3fbe6c259ab75bf6516299a0bf0e ]

The "fixed" LDOs with output voltage calibration use
mt6358_get_buck_voltage_sel as their get_voltage_sel op, but the
MT6358_REG_FIXED and MT6366_REG_FIXED entries do not populate
da_vsel_reg/da_vsel_mask. The op therefore reads register 0x0 with a
zero mask and shifts the result by ffs(0) - 1 = -1, which is undefined
behaviour and gets flagged by UBSAN on every boot on MT6366 boards:

  UBSAN: shift-out-of-bounds in drivers/regulator/mt6358-regulator.c:384:38
  shift exponent -1 is negative
  Call trace:
   mt6358_get_buck_voltage_sel+0xc8/0x120
   regulator_get_voltage_rdev+0x70/0x170
   set_machine_constraints+0x504/0xc38
   regulator_register+0x324/0xc68

Besides the undefined shift, the returned selector is always 0, so the
actual calibration offset programmed in <reg>_ANA_CON0 is never
reported.

The descriptor already carries the correct vsel_reg/vsel_mask (the
ANA_CON0 calibration field), matching the regulator_set_voltage_sel_regmap
op already in use. Read the selector back through
regulator_get_voltage_sel_regmap instead.

Fixes: cf08fa74c716 ("regulator: mt6358: Add output voltage fine tuning to fixed regulators")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Tested-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/dcd98d81dede338c9bbb9700a9613c848b702e49.1784336005.git.daniel@makrotopia.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6358-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mt6358-regulator.c b/drivers/regulator/mt6358-regulator.c
index 2604f674be493b..d483f85936f81f 100644
--- a/drivers/regulator/mt6358-regulator.c
+++ b/drivers/regulator/mt6358-regulator.c
@@ -492,7 +492,7 @@ static const struct regulator_ops mt6358_volt_fixed_ops = {
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
-	.get_voltage_sel = mt6358_get_buck_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_time_sel = regulator_set_voltage_time_sel,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-- 
2.53.0



