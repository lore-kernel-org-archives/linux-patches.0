Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D0A15218A;
	Tue,  2 Jul 2024 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940150; cv=none; b=rWVPzZgFwyUAoBZ0BGdwHtElbQlHApjvHCKXNorAqNG/0KaJWjVeOi+xliKKtMCoeylpSm9pXy+PdIgrG7bRtJeepicNZAzXRmh8fwd+E7Hft85+DE0FklpadB49f7Qep3HDtuNeF9n25FPJRQsqxmDkx+DoALGIhoEiIGQ6EC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940150; c=relaxed/simple;
	bh=Zgjwjv8dVd8WsQ+6RAOCuVpZfi3nVqNU0SMqMgS9s7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHyziRjOiHWMrJyqSWjvFm0RWx6HKadK8YKfFz1r6L4EVlaTt8BYeIgYmhgfOV+o+S1uU+5gTaQoeu/H0R5oTgE4ky0GJl1hjimv+GdetRw09ly4woooloP0/TYDIgjntyYgyFV40fTUqZ0Vpe0LjW3ENjB4citKkTI6YEOOWSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imonLVTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imonLVTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0CAC116B1;
	Tue,  2 Jul 2024 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940150;
	bh=Zgjwjv8dVd8WsQ+6RAOCuVpZfi3nVqNU0SMqMgS9s7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imonLVTTIcjkIc3Lo2yUKOw+yzW9hF3Gl9fVLr6GOURNwE7ZOTkDKMFfc6yeOHar5
	 v9on7uPmaDAOsNbJKVFXwHe36SA7kxhPokxBStFtx2ZeCWfiDWmWnQTFR9Q+SybXii
	 JOQiRhocFbMaSUV/Y0extBWDdVMUSEQpqyXb3Hl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 067/222] drm/panel: ilitek-ili9881c: Fix warning with GPIO controllers that sleep
Date: Tue,  2 Jul 2024 19:01:45 +0200
Message-ID: <20240702170246.542678342@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 2ffe5f68a8903..4c8c317191f3c 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
@@ -1080,10 +1080,10 @@ static int ili9881c_prepare(struct drm_panel *panel)
 	msleep(5);
 
 	/* And reset it */
-	gpiod_set_value(ctx->reset, 1);
+	gpiod_set_value_cansleep(ctx->reset, 1);
 	msleep(20);
 
-	gpiod_set_value(ctx->reset, 0);
+	gpiod_set_value_cansleep(ctx->reset, 0);
 	msleep(20);
 
 	for (i = 0; i < ctx->desc->init_length; i++) {
@@ -1138,7 +1138,7 @@ static int ili9881c_unprepare(struct drm_panel *panel)
 
 	mipi_dsi_dcs_enter_sleep_mode(ctx->dsi);
 	regulator_disable(ctx->power);
-	gpiod_set_value(ctx->reset, 1);
+	gpiod_set_value_cansleep(ctx->reset, 1);
 
 	return 0;
 }
-- 
2.43.0



