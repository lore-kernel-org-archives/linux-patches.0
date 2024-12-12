Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935C415696E;
	Thu, 12 Dec 2024 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025270; cv=none; b=IlCaIggRLeSZKW/vIJuSb1Rkmrm/9mmyfNR35d6s8qwmvAeKDP+8mmDSAFT4ZsKIu6voimtlWuMXNKdX++R9EdzG7rEX/YkyQGBwDKRFEVZeioU8sCD3D+KT7bPkFWSpcMmK36zZX5EYeMfDGqti8sV8IzH92NA3zj2DoNLujLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025270; c=relaxed/simple;
	bh=ETarZRPySSCyPI1AVPq48vIOyTXtY+jksDQWJlKF6N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amp1Ado06ndVWkLIwQzeqGantkhT6WQVjoVtxhWTFk/ueWKnC/ZjuEI2l8F7z3YXc+9kGwSl3Dw5Aqgmb1kKolxiTuHBNlKzN2VkAe+oDJFtKoEpciQ3JF5q5nfoZomxVMeFrvzSqC/qf2ooyyxEOfZ6aVnLS02Qv7uAimEDKmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBxWrICA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBxWrICA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19509C4CED0;
	Thu, 12 Dec 2024 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025270;
	bh=ETarZRPySSCyPI1AVPq48vIOyTXtY+jksDQWJlKF6N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBxWrICAudfCGL3AXTdge8iRotxVvPpZtzEjtj8H33fP6vE++md1XaXFAhVdbhhVJ
	 oL/j93E1tG2uTB0F2YfplwcYx8+g3KbSUBFwWpxW7PeZNCHrCUI5zUabEYUnj1f09z
	 RjVaHUYGM9PlKFVG8qCTH3KrdeqwzemWCPHufQO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/321] drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:59:51 +0100
Message-ID: <20241212144232.875887682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 394679f322649d06fea3c646ba65f5a0887f52c3 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Patchwork: https://patchwork.freedesktop.org/patch/614075/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 40431a09dc97c..55ff242292f3d 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1233,15 +1233,13 @@ static int a6xx_gmu_get_irq(struct a6xx_gmu *gmu, struct platform_device *pdev,
 
 	irq = platform_get_irq_byname(pdev, name);
 
-	ret = request_irq(irq, handler, IRQF_TRIGGER_HIGH, name, gmu);
+	ret = request_irq(irq, handler, IRQF_TRIGGER_HIGH | IRQF_NO_AUTOEN, name, gmu);
 	if (ret) {
 		DRM_DEV_ERROR(&pdev->dev, "Unable to get interrupt %s %d\n",
 			      name, ret);
 		return ret;
 	}
 
-	disable_irq(irq);
-
 	return irq;
 }
 
-- 
2.43.0



