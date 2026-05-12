Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE463EDE45;
	Tue, 12 May 2026 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609295; cv=none; b=KRwi6CAy6HzvjCExqbNxehaBVo5DcF8kVWhlZruqKQZ5FdTzXXtWMNY4+k4vzYP8s5j3q0/uktU5TKeM5Zejh8KHMPPLbTiB8vyqZWT3lyK3PJWP7Gz5lkm9CmS74xvlDWIFwQC3EMjYnt/aJ8s4AaZzabcGGstSevr7y0UGR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609295; c=relaxed/simple;
	bh=OC2GBWM7/5aSVMlMapBsG37wnvo+qde+cn+jkHG7CFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nk+VqgfgtrI+he0eK2NHxN7oX4G8jbWPJdnQIU0vq7mTFCPLpqDa0VWV26XDybiCk0AKD3fNfMlrmHZ6n9D8ni4iPwGimuuAkwZvo85LAeWTYe+DZkwgXtXWGoHslmNGOwawo+0CCZz2n+UR8HF5w9hM4d2iFH4m91ttFK/7LSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z030Jfrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z030Jfrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3A4C2BCB0;
	Tue, 12 May 2026 18:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609295;
	bh=OC2GBWM7/5aSVMlMapBsG37wnvo+qde+cn+jkHG7CFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z030JfrvXcmUG8sKv5LDoP7YFIoG3dgDSN/TtB4R3jD5UTfbFP5emjEO32rNpQtGn
	 Q2BgRQRdqW9XrO/W+PcsGaHROggEEdgb3iDZWgo4/nFltsPa+f+llnHtKMoxnas6Cc
	 il81zJZz7peuklbdQ+XE4gSkgTmRM60z0ixAcH5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.0 140/307] fbcon: Avoid OOB font access if console rotation fails
Date: Tue, 12 May 2026 19:38:55 +0200
Message-ID: <20260512173943.082034296@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit e4ef723d8975a2694cc90733a6b888a5e2841842 upstream.

Clear the font buffer if the reallocation during console rotation fails
in fbcon_rotate_font(). The putcs implementations for the rotated buffer
will return early in this case. See [1] for an example.

Currently, fbcon_rotate_font() keeps the old buffer, which is too small
for the rotated font. Printing to the rotated console with a high-enough
character code will overflow the font buffer.

v2:
- fix typos in commit message

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 6cc50e1c5b57 ("[PATCH] fbcon: Console Rotation - Add support to rotate font bitmap")
Cc: stable@vger.kernel.org # v2.6.15+
Link: https://elixir.bootlin.com/linux/v6.19/source/drivers/video/fbdev/core/fbcon_ccw.c#L144 # [1]
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon_rotate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbcon_rotate.c
+++ b/drivers/video/fbdev/core/fbcon_rotate.c
@@ -46,6 +46,10 @@ int fbcon_rotate_font(struct fb_info *in
 		info->fbops->fb_sync(info);
 
 	if (par->fd_size < d_cellsize * len) {
+		kfree(par->fontbuffer);
+		par->fontbuffer = NULL;
+		par->fd_size = 0;
+
 		dst = kmalloc_array(len, d_cellsize, GFP_KERNEL);
 
 		if (dst == NULL) {
@@ -54,7 +58,6 @@ int fbcon_rotate_font(struct fb_info *in
 		}
 
 		par->fd_size = d_cellsize * len;
-		kfree(par->fontbuffer);
 		par->fontbuffer = dst;
 	}
 


