Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C07198E9A;
	Thu,  6 Jun 2024 14:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683510; cv=none; b=bbIMn8TkiS0PsvsSYgt0Ipt6JouZsiCD/t8vidgv1gZnXPtWK+EIbqxsjs8YfpiAUIk/tUGsDf/oszogfLuXWPmQo4xNFzouUpTatO7aFZBf/ykpUpVqKoGzsmuU+jO+OsSBOBotruq8uPVMK5fMQxZLEbNKLEdny4KiKzGfp5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683510; c=relaxed/simple;
	bh=nwnS6UDzoVaTmdHaa7fI0vOZG9e4TiDTBKsmKT3KdII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwmg0X2N8PIGXruZxtom2Z/MjnNAL8ykA8ct04D0ORa1GOqSf0VmqJbPCvP5FW2N1DegdQWjw6kOi/RHAdNjMJ/3/bvcrxG/TRA5wK2TzscB4LrPhAyVTuktstwYy3EfDZuxjo6Grdckr+Vwvg6SHYV2f5vP+3kIJh030oKVg0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hC9Xk03o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hC9Xk03o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974E2C2BD10;
	Thu,  6 Jun 2024 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683510;
	bh=nwnS6UDzoVaTmdHaa7fI0vOZG9e4TiDTBKsmKT3KdII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hC9Xk03ojp908V8uh18fZqDoy+RmALgLF9+jZottaoPdyiPuPml4d/HG2y7hE1hqS
	 ms4KwFQ+Sfi4Cz98WQBrPSbFK5JL9QjBTMtg3NRRuXk8ESrXlkUahV1PyH7a71iTwB
	 ci7qoS8Dm3Z/i9XUxt3rYaTbSvw/qsDwbFcYCqW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 399/473] regulator: bd71828: Dont overwrite runtime voltages
Date: Thu,  6 Jun 2024 16:05:28 +0200
Message-ID: <20240606131713.012351296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 0f9f7c63c415e287cd57b5c98be61eb320dedcfc ]

Some of the regulators on the BD71828 have common voltage setting for
RUN/SUSPEND/IDLE/LPSR states. The enable control can be set for each
state though.

The driver allows setting the voltage values for these states via
device-tree. As a side effect, setting the voltages for
SUSPEND/IDLE/LPSR will also change the RUN level voltage which is not
desired and can break the system.

The comment in code reflects this behaviour, but it is likely to not
make people any happier. The right thing to do is to allow setting the
enable/disable state at SUSPEND/IDLE/LPSR via device-tree, but to
disallow setting state specific voltages for those regulators.

BUCK1 is a bit different. It only shares the SUSPEND and LPSR state
voltages. The former behaviour of allowing to silently overwrite the
SUSPEND state voltage by LPSR state voltage is also changed here so that
the SUSPEND voltage is prioritized over LPSR voltage.

Prevent setting PMIC state specific voltages for regulators which do not
support it.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 522498f8cb8c ("regulator: bd71828: Basic support for ROHM bd71828 PMIC regulators")
Link: https://msgid.link/r/e1883ae1e3ae5668f1030455d4750923561f3d68.1715848512.git.mazziesaccount@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/bd71828-regulator.c | 58 +--------------------------
 1 file changed, 2 insertions(+), 56 deletions(-)

diff --git a/drivers/regulator/bd71828-regulator.c b/drivers/regulator/bd71828-regulator.c
index a4f09a5a30cab..d07f0d120ca71 100644
--- a/drivers/regulator/bd71828-regulator.c
+++ b/drivers/regulator/bd71828-regulator.c
@@ -207,14 +207,11 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 			.suspend_reg = BD71828_REG_BUCK1_SUSP_VOLT,
 			.suspend_mask = BD71828_MASK_BUCK1267_VOLT,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
-			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
 			/*
 			 * LPSR voltage is same as SUSPEND voltage. Allow
-			 * setting it so that regulator can be set enabled at
-			 * LPSR state
+			 * only enabling/disabling regulator for LPSR state
 			 */
-			.lpsr_reg = BD71828_REG_BUCK1_SUSP_VOLT,
-			.lpsr_mask = BD71828_MASK_BUCK1267_VOLT,
+			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
 		},
 		.reg_inits = buck1_inits,
 		.reg_init_amnt = ARRAY_SIZE(buck1_inits),
@@ -289,13 +286,7 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 				     ROHM_DVS_LEVEL_SUSPEND |
 				     ROHM_DVS_LEVEL_LPSR,
 			.run_reg = BD71828_REG_BUCK3_VOLT,
-			.idle_reg = BD71828_REG_BUCK3_VOLT,
-			.suspend_reg = BD71828_REG_BUCK3_VOLT,
-			.lpsr_reg = BD71828_REG_BUCK3_VOLT,
 			.run_mask = BD71828_MASK_BUCK3_VOLT,
-			.idle_mask = BD71828_MASK_BUCK3_VOLT,
-			.suspend_mask = BD71828_MASK_BUCK3_VOLT,
-			.lpsr_mask = BD71828_MASK_BUCK3_VOLT,
 			.idle_on_mask = BD71828_MASK_IDLE_EN,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
 			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
@@ -330,13 +321,7 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 				     ROHM_DVS_LEVEL_SUSPEND |
 				     ROHM_DVS_LEVEL_LPSR,
 			.run_reg = BD71828_REG_BUCK4_VOLT,
-			.idle_reg = BD71828_REG_BUCK4_VOLT,
-			.suspend_reg = BD71828_REG_BUCK4_VOLT,
-			.lpsr_reg = BD71828_REG_BUCK4_VOLT,
 			.run_mask = BD71828_MASK_BUCK4_VOLT,
-			.idle_mask = BD71828_MASK_BUCK4_VOLT,
-			.suspend_mask = BD71828_MASK_BUCK4_VOLT,
-			.lpsr_mask = BD71828_MASK_BUCK4_VOLT,
 			.idle_on_mask = BD71828_MASK_IDLE_EN,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
 			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
@@ -371,13 +356,7 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 				     ROHM_DVS_LEVEL_SUSPEND |
 				     ROHM_DVS_LEVEL_LPSR,
 			.run_reg = BD71828_REG_BUCK5_VOLT,
-			.idle_reg = BD71828_REG_BUCK5_VOLT,
-			.suspend_reg = BD71828_REG_BUCK5_VOLT,
-			.lpsr_reg = BD71828_REG_BUCK5_VOLT,
 			.run_mask = BD71828_MASK_BUCK5_VOLT,
-			.idle_mask = BD71828_MASK_BUCK5_VOLT,
-			.suspend_mask = BD71828_MASK_BUCK5_VOLT,
-			.lpsr_mask = BD71828_MASK_BUCK5_VOLT,
 			.idle_on_mask = BD71828_MASK_IDLE_EN,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
 			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
@@ -494,13 +473,7 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 				     ROHM_DVS_LEVEL_SUSPEND |
 				     ROHM_DVS_LEVEL_LPSR,
 			.run_reg = BD71828_REG_LDO1_VOLT,
-			.idle_reg = BD71828_REG_LDO1_VOLT,
-			.suspend_reg = BD71828_REG_LDO1_VOLT,
-			.lpsr_reg = BD71828_REG_LDO1_VOLT,
 			.run_mask = BD71828_MASK_LDO_VOLT,
-			.idle_mask = BD71828_MASK_LDO_VOLT,
-			.suspend_mask = BD71828_MASK_LDO_VOLT,
-			.lpsr_mask = BD71828_MASK_LDO_VOLT,
 			.idle_on_mask = BD71828_MASK_IDLE_EN,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
 			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
@@ -534,13 +507,7 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 				     ROHM_DVS_LEVEL_SUSPEND |
 				     ROHM_DVS_LEVEL_LPSR,
 			.run_reg = BD71828_REG_LDO2_VOLT,
-			.idle_reg = BD71828_REG_LDO2_VOLT,
-			.suspend_reg = BD71828_REG_LDO2_VOLT,
-			.lpsr_reg = BD71828_REG_LDO2_VOLT,
 			.run_mask = BD71828_MASK_LDO_VOLT,
-			.idle_mask = BD71828_MASK_LDO_VOLT,
-			.suspend_mask = BD71828_MASK_LDO_VOLT,
-			.lpsr_mask = BD71828_MASK_LDO_VOLT,
 			.idle_on_mask = BD71828_MASK_IDLE_EN,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
 			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
@@ -574,13 +541,7 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 				     ROHM_DVS_LEVEL_SUSPEND |
 				     ROHM_DVS_LEVEL_LPSR,
 			.run_reg = BD71828_REG_LDO3_VOLT,
-			.idle_reg = BD71828_REG_LDO3_VOLT,
-			.suspend_reg = BD71828_REG_LDO3_VOLT,
-			.lpsr_reg = BD71828_REG_LDO3_VOLT,
 			.run_mask = BD71828_MASK_LDO_VOLT,
-			.idle_mask = BD71828_MASK_LDO_VOLT,
-			.suspend_mask = BD71828_MASK_LDO_VOLT,
-			.lpsr_mask = BD71828_MASK_LDO_VOLT,
 			.idle_on_mask = BD71828_MASK_IDLE_EN,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
 			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
@@ -615,13 +576,7 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 				     ROHM_DVS_LEVEL_SUSPEND |
 				     ROHM_DVS_LEVEL_LPSR,
 			.run_reg = BD71828_REG_LDO4_VOLT,
-			.idle_reg = BD71828_REG_LDO4_VOLT,
-			.suspend_reg = BD71828_REG_LDO4_VOLT,
-			.lpsr_reg = BD71828_REG_LDO4_VOLT,
 			.run_mask = BD71828_MASK_LDO_VOLT,
-			.idle_mask = BD71828_MASK_LDO_VOLT,
-			.suspend_mask = BD71828_MASK_LDO_VOLT,
-			.lpsr_mask = BD71828_MASK_LDO_VOLT,
 			.idle_on_mask = BD71828_MASK_IDLE_EN,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
 			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
@@ -656,13 +611,7 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 				     ROHM_DVS_LEVEL_SUSPEND |
 				     ROHM_DVS_LEVEL_LPSR,
 			.run_reg = BD71828_REG_LDO5_VOLT,
-			.idle_reg = BD71828_REG_LDO5_VOLT,
-			.suspend_reg = BD71828_REG_LDO5_VOLT,
-			.lpsr_reg = BD71828_REG_LDO5_VOLT,
 			.run_mask = BD71828_MASK_LDO_VOLT,
-			.idle_mask = BD71828_MASK_LDO_VOLT,
-			.suspend_mask = BD71828_MASK_LDO_VOLT,
-			.lpsr_mask = BD71828_MASK_LDO_VOLT,
 			.idle_on_mask = BD71828_MASK_IDLE_EN,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
 			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
@@ -721,9 +670,6 @@ static const struct bd71828_regulator_data bd71828_rdata[] = {
 			.suspend_reg = BD71828_REG_LDO7_VOLT,
 			.lpsr_reg = BD71828_REG_LDO7_VOLT,
 			.run_mask = BD71828_MASK_LDO_VOLT,
-			.idle_mask = BD71828_MASK_LDO_VOLT,
-			.suspend_mask = BD71828_MASK_LDO_VOLT,
-			.lpsr_mask = BD71828_MASK_LDO_VOLT,
 			.idle_on_mask = BD71828_MASK_IDLE_EN,
 			.suspend_on_mask = BD71828_MASK_SUSP_EN,
 			.lpsr_on_mask = BD71828_MASK_LPSR_EN,
-- 
2.43.0



