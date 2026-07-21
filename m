Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F9A430CDC;
	Tue, 21 Jul 2026 19:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663481; cv=none; b=NaFC3hnhB4Acx7jhCVvcfx+zgI21pAjaCwOr0gGscEFPOmlQwaKxdkoUwccXcEsgiUgSAKKxJE0f0mNSPOlN0HCupnVGDcPM5yGo1gt708R4NxmysqKU1AoYJKc2sGH2ZXhbwog+g343oP9JhdvCmHk7d1cUByvVW7gwB6d5eaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663481; c=relaxed/simple;
	bh=fqFOIPWPewOmMv1ueZNv98ijZutSSN7P/vrM6hCqoLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/tCXZF8UpI98Ja97Et3lro1JXBwNY5XJMy4/4rSHLPFeZd1wBMrvJt7VOYH5+OW/ZorbSzBHlbXNblJLz2kxwnf4dpabEyEddJHfM0novsh9VKWX4kuQq+FgWzsq1dpp03UO/ciIdDkGnBrl8DrrsmXTERoTfdPvZ2QuNd2VF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFVXHyrY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFVXHyrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E791F000E9;
	Tue, 21 Jul 2026 19:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663480;
	bh=ndteADsMv7ofufcBHaiALe1H86RxEQTzPIufVIz/osA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFVXHyrYFRb0EpHO8SxuZxOE2iIctPeG+EJElz164hwxLr1ULDghIfaapYJ76bdzT
	 LSg9Kz0gIxOt7pksTlleiWY6GuwuKteuLNemN44q2ZEhlUyE1I3szLYsJ1zxpxbexR
	 nIIhXNNw+QgAIY5SZ/xf1i089GwHrJGkze7SKbBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0840/1276] fbdev: hecubafb: fix potential memory leak in hecubafb_probe()
Date: Tue, 21 Jul 2026 17:21:23 +0200
Message-ID: <20260721152504.853555599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit cbef2a305a8a72969b86f96b7c07b86edde61aff upstream.

The memory allocated for pagerefs in fb_deferred_io_init() is not freed
on the error path. Fix it by calling fb_deferred_io_cleanup().

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hecubafb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/hecubafb.c
+++ b/drivers/video/fbdev/hecubafb.c
@@ -192,7 +192,9 @@ static int hecubafb_probe(struct platfor
 	info->flags = FBINFO_VIRTFB;
 
 	info->fbdefio = &hecubafb_defio;
-	fb_deferred_io_init(info);
+	retval = fb_deferred_io_init(info);
+	if (retval)
+		goto err_fbdefio;
 
 	retval = register_framebuffer(info);
 	if (retval < 0)
@@ -209,6 +211,8 @@ static int hecubafb_probe(struct platfor
 
 	return 0;
 err_fbreg:
+	fb_deferred_io_cleanup(info);
+err_fbdefio:
 	framebuffer_release(info);
 err_fballoc:
 	vfree(videomemory);


