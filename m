Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C4042A9B;
	Tue, 27 May 2025 17:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368113; cv=none; b=ncMC5TEB4sxg2gwhQYC7IzvkzGivivhTcfYiWY6Ks3ql1tH3YAj+48HQtF19UEoxObWxJu5LBTcvXHw/nZCurReXIp50eo8p7Ay4OxNQi5lwikmIlnLOGqb6iU3Drsr2dX0w0n+bQAxXIgEVVH92FhCyeM01lJWAOhwW9FmyrR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368113; c=relaxed/simple;
	bh=PzzBSX5iAQKbv4SkIE5VOwYy//chGAyjjFfLlqEwaOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzbHN0sG0//pUXwXwsFbgnSoQMWaBLVBF3DX9oPuEryRsvqptPF1iMGX49fN1k1T7QBquxgDk71rwFfkqvLn7PObuYyO940UTyMRWuuAoKqsVG3SNGNJVlNlaTyPnPEiruFjVmO+Fz2nE87DIS+84r5wTCdQeY5eC9Pn6OgeciU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNlpoZ0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNlpoZ0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CE6C4CEE9;
	Tue, 27 May 2025 17:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368112;
	bh=PzzBSX5iAQKbv4SkIE5VOwYy//chGAyjjFfLlqEwaOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNlpoZ0htS8zYb/oubIlAq/S9RRQ324OnAo8GWscTzdX/dNGo/kcXiQ8aCdibu5Yc
	 +9druIlfh61HgZzzBliWF9Lganxcm6yrnlI4IybHj3D9DJxVv5ea0ta1fGQM5uPbCE
	 ukddkQIxgHtAmj/aWoEhaSpwxZ0MQo1Nz4eMINrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Isaac Scott <isaac.scott@ideasonboard.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 602/783] regulator: ad5398: Add device tree support
Date: Tue, 27 May 2025 18:26:39 +0200
Message-ID: <20250527162537.671970012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 40f7dba42b5ad..404cbe32711e7 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 
 #define AD5398_CURRENT_EN_MASK	0x8000
 
@@ -221,15 +222,20 @@ static int ad5398_probe(struct i2c_client *client)
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



