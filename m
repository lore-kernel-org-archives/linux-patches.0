Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91C013A27E;
	Wed,  3 Jul 2024 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006146; cv=none; b=O8ZNupPLYbpXkYTm38GF+Fe4IoYL9KzVa5bc0/R1x6vPh7CwQWYN0X2s6cunz7A6z40im6FjvuhUum1yw8TcwSFiEiRTmSRsTfEwdxm2WAY/Q9e4hA/HAKoIIeozuwlSeFk3RS8YjeqmVbWTRiJxzMjIltdF8W0tBQGPfOaQuoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006146; c=relaxed/simple;
	bh=WR4GtdfhhGP1FNtGOa8k/REBSaumbPndegLcZxVlh70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqkopPwEUhPMGX/BbMXLYn0DF5cqw5gB4MCWGha9t0UAyn6N5TA5R0nSFhsYx5UiWwwZh2bTUSFawOJXnPpuIGocT5FIS7EWpdQO9EDZntZF/sAp9l9cqQ/R5wh8+O4QK5FOByY7G2DUexUqskjeRvD0HmB5vF0apFzC3306nJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaPU2GJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaPU2GJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB84EC2BD10;
	Wed,  3 Jul 2024 11:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006146;
	bh=WR4GtdfhhGP1FNtGOa8k/REBSaumbPndegLcZxVlh70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaPU2GJnjmeZNpKJX8RG7sQe7Lbg15ztd3wBYoyMPpuEcl0iuHfSwfHnXZjPpBw9E
	 Nt0S+EC1EyTcXT+077ulpsVsI7Vc1s7hDvoVA2qsCLZNkHHNx4kXvo9qflcXq+pIN9
	 AvX2V86V2rlLiXpBZue68IO91+if4Nb5UsVxiahk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/356] drm/panel: ilitek-ili9881c: Fix warning with GPIO controllers that sleep
Date: Wed,  3 Jul 2024 12:40:20 +0200
Message-ID: <20240703102923.859088171@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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
index 534dd7414d428..917cb322bab1a 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
@@ -506,10 +506,10 @@ static int ili9881c_prepare(struct drm_panel *panel)
 	msleep(5);
 
 	/* And reset it */
-	gpiod_set_value(ctx->reset, 1);
+	gpiod_set_value_cansleep(ctx->reset, 1);
 	msleep(20);
 
-	gpiod_set_value(ctx->reset, 0);
+	gpiod_set_value_cansleep(ctx->reset, 0);
 	msleep(20);
 
 	for (i = 0; i < ctx->desc->init_length; i++) {
@@ -564,7 +564,7 @@ static int ili9881c_unprepare(struct drm_panel *panel)
 
 	mipi_dsi_dcs_enter_sleep_mode(ctx->dsi);
 	regulator_disable(ctx->power);
-	gpiod_set_value(ctx->reset, 1);
+	gpiod_set_value_cansleep(ctx->reset, 1);
 
 	return 0;
 }
-- 
2.43.0



