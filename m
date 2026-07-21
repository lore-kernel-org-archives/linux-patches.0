Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755674582D7;
	Tue, 21 Jul 2026 22:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672273; cv=none; b=jVGbc9sTkuyJmHEtksLbL232IE0rvzTz9p1actoJgaAYJ92mhtp+I7js2zOQtR2ZjMhkcP3WahOwBPPp25h0yXhB3R2gS/BQqT8AO7+bBYDoQaFOiKWPUtefh4MX5YC+Hvp6vVomT/5hnQuq7c7p+1fPmERS4uhrMKXAqtNb3pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672273; c=relaxed/simple;
	bh=5hr1XOgtzrRYMbL1/UqFg26O91vYD2+hshSCjcKeOR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnuMT9R5V+PZLfJMpTwNPWTBiFkGNuALpT/Y6Cs1WIJcuvqw1c7OcuOU2Y8ypWxKLiIeto+oUCBVqDeJxV7YHJOVChAenuEX6ZrIz2gv9fxg9cPndV5EhkEAvJkDiG+ifEuad2OZBBmQYanx4kHUK6AC7sO+q5+faieTNbnPZik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pN2RI4ap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pN2RI4ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B271F00A3A;
	Tue, 21 Jul 2026 22:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672269;
	bh=sF6xffg4++JeyZ7HD4MPZeeaCzLqY1oMkFrwSPxveT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pN2RI4ap7gs1nWyeAj1TXfUvoCO83vODRNGUPQbcH0zxwgVPcqQzfFfiLWm5TJqpI
	 GsQLy0iTVWJwegLsnc0Dzuc4ZhGKq/Wn+cRSTDl4zFGbcbs42uMQl1gPjiJbEFgfkL
	 mVu3hSNgMufLlOy0STdWfM5MCQsn62+GtpF6vi/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 561/843] fbdev: broadsheetfb: fix potential memory leak in broadsheetfb_probe()
Date: Tue, 21 Jul 2026 17:23:16 +0200
Message-ID: <20260721152418.668995938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 9d18a4e4234fd3ee0d0eed8ccbbb50cb76b2232c upstream.

The memory allocated for pagerefs in fb_deferred_io_init() is not freed
on the error path. Fix it by calling fb_deferred_io_cleanup().

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/broadsheetfb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/broadsheetfb.c
+++ b/drivers/video/fbdev/broadsheetfb.c
@@ -1134,12 +1134,14 @@ static int broadsheetfb_probe(struct pla
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
 	info->fbdefio = &broadsheetfb_defio;
-	fb_deferred_io_init(info);
+	retval = fb_deferred_io_init(info);
+	if (retval)
+		goto err_vfree;
 
 	retval = fb_alloc_cmap(&info->cmap, 16, 0);
 	if (retval < 0) {
 		dev_err(&dev->dev, "Failed to allocate colormap\n");
-		goto err_vfree;
+		goto err_fbdefio;
 	}
 
 	/* set cmap */
@@ -1183,6 +1185,8 @@ err_free_irq:
 	board->cleanup(par);
 err_cmap:
 	fb_dealloc_cmap(&info->cmap);
+err_fbdefio:
+	fb_deferred_io_cleanup(info);
 err_vfree:
 	vfree(videomemory);
 err_fb_rel:


