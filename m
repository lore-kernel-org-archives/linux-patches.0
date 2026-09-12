Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42072E92BA;
	Sat, 12 Sep 2026 19:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241094; cv=none; b=J5Wbe8qFsaA8ScF2fg9b6KSeDFmx2vI2bqVnF5JA2kroFTFFMO2s/82xhlXGxPIE3GpwR6rhCxbk5Xt75cptr10QAdSDMkhF8GZfBtwZAkOeaK6ongRsa0M5sy/UetDdwpTc4kQyGrpIhB0+d+aSM/+OzhYZ+3haTC/KF6CTzC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241094; c=relaxed/simple;
	bh=aiqVNMdH9/WNL6FVDoSPG6JCO8MdRlLTB5lmp352aCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foFZMQ1oDCnPAOxSoxg0gDgWb9Z9CNqFP02aQU/JrVkuXgI6QQSWrRI00YG/kWNvw2TVZy9zapMNK9IP/hEuJ6pEoRfpgLmRl6/kYV28mv1g04exfma50D8VNabWm8U66PIutXyX67210pppTnUALBvJkgvp4a2T12XCVfavXUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9ANt7mg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9ANt7mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42F31F000FF;
	Sat, 12 Sep 2026 19:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241092;
	bh=pZsNH2h3Nnyv/eF1JagLdSEyuEAmSwD2j6ekwfJ0gkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9ANt7mgbGIHaIDBu7gl5s6pduUFxlrsUxbJs07YWOElACawi3dE9Iqyxrb42ztJN
	 lxNuQcJRKZq1Cve4C6asiAEEW0ZwFcuZVS6BUKXCv4zIYV0j7hHx5Svk8vxa/mYCBg
	 axAvA9/nLPG647OZqT9iQnYEIDeMpbEwGObINUXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 066/798] fbdev: omapfb: panel-dsi-cm: initialize lock before registering display
Date: Sat, 12 Sep 2026 08:54:54 +0200
Message-ID: <20260912065518.477346619@linuxfoundation.org>
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
@@ -1190,14 +1190,14 @@ static int dsicm_probe(struct platform_d
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
 
 	if (gpio_is_valid(ddata->reset_gpio)) {


