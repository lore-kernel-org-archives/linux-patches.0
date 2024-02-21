Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE4B55E5E;
	Wed, 21 Feb 2024 13:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523583; cv=none; b=hj23gd8G8vUBi+wAPhwm74qnwdS7iIEaAH67axpVxSpXfC0cfqnqmlCGZ+l1mJJT1VF/Ul7ogIRZz8U6AZuwUOD1nwYArpRJBYZYZ0GoWufqWCNWIF6pstEdg70H1QsTfTHfBWmVuJxgFpJR7e6wtt2g8vZ49lXYF9Xldcg3T0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523583; c=relaxed/simple;
	bh=gb5dkwkecC5gTVcb9JC2n7E+9nrQFPAHLNMmkU4s8x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnpaP4ELN8IBLeqaiWcS9jTfBH3sxS7rSo48oCO5AxPZQglG0AN3Wz51lE1fSYczikRDOJKyqSd6JdUGRyAGwt3rpbBueigUcTKYrBI0CXn9NXDh5jkwGSUduWaJb9JnHs09Cwsw3CvoItDL1OzvNyzzY18e3ilU8Cl8aN0oC/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPAQ87PX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPAQ87PX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A58BC43394;
	Wed, 21 Feb 2024 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523582;
	bh=gb5dkwkecC5gTVcb9JC2n7E+9nrQFPAHLNMmkU4s8x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPAQ87PXnvxbi5cVTwqliNZziBKTQ6gsl7Oir8TuJDTv/rAVLGoFkE1BIJ6MpL9dW
	 wM12Pc47CsVgztF7HunSPcv/09bdY6BQas+m6obD3CNa+I1efnHu0jriKJoDW4pOag
	 fznU2ovF4lmLCq5UvZ3/VEgmHee/n4/AsT2Hx81c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 452/476] fbdev: Fix incorrect page mapping clearance at fb_deferred_io_release()
Date: Wed, 21 Feb 2024 14:08:23 +0100
Message-ID: <20240221130024.744202577@linuxfoundation.org>
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

[ Upstream commit fe9ae05cfbe587dda724fcf537c00bc2f287da62 ]

The recent fix for the deferred I/O by the commit
  3efc61d95259 ("fbdev: Fix invalid page access after closing deferred I/O devices")
caused a regression when the same fb device is opened/closed while
it's being used.  It resulted in a frozen screen even if something
is redrawn there after the close.  The breakage is because the patch
was made under a wrong assumption of a single open; in the current
code, fb_deferred_io_release() cleans up the page mapping of the
pageref list and it calls cancel_delayed_work_sync() unconditionally,
where both are no correct behavior for multiple opens.

This patch adds a refcount for the opens of the device, and applies
the cleanup only when all files get closed.

As both fb_deferred_io_open() and _close() are called always in the
fb_info lock (mutex), it's safe to use the normal int for the
refcounting.

Also, a useless BUG_ON() is dropped.

Fixes: 3efc61d95259 ("fbdev: Fix invalid page access after closing deferred I/O devices")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230308105012.1845-1-tiwai@suse.de
Stable-dep-of: 33cd6ea9c067 ("fbdev: flush deferred IO before closing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 17 +++++++++++++----
 include/linux/fb.h                  |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index b3f41f432ec2..7e76e53b83d5 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -288,17 +288,18 @@ void fb_deferred_io_open(struct fb_info *info,
 			 struct inode *inode,
 			 struct file *file)
 {
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
 	file->f_mapping->a_ops = &fb_deferred_io_aops;
+	fbdefio->open_count++;
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 
-void fb_deferred_io_release(struct fb_info *info)
+static void fb_deferred_io_lastclose(struct fb_info *info)
 {
-	struct fb_deferred_io *fbdefio = info->fbdefio;
 	struct page *page;
 	int i;
 
-	BUG_ON(!fbdefio);
 	cancel_delayed_work_sync(&info->deferred_work);
 
 	/* clear out the mapping that we setup */
@@ -307,13 +308,21 @@ void fb_deferred_io_release(struct fb_info *info)
 		page->mapping = NULL;
 	}
 }
+
+void fb_deferred_io_release(struct fb_info *info)
+{
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
+	if (!--fbdefio->open_count)
+		fb_deferred_io_lastclose(info);
+}
 EXPORT_SYMBOL_GPL(fb_deferred_io_release);
 
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 
-	fb_deferred_io_release(info);
+	fb_deferred_io_lastclose(info);
 
 	kvfree(info->pagerefs);
 	mutex_destroy(&fbdefio->lock);
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 433cddf8442b..b79a833524ef 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -212,6 +212,7 @@ struct fb_deferred_io {
 	/* delay between mkwrite and deferred handler */
 	unsigned long delay;
 	bool sort_pagereflist; /* sort pagelist by offset */
+	int open_count; /* number of opened files; protected by fb_info lock */
 	struct mutex lock; /* mutex that protects the pageref list */
 	struct list_head pagereflist; /* list of pagerefs for touched pages */
 	/* callback */
-- 
2.43.0



