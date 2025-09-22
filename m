Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A9C27B320;
	Mon, 22 Sep 2025 19:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569747; cv=none; b=lvdXbxNPxt6lMDi7eOQDgeNWY9zOKq+kQGCJi88EKw4116M9T6BBAQNaWHIJcRx1f0Zqc6Zq5Nt1NelY5UOvV1vo0lyiSkNlKS65zTSqMDzjvgoagaMv4DEJSLednTPhKaUDut5WDdvxng6nCJOp5aRRLJc3Pa6Ebud33/V8YRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569747; c=relaxed/simple;
	bh=UpylKxcnQEAROy3nqe2mhgxn63++W8dtQTM/ch+jIvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4QWTQ8rdl2O1Yzun9GonS/gU7ReEt6IOJICegdQazv5UZTgXySn1vmjAgHj6aI1lwDXrk7XMC2vCAQWgtVTiSZ6Xzv1lay6ynqUzVti4zWTH1aDm+Q/EsL1tJAnG2SznEp2cC2xvUMelj8EiQ+fnVEvicNpto3A+Fm3UGk51q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWNV6Wds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWNV6Wds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E942C4CEF0;
	Mon, 22 Sep 2025 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569747;
	bh=UpylKxcnQEAROy3nqe2mhgxn63++W8dtQTM/ch+jIvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWNV6WdsgH1jsIPeFA8p61eyO9Hq6K1uRNYUMkx3A98w8MFig8GWdSD2XVkM+1bt+
	 pQS3IIhoI2dVLKv4TpOuV8QkzvbvhvnLajHBZ8en13Bs5PQnLSUALhSdEukUoPJGaE
	 E4vBK62KyJAVSHzRqADUFr4CS8+en5nxqVCd7Zig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 53/70] drm: bridge: anx7625: Fix NULL pointer dereference with early IRQ
Date: Mon, 22 Sep 2025 21:29:53 +0200
Message-ID: <20250922192406.030397419@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit a10f910c77f280327b481e77eab909934ec508f0 ]

If the interrupt occurs before resource initialization is complete, the
interrupt handler/worker may access uninitialized data such as the I2C
tcpc_client device, potentially leading to NULL pointer dereference.

Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250709085438.56188-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index ddf944651c55a..08885a5ba826e 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2705,7 +2705,7 @@ static int anx7625_i2c_probe(struct i2c_client *client)
 		ret = devm_request_threaded_irq(dev, platform->pdata.intp_irq,
 						NULL, anx7625_intr_hpd_isr,
 						IRQF_TRIGGER_FALLING |
-						IRQF_ONESHOT,
+						IRQF_ONESHOT | IRQF_NO_AUTOEN,
 						"anx7625-intp", platform);
 		if (ret) {
 			DRM_DEV_ERROR(dev, "fail to request irq\n");
@@ -2775,8 +2775,10 @@ static int anx7625_i2c_probe(struct i2c_client *client)
 	}
 
 	/* Add work function */
-	if (platform->pdata.intp_irq)
+	if (platform->pdata.intp_irq) {
+		enable_irq(platform->pdata.intp_irq);
 		queue_work(platform->workqueue, &platform->work);
+	}
 
 	if (platform->pdata.audio_en)
 		anx7625_register_audio(dev, platform);
-- 
2.51.0



