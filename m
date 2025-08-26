Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BD5283FDF;
	Tue, 26 Aug 2025 11:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208498; cv=none; b=fUz8IidHq1kevAxB5INJX4B9+gASU9Bplc6A6E0mYfAF8lesdrxc630tioq/E8urS2qBFJmtMOWtQH27Wj44NkEBhnvz1t4cWruRiwczXiuU+PGHozunJEQnn9eH75jTwmAyiVOJ8Ls+2PSa2w7gmah1lAhlR5Sc7q9u9TP3Ol4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208498; c=relaxed/simple;
	bh=pKSzRs4LBA15HhLEbWUbGcDDca6l40gJ4uFT37IZAY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4ef6DH+R2IZO+tHUeEJ4R75ogKkfjKGVWn05/iMyA7XRH83P9w6gIklfWy/zwcR7QFXEsVOPImPXXOx0Ro5Uv31bYBG0jsqaxwkDGK6sFfm9tAPl8JKnI8bShz3J14pETl71ThutCe2ehosYJrPNept8Y59SmQOSqIbClq3Mmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yy/ZA+10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy/ZA+10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD24C4CEF1;
	Tue, 26 Aug 2025 11:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208498;
	bh=pKSzRs4LBA15HhLEbWUbGcDDca6l40gJ4uFT37IZAY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy/ZA+10FSA/Z9kdFsvbfoV5vRuw+i2xoN3SVlOQBt+UTfd3vTr/+V+wK3vkYmhVO
	 yDjOdP9UsTXbjljAhKdMqQRlKQFy67+UOghWnsW4ro+U+kLsH6ZPeRvkSBJDhnTtLw
	 op6Wgorah7wT636feWg4yOkTaRoPUAIU4nXv5ZB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naushir Patuck <naush@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 107/322] media: pisp_be: Fix pm_runtime underrun in probe
Date: Tue, 26 Aug 2025 13:08:42 +0200
Message-ID: <20250826110918.415929046@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>

commit e9bb2eacc7222ff8210903eb3b7d56709cc53228 upstream.

During the probe() routine, the PiSP BE driver needs to power up the
interface in order to identify and initialize the hardware.

The driver resumes the interface by calling the
pispbe_runtime_resume() function directly, without going
through the pm_runtime helpers, but later suspends it by calling
pm_runtime_put_autosuspend().

This causes a PM usage count imbalance at probe time, notified by the
runtime_pm framework with the below message in the system log:

 pispbe 1000880000.pisp_be: Runtime PM usage count underflow!

Fix this by resuming the interface using the pm runtime helpers instead
of calling the resume function directly and use the pm_runtime framework
in the probe() error path. While at it, remove manual suspend of the
interface in the remove() function. The driver cannot be unloaded if in
use, so simply disable runtime pm.

To simplify the implementation, make the driver depend on PM as the
RPI5 platform where the ISP is integrated in uses the PM framework by
default.

Fixes: 12187bd5d4f8 ("media: raspberrypi: Add support for PiSP BE")
Cc: stable@vger.kernel.org
Tested-by: Naushir Patuck <naush@raspberrypi.com>
Reviewed-by: Naushir Patuck <naush@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/raspberrypi/pisp_be/Kconfig   |    1 +
 drivers/media/platform/raspberrypi/pisp_be/pisp_be.c |    5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/raspberrypi/pisp_be/Kconfig
+++ b/drivers/media/platform/raspberrypi/pisp_be/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_RASPBERRYPI_PISP_BE
 	depends on V4L_PLATFORM_DRIVERS
 	depends on VIDEO_DEV
 	depends on ARCH_BCM2835 || COMPILE_TEST
+	depends on PM
 	select VIDEO_V4L2_SUBDEV_API
 	select MEDIA_CONTROLLER
 	select VIDEOBUF2_DMA_CONTIG
--- a/drivers/media/platform/raspberrypi/pisp_be/pisp_be.c
+++ b/drivers/media/platform/raspberrypi/pisp_be/pisp_be.c
@@ -1726,7 +1726,7 @@ static int pispbe_probe(struct platform_
 	pm_runtime_use_autosuspend(pispbe->dev);
 	pm_runtime_enable(pispbe->dev);
 
-	ret = pispbe_runtime_resume(pispbe->dev);
+	ret = pm_runtime_resume_and_get(pispbe->dev);
 	if (ret)
 		goto pm_runtime_disable_err;
 
@@ -1748,7 +1748,7 @@ static int pispbe_probe(struct platform_
 disable_devs_err:
 	pispbe_destroy_devices(pispbe);
 pm_runtime_suspend_err:
-	pispbe_runtime_suspend(pispbe->dev);
+	pm_runtime_put(pispbe->dev);
 pm_runtime_disable_err:
 	pm_runtime_dont_use_autosuspend(pispbe->dev);
 	pm_runtime_disable(pispbe->dev);
@@ -1762,7 +1762,6 @@ static void pispbe_remove(struct platfor
 
 	pispbe_destroy_devices(pispbe);
 
-	pispbe_runtime_suspend(pispbe->dev);
 	pm_runtime_dont_use_autosuspend(pispbe->dev);
 	pm_runtime_disable(pispbe->dev);
 }


