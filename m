Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9417219049B;
	Mon, 23 Jun 2025 21:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715445; cv=none; b=K0R3AG83+GAREuyM2yv9N0wjAGrynY8pe/OkMTuqOCtT97kBXaHi1TROEGnYtF/uhpRvRFrdUgX6PK1mUDZVdnaLX8zpgGTBVOAKCaX3/rpUZSq2kqR12bwyqMvoL26Wc3KqBdddQ2KvrJcZMS7sV9GO2U2OzgBSFqRLTTZKzOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715445; c=relaxed/simple;
	bh=mpp6IV3hN7e3Bws/5TIOW1UAwFwKDW6Cu6SAM9tseXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Enov3Y4it7kvg0icew2M1EujiMmwr0SAsUF1DIlYetE9wybldJKlNKG0M9czMWdqYLCwafp8pMTW8ONIkQB4n854CDPQcv8r5VqFFsViHTX0TpPHh2A4r6c7l7W3PLSYNlrYgTN/tZIv0GZnodE5yHdnAVPYhZyuDABJwGIv03U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wz6dWVfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wz6dWVfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7CBC4CEEA;
	Mon, 23 Jun 2025 21:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715445;
	bh=mpp6IV3hN7e3Bws/5TIOW1UAwFwKDW6Cu6SAM9tseXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wz6dWVfC7/TXkKcpnwCNWIgOE8YA5WpcSePzPaKj2PFh+xisnR5IgmYlo6vATuRsm
	 QAf3KfxexP0/PKCFKA4odgDSs2J+A92H8AYUXMESx8CDiWYC8ylaMM5JaXNUmNjApk
	 t3UKkSvjd3NRzRd1x1WE1uYv61tOOrredAgvlDY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/508] regulator: max20086: Fix refcount leak in max20086_parse_regulators_dt()
Date: Mon, 23 Jun 2025 15:04:40 +0200
Message-ID: <20250623130651.040263628@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
index 332fb58f90952..a24dfffce25c7 100644
--- a/drivers/regulator/max20086-regulator.c
+++ b/drivers/regulator/max20086-regulator.c
@@ -5,6 +5,7 @@
 // Copyright (C) 2022 Laurent Pinchart <laurent.pinchart@idesonboard.com>
 // Copyright (C) 2018 Avnet, Inc.
 
+#include <linux/cleanup.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
@@ -134,11 +135,11 @@ static int max20086_regulators_register(struct max20086 *chip)
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
@@ -154,7 +155,6 @@ static int max20086_parse_regulators_dt(struct max20086 *chip, bool *boot_on)
 
 	ret = of_regulator_match(chip->dev, node, matches,
 				 chip->info->num_outputs);
-	of_node_put(node);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to match regulators\n");
 		return -EINVAL;
-- 
2.39.5



