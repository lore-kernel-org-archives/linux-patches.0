Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17404E0B63;
	Thu, 17 Sep 2026 18:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668400; cv=none; b=DrCDh1gqAYW6fyESSWp9SFwy4XK5PUAR/ZnMj/00JOGJFfa/Getnp887RLQgedj+4IJIZcP5BtmWQj5kEvIHJ3gyhrBDOCs2sgn3l0AVodljrE1S33CAEl2XQoK2AUndcvBz03iHC0Mizz0XSMNkmVa45ERpBrOzVoK3TiBmIBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668400; c=relaxed/simple;
	bh=uysjfyrbvMf51k2xSqYoGe6XwMOikLOcRVISA9rL5l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iT9E7/FWwGplZXVTVhYHOrvGOw8f/KcmV06KNH1QI2fVGSVG90mbQ1rYnmdqJkvfs5EHpS9GPwpMeoGXIj1y7qa8G1CVvranlkJ+P9n1iCexbuGvnm2yqdwGsTQwexq04Hu45gktXA2IPZuJhtIFUTAXqW48Wjb4zfj6jG5OU/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQB+Z4Gy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQB+Z4Gy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F0D1F00893;
	Thu, 17 Sep 2026 18:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668398;
	bh=p+G6Vo1zxP3aA3yxH1mFac4RgPBhE8Gvl6hawe10cyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQB+Z4Gyeg9bA8AqD9Folqz5RbcGskcGA6WLjH88mfo485EF+3m9Dj7eYlQ1WpAne
	 97FVmc5kL1tyOetXwdRXBGnVJIs9uBA+iQb65ByQyPIlpq7V+ztXzspAnG6WSlXao6
	 eQCG6mnKlSkYOm91+GTsdpUygpU8kwoXGeHWzEhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gustavo=20Kenji=20Mendon=C3=A7a=20Kaneko?= <kaneko.dev@pm.me>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0372/1102] drm/arm/malidp: use clk_bulk API in runtime PM resume and suspend
Date: Thu, 17 Sep 2026 16:05:15 +0100
Message-ID: <20260917151548.992320681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>

[ Upstream commit 46f715a16989f4e7bbbc2eb41447051874b027f3 ]

malidp_runtime_pm_resume() calls clk_prepare_enable() three times
without checking the return value. If any clock fails to enable, the
driver silently proceeds with unclocked hardware, leading to undefined
behavior.

Convert both the resume and suspend paths to use the clk_bulk API:
clk_bulk_prepare_enable() in resume checks the return value and rolls
back any successfully enabled clocks on failure;
clk_bulk_disable_unprepare() in suspend keeps the two paths symmetric.

This issue was found by code review without access to Mali DP hardware.

Signed-off-by: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260609130812.1065699-1-kaneko.dev@pm.me
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_drv.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index 6682131d29104..754afec5bc76c 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -668,6 +668,11 @@ static int malidp_runtime_pm_suspend(struct device *dev)
 	struct drm_device *drm = dev_get_drvdata(dev);
 	struct malidp_drm *malidp = drm_to_malidp(drm);
 	struct malidp_hw_device *hwdev = malidp->dev;
+	struct clk_bulk_data clks[] = {
+		{ .clk = hwdev->pclk },
+		{ .clk = hwdev->aclk },
+		{ .clk = hwdev->mclk },
+	};
 
 	/* we can only suspend if the hardware is in config mode */
 	WARN_ON(!hwdev->hw->in_config_mode(hwdev));
@@ -675,9 +680,7 @@ static int malidp_runtime_pm_suspend(struct device *dev)
 	malidp_se_irq_fini(hwdev);
 	malidp_de_irq_fini(hwdev);
 	hwdev->pm_suspended = true;
-	clk_disable_unprepare(hwdev->mclk);
-	clk_disable_unprepare(hwdev->aclk);
-	clk_disable_unprepare(hwdev->pclk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(clks), clks);
 
 	return 0;
 }
@@ -687,10 +690,17 @@ static int malidp_runtime_pm_resume(struct device *dev)
 	struct drm_device *drm = dev_get_drvdata(dev);
 	struct malidp_drm *malidp = drm_to_malidp(drm);
 	struct malidp_hw_device *hwdev = malidp->dev;
+	struct clk_bulk_data clks[] = {
+		{ .clk = hwdev->pclk },
+		{ .clk = hwdev->aclk },
+		{ .clk = hwdev->mclk },
+	};
+	int err;
+
+	err = clk_bulk_prepare_enable(ARRAY_SIZE(clks), clks);
+	if (err)
+		return err;
 
-	clk_prepare_enable(hwdev->pclk);
-	clk_prepare_enable(hwdev->aclk);
-	clk_prepare_enable(hwdev->mclk);
 	hwdev->pm_suspended = false;
 	malidp_de_irq_hw_init(hwdev);
 	malidp_se_irq_hw_init(hwdev);
-- 
2.53.0



