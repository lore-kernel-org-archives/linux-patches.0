Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5731636828B;
	Sat, 12 Sep 2026 19:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242488; cv=none; b=Nc7HxKY4oLYuExYDZJsbr+aauwBB10mnY/OWFbkHdnP1fAJ2++lzYcqHfjEtfeq/GBtFX6JBUk83O0qg5LRU/rT7fSDIrR5NarruPGiI5IW7xm8KQ7UjJpHK8jFxkDBB44oMchBSGpEpo+vfqePNIJeymQe3SYDGD1f4aaO4a5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242488; c=relaxed/simple;
	bh=YmjjSca9RiZHA4nfAQ4D1jsi6atBMkQ7jg0wkuCyWZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKp7nb+oq698oyUxRFGYqLTVKYWERDHBUMN4UcF2W79xs4e4M2xvNlbxFWnRFi2qI3VorMjAD5PyyfIs/cHygoQuJDPgGazWhZqD1CFAeAsH2P3KldNY27b2OyhULcF3tBvMRJNPn7CiIG7ha7qGLQsQOGf3poaZqej2g/5DWvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4Fv8koF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4Fv8koF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05E31F00893;
	Sat, 12 Sep 2026 19:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242487;
	bh=muZblvTfMpP88pNkVpyDG1m+Xm+LvMvwRb3sEG/YOOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4Fv8koFOk7CJOj8fpOCEgYbaFLyqRsOZjvXUZ59irhkygYt/qsN0mng49hnQgXO1
	 xMyHbHvJoB0mk4iifS03cobss9qYGVEhSuE3st0OgbD1pGxfOIe8fdACFwPPoavZAn
	 q68k5axfScOyz6g+AxbU7bQzcTFbO1t1eZYB9rFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 419/798] drm/panel: samsung-s6d16d0: Power off on prepare failure
Date: Sat, 12 Sep 2026 09:00:47 +0200
Message-ID: <20260912065526.753958758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit a9f950adfe2147318d75e7a6eab5e814851802ac ]

If enabling tearing mode or exiting sleep mode fails after the
regulator is enabled, s6d16d0_prepare() returns without asserting
reset or disabling the supply. Since the DRM panel core leaves the
panel unprepared, a later unprepare call skips the driver callback
and the supply remains enabled.

Assert reset and disable the supply before returning the DSI command error.

Fixes: ac1d6d74884e ("drm/panel: Add driver for Samsung S6D16D0 panel")
Assisted-by: Codex:gpt-5
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260704070648.35249-1-acharyalaxman8848@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-samsung-s6d16d0.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c b/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c
index 70560cac53a99..f8f98eb84c54c 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6d16d0.c
@@ -89,16 +89,22 @@ static int s6d16d0_prepare(struct drm_panel *panel)
 				       MIPI_DSI_DCS_TEAR_MODE_VBLANK);
 	if (ret) {
 		dev_err(s6->dev, "failed to enable vblank TE (%d)\n", ret);
-		return ret;
+		goto err_power_off;
 	}
 	/* Exit sleep mode and power on */
 	ret = mipi_dsi_dcs_exit_sleep_mode(dsi);
 	if (ret) {
 		dev_err(s6->dev, "failed to exit sleep mode (%d)\n", ret);
-		return ret;
+		goto err_power_off;
 	}
 
 	return 0;
+
+err_power_off:
+	gpiod_set_value_cansleep(s6->reset_gpio, 1);
+	regulator_disable(s6->supply);
+
+	return ret;
 }
 
 static int s6d16d0_enable(struct drm_panel *panel)
-- 
2.53.0



