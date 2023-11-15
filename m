Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E6B4121C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/DIw2zA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A16C433C7;
	Wed, 15 Nov 2023 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076282;
	bh=8oqn5shOpu7FzDx1UXprpBjt2x5m1V0VvgrnYIVwctg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/DIw2zA1w8tgR/+/WtijWJm2KDwAg2C7qZk9/m3useESqlpUkJ+1ObaVfecNd2dw
	 jJbqOUf2JKb9Tzzaa4G5UdxZjqiqA5V/l073E4d0d2MhFj64Ocu3JZ+oDlJudNEjyJ
	 pu6n/1guQXPPHbWyOBjxIlmgw6Fk+pp+SDOnPjMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Bogdan <dragos.bogdan@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 191/550] hwmon: (axi-fan-control) Fix possible NULL pointer dereference
Date: Wed, 15 Nov 2023 14:12:55 -0500
Message-ID: <20231115191613.997493397@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Bogdan <dragos.bogdan@analog.com>

[ Upstream commit 2a5b3370a1d9750eca325292e291c8c7cb8cf2e0 ]

axi_fan_control_irq_handler(), dependent on the private
axi_fan_control_data structure, might be called before the hwmon
device is registered. That will cause an "Unable to handle kernel
NULL pointer dereference" error.

Fixes: 8412b410fa5e ("hwmon: Support ADI Fan Control IP")
Signed-off-by: Dragos Bogdan <dragos.bogdan@analog.com>
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20231025132100.649499-1-nuno.sa@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/axi-fan-control.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/axi-fan-control.c b/drivers/hwmon/axi-fan-control.c
index 5fd136baf1cd3..19b9bf3d75ef9 100644
--- a/drivers/hwmon/axi-fan-control.c
+++ b/drivers/hwmon/axi-fan-control.c
@@ -496,6 +496,21 @@ static int axi_fan_control_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	ret = axi_fan_control_init(ctl, pdev->dev.of_node);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize device\n");
+		return ret;
+	}
+
+	ctl->hdev = devm_hwmon_device_register_with_info(&pdev->dev,
+							 name,
+							 ctl,
+							 &axi_chip_info,
+							 axi_fan_control_groups);
+
+	if (IS_ERR(ctl->hdev))
+		return PTR_ERR(ctl->hdev);
+
 	ctl->irq = platform_get_irq(pdev, 0);
 	if (ctl->irq < 0)
 		return ctl->irq;
@@ -509,19 +524,7 @@ static int axi_fan_control_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = axi_fan_control_init(ctl, pdev->dev.of_node);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to initialize device\n");
-		return ret;
-	}
-
-	ctl->hdev = devm_hwmon_device_register_with_info(&pdev->dev,
-							 name,
-							 ctl,
-							 &axi_chip_info,
-							 axi_fan_control_groups);
-
-	return PTR_ERR_OR_ZERO(ctl->hdev);
+	return 0;
 }
 
 static struct platform_driver axi_fan_control_driver = {
-- 
2.42.0



