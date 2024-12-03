Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4822A33FE;
	Tue,  3 Dec 2024 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238301; cv=none; b=iVMmKPy/eygW2JJUV1U0QCLXiKsrXH/V0feEYjpVc+VcsUGal0Wn6IJ34tKAGHi8T9Cfp7ialebc9ZHfdc9ytmLTDGrBxAFSTw+M6j28NzfNqkn9uhEz19tW+wlTqaI7WfGmWBJI/9alsT7uVWKfrlb5MMrr5VXUrOWe1JcblPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238301; c=relaxed/simple;
	bh=8zqr3BaC+ivUR2Gl2SuYJmRJtNcLdK/5NGALIy2M//E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsrBRfVYEV5545DYzqJ92zSzY7kq3FJMDU3llEcrC8hdakOURHMOL8EUdXdKzplMphur56MKuUj4+dvXhNKIDfb7taXbUsE3fuBRIRZDWCzVSTc8RfA/58+B8QQRAQTpOdJ3GwfDdDxv+Tl2lbz8f3Ri7RdaqeJOygmtgovx34Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqsG8CDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqsG8CDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54E0C4CECF;
	Tue,  3 Dec 2024 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238301;
	bh=8zqr3BaC+ivUR2Gl2SuYJmRJtNcLdK/5NGALIy2M//E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqsG8CDBrL8mt98TW8KsCElliciRB+0QsMh0CTLA+pHSe3a17behMbuUrIoCpSrAS
	 RyhRiydNKFDfaf9Nfl61hhkDNYv7a9nbMlOzl2Vclj/EzHytmQDuHRqt1jc1eGIBXG
	 fvwniJK67s35ipbxJvMJCRwUJntJo4Do7OAKA5IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 231/817] drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  3 Dec 2024 15:36:43 +0100
Message-ID: <20241203144004.765356177@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c
index ef29c9a61a461..99db53e167bd0 100644
--- a/drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c
@@ -410,14 +410,12 @@ static int ipu_drm_bind(struct device *dev, struct device *master, void *data)
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



