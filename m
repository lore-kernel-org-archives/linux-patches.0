Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E512F24;
	Mon, 23 Jun 2025 13:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685567; cv=none; b=XghpzUn8pTEuqzMrHrixK1vKpoVmOloc++oo7x6OUMeNcLFZcA4zEDlMAgvHmOvexo058lm3m0XJUXvatubNUqcJ3tEE2EMwFQ/yfI69GjzzMD5oPaemws1GbmLDJiqG2D/nkFOtIRcxyOkTiOanjvtLL84cD4wRitRu4W1UmBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685567; c=relaxed/simple;
	bh=nPNocmBpf3FMQW/3KDyBK/vjm66P9V9HVjPHvs+/+MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jl2oURCo1mjBQUnso6oj83Q9HRaYetiwoWRFXjQDFbVpM03Wz20GD7cJHWWK6o5oe9CnYpBTEJCv+hh5ogBmm6yhyaRhw7CF/3LXB4wl/cAmfnSPnR1C9VTKbyLrHEO5nyMcYN7Xv56smKkg2xXK/41186yORpyPOMb48l7R71w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIHUslNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIHUslNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C7CC4CEEA;
	Mon, 23 Jun 2025 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685567;
	bh=nPNocmBpf3FMQW/3KDyBK/vjm66P9V9HVjPHvs+/+MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIHUslNP328lzr+QZmTGORAVLy2HuvK6YnS3vvy9PyHJF0lhf/VsqxbfQzdeDk0bK
	 3RtkHjWl4KO83bPHxL8ZNbaiatoerupHH/BfWZmIttKtfL7UdcQGjITM0/Htf+ka0L
	 XrTr6iGntafmw+dpfqR/BgjdCBFzdLdRcjTmvVlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Damon Ding <damon.ding@rock-chips.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 244/592] drm/bridge: analogix_dp: Add irq flag IRQF_NO_AUTOEN instead of calling disable_irq()
Date: Mon, 23 Jun 2025 15:03:22 +0200
Message-ID: <20250623130706.095626686@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5222b1e9f533d..f96952e9ff4ef 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1622,10 +1622,10 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
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
@@ -1641,7 +1641,6 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 		dev_err(&pdev->dev, "failed to request irq\n");
 		return ERR_PTR(ret);
 	}
-	disable_irq(dp->irq);
 
 	dp->aux.name = "DP-AUX";
 	dp->aux.transfer = analogix_dpaux_transfer;
-- 
2.39.5



