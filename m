Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C627FD56;
	Wed,  4 Feb 2026 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216527; cv=none; b=lX4gLuJWE8GsVYOGiGMVo5+5Fzl7Pn8gRLnPNDoTziPg8YHniUopS7nMh5KsSm3Oulp/K13c8tU5qzDjxwWj2o0/jI9uVifj4csd225w3Wr4BiEahnltSVnnu3JyPNxFDA9kJd9JD/axKK99bSRkFPm4PdUUjDv8nHcH80AONyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216527; c=relaxed/simple;
	bh=bpm3nLfgkTF7ihDh8jbQgpGlYOaLz/tCl3vgQRwgM5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUhsSgVxR0I/KIBDZ1K2SabBdlNbQnCHiG806WreQhsinWb9KuFvZKrQCAM1cfOC3DqovRoJbuUMkWlIrh36TmLMNMDQdAq7RNmtneonXLzwyurpQ1PzP8YJfqLuPZpHxeiNuu7e1nj97KZD23ZFMkEEfaTvYb6k3ve31FNSMKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ebjv2TOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ebjv2TOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E914C4CEF7;
	Wed,  4 Feb 2026 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216527;
	bh=bpm3nLfgkTF7ihDh8jbQgpGlYOaLz/tCl3vgQRwgM5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ebjv2TOBteXySqI/TiJc3j6/NcLH7T2g20Ik9lELU10msLFcGLRZRdW96VvKblpCS
	 c1Ypxrhv7Qb17xbgr78QNeAk8YtIyAtBTlKLH0KhNodgJeU3iXAI6tOfA8+lxxgCM2
	 2mJV/TuRj4Fu92htSh3IhzasGCBPAnR6tP86oVig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a168dbeaaa7778273c1b@syzkaller.appspotmail.com,
	Shigeru Yoshida <syoshida@redhat.com>,
	Helge Deller <deller@gmx.de>,
	"Barry K. Nathan" <barryn@pobox.com>
Subject: [PATCH 5.10 115/161] fbdev: fbcon: Properly revert changes when vc_resize() failed
Date: Wed,  4 Feb 2026 15:39:38 +0100
Message-ID: <20260204143855.882128016@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

commit a5a923038d70d2d4a86cb4e3f32625a5ee6e7e24 upstream.

fbcon_do_set_font() calls vc_resize() when font size is changed.
However, if if vc_resize() failed, current implementation doesn't
revert changes for font size, and this causes inconsistent state.

syzbot reported unable to handle page fault due to this issue [1].
syzbot's repro uses fault injection which cause failure for memory
allocation, so vc_resize() failed.

This patch fixes this issue by properly revert changes for font
related date when vc_resize() failed.

Link: https://syzkaller.appspot.com/bug?id=3443d3a1fa6d964dd7310a0cb1696d165a3e07c4 [1]
Reported-by: syzbot+a168dbeaaa7778273c1b@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: "Barry K. Nathan" <barryn@pobox.com>
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2424,15 +2424,21 @@ static int fbcon_do_set_font(struct vc_d
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fbcon_display *p = &fb_display[vc->vc_num];
-	int resize;
+	int resize, ret, old_userfont, old_width, old_height, old_charcount;
 	char *old_data = NULL;
 
 	resize = (w != vc->vc_font.width) || (h != vc->vc_font.height);
 	if (p->userfont)
 		old_data = vc->vc_font.data;
 	vc->vc_font.data = (void *)(p->fontdata = data);
+	old_userfont = p->userfont;
 	if ((p->userfont = userfont))
 		REFCOUNT(data)++;
+
+	old_width = vc->vc_font.width;
+	old_height = vc->vc_font.height;
+	old_charcount = vc->vc_font.charcount;
+
 	vc->vc_font.width = w;
 	vc->vc_font.height = h;
 	vc->vc_font.charcount = charcount;
@@ -2448,7 +2454,9 @@ static int fbcon_do_set_font(struct vc_d
 		rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
 		cols /= w;
 		rows /= h;
-		vc_resize(vc, cols, rows);
+		ret = vc_resize(vc, cols, rows);
+		if (ret)
+			goto err_out;
 	} else if (con_is_visible(vc)
 		   && vc->vc_mode == KD_TEXT) {
 		fbcon_clear_margins(vc, 0);
@@ -2458,6 +2466,21 @@ static int fbcon_do_set_font(struct vc_d
 	if (old_data && (--REFCOUNT(old_data) == 0))
 		kfree(old_data - FONT_EXTRA_WORDS * sizeof(int));
 	return 0;
+
+err_out:
+	p->fontdata = old_data;
+	vc->vc_font.data = (void *)old_data;
+
+	if (userfont) {
+		p->userfont = old_userfont;
+		REFCOUNT(data)--;
+	}
+
+	vc->vc_font.width = old_width;
+	vc->vc_font.height = old_height;
+	vc->vc_font.charcount = old_charcount;
+
+	return ret;
 }
 
 /*


