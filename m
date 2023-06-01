Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F38EE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68293C433D2;
	Thu,  1 Jun 2023 13:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625781;
	bh=sNBINE4f3wI4nfZWemx6M4fze2KkEIZy6Ii9i/SbOok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaeIqDVQg/P4sMiETdSG1GZgc72Kde/w/5auRjx6+p5Np7fwzcNYGYdbiLzj9O2fE
	 91tMxb+C+lqoYhZ9GpZXrH7mdNnx/5Ac4Omu9JYrZEJFB13Cck8iaWur9dCJerrqyV
	 t4hSzfdrAImDag+aY6aS61HMosMy2jpinKgB3rK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/22] regulator: Add regmap helper for ramp-delay setting
Date: Thu,  1 Jun 2023 14:21:11 +0100
Message-Id: <20230601131934.359763608@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131933.727832920@linuxfoundation.org>
References: <20230601131933.727832920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit fb8fee9efdcf084d9e31ba14cc4734d97e5dd972 ]

Quite a few regulator ICs do support setting ramp-delay by writing a value
matching the delay to a ramp-delay register.

Provide a simple helper for table-based delay setting.

Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/f101f1db564cf32cb58719c77af0b00d7236bb89.1617020713.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d67dada3e252 ("regulator: pca9450: Fix BUCK2 enable_mask")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/helpers.c      | 65 ++++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |  5 +++
 2 files changed, 70 insertions(+)

diff --git a/drivers/regulator/helpers.c b/drivers/regulator/helpers.c
index e4bb09bbd3fa6..a356f84b1285b 100644
--- a/drivers/regulator/helpers.c
+++ b/drivers/regulator/helpers.c
@@ -879,3 +879,68 @@ bool regulator_is_equal(struct regulator *reg1, struct regulator *reg2)
 	return reg1->rdev == reg2->rdev;
 }
 EXPORT_SYMBOL_GPL(regulator_is_equal);
+
+static int find_closest_bigger(unsigned int target, const unsigned int *table,
+			       unsigned int num_sel, unsigned int *sel)
+{
+	unsigned int s, tmp, max, maxsel = 0;
+	bool found = false;
+
+	max = table[0];
+
+	for (s = 0; s < num_sel; s++) {
+		if (table[s] > max) {
+			max = table[s];
+			maxsel = s;
+		}
+		if (table[s] >= target) {
+			if (!found || table[s] - target < tmp - target) {
+				tmp = table[s];
+				*sel = s;
+				found = true;
+				if (tmp == target)
+					break;
+			}
+		}
+	}
+
+	if (!found) {
+		*sel = maxsel;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * regulator_set_ramp_delay_regmap - set_ramp_delay() helper
+ *
+ * @rdev: regulator to operate on
+ *
+ * Regulators that use regmap for their register I/O can set the ramp_reg
+ * and ramp_mask fields in their descriptor and then use this as their
+ * set_ramp_delay operation, saving some code.
+ */
+int regulator_set_ramp_delay_regmap(struct regulator_dev *rdev, int ramp_delay)
+{
+	int ret;
+	unsigned int sel;
+
+	if (!rdev->desc->n_ramp_values)
+		return -EINVAL;
+
+	ret = find_closest_bigger(ramp_delay, rdev->desc->ramp_delay_table,
+				  rdev->desc->n_ramp_values, &sel);
+
+	if (ret) {
+		dev_warn(rdev_get_dev(rdev),
+			 "Can't set ramp-delay %u, setting %u\n", ramp_delay,
+			 rdev->desc->ramp_delay_table[sel]);
+	}
+
+	sel <<= ffs(rdev->desc->ramp_mask) - 1;
+
+	return regmap_update_bits(rdev->regmap, rdev->desc->ramp_reg,
+				  rdev->desc->ramp_mask, sel);
+}
+EXPORT_SYMBOL_GPL(regulator_set_ramp_delay_regmap);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 11cade73726ce..633e7a2ab01d0 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -370,6 +370,10 @@ struct regulator_desc {
 	unsigned int pull_down_reg;
 	unsigned int pull_down_mask;
 	unsigned int pull_down_val_on;
+	unsigned int ramp_reg;
+	unsigned int ramp_mask;
+	const unsigned int *ramp_delay_table;
+	unsigned int n_ramp_values;
 
 	unsigned int enable_time;
 
@@ -532,6 +536,7 @@ int regulator_set_current_limit_regmap(struct regulator_dev *rdev,
 				       int min_uA, int max_uA);
 int regulator_get_current_limit_regmap(struct regulator_dev *rdev);
 void *regulator_get_init_drvdata(struct regulator_init_data *reg_init_data);
+int regulator_set_ramp_delay_regmap(struct regulator_dev *rdev, int ramp_delay);
 
 /*
  * Helper functions intended to be used by regulator drivers prior registering
-- 
2.39.2



