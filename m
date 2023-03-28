Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454F38BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6E9C433D2;
	Tue, 28 Mar 2023 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014947;
	bh=fEZOnQtP0VdFol/D97Icme1BuX4OM5d6XCMc3GCW6qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guRbdizGzXjrErlF1NPzWjqpCsyExIrVCxTqQzQ+ZuCRFeYMW5TwG5g3A83wHb6Pk
	 prZxQCdcfNjfjB0+EUdkVfUF02ubfm2te7fK2KFly/V2F5V//a67YWvzLP6/p9sFZC
	 vkXkhOdtaCQOHUdeU9BRZo1REOuNalHBCkEmY2O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phinex Hung <phinex@realtek.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 111/240] hwmon: fix potential sensor registration fail if of_node is missing
Date: Tue, 28 Mar 2023 16:41:14 +0200
Message-Id: <20230328142624.405320947@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Phinex Hung <phinex@realtek.com>

[ Upstream commit 2315332efcbe7124252f080e03b57d3d2f1f4771 ]

It is not sufficient to check of_node in current device.
In some cases, this would cause the sensor registration to fail.

This patch looks for device's ancestors to find a valid of_node if any.

Fixes: d560168b5d0f ("hwmon: (core) New hwmon registration API")
Signed-off-by: Phinex Hung <phinex@realtek.com>
Link: https://lore.kernel.org/r/20230321060224.3819-1-phinex@realtek.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hwmon.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 33edb5c02f7d7..d193ed3cb35e5 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -757,6 +757,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	struct hwmon_device *hwdev;
 	const char *label;
 	struct device *hdev;
+	struct device *tdev = dev;
 	int i, err, id;
 
 	/* Complain about invalid characters in hwmon name attribute */
@@ -826,7 +827,9 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	hwdev->name = name;
 	hdev->class = &hwmon_class;
 	hdev->parent = dev;
-	hdev->of_node = dev ? dev->of_node : NULL;
+	while (tdev && !tdev->of_node)
+		tdev = tdev->parent;
+	hdev->of_node = tdev ? tdev->of_node : NULL;
 	hwdev->chip = chip;
 	dev_set_drvdata(hdev, drvdata);
 	dev_set_name(hdev, HWMON_ID_FORMAT, id);
@@ -838,7 +841,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 
 	INIT_LIST_HEAD(&hwdev->tzdata);
 
-	if (dev && dev->of_node && chip && chip->ops->read &&
+	if (hdev->of_node && chip && chip->ops->read &&
 	    chip->info[0]->type == hwmon_chip &&
 	    (chip->info[0]->config[0] & HWMON_C_REGISTER_TZ)) {
 		err = hwmon_thermal_register_sensors(hdev);
-- 
2.39.2



