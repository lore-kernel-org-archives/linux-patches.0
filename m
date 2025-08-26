Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B8D1B87E8;
	Tue, 26 Aug 2025 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214838; cv=none; b=fJR5LpUOzY7oeRYllC85ksXZUgmZb9msSAfn1gKUOaJRg6ma4dhjR4CMBHu7MHBIuVJ9FIYuAxTuUUYMb0zP+7HCfpgvZuYIA9UWoF8c/M1jDAuKHqQWQC0nk6RhXdWDY669GjZHdd2QrwB3FSHfVcPXUY1VfnYOWAJIMHnmups=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214838; c=relaxed/simple;
	bh=SbmApaK1G/Fcm2QZJ0K6YJEstH2upefx+uJF1T8ro+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyoIu06Fvzo/2xNK6JCMwN0dLkm6HjjzWAJstnlV6maJ3nA3mg8P6CehuVcCxGRmPFderEagFOV9vfvRjd1NkR+7D7WASlumGL+tSxXlL9aMR0PoBN7DfzlkIiTo5ZnTdChNe/c8dpaCB/Nki4sPIjhElxjp4xp18iJSUK//uUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maAhAf/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maAhAf/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECD8C4CEF1;
	Tue, 26 Aug 2025 13:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214837;
	bh=SbmApaK1G/Fcm2QZJ0K6YJEstH2upefx+uJF1T8ro+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maAhAf/WLUMmksXeDo+1SJPOEpkzK9r063b6c40VS51Tydp0XpN2Gb+0sXx9pIdXC
	 n7HFZWRPr84cAvadI5jsJXz/HwIvdzXyLyDeaBp8FDsWNEwZxkOQRuzol7fi6u2aIP
	 EJKxJJFa/aqzf3BKjTNZTJPoWPmGkf3ZksTH0wD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sravan Kumar Gundu <sravankumarlpu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	syzbot+c4b7aa0513823e2ea880@syzkaller.appspotmail.com
Subject: [PATCH 6.1 257/482] fbdev: Fix vmalloc out-of-bounds write in fast_imageblit
Date: Tue, 26 Aug 2025 13:08:30 +0200
Message-ID: <20250826110937.118509308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sravan Kumar Gundu <sravankumarlpu@gmail.com>

commit af0db3c1f898144846d4c172531a199bb3ca375d upstream.

This issue triggers when a userspace program does an ioctl
FBIOPUT_CON2FBMAP by passing console number and frame buffer number.
Ideally this maps console to frame buffer and updates the screen if
console is visible.

As part of mapping it has to do resize of console according to frame
buffer info. if this resize fails and returns from vc_do_resize() and
continues further. At this point console and new frame buffer are mapped
and sets display vars. Despite failure still it continue to proceed
updating the screen at later stages where vc_data is related to previous
frame buffer and frame buffer info and display vars are mapped to new
frame buffer and eventully leading to out-of-bounds write in
fast_imageblit(). This bheviour is excepted only when fg_console is
equal to requested console which is a visible console and updates screen
with invalid struct references in fbcon_putcs().

Reported-and-tested-by: syzbot+c4b7aa0513823e2ea880@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c4b7aa0513823e2ea880
Signed-off-by: Sravan Kumar Gundu <sravankumarlpu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -808,7 +808,8 @@ static void con2fb_init_display(struct v
 				   fg_vc->vc_rows);
 	}
 
-	update_screen(vc_cons[fg_console].d);
+	if (fg_console != unit)
+		update_screen(vc_cons[fg_console].d);
 }
 
 /**
@@ -1353,6 +1354,7 @@ static void fbcon_set_disp(struct fb_inf
 	struct vc_data *svc;
 	struct fbcon_ops *ops = info->fbcon_par;
 	int rows, cols;
+	unsigned long ret = 0;
 
 	p = &fb_display[unit];
 
@@ -1403,11 +1405,10 @@ static void fbcon_set_disp(struct fb_inf
 	rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
 	cols /= vc->vc_font.width;
 	rows /= vc->vc_font.height;
-	vc_resize(vc, cols, rows);
+	ret = vc_resize(vc, cols, rows);
 
-	if (con_is_visible(vc)) {
+	if (con_is_visible(vc) && !ret)
 		update_screen(vc);
-	}
 }
 
 static __inline__ void ywrap_up(struct vc_data *vc, int count)


