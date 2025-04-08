Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F88E267B9C;
	Tue,  8 Apr 2025 12:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114320; cv=none; b=q+5JlszJh1T1T1y/A0GcyNOEBuYx3H6cNTcrYy24cht9KJfg6kyB7ohYxUJVMNC09G4XiwUCGeCLhxUrJtHODUBmD2XcRTJxr6gr8N6K9Kj8s0YoRtGRbg6U0vkcZcxPIGGlP4WIuKDTOHWycwmnOdbUR6hRCMZqHYRIxMaNDOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114320; c=relaxed/simple;
	bh=zKRoEw+DrsspV0Y4M3akEzsEFa6C6SzvkESaC0WNguA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOe9Yt8XiaFZD7BK51VEiPA832DDmjcpzBy4FzmD6LflgoJyXtUtsJUavt19KO0Xcno1lEENSG45xkwJjyMgFuit8KVfapiZgUNuW1AuAKROvJqUWAHAlvYb7rEX97R88NDeqjWjIc2yUxxRI+8rtXEAbl4bnnKGoUOxbLEHBgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQBuXmga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQBuXmga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CA5C4CEE5;
	Tue,  8 Apr 2025 12:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114319;
	bh=zKRoEw+DrsspV0Y4M3akEzsEFa6C6SzvkESaC0WNguA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQBuXmga9vb7J45AdQsxXeBPWPqgxP2HWJ/ofBqvLf0cywdLBYTI/6B2VX2jr3ZuH
	 U7avA6AhOpSySX9GyS4vMcJ9MHlLEsFG6O20C4QTXEoNUzOfVXDBFyv06M36S7uTqZ
	 OPGLBFactXZxj91GAG/lO89xl0KfFMj0KgYhGx1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 063/499] drm/ssd130x: ensure ssd132x pitch is correct
Date: Tue,  8 Apr 2025 12:44:35 +0200
Message-ID: <20250408104852.804686752@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 229adcffdb54b13332d2afd2dc5d203418d50908 ]

The bounding rectangle is adjusted to ensure it aligns to
SSD132X_SEGMENT_WIDTH, which may adjust the pitch.  Calculate the pitch
after aligning the left and right edge.

Fixes: fdd591e00a9c ("drm/ssd130x: Add support for the SSD132x OLED controller family")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250115110139.1672488-3-jkeeping@inmusicbrands.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index 4ceccad91ba0b..8cbfd8af3f15a 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -1038,7 +1038,7 @@ static int ssd132x_fb_blit_rect(struct drm_framebuffer *fb,
 				struct drm_format_conv_state *fmtcnv_state)
 {
 	struct ssd130x_device *ssd130x = drm_to_ssd130x(fb->dev);
-	unsigned int dst_pitch = drm_rect_width(rect);
+	unsigned int dst_pitch;
 	struct iosys_map dst;
 	int ret = 0;
 
@@ -1047,6 +1047,8 @@ static int ssd132x_fb_blit_rect(struct drm_framebuffer *fb,
 	rect->x2 = min_t(unsigned int, round_up(rect->x2, SSD132X_SEGMENT_WIDTH),
 			 ssd130x->width);
 
+	dst_pitch = drm_rect_width(rect);
+
 	ret = drm_gem_fb_begin_cpu_access(fb, DMA_FROM_DEVICE);
 	if (ret)
 		return ret;
-- 
2.39.5



