Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBC8181B88;
	Sun,  1 Sep 2024 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207804; cv=none; b=quUfFXfNz0sfNnn7mMkUoWbl1uSXpT2eSCNLTAuRHILpzs71hH3aVUr7Ia4jq/QY7Y2hHLu5T5WbS3PuSGiZeyP0YxB/IlSaYQna/15O3wsTq/9r0d3HAdq2GAtN2xBs30KNMW4TEU4kyEGj85qF5swECaCsT7OgKlaII8RVJ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207804; c=relaxed/simple;
	bh=zccGxrjQkVGCMovawnDP7LSiBm5A1OJL0nF/PqYIXwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naW/kxuB/QLt/DZ4GnT/n9LieeD0es05RafKWz7D4NZvOsOLNJ4WkeIpqarW0nIGpZLsT1UsnoltWSjBeMIKPQvLmPB2/S6AF7XEn2//CaW1jALLo+NxcLuw7hD9JtEoy58S8imzamiiLjV8Q6391gL0JCjUsBG/XnAe0IS+YkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4s6ruB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4s6ruB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC827C4CEC3;
	Sun,  1 Sep 2024 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207804;
	bh=zccGxrjQkVGCMovawnDP7LSiBm5A1OJL0nF/PqYIXwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4s6ruB2wBdUirIbhYjMcwiOYmhktwLip6Yl2J6mdV7Kk2HKxIQVX8FWSy8eQMp8E
	 bkzTKXFoO97u82GWgf7mP7QgGheXO2IDFkaV3O7MXCzXZra3TcbSl+SdOypAmiS9cH
	 jTqIZdMTVfw3fs5O3Z48zMmm/4g5iRXJQ9q87+W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 4.19 82/98] fbcon: Prevent that screen size is smaller than font size
Date: Sun,  1 Sep 2024 18:16:52 +0200
Message-ID: <20240901160806.788654217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream.

We need to prevent that users configure a screen size which is smaller than the
currently selected font size. Otherwise rendering chars on the screen will
access memory outside the graphics memory region.

This patch adds a new function fbcon_modechange_possible() which
implements this check and which later may be extended with other checks
if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
for a too small screen size.

Signed-off-by: Helge Deller <deller@gmx.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |   28 ++++++++++++++++++++++++++++
 drivers/video/fbdev/core/fbmem.c |    9 ++++++---
 include/linux/fbcon.h            |    4 ++++
 3 files changed, 38 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2734,6 +2734,34 @@ static void fbcon_set_all_vcs(struct fb_
 		fbcon_modechanged(info);
 }
 
+/* let fbcon check if it supports a new screen resolution */
+int fbcon_modechange_possible(struct fb_info *info, struct fb_var_screeninfo *var)
+{
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct vc_data *vc;
+	unsigned int i;
+
+	WARN_CONSOLE_UNLOCKED();
+
+	if (!ops)
+		return 0;
+
+	/* prevent setting a screen size which is smaller than font size */
+	for (i = first_fb_vc; i <= last_fb_vc; i++) {
+		vc = vc_cons[i].d;
+		if (!vc || vc->vc_mode != KD_TEXT ||
+			   registered_fb[con2fb_map[i]] != info)
+			continue;
+
+		if (vc->vc_font.width  > FBCON_SWAP(var->rotate, var->xres, var->yres) ||
+		    vc->vc_font.height > FBCON_SWAP(var->rotate, var->yres, var->xres))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fbcon_modechange_possible);
+
 static int fbcon_mode_deleted(struct fb_info *info,
 			      struct fb_videomode *mode)
 {
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1121,9 +1121,12 @@ static long do_fb_ioctl(struct fb_info *
 			console_unlock();
 			return -ENODEV;
 		}
-		info->flags |= FBINFO_MISC_USEREVENT;
-		ret = fb_set_var(info, &var);
-		info->flags &= ~FBINFO_MISC_USEREVENT;
+		ret = fbcon_modechange_possible(info, &var);
+		if (!ret) {
+			info->flags |= FBINFO_MISC_USEREVENT;
+			ret = fb_set_var(info, &var);
+			info->flags &= ~FBINFO_MISC_USEREVENT;
+		}
 		unlock_fb_info(info);
 		console_unlock();
 		if (!ret && copy_to_user(argp, &var, sizeof(var)))
--- a/include/linux/fbcon.h
+++ b/include/linux/fbcon.h
@@ -4,9 +4,13 @@
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE
 void __init fb_console_init(void);
 void __exit fb_console_exit(void);
+int  fbcon_modechange_possible(struct fb_info *info,
+			       struct fb_var_screeninfo *var);
 #else
 static inline void fb_console_init(void) {}
 static inline void fb_console_exit(void) {}
+static inline int  fbcon_modechange_possible(struct fb_info *info,
+				struct fb_var_screeninfo *var) { return 0; }
 #endif
 
 #endif /* _LINUX_FBCON_H */


