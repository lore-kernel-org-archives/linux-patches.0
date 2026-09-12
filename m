Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CDB2DE702;
	Sat, 12 Sep 2026 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220080; cv=none; b=P1aIWzcGeD+FoSaDr/vICEWP0Ub1/pQNI2Pzd408AlBZNouJeXLznQD1ezERkVJ6GbRyrE2lk0FKZBXTvFYudpsOzFmCBGTf24dlSoUNL7Kx1nXPy+rz0swrYPE/9qjBURHJBUsj/5R1OoqngLASnnMBiBS7fwQY/rMuU4175Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220080; c=relaxed/simple;
	bh=EadefrhO0nYcLB2LjGkuy7wqg6LyVstq4vC9+tEcMfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDCSR409Ho/egZ7t8DdiN003SI1Tlt3nVxXfdp5znRVpFdVhTZtATX0ONonXRsEVUzWYgT5inRRWeCFfyGBVqD60n4IjakTROclTMzfeQDfp4N1M7mtwQNs0hTWLYw+KGZmHm/1UpBRIkI8lsXXuJk0MYI+5F+FH6XEhuwvswFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXokcIRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXokcIRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCB41F000FF;
	Sat, 12 Sep 2026 13:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220079;
	bh=TOQ6+8U5vrHUGA7D2Xqj8gfvubfviZCBmYg76y1KYjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXokcIRzPVHzHvqZY11b40JLzTSjlrIiSSX3TkqVwJ35MIwElQzYGvHSW2eefQfJ8
	 z8XC57lkzIAV7nvdAKDyzI3uPJmqdapg16ngnodVG0VsPcJ7UAq/A8dBhu0V2IYiaW
	 Hy4NSJxyJS8zEQ0nWp0FFJlZ54hL7FA3+RrF9fUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0103/1424] fbdev: omapfb: panel-dsi-cm: initialize lock before registering display
Date: Sat, 12 Sep 2026 08:42:15 +0200
Message-ID: <20260912065609.613813016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1155,14 +1155,14 @@ static int dsicm_probe(struct platform_d
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


