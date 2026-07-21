Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68272366816;
	Tue, 21 Jul 2026 20:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667034; cv=none; b=uP4HnYx9e4vq0r/xFcSM6GVGljTtKanNBMDGVm6polGLwE1M0fb5Fdr+WyACo9X+1vcXtUd6IJYj3h5v5uNg3U8stxkogsiOiV7JKprAADK6pDQiSU1ZhMfKzcWXm82v6PnYMS1jUTae65TmW8jNdNvMY11kzkcDr+Z5sx4UUzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667034; c=relaxed/simple;
	bh=EjpcBUyo1T1TTJB0hKRLfdaBD2dhoNETjgsXzNXrHes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4GioZZPk+ycWJpCWGIpjQ51DgqUTgpSuUhfEakxLEKMuEyXhRQcpS1ZU1njvw7lsAJvnPts4WKOZLPaX5/fSLgWi9KZACQC4nsJrjHugSEMCX98CNRkb2l2ip47HlcHFxvHWUR24mSFCpFvt+lQrmDK4IuVziQ8LSz3e1l1Jww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J64nndMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J64nndMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FE61F000E9;
	Tue, 21 Jul 2026 20:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667033;
	bh=fQXttmkIV5kQa/9cFD2k1quLELvbJWTeIl4dYJUmbis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J64nndMTQmeFxUlVzayJz07jB9IPbO50L/2EqJb8IX9+t2GRK981Jkp+CTkpcFDoi
	 dhhfKWdGmOBKHtvBYoTYHDeP4ljqCAGUyo0Mk7CplELM4qLCICfCnU5xKaAZ017qKp
	 CVtvXsfETgEJu3n24TPoy7u94EpXgdXMZm8kNvE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0907/1266] fbdev: hecubafb: fix potential memory leak in hecubafb_probe()
Date: Tue, 21 Jul 2026 17:22:24 +0200
Message-ID: <20260721152502.141658062@linuxfoundation.org>
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


