Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7298366816;
	Tue, 21 Jul 2026 20:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667031; cv=none; b=DJxGuDoeku6tCmpgzsFN+634I39Mkd1hhoXX+RmT5r+FG2BSUb/iVRAXJlZyYtjz/3im6RwYi+Ob9Gmzv201fyJl6Mm/a1MGxCS/d4p8mUUl7X62BFj3xf3gTSrz0T7TkAE/GmK9T4zNqlmYoGQg6KHKYsz9PoZYG8VXoWfXfls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667031; c=relaxed/simple;
	bh=oamZjXE0klfMC+QiwhObHZBfP2WuJnxxPMrIdTrWblY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/8YViPip5VCN3ALu/1UAMd9PwTpKfTn7K6ZtWjvQWMWWiKIq2MlcaHL4sZ5h1VRr41i8fvJkKF9/fF5hykAL9QWKdPANcluaxtWxm1osD8JrInRCyBFphfRII5HVMrl1X1zC2yeWxb3C7MAtJMulj2BhDVIspTVwKM1rHRoYz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grrdp17G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grrdp17G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281AB1F000E9;
	Tue, 21 Jul 2026 20:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667030;
	bh=a+lzW9/z7205LufEGEzNtXwQN3vo3nyqJk5odssuhZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grrdp17G3sx8dVC4LyNc8/Oai+SyhVf5bUAaQ2QYkXwLTEpwNzSZhuP5qg1IfPOL8
	 DevKiUigqfMJZQnSLQmKNZwT9wITyDZcKH2PZQ+VFTvM4ZfWrD6bv9H6kCa28aixvz
	 17ZuRmY0vDTG2SIinK917t8ZBO5OU/UxvBtcHzjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0906/1266] fbdev: broadsheetfb: fix potential memory leak in broadsheetfb_probe()
Date: Tue, 21 Jul 2026 17:22:23 +0200
Message-ID: <20260721152502.118522559@linuxfoundation.org>
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
@@ -1072,12 +1072,14 @@ static int broadsheetfb_probe(struct pla
 	info->flags = FBINFO_VIRTFB;
 
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
@@ -1121,6 +1123,8 @@ err_free_irq:
 	board->cleanup(par);
 err_cmap:
 	fb_dealloc_cmap(&info->cmap);
+err_fbdefio:
+	fb_deferred_io_cleanup(info);
 err_vfree:
 	vfree(videomemory);
 err_fb_rel:


