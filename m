Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC2F2144C0;
	Thu, 12 Dec 2024 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022220; cv=none; b=YG4VUDCL6BmYcGRICVqB0F695veqR78hrCH1AcbNwq1155NruhY2NxXStDMmWlZV3qYjwB4/OsPwsDAA7Ady6LUNHn5hd3BSX2IM3ba2LvABQ4HA6vROMSRUjLAUKgP/ZNA+scoal5v8yEB6yo7EYmcNDGQU613hyaTNJQPi1Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022220; c=relaxed/simple;
	bh=absL+8Quhk587pYSIqmRIVmq3APmsA3lBdBUfd8wLNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3II2Xr3QuP8oncPW/2VqVYKAvXtn64w2CLFSDPt7CNrlWBGHnk5ueCxltaGsyBncqhf63lzy9Jns7Rm+QqBgxDxN5PJM3xfHa7jDIxgByXhC39sq3U8ZpFzR0lbn8UDD7cuJp7eJIBf1X/mLCi9It2tpqtPNxG+F1ghVTNKgzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IC35xOhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IC35xOhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982A0C4CECE;
	Thu, 12 Dec 2024 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022220;
	bh=absL+8Quhk587pYSIqmRIVmq3APmsA3lBdBUfd8wLNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IC35xOhmTGtbcYui1mnd/AMfxmvI3pLZL0+3GvafYGuIh5FONGyrUmANnyi2JGXPC
	 dbok41AelunDxODcrbO+4Nzh2L5Jj1idVMftXUj2t6vWrGP9djMOnnPZsP4zZnsjNQ
	 rJLqRmgy7JEYm/l/W5431MuafUlspeds+14uhW/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/565] drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:56:15 +0100
Message-ID: <20241212144318.589327057@linuxfoundation.org>
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
index 4347a104755a9..8b6fc1b26f049 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1432,15 +1432,13 @@ static int a6xx_gmu_get_irq(struct a6xx_gmu *gmu, struct platform_device *pdev,
 
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



