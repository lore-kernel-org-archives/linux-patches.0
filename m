Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7428E239E95;
	Mon,  2 Jun 2025 14:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876376; cv=none; b=HbGDAiLNzjEwTw2Iz5v3lk5Gonn3/cBtMNVIlIYS7zufhF4ng1eXhZR38W0kBZw90CxmbCSiPllzEqQ3zghySuJbz3Rtv4zJW14+vUHsO4vQ53yaKkrw407sC+Ti2pNcxppbzMEL4rovkwoad1zVyWxWyAlS66D61KhXQkl3yDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876376; c=relaxed/simple;
	bh=FNPfN3MCDltyu+j5LSJZHWNp2E4ubFgvZO8/s9pWaHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btf/bVGy3UUfLIlDroocDVrdIZxdEUw8KEIJJpRrGDueuyx8+RKdb+AofV7WeUXIGy3awYpqX5ZTkz8Nbk9FnAtxUhAxgufy4cW6yDKUOGB3bVPWZEIl26LzMtT5DB6cAqr27RVnOmBF8Xete2n+2QU0wRYalx9Lv/EcrRhtIb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BjETFwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BjETFwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CD1C4CEEE;
	Mon,  2 Jun 2025 14:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876376;
	bh=FNPfN3MCDltyu+j5LSJZHWNp2E4ubFgvZO8/s9pWaHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BjETFwXOAanqvqS3P0b/+n3XuRWr8syaCThjkJlGKJmokZ4ldUVA5at1zJKIZPWS
	 rmTmE1IzBP7/MwM7vs9eVDVzNJochvHLGeMH3IeW5kS9iUh/IG4qdTaTYaCIZpt8GZ
	 eX7+9070/SpRVS98qyOfUOR+c+ADrceCCixXP2zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Isaac Scott <isaac.scott@ideasonboard.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/207] regulator: ad5398: Add device tree support
Date: Mon,  2 Jun 2025 15:48:42 +0200
Message-ID: <20250602134304.596453398@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Isaac Scott <isaac.scott@ideasonboard.com>

[ Upstream commit 5a6a461079decea452fdcae955bccecf92e07e97 ]

Previously, the ad5398 driver used only platform_data, which is
deprecated in favour of device tree. This caused the AD5398 to fail to
probe as it could not load its init_data. If the AD5398 has a device
tree node, pull the init_data from there using
of_get_regulator_init_data.

Signed-off-by: Isaac Scott <isaac.scott@ideasonboard.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://patch.msgid.link/20250128173143.959600-4-isaac.scott@ideasonboard.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ad5398.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 75f432f61e919..f4d6e62bd963e 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 
 #define AD5398_CURRENT_EN_MASK	0x8000
 
@@ -221,15 +222,20 @@ static int ad5398_probe(struct i2c_client *client,
 	const struct ad5398_current_data_format *df =
 			(struct ad5398_current_data_format *)id->driver_data;
 
-	if (!init_data)
-		return -EINVAL;
-
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
 	config.dev = &client->dev;
+	if (client->dev.of_node)
+		init_data = of_get_regulator_init_data(&client->dev,
+						       client->dev.of_node,
+						       &ad5398_reg);
+	if (!init_data)
+		return -EINVAL;
+
 	config.init_data = init_data;
+	config.of_node = client->dev.of_node;
 	config.driver_data = chip;
 
 	chip->client = client;
-- 
2.39.5



