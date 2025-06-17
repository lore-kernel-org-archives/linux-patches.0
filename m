Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E2928506E;
	Tue, 17 Jun 2025 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176674; cv=none; b=jLlK/n/GZjMT+NaWqwAyEBAHSiQW4seDcPUCbdVMWfAsPS63nETSpFHqe2q3VS2INs726r5ox0pIBvnHvE0VPHSGdLmrtK3sV7aOLO853bhQKo+nz6KSuiX5YRaPF2ZkP9rz8dsMTyPLDxZXu+XqxeEntKtLI48ifJiFzqQlTnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176674; c=relaxed/simple;
	bh=q0sLmmdKYAHhARmxkP+Ir2OXdPo7Tv1SVLFw3irvuw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPVoOMCN3/q1ZXRgvfaiQW2osF8A9Q7Bs728wBW6As2v4nzUmpytHpO0Cs9FMnkZIZ65LGxtyuKlqVZifmF2b9vi5MTeln7BHv4wfQFsBpTkYBaXpun4LiHstuugeWlekqEND22mORXxgAgh8F2vN96cdB3pCYsGn+hhmi8oABI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNgVj8ZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNgVj8ZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA5AC4CEF0;
	Tue, 17 Jun 2025 16:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176673;
	bh=q0sLmmdKYAHhARmxkP+Ir2OXdPo7Tv1SVLFw3irvuw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNgVj8ZFNcwSASCrzpZQQ7ostb42l+OtiNMdiD6/zcayeBsbJLKLofnwHzs257VEy
	 If+EhdMruQRwa4+kEnIjqPNg3yWLom6k0Yr3+iLcQwX8Q21aqQm6hfV11i3O3zAMaM
	 uDt7T9Ayj/2DxFOTDO4TgpOvhpLd6Z3jlW7GT0C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/356] regulator: max20086: Fix refcount leak in max20086_parse_regulators_dt()
Date: Tue, 17 Jun 2025 17:26:58 +0200
Message-ID: <20250617152350.366264306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 06118ae36855b7d3d22688298e74a766ccf0cb7a ]

There is a missing call to of_node_put() if devm_kcalloc() fails.
Fix this by changing the code to use cleanup.h magic to drop the
refcount.

Fixes: 6b0cd72757c6 ("regulator: max20086: fix invalid memory access")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aDVRLqgJWMxYU03G@stanley.mountain
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/max20086-regulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max20086-regulator.c b/drivers/regulator/max20086-regulator.c
index ebfbcadbca529..1cf04d1efb331 100644
--- a/drivers/regulator/max20086-regulator.c
+++ b/drivers/regulator/max20086-regulator.c
@@ -5,6 +5,7 @@
 // Copyright (C) 2022 Laurent Pinchart <laurent.pinchart@idesonboard.com>
 // Copyright (C) 2018 Avnet, Inc.
 
+#include <linux/cleanup.h>
 #include <linux/err.h>
 #include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
@@ -133,11 +134,11 @@ static int max20086_regulators_register(struct max20086 *chip)
 static int max20086_parse_regulators_dt(struct max20086 *chip, bool *boot_on)
 {
 	struct of_regulator_match *matches;
-	struct device_node *node;
 	unsigned int i;
 	int ret;
 
-	node = of_get_child_by_name(chip->dev->of_node, "regulators");
+	struct device_node *node __free(device_node) =
+		of_get_child_by_name(chip->dev->of_node, "regulators");
 	if (!node) {
 		dev_err(chip->dev, "regulators node not found\n");
 		return -ENODEV;
@@ -153,7 +154,6 @@ static int max20086_parse_regulators_dt(struct max20086 *chip, bool *boot_on)
 
 	ret = of_regulator_match(chip->dev, node, matches,
 				 chip->info->num_outputs);
-	of_node_put(node);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to match regulators\n");
 		return -EINVAL;
-- 
2.39.5



