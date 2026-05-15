Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4573F44CD;
	Fri, 15 May 2026 16:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861903; cv=none; b=S5rNl5KeDyL1yvlwBJH1koil9YUuF6BpzdEKWhozk+Mto/TYzzYadHp9M1FF4jeNv1FCPzNb7aPUpc0ZqWlJq9JMmtPR4Ek4niFHJI0sFKa0mgWibqd5noXvOAjkiV4W+7Oh4VGXAb7lM6TsCJympVhtIIcUdvCvLXgMNPiC2FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861903; c=relaxed/simple;
	bh=d9rFriCjRtum+ErpXrXrKxfNMcjFlPkpuCOQkIa889c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlLSZA9VTjaBD4tAtpZemRtRiac9nLvxITkc1twhz3+UgUA3VM6al2n/BXWgt0AuOUJx8iXiOGJ3p3vO+uQwuHqYyrdrAEFfvJ4XJiWJca6ULE4RHSXZUINDZisyVpS8CNTH4Z7/mPVGgUmmRQXYQOTbuUrqPBisNPOTvIQ1E9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FyhNnKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FyhNnKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A4BC2BCB0;
	Fri, 15 May 2026 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861902;
	bh=d9rFriCjRtum+ErpXrXrKxfNMcjFlPkpuCOQkIa889c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FyhNnKQOaOqVgGVO3hFWreUzna7CjXeAy6N0qfp9InmyGRUL0hueB117gRc0zzBr
	 7D9BD1brS3blpAbgpMNfJz+ZnlTDOFM4I1ZD8LYvFiJQMjRO34W/4whuowDbnrWKdD
	 15yfuHBDJWAGaFRiZMWfhgadCBkqrz/fA0DWzNNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.18 033/188] media: i2c: imx283: Fix hang when going from large to small resolution
Date: Fri, 15 May 2026 17:47:30 +0200
Message-ID: <20260515154658.026142195@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Jai Luthra <jai.luthra@ideasonboard.com>

commit 9206359b2c396ff594adf39bc7daaadab0fcb367 upstream.

When switching between modes (e.g. full resolution to binned),
standby_cancel() previously cleared XMSTA (starting master mode data
output) before the new mode's MDSEL, crop, and timing registers were
programmed in start_streaming(). This caused the sensor to briefly
output MIPI data using the previous mode's configuration.

On receivers like imx-mipi-csis, this leads to FIFO overflow errors
when switching from a higher to a lower resolution, as the receiver is
configured for the new smaller frame size but receives stale
full-resolution data.

Fix this by moving the XMSTA and SYNCDRV register writes from
standby_cancel() to the end of start_streaming(), after all mode,
crop, and timing registers have been configured. Also explicitly stop
master mode (XMSTA=1) when stopping the stream, matching the pattern
used by other Sony sensor drivers (imx290, imx415).

Use named macros IMX283_XMSTA_START/STOP instead of raw 0/BIT(0) for
readability.

Cc: stable@vger.kernel.org
Fixes: ccb4eb4496fa ("media: i2c: Add imx283 camera sensor driver")
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Tested-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx283.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/imx283.c
+++ b/drivers/media/i2c/imx283.c
@@ -129,7 +129,8 @@
 
 /* Master Mode Operation Control */
 #define IMX283_REG_XMSTA		CCI_REG8(0x3105)
-#define   IMX283_XMSTA			BIT(0)
+#define   IMX283_XMSTA_START		0
+#define   IMX283_XMSTA_STOP		BIT(0)
 
 #define IMX283_REG_SYNCDRV		CCI_REG8(0x3107)
 #define   IMX283_SYNCDRV_XHS_XVS	(0xa0 | 0x02)
@@ -1023,8 +1024,6 @@ static int imx283_standby_cancel(struct
 	usleep_range(19000, 20000);
 
 	cci_write(imx283->cci, IMX283_REG_CLAMP, IMX283_CLPSQRST, &ret);
-	cci_write(imx283->cci, IMX283_REG_XMSTA, 0, &ret);
-	cci_write(imx283->cci, IMX283_REG_SYNCDRV, IMX283_SYNCDRV_XHS_XVS, &ret);
 
 	return ret;
 }
@@ -1117,6 +1116,10 @@ static int imx283_start_streaming(struct
 	/* Apply customized values from controls (HMAX/VMAX/SHR) */
 	ret =  __v4l2_ctrl_handler_setup(imx283->sd.ctrl_handler);
 
+	/* Start master mode */
+	cci_write(imx283->cci, IMX283_REG_XMSTA, IMX283_XMSTA_START, &ret);
+	cci_write(imx283->cci, IMX283_REG_SYNCDRV, IMX283_SYNCDRV_XHS_XVS, &ret);
+
 	return ret;
 }
 
@@ -1153,12 +1156,14 @@ static int imx283_disable_streams(struct
 				  u64 streams_mask)
 {
 	struct imx283 *imx283 = to_imx283(sd);
-	int ret;
+	int ret = 0;
 
 	if (pad != IMAGE_PAD)
 		return -EINVAL;
 
-	ret = cci_write(imx283->cci, IMX283_REG_STANDBY, IMX283_STANDBY, NULL);
+	cci_write(imx283->cci, IMX283_REG_XMSTA, IMX283_XMSTA_STOP, &ret);
+	cci_write(imx283->cci, IMX283_REG_STANDBY, IMX283_STANDBY, &ret);
+
 	if (ret)
 		dev_err(imx283->dev, "Failed to stop stream\n");
 


