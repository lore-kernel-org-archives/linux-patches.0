Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A5017A2EA;
	Mon, 22 Sep 2025 19:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569581; cv=none; b=cOR2etJp2EYhgtxm357I8hFGYiEN//8Y2xzrE6lVY35lQdO2u9tQYtLKtMmR/hKUsweQWtyRcTudnYeVy44nxHXyUtWGTAhX5jWN4eKvuvi3NSVc38nKA1PagBJ+EMak4vm2SNS1AOAD6QE1QllBpitg7rsRHxFnguwThSyoNLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569581; c=relaxed/simple;
	bh=y8In/KbXwM469K+r6cc8CZuz67dDLt+yzyh+2T0Zgyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAovSwmDX9bffFEerk9VjcB/ByFSlJ/moPR6Pa6Ky0MmBV5bXCzkwkfAlrMTdYdt4ZvtSDY9FZ3dFnonaBzVLRam2BQV+99eum9xO4gSPxxYvK+qlzn+5Za6p+ii2OZsSowp+QGTpBmW+w2pt87GMDUynh45QAitape2PYB23l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7Xv4lCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7Xv4lCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6A1C4CEF0;
	Mon, 22 Sep 2025 19:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569581;
	bh=y8In/KbXwM469K+r6cc8CZuz67dDLt+yzyh+2T0Zgyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7Xv4lCvzSs5hEBnNsE66NhaNDyHnZNv8LH+I9HVoZJVPeZaxbi2tJpwpgJCFKXdb
	 lOz0kkXmQdJPMQqJ7Ai0gdGfcTyW22uR36jqhMdGTf+kJq0y546jpVtGNDWy8MXR1V
	 LIMlD8PkBVieEuoWaj0EWWdc6rs30OY65lrp33ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/61] drm: bridge: anx7625: Fix NULL pointer dereference with early IRQ
Date: Mon, 22 Sep 2025 21:29:34 +0200
Message-ID: <20250922192404.703112947@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e14c9fdabe2ba..690a0e7f5f6e2 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2697,7 +2697,7 @@ static int anx7625_i2c_probe(struct i2c_client *client)
 		ret = devm_request_threaded_irq(dev, platform->pdata.intp_irq,
 						NULL, anx7625_intr_hpd_isr,
 						IRQF_TRIGGER_FALLING |
-						IRQF_ONESHOT,
+						IRQF_ONESHOT | IRQF_NO_AUTOEN,
 						"anx7625-intp", platform);
 		if (ret) {
 			DRM_DEV_ERROR(dev, "fail to request irq\n");
@@ -2767,8 +2767,10 @@ static int anx7625_i2c_probe(struct i2c_client *client)
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



