Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A713F1F759C;
	Tue,  3 Dec 2024 15:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241340; cv=none; b=n0R3+gXji0Zj0f9MOUpANqDnw2v11nkCAo/dNzJa/gHVHYCUFC4WVOwJilzmkrcr30+NvCMNg8COFTMZ6JLFmeF56kxgEM/E4sSIHECb5PhQVvnsA4cAATzyogG+euoCvmVCfuOqhh7KYz+AHiB8e7SHegtlrnJ0R5U2vVVbTuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241340; c=relaxed/simple;
	bh=PJ23XCJC8U/5LPTnDfQ0tYg0bpsy67VpYRktnqER3VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P647s+tRDj3YfmIoMsqiKdqx4e6gIBWwFQ1n1c5CRrCNTiqFzjsDwamOTtjDLbJ2yPjjqv33nkz6DKNyx6iqkykhOXOrPrK7hIrFaD+bt3CbVQNRrpJNWFs/5SEH6DIaUvSjf27jAa+QxVYiR+BUyokCUgkixT1N2Ka+u27GAWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLWN6iWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLWN6iWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F6DC4CED8;
	Tue,  3 Dec 2024 15:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241340;
	bh=PJ23XCJC8U/5LPTnDfQ0tYg0bpsy67VpYRktnqER3VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLWN6iWobsuf+9mcIzjap6j8qBW8YTb+5RVmFduQvL9RKj7rjcTFLz2kpnIOPTd4F
	 /cKJdGiRH4+Kav3LhuPVqCLRQhZvbgYFtqA8tMciJ6Vq/Z7BALg5TvfQ+WYZBD/M4j
	 igOvtL6ZUNJ7dYu/OnZAh4vRE1Cx4BBQprgl3k0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/826] mfd: intel_soc_pmic_bxtwc: Fix IRQ domain names duplication
Date: Tue,  3 Dec 2024 15:41:42 +0100
Message-ID: <20241203144758.394041665@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3727c0b4ff6ba0e61203544b4c831f7f8899753b ]

For all of the devices regmap IRQ may try to created the folder
with the same name which is impossible and fails with:

  debugfs: File '\_SB.IPC1.PMIC' in directory 'domains' already present!

Add domain_suffix to all of the IRQ chips driver registers to solve
the issue.

Fixes: 39d047c0b1c8 ("mfd: add Intel Broxton Whiskey Cove PMIC driver")
Fixes: 957ae5098185 ("platform/x86: Add Whiskey Cove PMIC TMU support")
Fixes: 57129044f504 ("mfd: intel_soc_pmic_bxtwc: Use chained IRQs for second level IRQ chips")
Depends-on: dde286ee5770 ("regmap: Allow setting IRQ domain name suffix")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241005193029.1929139-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_bxtwc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/intel_soc_pmic_bxtwc.c b/drivers/mfd/intel_soc_pmic_bxtwc.c
index fefbeb4164fde..b7204072e93ef 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -148,6 +148,7 @@ static const struct regmap_irq_chip bxtwc_regmap_irq_chip = {
 
 static const struct regmap_irq_chip bxtwc_regmap_irq_chip_pwrbtn = {
 	.name = "bxtwc_irq_chip_pwrbtn",
+	.domain_suffix = "PWRBTN",
 	.status_base = BXTWC_PWRBTNIRQ,
 	.mask_base = BXTWC_MPWRBTNIRQ,
 	.irqs = bxtwc_regmap_irqs_pwrbtn,
@@ -157,6 +158,7 @@ static const struct regmap_irq_chip bxtwc_regmap_irq_chip_pwrbtn = {
 
 static const struct regmap_irq_chip bxtwc_regmap_irq_chip_tmu = {
 	.name = "bxtwc_irq_chip_tmu",
+	.domain_suffix = "TMU",
 	.status_base = BXTWC_TMUIRQ,
 	.mask_base = BXTWC_MTMUIRQ,
 	.irqs = bxtwc_regmap_irqs_tmu,
@@ -166,6 +168,7 @@ static const struct regmap_irq_chip bxtwc_regmap_irq_chip_tmu = {
 
 static const struct regmap_irq_chip bxtwc_regmap_irq_chip_bcu = {
 	.name = "bxtwc_irq_chip_bcu",
+	.domain_suffix = "BCU",
 	.status_base = BXTWC_BCUIRQ,
 	.mask_base = BXTWC_MBCUIRQ,
 	.irqs = bxtwc_regmap_irqs_bcu,
@@ -175,6 +178,7 @@ static const struct regmap_irq_chip bxtwc_regmap_irq_chip_bcu = {
 
 static const struct regmap_irq_chip bxtwc_regmap_irq_chip_adc = {
 	.name = "bxtwc_irq_chip_adc",
+	.domain_suffix = "ADC",
 	.status_base = BXTWC_ADCIRQ,
 	.mask_base = BXTWC_MADCIRQ,
 	.irqs = bxtwc_regmap_irqs_adc,
@@ -184,6 +188,7 @@ static const struct regmap_irq_chip bxtwc_regmap_irq_chip_adc = {
 
 static const struct regmap_irq_chip bxtwc_regmap_irq_chip_chgr = {
 	.name = "bxtwc_irq_chip_chgr",
+	.domain_suffix = "CHGR",
 	.status_base = BXTWC_CHGR0IRQ,
 	.mask_base = BXTWC_MCHGR0IRQ,
 	.irqs = bxtwc_regmap_irqs_chgr,
@@ -193,6 +198,7 @@ static const struct regmap_irq_chip bxtwc_regmap_irq_chip_chgr = {
 
 static const struct regmap_irq_chip bxtwc_regmap_irq_chip_crit = {
 	.name = "bxtwc_irq_chip_crit",
+	.domain_suffix = "CRIT",
 	.status_base = BXTWC_CRITIRQ,
 	.mask_base = BXTWC_MCRITIRQ,
 	.irqs = bxtwc_regmap_irqs_crit,
-- 
2.43.0



