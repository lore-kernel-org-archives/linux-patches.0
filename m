Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C38C2054EF;
	Thu, 12 Dec 2024 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022145; cv=none; b=fUTcLNEZwV719xHjRbnsNnq32/B2wVqdVREdkybq169nbXeIor/6zJmwjPot/dBxqrzkTMw3VOBC8jVOP3YD12oEq8/H3WemErxIYkNAgEq2mUKaRfetWIBziiDrBJi65JOFnqMHmq82A2ZnE0Pv8nq61C4eThqsEqvgqzevkbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022145; c=relaxed/simple;
	bh=irmW9OEw2xgP6JiLgD1Lhsy2o2Fmbc5Zuw3SXyU/6Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCO5XaY4W08pN3BT3xSQm6CxF72Bjt3qxnaWwH8B9Ljs/LlRu2+vGSvXLrJpoaWvVMW+GIYHpwfX8HA0V1qNtlihadOcyxjLbRgREBgMWyxeAY3ZBZuvzXXsc6pxyRFqSsxS7VRgT8c3Pl/ZtrG6Il267xC6nFzr5ChV9OmdTSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhooiMVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhooiMVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BCBC4CECE;
	Thu, 12 Dec 2024 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022145;
	bh=irmW9OEw2xgP6JiLgD1Lhsy2o2Fmbc5Zuw3SXyU/6Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhooiMVZB8ogPWUPo97iued+U6GxBADISHZhmrXfTB7o1qtHDkXkCAqOrf9iYlIz2
	 gIsFUkFqkK3JIzCUO9KWWJn6ND4q1b/h7Y7C9KG1QykF4QVDuuObA/IxKHMW1S3lD9
	 pboup9xIrXqyghs5kFU4oSYCTl2f7qAnQJ3Am+pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/565] drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:55:48 +0100
Message-ID: <20241212144317.530915236@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 40004709a3d3b07041a473a163ca911ef04ab8bd ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 47b1be5c0f4e ("staging: imx/drm: request irq only after adding the crtc")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240912083020.3720233-4-ruanjinjie@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index ba5b16618c237..15277629792d7 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -411,14 +411,12 @@ static int ipu_drm_bind(struct device *dev, struct device *master, void *data)
 	}
 
 	ipu_crtc->irq = ipu_plane_irq(ipu_crtc->plane[0]);
-	ret = devm_request_irq(ipu_crtc->dev, ipu_crtc->irq, ipu_irq_handler, 0,
-			"imx_drm", ipu_crtc);
+	ret = devm_request_irq(ipu_crtc->dev, ipu_crtc->irq, ipu_irq_handler,
+			       IRQF_NO_AUTOEN, "imx_drm", ipu_crtc);
 	if (ret < 0) {
 		dev_err(ipu_crtc->dev, "irq request failed with %d.\n", ret);
 		return ret;
 	}
-	/* Only enable IRQ when we actually need it to trigger work. */
-	disable_irq(ipu_crtc->irq);
 
 	return 0;
 }
-- 
2.43.0



