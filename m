Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC67D434409;
	Tue, 21 Jul 2026 21:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669898; cv=none; b=AjJDKtzREmgy6b/A0OvWnGjUZk+EQhe+nAfKEcCvjumSyypuj6UVag4h1S0TPV0890pdkcE6r5W8Lf4Q0/8tZdd5QYwJxGgNg7Z3Zj5mf+qVIaLRpnexONXAA07FfwxlmbwXqIFwlSd5PtRdzxb2fnD9QJuu5l4BIWssWfc+acQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669898; c=relaxed/simple;
	bh=yh1zAbRefinWy5w5NxrrcPTvHLSFuKDP4sQagx9Pa8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/KE+JVyRvTCGEtIVVsus5b1Z+uq0TLtyjYdc/JWrD5vmAbaPTT0qllnwhPA5jYTdXpPHk9F4PvsCx4mTGrObTQSd6cioac0OIq5iJJSpPFyPvjIjvSbCguI9ZavSfLCItwNJO50HEF6h2qXf+BHMt336Skv48cmYpM5jugKgJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rA2trGjO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rA2trGjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4D01F000E9;
	Tue, 21 Jul 2026 21:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669896;
	bh=g7Bk59aAL489kAIj687FR12URu5I1AEbX7DBBA5Ovec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rA2trGjOQCCp+eOhXg4pOJ52/QCsbT46vyeISbeANOO6rnmfmJLj80//kBym0j5oc
	 r2I6/MarS0kYlKDISuLzL3HYFlx8Rf9UEBXcjZQ0WFNpu7RuegHltMCR5b3VWlE64c
	 sTDkeSDdBiEP9FUcEzABd4ZrUibHOsCqpMGa1Q4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0728/1067] fbdev: metronomefb: fix potential memory leak in metronomefb_probe()
Date: Tue, 21 Jul 2026 17:22:09 +0200
Message-ID: <20260721152440.873300989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -703,12 +703,14 @@ static int metronomefb_probe(struct plat
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
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
@@ -731,6 +733,8 @@ static int metronomefb_probe(struct plat
 
 err_cmap:
 	fb_dealloc_cmap(&info->cmap);
+err_fbdefio:
+	fb_deferred_io_cleanup(info);
 err_free_irq:
 	board->cleanup(par);
 err_csum_table:


