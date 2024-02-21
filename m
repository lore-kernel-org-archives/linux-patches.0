Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B57955E5E;
	Wed, 21 Feb 2024 13:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523580; cv=none; b=Kuyj6VpYTTlITf2VcAxzJbz34GlWWDevaJUtxeVWC6NLG1p+v3YEt7ZxJ2tQSJngP+kGKuTZUs5Dgp1DZy4pgqj7uxWLa2LjnosorZFIuzWCOjHZ9sT1Kt1766uLZCm4IZvDu8tfwwoEwQsbx/nYWRQZ/2zknd1y96rYXhUA5D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523580; c=relaxed/simple;
	bh=9HA8aK8k5PJCJe20XN1KcEQuVAVhK7mAKAIu8v5dWQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmbMQZYQASNLKD/DpZAYUBfK6KXH8SG48YNE0Wr6wbz7MZvjhWsdLFWso+z4zymVy9GAoxx+Cq9ynrw7cJCrMYGKIlX+ufi0WM9w3LrXxdkWrqpscR9nozTnpF5OhL4E76qsBoGz9WFr5znc0Ww+5Qqq1hqGQPvIrA9aNZKzzKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6h63yz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6h63yz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697BBC433F1;
	Wed, 21 Feb 2024 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523579;
	bh=9HA8aK8k5PJCJe20XN1KcEQuVAVhK7mAKAIu8v5dWQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6h63yz5VEBEoYsxkC7yWXwE8GKkvmrfy87GioUJQ0GV2LdvDm9ZeePx908dMAIEA
	 zFpiPlpcF38Ig9Tr26+DU5UYEWl2ofYLR87Q0bH43zzDvKq8KulGgHgmxJ3FbAtTxx
	 bgOv8bVDxi6Iy+rTRn6u8UIDC25/obvs6ptxpRYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Miko Larsson <mikoxyzzz@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 451/476] fbdev: Fix invalid page access after closing deferred I/O devices
Date: Wed, 21 Feb 2024 14:08:22 +0100
Message-ID: <20240221130024.699469227@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3efc61d95259956db25347e2a9562c3e54546e20 ]

When a fbdev with deferred I/O is once opened and closed, the dirty
pages still remain queued in the pageref list, and eventually later
those may be processed in the delayed work.  This may lead to a
corruption of pages, hitting an Oops.

This patch makes sure to cancel the delayed work and clean up the
pageref list at closing the device for addressing the bug.  A part of
the cleanup code is factored out as a new helper function that is
called from the common fb_release().

Reviewed-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Miko Larsson <mikoxyzzz@gmail.com>
Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230129082856.22113-1-tiwai@suse.de
Stable-dep-of: 33cd6ea9c067 ("fbdev: flush deferred IO before closing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 10 +++++++++-
 drivers/video/fbdev/core/fbmem.c    |  4 ++++
 include/linux/fb.h                  |  1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index 5faeca61d3dd..b3f41f432ec2 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -292,7 +292,7 @@ void fb_deferred_io_open(struct fb_info *info,
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 
-void fb_deferred_io_cleanup(struct fb_info *info)
+void fb_deferred_io_release(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 	struct page *page;
@@ -306,6 +306,14 @@ void fb_deferred_io_cleanup(struct fb_info *info)
 		page = fb_deferred_io_page(info, i);
 		page->mapping = NULL;
 	}
+}
+EXPORT_SYMBOL_GPL(fb_deferred_io_release);
+
+void fb_deferred_io_cleanup(struct fb_info *info)
+{
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
+	fb_deferred_io_release(info);
 
 	kvfree(info->pagerefs);
 	mutex_destroy(&fbdefio->lock);
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 1b288a613a6e..ec7a883715e3 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1454,6 +1454,10 @@ __releases(&info->lock)
 	struct fb_info * const info = file->private_data;
 
 	lock_fb_info(info);
+#if IS_ENABLED(CONFIG_FB_DEFERRED_IO)
+	if (info->fbdefio)
+		fb_deferred_io_release(info);
+#endif
 	if (info->fbops->fb_release)
 		info->fbops->fb_release(info,1);
 	module_put(info->fbops->owner);
diff --git a/include/linux/fb.h b/include/linux/fb.h
index b322d30f6225..433cddf8442b 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -675,6 +675,7 @@ extern int  fb_deferred_io_init(struct fb_info *info);
 extern void fb_deferred_io_open(struct fb_info *info,
 				struct inode *inode,
 				struct file *file);
+extern void fb_deferred_io_release(struct fb_info *info);
 extern void fb_deferred_io_cleanup(struct fb_info *info);
 extern int fb_deferred_io_fsync(struct file *file, loff_t start,
 				loff_t end, int datasync);
-- 
2.43.0



