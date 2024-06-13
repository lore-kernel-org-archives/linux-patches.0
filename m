Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA91514375C;
	Thu, 13 Jun 2024 12:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282475; cv=none; b=IaYwLeWpjHobbEGCWcrCOfOROgOYZQFRjTSJachReJHviOQI0CEM+nQ8thzS1XF/XAc1GnO8fEnZ++CCdZr8wWL+DkhXmVVZdd38X2yIB5Jp3kdKfrj97FIhT46aLqb6yiF4bVcVfDmZ8MC7ivWPK4nxR0oU3eMJPdchQhCGZ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282475; c=relaxed/simple;
	bh=nsxT4sB6mvbAIAvEMEhXDDk+fp2rLFq24PiBy9joIkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+0MVYzHfUIMYfvQJzSlMwEwdQWexIghEPr2On+g1VQLPrhKBxLZW9ViJApgyGowDjKShTBG10nN65ii0BitmXHvcCc9bQnikzclB1q2cGSNohb0VTsZlcB+ERxfwrC+l5vDHNYeA1D15xEt4n3B4SwJ/8H9j7/LC3TCmFm6kTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByE6RXkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByE6RXkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A40C4AF1D;
	Thu, 13 Jun 2024 12:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282474;
	bh=nsxT4sB6mvbAIAvEMEhXDDk+fp2rLFq24PiBy9joIkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByE6RXkckYA6a5YICoWScT/hBw/v9gyKd3n8e1kaQBKl4zxOwTppsCWMG1rQy3cj3
	 ty5A9MBaAMddjVFfhVAo2iMmyQBFvQfG5/M1DZTDsdztE6QQM5WcdVDNMxBTJ3V+OI
	 njff8wFtYNuTT5Mkmh3swJfDzkK91Y+taeQiwsUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/402] regulator: bd71828: Dont overwrite runtime voltages
Date: Thu, 13 Jun 2024 13:33:59 +0200
Message-ID: <20240613113313.148102289@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



