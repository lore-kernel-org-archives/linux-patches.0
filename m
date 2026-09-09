Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30DD492E33;
	Wed,  9 Sep 2026 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961749; cv=none; b=XK/KRj49agkqaC10B+ITxlQOX2BRaGjjlz5GqgZidN/kYoo0GIAjWLKQRoeGKn3QfG5yv3IjxFz+4FYYFjmie4IXdT7ydeoi/8VPRM4qS7jjpyh6dpal73RjG+S8bCYyGjIeIDyJ2xNlWR677gCz+DCURnA15EN1DsVcbGFblTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961749; c=relaxed/simple;
	bh=P/M6HBGA8sdSk6G/XOV2TUGysULe9h+h9F7Pklw2hNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxJaEu1qhaix5JnqUgE0Ss5EQoG3x1qsaaEEh+x6w1y2sD0MKORYwUGQCprndJRqOtfDcUqM/zCHsDsXB+RqdIaQqMfmQ8F3arfHVdjS+8sZHkkk+NuWKQlmtSPnFRB71Iz6X+df+VOR+1tn1Z8ke6kptEIcqqTwaKxBMfD0j7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFEznYnX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFEznYnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4E51F00A3A;
	Wed,  9 Sep 2026 13:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961747;
	bh=ECJ6l/hMT+ftS6giW6SIvMWXHOF4/LXlQX2qbGE0+PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFEznYnXRsUbpXri17b6Si6IAEU0pTg0uly4RPCwcRCqEt2bjSPsjUw0y1ttsbEib
	 vFWEx4Zv/PTUXREQIBzrOOuntmtMj38OPAoc50fze9z2XPIs4hO4hwTxJJrAzS3cal
	 3gPw90Gb/1ZeqR/KM81kytDUG3F4qbd3dEwWtFx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.2 054/556] thermal/drivers/imx: Disable clock on runtime resume failure
Date: Wed,  9 Sep 2026 15:35:34 +0200
Message-ID: <20260909134232.372532498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


