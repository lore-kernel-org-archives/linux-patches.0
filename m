Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE01343D64;
	Mon, 18 Aug 2025 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526368; cv=none; b=hCJ8NdNJQ0QSrTeQxj19+08kuHuwlZiVIPU57epXru9Re0rbqxovOQZNPHIxQ0tkRlGflHbfjbefxyM6hLaHOkm+eC4QHIHsuFlQAokY9Yd8XXxt8CMo+q4rdWeVhL+XVT0uW6Er1pS/Rxm8Sk6avjCAFMaV5mBB3HQNWQvmmWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526368; c=relaxed/simple;
	bh=AXHvgtKGPSLJ+NY4dWfJopBXR8lg9e6HH91QCn0W6mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVdnO51dYBv6gwqLgnQWcFv+WTnhU0HkygEonQm/pzbaIYLw0C27xd/4KJb1euuEWUQQ6cn5cTxJjsvmUMjN9EJh8Mn8snJIIfhcdap9KWe1LLZumeeU5/Ax3/Ei8pTB5J9eXEFupdZBWrOFWcqVDSlWzz4rVnaL1M1FhskUmYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALfcPRkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALfcPRkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475BEC4CEEB;
	Mon, 18 Aug 2025 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526368;
	bh=AXHvgtKGPSLJ+NY4dWfJopBXR8lg9e6HH91QCn0W6mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALfcPRkAUgMk373ewDgWzT/2GVMAot+mpVEq2jZvKSnQD4Wlx3xmIDmXhV5+YUw7r
	 lNRO/QFtRrWoV3stGGvUhLK2KkNwjSM5+E4Vfw0OXD3UxtSZJaJUqg5on5SfJ3Gl73
	 XvT6XWHirhv5B2b3lu5cPmA6cHmH81YeKQ6j127c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sravan Kumar Gundu <sravankumarlpu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	syzbot+c4b7aa0513823e2ea880@syzkaller.appspotmail.com
Subject: [PATCH 6.16 535/570] fbdev: Fix vmalloc out-of-bounds write in fast_imageblit
Date: Mon, 18 Aug 2025 14:48:42 +0200
Message-ID: <20250818124526.489513126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -825,7 +825,8 @@ static void con2fb_init_display(struct v
 				   fg_vc->vc_rows);
 	}
 
-	update_screen(vc_cons[fg_console].d);
+	if (fg_console != unit)
+		update_screen(vc_cons[fg_console].d);
 }
 
 /**
@@ -1362,6 +1363,7 @@ static void fbcon_set_disp(struct fb_inf
 	struct vc_data *svc;
 	struct fbcon_ops *ops = info->fbcon_par;
 	int rows, cols;
+	unsigned long ret = 0;
 
 	p = &fb_display[unit];
 
@@ -1412,11 +1414,10 @@ static void fbcon_set_disp(struct fb_inf
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


