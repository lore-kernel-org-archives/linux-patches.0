Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B14C1A6166;
	Tue, 30 Jul 2024 16:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356786; cv=none; b=d9u0mYt4t7k0vc6EbK+GG20Wg/GGcoivrt2jpXK/mlaMLtEPQGoLrGDPIiSrGeEMx9zqf2Qiwdp2THammqEMdLX61LU79zs48uSHU3m3kB+pscfGMZuMi4JLYGPiikH/tQyRYXgJLu8Ny9oAYwaIiES/V2Onxs9vTcRnWKjzTUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356786; c=relaxed/simple;
	bh=6ioOyHVe54/2hU3nPGTcCCIMeMLkI6ewvzyYq0ZWDDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7Vlc39XQFB/EXDcDrHqZcJ2U1nET8wFVKHJ1nlzNnwZLzGvPZLGu1fwZH7GdWxIQjF/fWqT3fXVyoyZa83Bw1O55FQr/da4aTiAfKLSiEgZb5dxqW/FWg2guJyMB+0WCZ7yzc+tcoS5nOetrD7sHRR9jAr8CdoQajmtJHs8yN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjCZpgnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjCZpgnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1089DC32782;
	Tue, 30 Jul 2024 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356786;
	bh=6ioOyHVe54/2hU3nPGTcCCIMeMLkI6ewvzyYq0ZWDDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjCZpgnvB3diMAgC8N5lK4t5KoobVDUgJZJcjOu+xJKvIWR1DZs27s9Dvqd+mTeuA
	 Xl+Icuf9hqECOOFMWaCyp/pbDE7XicGnV8aZzMh3e0kdItiT4wS30dxN1pQnByF+Q7
	 kQR5XnaPamaB16zWZNrffrywrLoF9U7f8I40fqko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/568] drm/panel: himax-hx8394: Handle errors from mipi_dsi_dcs_set_display_on() better
Date: Tue, 30 Jul 2024 17:44:51 +0200
Message-ID: <20240730151647.071131155@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit cc2db2ef8d9eebc0df03808ac0dadbdb96733499 ]

If mipi_dsi_dcs_set_display_on() returned an error then we'd store
that in the "ret" variable and jump to error handling. We'd then
attempt an orderly poweroff. Unfortunately we then blew away the value
stored in "ret". That means that if the orderly poweroff actually
worked then we're return 0 (no error) from hx8394_enable() even though
the panel wasn't enabled.

Fix this by not blowing away "ret".

Found by code inspection.

Fixes: 65dc9360f741 ("drm: panel: Add Himax HX8394 panel controller driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240517143643.1.I0a6836fffd8d7620f353becb3df2370d2898f803@changeid
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240517143643.1.I0a6836fffd8d7620f353becb3df2370d2898f803@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-himax-hx8394.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-himax-hx8394.c b/drivers/gpu/drm/panel/panel-himax-hx8394.c
index c73243d85de71..631420d28be4c 100644
--- a/drivers/gpu/drm/panel/panel-himax-hx8394.c
+++ b/drivers/gpu/drm/panel/panel-himax-hx8394.c
@@ -234,8 +234,7 @@ static int hx8394_enable(struct drm_panel *panel)
 
 sleep_in:
 	/* This will probably fail, but let's try orderly power off anyway. */
-	ret = mipi_dsi_dcs_enter_sleep_mode(dsi);
-	if (!ret)
+	if (!mipi_dsi_dcs_enter_sleep_mode(dsi))
 		msleep(50);
 
 	return ret;
-- 
2.43.0



