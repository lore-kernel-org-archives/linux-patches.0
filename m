Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E70B174ED1;
	Wed,  3 Jul 2024 10:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003614; cv=none; b=S/g9MgxMCNkikNNe/7knvBCp1GnFs648xJJCNRs9Mo2v5NGuFQM0UoU71CoXzAhEpgAPX35iKJ/gt3OcTkzGeK2x1izrRuYIbZvhetRTD5E7po4tUQDUKJEMN5zFXdZuV/+RkmJHsgkroHYeI5p40g8TdQE7gELc5/NllCEj1Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003614; c=relaxed/simple;
	bh=4XfUdrJ/vkbYK+i5LWFTPDX4SlV/uA2RSVayQWbI81w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERwaaSL3vY6V39xUKh4Aazqt9zjlhBXbWcqd6Rob6R2KzA4f4BLjJeexQX5/SVkUhD9XmlDLFzzOwP66jslBRw3UA9S487Vc0Z7Gv0CwDKKo3ZCzwZqdvgwWbD0/StsnwZr+bcUUstyD+pbgR/nF2GpvnPw4cqfu4nRtiQOzp44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eo5boKAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eo5boKAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47909C2BD10;
	Wed,  3 Jul 2024 10:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003613;
	bh=4XfUdrJ/vkbYK+i5LWFTPDX4SlV/uA2RSVayQWbI81w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eo5boKAws9KfhImT49k1ZBYOtW5IvZ0PevwnlSZ0G8sS7CmAmMY6YIXAMJkuQSceK
	 ZphYiwvHLTJTRe8qPAdGV8LfpgQOy54j0SCd5iu0yS3bFK6/4Dg8iijdWBZwyXi3TD
	 BzdyQhjsgTlY81BfmFsZxW8LPJiG40WrOGhfQwKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/139] drm/panel: ilitek-ili9881c: Fix warning with GPIO controllers that sleep
Date: Wed,  3 Jul 2024 12:40:04 +0200
Message-ID: <20240703102834.483004457@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit ee7860cd8b5763017f8dc785c2851fecb7a0c565 ]

The ilitek-ili9881c controls the reset GPIO using the non-sleeping
gpiod_set_value() function. This complains loudly when the GPIO
controller needs to sleep. As the caller can sleep, use
gpiod_set_value_cansleep() to fix the issue.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240317154839.21260-1-laurent.pinchart@ideasonboard.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240317154839.21260-1-laurent.pinchart@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
index 3ad4a46c4e945..cc11cf41d392c 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
@@ -307,10 +307,10 @@ static int ili9881c_prepare(struct drm_panel *panel)
 	msleep(5);
 
 	/* And reset it */
-	gpiod_set_value(ctx->reset, 1);
+	gpiod_set_value_cansleep(ctx->reset, 1);
 	msleep(20);
 
-	gpiod_set_value(ctx->reset, 0);
+	gpiod_set_value_cansleep(ctx->reset, 0);
 	msleep(20);
 
 	for (i = 0; i < ARRAY_SIZE(ili9881c_init); i++) {
@@ -367,7 +367,7 @@ static int ili9881c_unprepare(struct drm_panel *panel)
 
 	mipi_dsi_dcs_enter_sleep_mode(ctx->dsi);
 	regulator_disable(ctx->power);
-	gpiod_set_value(ctx->reset, 1);
+	gpiod_set_value_cansleep(ctx->reset, 1);
 
 	return 0;
 }
-- 
2.43.0



