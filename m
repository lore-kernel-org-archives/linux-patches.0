Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2011648F848;
	Sat, 12 Sep 2026 18:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237378; cv=none; b=fGOMoovlRqpXvWf2IjIpprXVGByg1bvzvI5lbcc6EXZQObp0MpLbw0P+DqP26o4FrYMIz5z0X2odhI/8VbhF/5VQgt0GC+fuoxXiCThytO4wYv+CHkXjAIGcYWKMVmdcgsInFOkxYntGssABcKpZYYIrfyGRwQLHYSNIfm07Q6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237378; c=relaxed/simple;
	bh=XN9pCPHMN3hYC38W4Lekn3fAAGsRUpdcDOSjKe8KYbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gX2NJTGUlMZQ4SCtK8C4pPm8E0Pm1KPxN9s0QI2d4EGgPNNQ//QKu6+Oaqsih/jzYFyd+MWaSLu6fIW9J5FS3Ut5DLBkhEyAhNWO1SY/4RukqAimeItH4HMH+omuv5gDlkxDy3uzdai3NFAz6pEzI7QDTb3y2Ek7pzfuB666Dww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5vBq1P2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5vBq1P2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9101F000FF;
	Sat, 12 Sep 2026 18:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237376;
	bh=UUrsHpTWWsLv9aHSRRJ8gBnY59m3TqRzQ7kPHDWM0D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5vBq1P2Ca76kht5bK+KHX8PhxOGt3lylbifdVjonp9lryPeo4DuDTC3D4s/P8iOO
	 AitomT3/R2arKCNa5DfKWFRFPLu4PBbgvOUsleOx/0aBlEBTbXij7GoIdtmrfakCHR
	 YKuh66QmInsNWHBv71D06FmNqyL/EFCMdS3gWZtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 5.15 245/935] thermal/drivers/imx: Disable clock on runtime resume failure
Date: Sat, 12 Sep 2026 08:54:35 +0200
Message-ID: <20260912065532.444729876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit bcc6d886e5006a4656901d2d7fb6a215c96068a0 upstream.

imx_thermal_runtime_resume() enables the thermal clock before
powering up the sensor and enabling measurements.

If either regmap_write() fails, the function returns with the clock
still enabled. This leaves the clock enable count unbalanced after a
failed runtime resume.

Disable the clock on those failure paths before returning the error.

Fixes: 4cf2ddf16e17 ("thermal/drivers/imx: Implement runtime PM support")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260722084909.463437-1-pengcan@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/imx_thermal.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -897,12 +897,12 @@ static int __maybe_unused imx_thermal_ru
 	ret = regmap_write(map, socdata->sensor_ctrl + REG_CLR,
 			   socdata->power_down_mask);
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	ret = regmap_write(map, socdata->sensor_ctrl + REG_SET,
 			   socdata->measure_temp_mask);
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	/*
 	 * According to the temp sensor designers, it may require up to ~17us
@@ -911,6 +911,11 @@ static int __maybe_unused imx_thermal_ru
 	usleep_range(20, 50);
 
 	return 0;
+
+disable_clk:
+	clk_disable_unprepare(data->thermal_clk);
+
+	return ret;
 }
 
 static const struct dev_pm_ops imx_thermal_pm_ops = {


