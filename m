Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDF3379982;
	Sat, 12 Sep 2026 11:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213015; cv=none; b=j8++f520zky19w7PBRnabdaqqMPTOKRWyxGHRrz3GOjhj++SPTySfaeQTB0gx5Hfzt5tKvoh5fcYDrG601IhpvrcKw665E7o2YJr5Zazpfet8bYTzu8ylVG50YZUQGNi0UBee6fKmuNcerleNw/CxckB95h8vJRHavmQEbngVWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213015; c=relaxed/simple;
	bh=ZPMlCRWruVMNG+ciHgUa/+SEhmX1+vmOlWTxEENpVqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHNxfVVRpUnh7TmBo03L11Ode31OqK+tOSngSNNSdCPohihW4z4Y9cMldQvm1tPwVoohOK09yA9PHKsLCDYr/c4Eu67MOaJjfiOgCn6f/RSEHx5qLd9wqq4Gjr/zptTf329NW1EB56gQTlMYFz+I0Xp4dRsIv/7LMvoufLPUKpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfZunfL7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfZunfL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266C21F000FF;
	Sat, 12 Sep 2026 11:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213014;
	bh=gRHglxOyHJmB44zacq8GzR8qlawQP2kiXGu4NevXR4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfZunfL7nwG2wC32kLkexpFftVDp3MJQfTSONZl6P33etfvFy3n0repKchGY0HB9W
	 TNFM/OyXCuj+GuHMW8XI3DyjISZDhpYJhY3/WJaocAFWiOVzMu9jaV5UX3cYcGcCL2
	 2neLpQobVSB2JEkAVXSFmSVVs+esPsfsEWRR19qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 0034/1376] thermal/drivers/imx: Disable clock on runtime resume failure
Date: Sat, 12 Sep 2026 08:41:00 +0200
Message-ID: <20260912065608.313965877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -832,12 +832,12 @@ static int imx_thermal_runtime_resume(st
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
@@ -846,6 +846,11 @@ static int imx_thermal_runtime_resume(st
 	usleep_range(20, 50);
 
 	return 0;
+
+disable_clk:
+	clk_disable_unprepare(data->thermal_clk);
+
+	return ret;
 }
 
 static const struct dev_pm_ops imx_thermal_pm_ops = {


