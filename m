Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5F03C1967;
	Thu, 15 Jan 2026 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499868; cv=none; b=K9T5Uhm0vI0thlc6P/xYiqCEqUuQj5MOFNFwBzlTgh80BYqjBapckkT7K6wp4UsYmTqPtwniV5FxZjsW8e7VARaOH5GnI/zrYylTS3GAUMy6prsM5vGoO5hLFnCDeMxbgbGLq/LFWqCAk0nsKkQ+/zo95cjF574ecm2/06rd1sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499868; c=relaxed/simple;
	bh=2JLNUkxfEgLZE3omG69Thj2LjL6MZV28a9X8Tg8ROVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oP+pRLCxjKJV6PUl/GWM0a5e8YQVCxk9ycRatQOq11114UUz83L7dhW1fGSakxLigLBhjK+CwW+jZQIrwfyRdvSaUFwMOZigPqgK7UfuK/KFOjk+PgdbGC8LQKMpWx/xaCzPqOo1lQ/QV8WEiMjhC+NggRLUp7g5Dvnhx9tErJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pp0m08X9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pp0m08X9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11505C116D0;
	Thu, 15 Jan 2026 17:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499868;
	bh=2JLNUkxfEgLZE3omG69Thj2LjL6MZV28a9X8Tg8ROVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pp0m08X9gP/wfe84sn5O2BaB74W1+wP1CDS31X1S/fJ8P94rs/aX0WeYmW+pwGTkF
	 Wi6BJytjqzePC/Z1PKPtaAC6qRtx8qO4w6+Rvc6gpVQl5jEIi+9oqGH/vNL5Ah43zt
	 AjjYsfb1bUMJ3VNQ15wA7lLrL6eOt76HDAN4iJgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel@ffwll.ch>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 344/451] fbcon: Avoid using FNTCHARCNT() and hard-coded built-in font charcount
Date: Thu, 15 Jan 2026 17:49:05 +0100
Message-ID: <20260115164243.339326137@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peilin Ye <yepeilin.cs@gmail.com>

commit a1ac250a82a5e97db71f14101ff7468291a6aaef upstream.

For user-provided fonts, the framebuffer layer is using a magic
negative-indexing macro, FNTCHARCNT(), to keep track of their number of
characters:

	#define FNTCHARCNT(fd)	(((int *)(fd))[-3])

For built-in fonts, it is using hard-coded values (256). This results in
something like the following:

		map.length = (ops->p->userfont) ?
			FNTCHARCNT(ops->p->fontdata) : 256;

This is unsatisfactory. In fact, there is already a `charcount` field in
our virtual console descriptor (see `struct console_font` inside `struct
vc_data`), let us use it:

		map.length = vc->vc_font.charcount;

Recently we added a `charcount` field to `struct font_desc`. Use it to set
`vc->vc_font.charcount` properly. The idea is:

  - We only use FNTCHARCNT() on `vc->vc_font.data` and `p->fontdata`.
    Assume FNTCHARCNT() is working as intended;
  - Whenever `vc->vc_font.data` is set, also set `vc->vc_font.charcount`
    properly;
  - We can now replace `FNTCHARCNT(vc->vc_font.data)` with
    `vc->vc_font.charcount`;
  - Since `p->fontdata` always point to the same font data buffer with
    `vc->vc_font.data`, we can also replace `FNTCHARCNT(p->fontdata)` with
    `vc->vc_font.charcount`.

In conclusion, set `vc->vc_font.charcount` properly in fbcon_startup(),
fbcon_init(), fbcon_set_disp() and fbcon_do_set_font(), then replace
FNTCHARCNT() with `vc->vc_font.charcount`. No more if-else between
negative-indexing macros and hard-coded values.

Do not include <linux/font.h> in fbcon_rotate.c and tileblit.c, since they
no longer need it.

Depends on patch "Fonts: Add charcount field to font_desc".

Suggested-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/e460a5780e54e3022661d5f09555144583b4cc59.1605169912.git.yepeilin.cs@gmail.com
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c        |   57 +++++++++++---------------------
 drivers/video/fbdev/core/fbcon_rotate.c |    3 -
 drivers/video/fbdev/core/tileblit.c     |    4 --
 3 files changed, 23 insertions(+), 41 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1006,7 +1006,7 @@ static const char *fbcon_startup(void)
 		vc->vc_font.width = font->width;
 		vc->vc_font.height = font->height;
 		vc->vc_font.data = (void *)(p->fontdata = font->data);
-		vc->vc_font.charcount = 256; /* FIXME  Need to support more fonts */
+		vc->vc_font.charcount = font->charcount;
 	} else {
 		p->fontdata = vc->vc_font.data;
 	}
@@ -1034,7 +1034,7 @@ static void fbcon_init(struct vc_data *v
 	struct vc_data **default_mode = vc->vc_display_fg;
 	struct vc_data *svc = *default_mode;
 	struct fbcon_display *t, *p = &fb_display[vc->vc_num];
-	int logo = 1, new_rows, new_cols, rows, cols, charcnt = 256;
+	int logo = 1, new_rows, new_cols, rows, cols;
 	int cap, ret;
 
 	if (WARN_ON(info_idx == -1))
@@ -1070,6 +1070,7 @@ static void fbcon_init(struct vc_data *v
 						    fvc->vc_font.data);
 			vc->vc_font.width = fvc->vc_font.width;
 			vc->vc_font.height = fvc->vc_font.height;
+			vc->vc_font.charcount = fvc->vc_font.charcount;
 			p->userfont = t->userfont;
 
 			if (p->userfont)
@@ -1085,17 +1086,13 @@ static void fbcon_init(struct vc_data *v
 			vc->vc_font.width = font->width;
 			vc->vc_font.height = font->height;
 			vc->vc_font.data = (void *)(p->fontdata = font->data);
-			vc->vc_font.charcount = 256; /* FIXME  Need to
-							support more fonts */
+			vc->vc_font.charcount = font->charcount;
 		}
 	}
 
-	if (p->userfont)
-		charcnt = FNTCHARCNT(p->fontdata);
-
 	vc->vc_can_do_color = (fb_get_color_depth(&info->var, &info->fix)!=1);
 	vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
-	if (charcnt == 256) {
+	if (vc->vc_font.charcount == 256) {
 		vc->vc_hi_font_mask = 0;
 	} else {
 		vc->vc_hi_font_mask = 0x100;
@@ -1367,7 +1364,7 @@ static void fbcon_set_disp(struct fb_inf
 	struct vc_data **default_mode, *vc;
 	struct vc_data *svc;
 	struct fbcon_ops *ops = info->fbcon_par;
-	int rows, cols, charcnt = 256;
+	int rows, cols;
 
 	p = &fb_display[unit];
 
@@ -1387,12 +1384,11 @@ static void fbcon_set_disp(struct fb_inf
 		vc->vc_font.data = (void *)(p->fontdata = t->fontdata);
 		vc->vc_font.width = (*default_mode)->vc_font.width;
 		vc->vc_font.height = (*default_mode)->vc_font.height;
+		vc->vc_font.charcount = (*default_mode)->vc_font.charcount;
 		p->userfont = t->userfont;
 		if (p->userfont)
 			REFCOUNT(p->fontdata)++;
 	}
-	if (p->userfont)
-		charcnt = FNTCHARCNT(p->fontdata);
 
 	var->activate = FB_ACTIVATE_NOW;
 	info->var.activate = var->activate;
@@ -1402,7 +1398,7 @@ static void fbcon_set_disp(struct fb_inf
 	ops->var = info->var;
 	vc->vc_can_do_color = (fb_get_color_depth(&info->var, &info->fix)!=1);
 	vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
-	if (charcnt == 256) {
+	if (vc->vc_font.charcount == 256) {
 		vc->vc_hi_font_mask = 0;
 	} else {
 		vc->vc_hi_font_mask = 0x100;
@@ -2047,7 +2043,7 @@ static int fbcon_resize(struct vc_data *
 		 */
 		if (pitch <= 0)
 			return -EINVAL;
-		size = CALC_FONTSZ(vc->vc_font.height, pitch, FNTCHARCNT(vc->vc_font.data));
+		size = CALC_FONTSZ(vc->vc_font.height, pitch, vc->vc_font.charcount);
 		if (size > FNTSIZE(vc->vc_font.data))
 			return -EINVAL;
 	}
@@ -2095,7 +2091,7 @@ static int fbcon_switch(struct vc_data *
 	struct fbcon_ops *ops;
 	struct fbcon_display *p = &fb_display[vc->vc_num];
 	struct fb_var_screeninfo var;
-	int i, ret, prev_console, charcnt = 256;
+	int i, ret, prev_console;
 
 	info = registered_fb[con2fb_map[vc->vc_num]];
 	ops = info->fbcon_par;
@@ -2172,10 +2168,7 @@ static int fbcon_switch(struct vc_data *
 	vc->vc_can_do_color = (fb_get_color_depth(&info->var, &info->fix)!=1);
 	vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
 
-	if (p->userfont)
-		charcnt = FNTCHARCNT(vc->vc_font.data);
-
-	if (charcnt > 256)
+	if (vc->vc_font.charcount > 256)
 		vc->vc_complement_mask <<= 1;
 
 	updatescrollmode(p, info, vc);
@@ -2425,31 +2418,27 @@ static void set_vc_hi_font(struct vc_dat
 	}
 }
 
-static int fbcon_do_set_font(struct vc_data *vc, int w, int h,
+static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 			     const u8 * data, int userfont)
 {
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fbcon_display *p = &fb_display[vc->vc_num];
 	int resize;
-	int cnt;
 	char *old_data = NULL;
 
 	resize = (w != vc->vc_font.width) || (h != vc->vc_font.height);
 	if (p->userfont)
 		old_data = vc->vc_font.data;
-	if (userfont)
-		cnt = FNTCHARCNT(data);
-	else
-		cnt = 256;
 	vc->vc_font.data = (void *)(p->fontdata = data);
 	if ((p->userfont = userfont))
 		REFCOUNT(data)++;
 	vc->vc_font.width = w;
 	vc->vc_font.height = h;
-	if (vc->vc_hi_font_mask && cnt == 256)
+	vc->vc_font.charcount = charcount;
+	if (vc->vc_hi_font_mask && charcount == 256)
 		set_vc_hi_font(vc, false);
-	else if (!vc->vc_hi_font_mask && cnt == 512)
+	else if (!vc->vc_hi_font_mask && charcount == 512)
 		set_vc_hi_font(vc, true);
 
 	if (resize) {
@@ -2531,9 +2520,10 @@ static int fbcon_set_font(struct vc_data
 	if (!new_data)
 		return -ENOMEM;
 
+	memset(new_data, 0, FONT_EXTRA_WORDS * sizeof(int));
+
 	new_data += FONT_EXTRA_WORDS * sizeof(int);
 	FNTSIZE(new_data) = size;
-	FNTCHARCNT(new_data) = charcount;
 	REFCOUNT(new_data) = 0;	/* usage counter */
 	for (i=0; i< charcount; i++) {
 		memcpy(new_data + i*h*pitch, data +  i*32*pitch, h*pitch);
@@ -2559,7 +2549,7 @@ static int fbcon_set_font(struct vc_data
 			break;
 		}
 	}
-	return fbcon_do_set_font(vc, font->width, font->height, new_data, 1);
+	return fbcon_do_set_font(vc, font->width, font->height, charcount, new_data, 1);
 }
 
 static int fbcon_set_def_font(struct vc_data *vc, struct console_font *font, char *name)
@@ -2575,7 +2565,7 @@ static int fbcon_set_def_font(struct vc_
 
 	font->width = f->width;
 	font->height = f->height;
-	return fbcon_do_set_font(vc, f->width, f->height, f->data, 0);
+	return fbcon_do_set_font(vc, f->width, f->height, f->charcount, f->data, 0);
 }
 
 static u16 palette_red[16];
@@ -3072,7 +3062,6 @@ void fbcon_get_requirement(struct fb_inf
 			   struct fb_blit_caps *caps)
 {
 	struct vc_data *vc;
-	struct fbcon_display *p;
 
 	if (caps->flags) {
 		int i, charcnt;
@@ -3081,11 +3070,9 @@ void fbcon_get_requirement(struct fb_inf
 			vc = vc_cons[i].d;
 			if (vc && vc->vc_mode == KD_TEXT &&
 			    info->node == con2fb_map[i]) {
-				p = &fb_display[i];
 				caps->x |= 1 << (vc->vc_font.width - 1);
 				caps->y |= 1 << (vc->vc_font.height - 1);
-				charcnt = (p->userfont) ?
-					FNTCHARCNT(p->fontdata) : 256;
+				charcnt = vc->vc_font.charcount;
 				if (caps->len < charcnt)
 					caps->len = charcnt;
 			}
@@ -3095,11 +3082,9 @@ void fbcon_get_requirement(struct fb_inf
 
 		if (vc && vc->vc_mode == KD_TEXT &&
 		    info->node == con2fb_map[fg_console]) {
-			p = &fb_display[fg_console];
 			caps->x = 1 << (vc->vc_font.width - 1);
 			caps->y = 1 << (vc->vc_font.height - 1);
-			caps->len = (p->userfont) ?
-				FNTCHARCNT(p->fontdata) : 256;
+			caps->len = vc->vc_font.charcount;
 		}
 	}
 }
--- a/drivers/video/fbdev/core/fbcon_rotate.c
+++ b/drivers/video/fbdev/core/fbcon_rotate.c
@@ -14,7 +14,6 @@
 #include <linux/fb.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
-#include <linux/font.h>
 #include <asm/types.h>
 #include "fbcon.h"
 #include "fbcon_rotate.h"
@@ -33,7 +32,7 @@ static int fbcon_rotate_font(struct fb_i
 
 	src = ops->fontdata = vc->vc_font.data;
 	ops->cur_rotate = ops->p->con_rotate;
-	len = (!ops->p->userfont) ? 256 : FNTCHARCNT(src);
+	len = vc->vc_font.charcount;
 	s_cellsize = ((vc->vc_font.width + 7)/8) *
 		vc->vc_font.height;
 	d_cellsize = s_cellsize;
--- a/drivers/video/fbdev/core/tileblit.c
+++ b/drivers/video/fbdev/core/tileblit.c
@@ -13,7 +13,6 @@
 #include <linux/fb.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
-#include <linux/font.h>
 #include <asm/types.h>
 #include "fbcon.h"
 
@@ -178,8 +177,7 @@ void fbcon_set_tileops(struct vc_data *v
 		map.width = vc->vc_font.width;
 		map.height = vc->vc_font.height;
 		map.depth = 1;
-		map.length = (ops->p->userfont) ?
-			FNTCHARCNT(ops->p->fontdata) : 256;
+		map.length = vc->vc_font.charcount;
 		map.data = ops->p->fontdata;
 		info->tileops->fb_settile(info, &map);
 	}


