Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3141B377EDC;
	Fri,  4 Sep 2026 05:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500857; cv=none; b=Ola7ZZlj30nEzjYH127hPRPd9+9OD7FXbw2wVsX+PIyPD08iEzuhDu+/oWWKVJ6/DScYvofgzIHVCiMcOoDChM/i/iNc87G4lm48X0aGfvFEwQbtaQ2aNWIco0QztaNpYnhZ55bVKiIvGMuTo8wp13Dw8ULgatDrurwH2GAWz7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500857; c=relaxed/simple;
	bh=VxIY5tHqw1mCFad7zRE/lqJQ0wUBI4r8+BUHuuCl9kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uusg/dNa82lAQBvMASLc1N9c85B4GQOP5ovkHDyuS5cIWKWTAO3mtFVEs2d//SfXM60fQMvo+uDJJIJ8ESQXw+Vep08xACdzu011ORRhqdllR3tUoTHr2PybM24ioAJtsg0OFtItz3gizoBmJ7+uwH8ObbzexS4AW9lVaTrvb/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whNOcTy1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whNOcTy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A91E1F00A3D;
	Fri,  4 Sep 2026 05:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500856;
	bh=xzktKFdmK0lPHqzu1tlsisrhAU8tDJEpVS+2L4SJxFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whNOcTy1ecQAHsn5jb3aYI4Woqcax5V1WWqUBd985zKWvKbvtteEBigLooVOFeHXa
	 eUOElPZvSAbyB5/RCRrlscZxPOSf8RbiybyjZg0jluaUuGrgZHjqbDzH9jWBVtpDlc
	 SkFtIM2/8v+yz35fayrnxKZkd8fHNaRJkcAdPdTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 202/552] fbdev: omapfb: panel-dsi-cm: initialize lock before registering display
Date: Fri,  4 Sep 2026 06:55:59 +0200
Message-ID: <20260904045753.782888997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit f8e43fe0f22b7137ce456e6fe3581d3098174f74 upstream.

dsicm_probe() registers the display before initializing ddata->lock.
Once omapdss_register_display() publishes the display, another consumer
can reach a dsicm callback that takes this mutex while it is still
uninitialized.

Initialize the mutex before registering the display so the published
callbacks always see a valid lock.

Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
@@ -1151,14 +1151,14 @@ static int dsicm_probe(struct platform_d
 	dssdev->caps = OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE |
 		OMAP_DSS_DISPLAY_CAP_TEAR_ELIM;
 
+	mutex_init(&ddata->lock);
+
 	r = omapdss_register_display(dssdev);
 	if (r) {
 		dev_err(dev, "Failed to register panel\n");
 		goto err_reg;
 	}
 
-	mutex_init(&ddata->lock);
-
 	atomic_set(&ddata->do_update, 0);
 
 	ddata->reset_gpio = devm_gpiod_get(&pdev->dev, "reset", GPIOD_OUT_LOW);


