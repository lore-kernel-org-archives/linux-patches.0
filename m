Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455D9472091;
	Sat, 12 Sep 2026 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226992; cv=none; b=l/k3avBxDbuqEPLUlrSA8M7udHIQAIWidyQi8UaK1PN0bVMWu0GNKzmQPdWmIuG4CCHJYUVZ+INk81XTao8vXxu9oGZO+owDAoFD8JfC9va+ZMLsk2v9mBBZYeoeg2PLCnCJQaxr8OQMPCDsWrR5phTJ2gv9dYHwQWTCgoIMseU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226992; c=relaxed/simple;
	bh=UPQhr+rIIpONNeU1r7xLKzkSnRf3Wn34cGAxxL7HvmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKlyCvCb0FWjhIqJGvtQtoM2nvHoBGFxcZmBSFRov+boz9lROTZE0ax+mCr3UkWuaPSHuQ91bKvT6BnEOggjcwW1DENLggQLIgppTJJEglwv6ttkUUAWx6Fb7FYYP21AYw7WBzZzYeOMUpUcaCrmoemutwisg6NIvgc6+Q3gx5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCubs3+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCubs3+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0739A1F00893;
	Sat, 12 Sep 2026 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226983;
	bh=hbqIvEP8hFQiNDINVdcXxcIMrj0Yvg2omRQYgHxBmyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCubs3+f4WwfKCwVvlfp65wUE92mbQ+ii/uGReZCyuPA+wSr349dDpqRaOEiMf8Sj
	 Engm0q2nUJsdGpz4oaAWXVH6uuBKsCvLquAu/xNImsPCACS4p88zgGW3whSl4/HU0N
	 G5UlweQYehBbWzjtj3ineamaTKQ2GhbZSXESEoI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0087/1191] fbdev: omapfb: panel-dsi-cm: initialize lock before registering display
Date: Sat, 12 Sep 2026 08:46:55 +0200
Message-ID: <20260912065550.133073020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


