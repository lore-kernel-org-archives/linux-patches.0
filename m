Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E46341056;
	Tue, 16 Dec 2025 12:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888448; cv=none; b=UhC2/+oH42VcS2dtBI0ifsWBROVavjeX4TMVFYxAzOiOOm7eiYaYjvv1onZpRKj48IDUC1Nq3s/QjwnjFAPUvHQCy0zQHm3p11iwjC98lyxT3t5YiyjCiv5eFW3XtXhz1qQaEMEpqVlssdnj5m9NmjQrK7fiqAUMrbTSD2HX9aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888448; c=relaxed/simple;
	bh=fkQQ+Q5CYVNtgN5vzHv+4z+qD9j+WblbsCe3Q0DYNoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gxlh0a/f7UBId/g23zaH5zZ0JYqjeMcDYcTxzI8WdECibrS+GJbJpDfDGBDyHDADilf12yTYT/Arm7YO9zQIP+yUbs7QyQFCCz8nwAAhwVeRw7bQ+SZYYQd3SbQyCzt0Q2p6OzhN/1FolYRssSCZViOV28GsVYs9rgBiIQXTAsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcGowOEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcGowOEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6644C4CEF5;
	Tue, 16 Dec 2025 12:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888448;
	bh=fkQQ+Q5CYVNtgN5vzHv+4z+qD9j+WblbsCe3Q0DYNoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcGowOEE1Qy1fcrQKUsh/ZHVk7bwTNkds9GERUzFIziMF9gZfxlXolmp5ZPZG+c3k
	 1ZjnqQJuL6YfPnjDFR4Xeio1yuW5yKIjEuu4b7wben5XlZp21UMC8uitmP7SdWnDu0
	 Avt6Zpu/GEppgiwYwUyrum6oRRAUtmnyco2qwn6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 538/614] rtc: amlogic-a4: fix double free caused by devm
Date: Tue, 16 Dec 2025 12:15:05 +0100
Message-ID: <20251216111420.872328238@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 384150d7a5b60c1086790a8ee07b0629f906cca2 ]

The clock obtained via devm_clk_get_enabled() is automatically managed
by devres and will be disabled and freed on driver detach. Manually
calling clk_disable_unprepare() in error path and remove function
causes double free.

Remove the redundant clk_disable_unprepare() calls from the probe
error path and aml_rtc_remove(), allowing the devm framework to
automatically manage the clock lifecycle.

Fixes: c89ac9182ee2 ("rtc: support for the Amlogic on-chip RTC")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Link: https://patch.msgid.link/20251021103559.1903-1-vulab@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-amlogic-a4.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/rtc/rtc-amlogic-a4.c b/drivers/rtc/rtc-amlogic-a4.c
index 1928b29c10454..a993d35e1d6b0 100644
--- a/drivers/rtc/rtc-amlogic-a4.c
+++ b/drivers/rtc/rtc-amlogic-a4.c
@@ -390,7 +390,6 @@ static int aml_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 err_clk:
-	clk_disable_unprepare(rtc->sys_clk);
 	device_init_wakeup(dev, false);
 
 	return ret;
@@ -423,9 +422,6 @@ static SIMPLE_DEV_PM_OPS(aml_rtc_pm_ops,
 
 static void aml_rtc_remove(struct platform_device *pdev)
 {
-	struct aml_rtc_data *rtc = dev_get_drvdata(&pdev->dev);
-
-	clk_disable_unprepare(rtc->sys_clk);
 	device_init_wakeup(&pdev->dev, false);
 }
 
-- 
2.51.0



