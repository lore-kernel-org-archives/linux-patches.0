Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7562FA645;
	Tue, 17 Jun 2025 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178052; cv=none; b=cdyXIxI1kK9OyIRazBDCjxdcTGa/ZoUJHrCjb7tw7sG37RWwPVMoMKKLP8KjZk33l90JkotAC2PoBMsCDWCcD2dKGj2GnaMggjnR+SmjGQP2b9IxEO/zSwpGzrh+n876GN9RtjLNj7klXNGHecYQLky7CQIz/DZDjedGzVBRmhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178052; c=relaxed/simple;
	bh=0YCobVDi5jD/iAPsaKF+4HOhnxDJhxlb7e+avxeS8uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/kvPBGPIAI+wvlaZgWVDoqCHwpYPWl46+MuTl+ngchtRsmP3Wrx7kQlhgKacTf9vlN96H0k3ElkKaRKDrbrkBx0aXGKe2j6woBuys0NTBY1+O7uPFmUKNytYGC+oiDHgOFMDuFSwl9t0obgpV9lO9w7fZ+x1BAx4gc1HQBXokY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAYqQvm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAYqQvm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A83EC4CEE3;
	Tue, 17 Jun 2025 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178052;
	bh=0YCobVDi5jD/iAPsaKF+4HOhnxDJhxlb7e+avxeS8uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAYqQvm5whRkCibyFGliJWTFSrNmE53PSFC33lF3zLebG+8IUtBzzj9UsikkEVo5K
	 qu7otwhRJ70pkWNHeI7Ih/XHk38gcxJ1n7bZobpBAu/Kaucb+2ma68Svgjhzgu29Ki
	 hZKadgJzC3/rwoWYHZeLTs4ehx//LlZN9E2p9ffA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/512] regulator: max20086: Fix refcount leak in max20086_parse_regulators_dt()
Date: Tue, 17 Jun 2025 17:26:43 +0200
Message-ID: <20250617152437.278715325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 198d45f8e8849..3d333b61fb18c 100644
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



