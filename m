Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F319221734;
	Mon, 23 Jun 2025 21:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714711; cv=none; b=rviMAeYLaM3zK4xdVyyqleoqgiOOaRA/DZ/zodXMa011DwmYA56BDphQOhTms4tMlkW8BrEy5k/jxnvhBhr+MDddCjwVoq0CEl2tRgQTXo6k3akTGp+g9tk/MN5d6r+g/JNu0lOJTm6RmrFy8ngJ1hW/IhQUjvR3VQL0KJxdlPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714711; c=relaxed/simple;
	bh=VT2U2qSyWrFiJT73f/83++Dttc6bNQFq0GLWM3tUZ2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubJqJIvHvZ1IongpcC3GhCxVXBT3ASI0GT1yRNmTj/faHzcKIJxMEMfDwiwbu8vH6uZalVdl19Hs7x81ZNq1sfvHtSlxkvRretv8+TzlsVuVjox7ahe+a5znldPUX+g3zlE/jp2Uk014wRNExl3wwy5PZ+2ZkjEVqvykkG65bpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yx9RGofU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yx9RGofU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27C8C4CEEA;
	Mon, 23 Jun 2025 21:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714711;
	bh=VT2U2qSyWrFiJT73f/83++Dttc6bNQFq0GLWM3tUZ2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yx9RGofUrOhylVb3+fne9FNefDwI6vopWKIyxx84qkVCYbcs5B4EqQ3h+EfoZ4I+d
	 fEgtEzy+U9+EwNdZQyC/iMAGIrxyZbQZKF+XKY0Sip0LSDjoBzJMEE5wF4e2gW3ZtA
	 UlgCJnGj4THOqMnLCJUJ33uUresYI1N4alunLfCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Damon Ding <damon.ding@rock-chips.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/355] drm/bridge: analogix_dp: Add irq flag IRQF_NO_AUTOEN instead of calling disable_irq()
Date: Mon, 23 Jun 2025 15:07:05 +0200
Message-ID: <20250623130633.475517564@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit efab13e7d13a641a22c7508cde6e1a5285161944 ]

The IRQF_NO_AUTOEN can be used for the drivers that don't want
interrupts to be enabled automatically via devm_request_threaded_irq().
Using this flag can provide be more robust compared to the way of
calling disable_irq() after devm_request_threaded_irq() without the
IRQF_NO_AUTOEN flag.

Suggested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Link: https://lore.kernel.org/r/20250310104114.2608063-2-damon.ding@rock-chips.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index e8baa07450b7d..3d8f08d895612 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1778,10 +1778,10 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 		 * that we can get the current state of the GPIO.
 		 */
 		dp->irq = gpiod_to_irq(dp->hpd_gpiod);
-		irq_flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING;
+		irq_flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN;
 	} else {
 		dp->irq = platform_get_irq(pdev, 0);
-		irq_flags = 0;
+		irq_flags = IRQF_NO_AUTOEN;
 	}
 
 	if (dp->irq == -ENXIO) {
@@ -1798,7 +1798,6 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 		dev_err(&pdev->dev, "failed to request irq\n");
 		goto err_disable_clk;
 	}
-	disable_irq(dp->irq);
 
 	return dp;
 
-- 
2.39.5



