Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E44D80043;
	Wed,  7 Aug 2024 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043221; cv=none; b=LrYhci6om3omQpW2VaFOBJsqAAPTg2ZL8wq2RslUao0nMHEG5cHf1GUOTbGNRlhZ0ns93tR1MTuM7nJNW79SM4PXKFaAxHzA5XiieSRqx+ruIhP6x7UO6b5fASOJ4fmRWDMjthDq7xH2JUy4amNBqhcr2lUVGuHHvAYYw5r7qX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043221; c=relaxed/simple;
	bh=IONtCx8hU574QqRKlBK95NKGCiNQ7aBBQefmkCZIZCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeqOEtqOUov9tWtGHhN+ng0tjI+q9DleHdip1wK5V7k1MEsH6zL1tIiv0Be2IX5fQvGfDwdi0/E4N/RXyXoAMUqAU/hwmaINEKd438h3AWugr+PwVYcks42yVQdDdyN3qHpe0PHx+mlEdhlOUJBP2+UYt3myxhJUNSqfS89l/Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyFSfv17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyFSfv17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A02C4AF0B;
	Wed,  7 Aug 2024 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043221;
	bh=IONtCx8hU574QqRKlBK95NKGCiNQ7aBBQefmkCZIZCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyFSfv17C4zrjuGV3zOEFNCAGWABfVeap6ZKWNuLr0YrORhtWy/qh/bIOWSwF/eX3
	 gaJlcvObKV3LhEZD2hFYn2u6vdCsk6UDKwgmnuw/Gn1GdAg3ilRD7RLI4HKNBHpf0I
	 LDEqaXwoc7onLyOTSaTNTC4cDOI35mea/47DTOds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/121] thermal/drivers/broadcom: Fix race between removal and clock disable
Date: Wed,  7 Aug 2024 16:59:04 +0200
Message-ID: <20240807150019.775181310@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit e90c369cc2ffcf7145a46448de101f715a1f5584 ]

During the probe, driver enables clocks necessary to access registers
(in get_temp()) and then registers thermal zone with managed-resources
(devm) interface.  Removal of device is not done in reversed order,
because:
1. Clock will be disabled in driver remove() callback - thermal zone is
   still registered and accessible to users,
2. devm interface will unregister thermal zone.

This leaves short window between (1) and (2) for accessing the
get_temp() callback with disabled clock.

Fix this by enabling clock also via devm-interface, so entire cleanup
path will be in proper, reversed order.

Fixes: 8454c8c09c77 ("thermal/drivers/bcm2835: Remove buggy call to thermal_of_zone_unregister")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240709-thermal-probe-v1-1-241644e2b6e0@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/broadcom/bcm2835_thermal.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/broadcom/bcm2835_thermal.c b/drivers/thermal/broadcom/bcm2835_thermal.c
index 5c1cebe075801..3b1030fc4fbfe 100644
--- a/drivers/thermal/broadcom/bcm2835_thermal.c
+++ b/drivers/thermal/broadcom/bcm2835_thermal.c
@@ -185,7 +185,7 @@ static int bcm2835_thermal_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	data->clk = devm_clk_get(&pdev->dev, NULL);
+	data->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(data->clk)) {
 		err = PTR_ERR(data->clk);
 		if (err != -EPROBE_DEFER)
@@ -193,10 +193,6 @@ static int bcm2835_thermal_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	err = clk_prepare_enable(data->clk);
-	if (err)
-		return err;
-
 	rate = clk_get_rate(data->clk);
 	if ((rate < 1920000) || (rate > 5000000))
 		dev_warn(&pdev->dev,
@@ -211,7 +207,7 @@ static int bcm2835_thermal_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"Failed to register the thermal device: %d\n",
 			err);
-		goto err_clk;
+		return err;
 	}
 
 	/*
@@ -236,7 +232,7 @@ static int bcm2835_thermal_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"Not able to read trip_temp: %d\n",
 				err);
-			goto err_tz;
+			return err;
 		}
 
 		/* set bandgap reference voltage and enable voltage regulator */
@@ -269,17 +265,11 @@ static int bcm2835_thermal_probe(struct platform_device *pdev)
 	 */
 	err = thermal_add_hwmon_sysfs(tz);
 	if (err)
-		goto err_tz;
+		return err;
 
 	bcm2835_thermal_debugfs(pdev);
 
 	return 0;
-err_tz:
-	devm_thermal_of_zone_unregister(&pdev->dev, tz);
-err_clk:
-	clk_disable_unprepare(data->clk);
-
-	return err;
 }
 
 static void bcm2835_thermal_remove(struct platform_device *pdev)
@@ -287,7 +277,6 @@ static void bcm2835_thermal_remove(struct platform_device *pdev)
 	struct bcm2835_thermal_data *data = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(data->debugfsdir);
-	clk_disable_unprepare(data->clk);
 }
 
 static struct platform_driver bcm2835_thermal_driver = {
-- 
2.43.0



