Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ED02E40E
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1xaFE+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BA3C32793;
	Wed, 15 Nov 2023 20:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081363;
	bh=NJYNLVJMiWy77bOopTInqcUMLf8xV/bTdY2VWSPlcFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1xaFE+XuG+v9rL0gPoAByiIfnyt0RhMG/dtit2rjDtN0JCtEVrM8DE964T68ukCx
	 ukB+/JXxgkBYr2OtFFIzEk8Iw63KiQvFZ/eqdDCZgk3TBi++FiGuCaZRfPBSIYvD53
	 YF0A+qr293e6X0k9ioFv6psHE6rVfyjjw+BMtJek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Bogdan <dragos.bogdan@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/244] hwmon: (axi-fan-control) Fix possible NULL pointer dereference
Date: Wed, 15 Nov 2023 15:34:33 -0500
Message-ID: <20231115203553.220083968@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d2092c17d9935..7af18018a32ff 100644
--- a/drivers/hwmon/axi-fan-control.c
+++ b/drivers/hwmon/axi-fan-control.c
@@ -508,6 +508,21 @@ static int axi_fan_control_probe(struct platform_device *pdev)
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
@@ -521,19 +536,7 @@ static int axi_fan_control_probe(struct platform_device *pdev)
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



