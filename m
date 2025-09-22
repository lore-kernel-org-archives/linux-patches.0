Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54FB31CA4A;
	Mon, 22 Sep 2025 19:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570017; cv=none; b=RDC65DiomLKr9Uy+NvMI00f5BKh+gYMrAN+c89VICjNbPRdNhbGBPqm+8vY9pTNJdLIYCtX64ATXMtYP3rMlCk2Qbd4USVD4y3SNbTrHEGX047sjbC9y0iDGsmJncqCLMC2XI67quVEK8ulzZwGyFTiHPHzUAUYa98eoijthDwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570017; c=relaxed/simple;
	bh=nUTjOb0/DpWB1k06olfa3M6hxtqcX/Gy/ueeF86Gd1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ljg64Qjpr6Hm3K/HNHslmLMFP82k0uAZdVicJ4P2WM9538pF1j7a6xpxpd6hIS4kGU4RoAea0KBCbMja+05cmcNhO//ihr+FHRaqFCJ8G6hbLNtNE6wP8QNkhNyq+NEzhxCSBk/yN2qOLo5RoSHNdRWORtqE6cWIwDNXe2BTM9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMS2mKqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMS2mKqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0202C4CEF0;
	Mon, 22 Sep 2025 19:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570017;
	bh=nUTjOb0/DpWB1k06olfa3M6hxtqcX/Gy/ueeF86Gd1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMS2mKqUpzH3Uz+NPENcd4w7a0T0ic+C9Yk1Q+ELmHkmrGh6hR/0m5eT49yMI7DQC
	 +jbbIBhiqWFq80lRiAsL0kmNrS5roTo0ezKjsXg5KQi+qjc8gwi7mKASv43gzCRiTj
	 U0Zcm/Gp+RyeuQFpKJ29rfhszMzaIk6gaQ3B62FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/105] drm: bridge: anx7625: Fix NULL pointer dereference with early IRQ
Date: Mon, 22 Sep 2025 21:30:00 +0200
Message-ID: <20250922192410.910807487@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c036bbc92ba96..7244c3abb7f99 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2683,7 +2683,7 @@ static int anx7625_i2c_probe(struct i2c_client *client)
 		ret = devm_request_threaded_irq(dev, platform->pdata.intp_irq,
 						NULL, anx7625_intr_hpd_isr,
 						IRQF_TRIGGER_FALLING |
-						IRQF_ONESHOT,
+						IRQF_ONESHOT | IRQF_NO_AUTOEN,
 						"anx7625-intp", platform);
 		if (ret) {
 			DRM_DEV_ERROR(dev, "fail to request irq\n");
@@ -2753,8 +2753,10 @@ static int anx7625_i2c_probe(struct i2c_client *client)
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



