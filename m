Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20934407CCF;
	Thu, 30 Jul 2026 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423920; cv=none; b=ngX80sxND2ND/FuOn7VVX5rn9SUq5QJgesR34zEYD/1SZ1zOumWujnoqOlbvVUP4uDdhBIPsHZELvY3cUsx+TiGWbSww1ljs3QGtcUPIldoj6333dqeLPILKi7FxdWHZIC5hecRq3TiR9XXyEqiGKp+1dyJ30iNCZvXn9FDHSDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423920; c=relaxed/simple;
	bh=PPk+xxt4/eVvhtfXf2oilsip8v6XO6e6U0tX+A9hlnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cebvD4OunzbevxGzz+f46p1SQKkQ+iWKVE+dgb0uJCKRNUzzYjv6cUYYe/wP2Ah62UokAtIXMGI4m/ZZA8SAletLsHZDBRUap+/k2QlZJt38QXD5vRgP5+NKLdQmfow0g+mrfApb3FldYsAmi+uAAk5M+aRXjoOdIIdephD7i+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gweCRQKn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gweCRQKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0D61F000E9;
	Thu, 30 Jul 2026 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423919;
	bh=hbnIaXXXHmF/0Z9MohxBSDAsj5+x69/OF44JzLxKGkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gweCRQKnPpGU9jJ1/oIxH37FSxpr9GihvGyNwbV9MmFVD1KooR7Tgg5DyOwLtIG+m
	 QPJbC70onABbVjBAnIJ6YkzJZjDcLldh3djAXOT9Ew5+/IuX3bqCTMEg3AbgIPLYZ+
	 mYlg10QocSusJZ1cNgPRIG/hgpIHzgbBNgEaDufw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/675] regulator: mt6358: use regmap helper to read fixed LDO calibration
Date: Thu, 30 Jul 2026 16:09:00 +0200
Message-ID: <20260730141449.605784950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e4745f616cea3b..44bef0bdfdbe35 100644
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



