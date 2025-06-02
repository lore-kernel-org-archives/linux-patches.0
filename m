Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0EC22330F;
	Mon,  2 Jun 2025 15:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876890; cv=none; b=HPLmxbNY61gZaNJ0j59W6Us2r+mF7CFX6nU/V6HO4nz/tTbkgoSH2fTqVJ/uwBCHorG9ZxvANJnBwYi6F9751GEYMglHmVHG8MTUy6SiZCLq6vCkoMpxe1YQnWHZVP3RNNzQFHxk0cEhhfB+qaie1r9MqufakbwQpwMwKgHGrQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876890; c=relaxed/simple;
	bh=hA1aulh+sPykBBLESP9EiegOSglNQva+hl3dwoNkpsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC9ytYZ+8AOroeaSiLs05NoiI2qRrrqdCtDmbneh6PBQBMkVI/2MH+mlZ1cMc3JZg3UL4/aLbPmnUc5N/3Gj5XuEqeExzJ23/shXzXonHpp02bKACIo1f1FwHzhRBO+sCGNugxvPHLuEqpK5YNO9QCRYUMGhr8Ocu9bxoBgrzKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdJSEI+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdJSEI+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1F2C4CEEB;
	Mon,  2 Jun 2025 15:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876890;
	bh=hA1aulh+sPykBBLESP9EiegOSglNQva+hl3dwoNkpsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdJSEI+NorRAum3jFE7RgLIyRxF/Wi7LmDntCFnLWWI0pNEtxSdIoTQID1+cwDL2p
	 mHTxJFYCDOXikZgeupXebXysessn4NGO0WpllmGPlazgrZXLquwtf8c9oSNQbaYIzN
	 PVD53YkO8mfZqYa8CIaWMxclPRR8fflFKC70Y0JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/325] pinctrl-tegra: Restore SFSEL bit when freeing pins
Date: Mon,  2 Jun 2025 15:45:52 +0200
Message-ID: <20250602134322.870423397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Prathamesh Shete <pshete@nvidia.com>

[ Upstream commit c12bfa0fee65940b10ff5187349f76c6f6b1df9c ]

Each pin can be configured as a Special Function IO (SFIO) or GPIO,
where the SFIO enables the pin to operate in alternative modes such as
I2C, SPI, etc.

The current implementation sets all the pins back to SFIO mode
even if they were initially in GPIO mode. This can cause glitches
on the pins when pinctrl_gpio_free() is called.

Avoid these undesired glitches by storing the pin's SFIO/GPIO
state on GPIO request and restoring it on GPIO free.

Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Link: https://lore.kernel.org/20250305104939.15168-2-pshete@nvidia.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/tegra/pinctrl-tegra.c | 59 +++++++++++++++++++++++----
 drivers/pinctrl/tegra/pinctrl-tegra.h |  6 +++
 2 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/tegra/pinctrl-tegra.c b/drivers/pinctrl/tegra/pinctrl-tegra.c
index 30341c43da59a..ba7bcc876e304 100644
--- a/drivers/pinctrl/tegra/pinctrl-tegra.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra.c
@@ -278,8 +278,8 @@ static int tegra_pinctrl_set_mux(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-static const struct tegra_pingroup *tegra_pinctrl_get_group(struct pinctrl_dev *pctldev,
-					unsigned int offset)
+static int tegra_pinctrl_get_group_index(struct pinctrl_dev *pctldev,
+					 unsigned int offset)
 {
 	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 	unsigned int group, num_pins, j;
@@ -292,12 +292,35 @@ static const struct tegra_pingroup *tegra_pinctrl_get_group(struct pinctrl_dev *
 			continue;
 		for (j = 0; j < num_pins; j++) {
 			if (offset == pins[j])
-				return &pmx->soc->groups[group];
+				return group;
 		}
 	}
 
-	dev_err(pctldev->dev, "Pingroup not found for pin %u\n", offset);
-	return NULL;
+	return -EINVAL;
+}
+
+static const struct tegra_pingroup *tegra_pinctrl_get_group(struct pinctrl_dev *pctldev,
+							    unsigned int offset,
+							    int group_index)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	if (group_index < 0 || group_index > pmx->soc->ngroups)
+		return NULL;
+
+	return &pmx->soc->groups[group_index];
+}
+
+static struct tegra_pingroup_config *tegra_pinctrl_get_group_config(struct pinctrl_dev *pctldev,
+								    unsigned int offset,
+								    int group_index)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	if (group_index < 0)
+		return NULL;
+
+	return &pmx->pingroup_configs[group_index];
 }
 
 static int tegra_pinctrl_gpio_request_enable(struct pinctrl_dev *pctldev,
@@ -306,12 +329,15 @@ static int tegra_pinctrl_gpio_request_enable(struct pinctrl_dev *pctldev,
 {
 	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 	const struct tegra_pingroup *group;
+	struct tegra_pingroup_config *config;
+	int group_index;
 	u32 value;
 
 	if (!pmx->soc->sfsel_in_mux)
 		return 0;
 
-	group = tegra_pinctrl_get_group(pctldev, offset);
+	group_index = tegra_pinctrl_get_group_index(pctldev, offset);
+	group = tegra_pinctrl_get_group(pctldev, offset, group_index);
 
 	if (!group)
 		return -EINVAL;
@@ -319,7 +345,11 @@ static int tegra_pinctrl_gpio_request_enable(struct pinctrl_dev *pctldev,
 	if (group->mux_reg < 0 || group->sfsel_bit < 0)
 		return -EINVAL;
 
+	config = tegra_pinctrl_get_group_config(pctldev, offset, group_index);
+	if (!config)
+		return -EINVAL;
 	value = pmx_readl(pmx, group->mux_bank, group->mux_reg);
+	config->is_sfsel = (value & BIT(group->sfsel_bit)) != 0;
 	value &= ~BIT(group->sfsel_bit);
 	pmx_writel(pmx, value, group->mux_bank, group->mux_reg);
 
@@ -332,12 +362,15 @@ static void tegra_pinctrl_gpio_disable_free(struct pinctrl_dev *pctldev,
 {
 	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 	const struct tegra_pingroup *group;
+	struct tegra_pingroup_config *config;
+	int group_index;
 	u32 value;
 
 	if (!pmx->soc->sfsel_in_mux)
 		return;
 
-	group = tegra_pinctrl_get_group(pctldev, offset);
+	group_index = tegra_pinctrl_get_group_index(pctldev, offset);
+	group = tegra_pinctrl_get_group(pctldev, offset, group_index);
 
 	if (!group)
 		return;
@@ -345,8 +378,12 @@ static void tegra_pinctrl_gpio_disable_free(struct pinctrl_dev *pctldev,
 	if (group->mux_reg < 0 || group->sfsel_bit < 0)
 		return;
 
+	config = tegra_pinctrl_get_group_config(pctldev, offset, group_index);
+	if (!config)
+		return;
 	value = pmx_readl(pmx, group->mux_bank, group->mux_reg);
-	value |= BIT(group->sfsel_bit);
+	if (config->is_sfsel)
+		value |= BIT(group->sfsel_bit);
 	pmx_writel(pmx, value, group->mux_bank, group->mux_reg);
 }
 
@@ -799,6 +836,12 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 	pmx->dev = &pdev->dev;
 	pmx->soc = soc_data;
 
+	pmx->pingroup_configs = devm_kcalloc(&pdev->dev,
+					     pmx->soc->ngroups, sizeof(*pmx->pingroup_configs),
+					     GFP_KERNEL);
+	if (!pmx->pingroup_configs)
+		return -ENOMEM;
+
 	/*
 	 * Each mux group will appear in 4 functions' list of groups.
 	 * This over-allocates slightly, since not all groups are mux groups.
diff --git a/drivers/pinctrl/tegra/pinctrl-tegra.h b/drivers/pinctrl/tegra/pinctrl-tegra.h
index f8269858eb78a..ec5198d391ea5 100644
--- a/drivers/pinctrl/tegra/pinctrl-tegra.h
+++ b/drivers/pinctrl/tegra/pinctrl-tegra.h
@@ -8,6 +8,10 @@
 #ifndef __PINMUX_TEGRA_H__
 #define __PINMUX_TEGRA_H__
 
+struct tegra_pingroup_config {
+	bool is_sfsel;
+};
+
 struct tegra_pmx {
 	struct device *dev;
 	struct pinctrl_dev *pctl;
@@ -18,6 +22,8 @@ struct tegra_pmx {
 	int nbanks;
 	void __iomem **regs;
 	u32 *backup_regs;
+	/* Array of size soc->ngroups */
+	struct tegra_pingroup_config *pingroup_configs;
 };
 
 enum tegra_pinconf_param {
-- 
2.39.5



