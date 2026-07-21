Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649B2366816;
	Tue, 21 Jul 2026 20:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667029; cv=none; b=VSUh+rGseaIHqAhHx2WAmmiaWnWbZkgruSck+Rlmbhe6W+mdRPTp3IgnvaNiZ7aif+pGInhEyCNL4YMbcVb+cRpTj7PWIJFDmsfi761tghxa8t1LNmGQC3Yy4vQXt3gpLFJClnh6mgKeqXhMwQa1mDgM7GlDgqNfKiylOm3aBHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667029; c=relaxed/simple;
	bh=Yb0VL3KD87lbTUIG440Q2y9oVKYV3js7ukTr3EMyUE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyzoUTjZkRzxvDaS7Q89Gu5RxL64Pe0z8BWY/V/vPFvVhFJElVjq1Lrr7lbkLlqvnbrDjfDHF2mXMVGz4M/Igp+vcMrfAvhGG20NGPY/3WgEOMzm17rwnPbvBICAVEJQDHYUXFaJiO/brgrj2JJCNlY5NBEPyAxdxfTfkJekMPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDKMmjwv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDKMmjwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806C81F000E9;
	Tue, 21 Jul 2026 20:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667028;
	bh=/whbeRwuQr2RWpa1wkrZ3qynOSFIC3+JM02oA7+F9rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDKMmjwvMoUh7jKFyVhZW2qhuzLFpsVyTJjwq/piNZk+JBfWl43uJu1i+oiIUoF0g
	 Upj7RdKN/na6y5EKCMh4Km5P42N5/Bq1tA/VGRNhBuFbJ+tFkentWR2dSUM1u+LyHM
	 7/0Wv/3vzPKMBX9rx9YA677xGKJlnWJeWnPhphxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0905/1266] fbdev: metronomefb: fix potential memory leak in metronomefb_probe()
Date: Tue, 21 Jul 2026 17:22:22 +0200
Message-ID: <20260721152502.095973907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 894632b862a39b3fe1cb5de06fbae86225ea64de upstream.

The memory allocated for pagerefs in fb_deferred_io_init() is not freed
on the error path. Fix it by calling fb_deferred_io_cleanup().

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/metronomefb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/metronomefb.c
+++ b/drivers/video/fbdev/metronomefb.c
@@ -645,12 +645,14 @@ static int metronomefb_probe(struct plat
 	info->flags = FBINFO_VIRTFB;
 
 	info->fbdefio = &metronomefb_defio;
-	fb_deferred_io_init(info);
+	retval = fb_deferred_io_init(info);
+	if (retval)
+		goto err_free_irq;
 
 	retval = fb_alloc_cmap(&info->cmap, 8, 0);
 	if (retval < 0) {
 		dev_err(&dev->dev, "Failed to allocate colormap\n");
-		goto err_free_irq;
+		goto err_fbdefio;
 	}
 
 	/* set cmap */
@@ -673,6 +675,8 @@ static int metronomefb_probe(struct plat
 
 err_cmap:
 	fb_dealloc_cmap(&info->cmap);
+err_fbdefio:
+	fb_deferred_io_cleanup(info);
 err_free_irq:
 	board->cleanup(par);
 err_csum_table:


