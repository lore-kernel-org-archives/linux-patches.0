Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BBA3FF1D8;
	Fri, 15 May 2026 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860519; cv=none; b=AMhDNQ3e348c0Dnss1JMctpYYPcEzsXoRFNadU+m8d14E8Srj1KBqJ6tjTwLNc2eJruMrYWUyYfgxiEOkGFBY/8CZ1S7+vnVjbA4WHhBIeQrzVM3EyIvueXIqvkXzmRtSNCC4LCMc4zv0RLpHG5G+DAjFicn2twg0SimJdQKopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860519; c=relaxed/simple;
	bh=cGkDbWum4ghFoFYoHvF541bMLiyBgSMnDuW6rBL//x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa85vvZIC70QwXdktvJ3uKen4S5x+Vb6fKHrgaE6jwcFMwJL0rQeJuWOt6rrJrEscLlcBtflaaDs4NDSAeBdhfdbWorGjooDr5YB9AKIdjlJLy4M9ShI3doA266SduuqGPscFwWFgFvRnSaCeI9hzk/tfDt+mw6e26uoPjFsa1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XD0ns8b6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XD0ns8b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABB0C2BCB3;
	Fri, 15 May 2026 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860518;
	bh=cGkDbWum4ghFoFYoHvF541bMLiyBgSMnDuW6rBL//x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XD0ns8b67BWuR/IO+RZZ3pjptx+pyaQceFwYbjlZ72M/ErDNBe+9fl1WB5yDYdT/1
	 TIAHaJ3Bot3juDOG20w4cWWI4SPuhFQLo5ib/x1lvYqOvFJ+wRMPJjupb/eHFETulr
	 ulKEAgX5wAVMo8jLtGsHNYvaDIAKy3At46qeru8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/144] fbcon: Avoid OOB font access if console rotation fails
Date: Fri, 15 May 2026 17:49:07 +0200
Message-ID: <20260515154656.310918889@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit e4ef723d8975a2694cc90733a6b888a5e2841842 ]

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
[ renamed `par` to `ops` to match the 6.12 local pointer name ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon_rotate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbcon_rotate.c
+++ b/drivers/video/fbdev/core/fbcon_rotate.c
@@ -46,6 +46,10 @@ static int fbcon_rotate_font(struct fb_i
 		info->fbops->fb_sync(info);
 
 	if (ops->fd_size < d_cellsize * len) {
+		kfree(ops->fontbuffer);
+		ops->fontbuffer = NULL;
+		ops->fd_size = 0;
+
 		dst = kmalloc_array(len, d_cellsize, GFP_KERNEL);
 
 		if (dst == NULL) {
@@ -54,7 +58,6 @@ static int fbcon_rotate_font(struct fb_i
 		}
 
 		ops->fd_size = d_cellsize * len;
-		kfree(ops->fontbuffer);
 		ops->fontbuffer = dst;
 	}
 


