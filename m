Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6613435200C;
	Thu, 20 Aug 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238191; cv=none; b=WLZ3QRjPtI+X3o6ZKWzfYCJ09UM9fuhQWnExjVe/EmUZQqunK9ey8QtmwNd8LnCPKgD2HCCx6mQPT5ClU8Ag2BQlPg81K8Mo6tlFMmo/FL0RA143KIk1uPjrAXFJxuJRMNEiI5TPthePGjfyiBjlweMAw5LGUR8kUhhSk/RnLrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238191; c=relaxed/simple;
	bh=P64dnKYJ9e+1gbBNEBBrZa3uXS/p0hL81gapQRMW1wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHnNL86sJcrKqW1MnVb4MoeCYxsZjYz9ErbSPCMCeNqlKg7onDchNTG5oB27F4QE2jlVYXAos0zU9IZbycOV0u0wvizliutWLAyZkilp1wuTRDvIx00frRFGBJpV5YM/2Pdzg25qlNImsYgVJZ7+GpXvnlori8c4EqFIBoBIieU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gj5yL22R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gj5yL22R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D8E1F000E9;
	Thu, 20 Aug 2026 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238190;
	bh=s8NR5KhWcAibosI0+3QBdfaI8wL+JPePogEV5yjdIjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gj5yL22RbolZbG6trywEV8JjCT0vBLNpMduZqYffD3r2VSPwamDsAD9lbXCNvDtwv
	 gYh+a4JbLy1wMgQYDSIr8n9Tu54uyJOmBk2Cuo0dOeAWL9Hu00VcFyRd+yVfbQV6Wk
	 yvjPCeLwTZu8rj/TIPUdMJUmmeU/ej1T2rXnYpzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melbin K Mathew <mlbnkm1@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 023/228] fbdev: bound mode sysfs output to the sysfs buffer
Date: Thu, 20 Aug 2026 16:52:45 +0200
Message-ID: <20260820145245.164510740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melbin K Mathew <mlbnkm1@gmail.com>

commit d15d51fb26e830af58f3f21964f1c09c239077ea upstream.

mode_string() uses snprintf() which can return a value larger than the
remaining buffer space. show_modes() accumulates the return value into i
without checking whether i has reached PAGE_SIZE, causing the offset to
advance past the sysfs buffer if the modelist is long enough.

Add a size parameter to mode_string() and use scnprintf() to return
only the bytes actually written. Add an early return when offset
already exceeds the buffer. In show_modes(), stop accumulating once
the buffer is full.

Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbsysfs.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -30,12 +30,15 @@ static int activate(struct fb_info *fb_i
 	return 0;
 }
 
-static int mode_string(char *buf, unsigned int offset,
+static int mode_string(char *buf, size_t size, unsigned int offset,
 		       const struct fb_videomode *mode)
 {
 	char m = 'U';
 	char v = 'p';
 
+	if (offset >= size)
+		return 0;
+
 	if (mode->flag & FB_MODE_IS_DETAILED)
 		m = 'D';
 	if (mode->flag & FB_MODE_IS_VESA)
@@ -48,7 +51,7 @@ static int mode_string(char *buf, unsign
 	if (mode->vmode & FB_VMODE_DOUBLE)
 		v = 'd';
 
-	return snprintf(&buf[offset], PAGE_SIZE - offset, "%c:%dx%d%c-%d\n",
+	return scnprintf(&buf[offset], size - offset, "%c:%dx%d%c-%d\n",
 	                m, mode->xres, mode->yres, v, mode->refresh);
 }
 
@@ -67,7 +70,7 @@ static ssize_t store_mode(struct device
 
 	list_for_each_entry(modelist, &fb_info->modelist, list) {
 		mode = &modelist->mode;
-		i = mode_string(mstr, 0, mode);
+		i = mode_string(mstr, sizeof(mstr), 0, mode);
 		if (strncmp(mstr, buf, max(count, i)) == 0) {
 
 			var = fb_info->var;
@@ -89,7 +92,7 @@ static ssize_t show_mode(struct device *
 	if (!fb_info->mode)
 		return 0;
 
-	return mode_string(buf, 0, fb_info->mode);
+	return mode_string(buf, PAGE_SIZE, 0, fb_info->mode);
 }
 
 static ssize_t store_modes(struct device *device,
@@ -139,7 +142,9 @@ static ssize_t show_modes(struct device
 	i = 0;
 	list_for_each_entry(modelist, &fb_info->modelist, list) {
 		mode = &modelist->mode;
-		i += mode_string(buf, i, mode);
+		i += mode_string(buf, PAGE_SIZE, i, mode);
+		if (i >= PAGE_SIZE - 1)
+			break;
 	}
 	return i;
 }


