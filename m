Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DDF1A76A4;
	Tue, 30 Jul 2024 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359863; cv=none; b=a+kqstbA+vztPsVH/Je6W1cvNisfq33iP6OFkERVDzJZiSleCrAlq1z+YY8qQXqNAQBe8irVjVihH0rt4SEDCqwppiRDCqh5C007yDdMDTtuY5Lp8PD0BtwGXtWc4FFKPIKEPHwG1puL7EQK0YWg489s9J/W7gK0o6FbsRnIpbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359863; c=relaxed/simple;
	bh=JyNpUkievU8pE1p268MpSsBcATsxPIQf7Tn+Ah6Hw1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eu0Yr2Afj43LURejfqAQ4Q2QJ7i6b6rI0/t44cI2x+hznJV/3LYwN+xqbiyj56rabXUuKVb0GwA0N4S0dOtzg+GiKWQcHujXxDur1cnQ2XzN+IcU/Jmb9D1jbmFD+L83NtcQ7C7wLVdinESavL4zEhV68RDbpTL4RJ9K9Jh9guQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDwbcPqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDwbcPqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8032CC32782;
	Tue, 30 Jul 2024 17:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359863;
	bh=JyNpUkievU8pE1p268MpSsBcATsxPIQf7Tn+Ah6Hw1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDwbcPqbd6uoJKi95ZyGraK1JNyrkRPqnUCiUdUvtj9azQpoNv+30sClCDaXV/gOQ
	 vyppBrNR7J95uB44KzfXCM9XKRLFaSejd5iQQgzdYdLAovWiJLjPbT+GZXzI/ZHjAV
	 /AJRbIUXwU9cKSoSQ1k/RCNHP01tzoGiRm9TnECc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.10 546/809] thermal/drivers/broadcom: Fix race between removal and clock disable
Date: Tue, 30 Jul 2024 17:47:02 +0200
Message-ID: <20240730151746.319260771@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit e90c369cc2ffcf7145a46448de101f715a1f5584 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/broadcom/bcm2835_thermal.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/drivers/thermal/broadcom/bcm2835_thermal.c
+++ b/drivers/thermal/broadcom/bcm2835_thermal.c
@@ -185,7 +185,7 @@ static int bcm2835_thermal_probe(struct
 		return err;
 	}
 
-	data->clk = devm_clk_get(&pdev->dev, NULL);
+	data->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(data->clk)) {
 		err = PTR_ERR(data->clk);
 		if (err != -EPROBE_DEFER)
@@ -193,10 +193,6 @@ static int bcm2835_thermal_probe(struct
 		return err;
 	}
 
-	err = clk_prepare_enable(data->clk);
-	if (err)
-		return err;
-
 	rate = clk_get_rate(data->clk);
 	if ((rate < 1920000) || (rate > 5000000))
 		dev_warn(&pdev->dev,
@@ -211,7 +207,7 @@ static int bcm2835_thermal_probe(struct
 		dev_err(&pdev->dev,
 			"Failed to register the thermal device: %d\n",
 			err);
-		goto err_clk;
+		return err;
 	}
 
 	/*
@@ -236,7 +232,7 @@ static int bcm2835_thermal_probe(struct
 			dev_err(&pdev->dev,
 				"Not able to read trip_temp: %d\n",
 				err);
-			goto err_tz;
+			return err;
 		}
 
 		/* set bandgap reference voltage and enable voltage regulator */
@@ -269,17 +265,11 @@ static int bcm2835_thermal_probe(struct
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
@@ -287,7 +277,6 @@ static void bcm2835_thermal_remove(struc
 	struct bcm2835_thermal_data *data = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(data->debugfsdir);
-	clk_disable_unprepare(data->clk);
 }
 
 static struct platform_driver bcm2835_thermal_driver = {


