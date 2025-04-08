Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1723E2673B7;
	Tue,  8 Apr 2025 12:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116295; cv=none; b=IZeHWQ3aHh6ofe0vg+JC1Lru3ng9WMWrJB0ktMRHOMQZDWqqEiJnSyI9atqax30yOaKUJQMx7OwcePsFD9LNGG6EgbMy/4OtbXmxhaNTyqbcw+d+tyYKbCp9BRXndMQ9ugGfmizq/ioT/WUp3nXuOrq1te0FfHoLuzK/cDYWT6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116295; c=relaxed/simple;
	bh=1d6t7SmW6P/A1X/7dyHE3M3Js8rfNvlh85pAkgjeams=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LklUO8gSyg1MOY2SlcYuUqAuwTmuxPqoDErrISZEsPvF2BO4HJ7BENXiy1MnS9qKI/ujfVCylpatm8c/sfldHhoxStOTthxtIHN1MZ5kJxR3HpN9jSBfcDJC1761FjTABDKqTGJ+xm1d6hmzK+tmj6SGOI3HI0L4PUcfowqK4mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDFH6W+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDFH6W+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304F9C4CEE7;
	Tue,  8 Apr 2025 12:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116294;
	bh=1d6t7SmW6P/A1X/7dyHE3M3Js8rfNvlh85pAkgjeams=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDFH6W+W7qdp7555JABPHSeqyMV9i9Y4vcY8YEoN/MA11JOhSdzle9HWz0LDmirLi
	 QT20/ujSvDk0gKHOLabl5c56zWwVlOEmGs/Uok06cY34uVnB70jldktc8VfBdfxBl9
	 dsB52VmpuqcXJj2oyyU1hKEujphT7VRhVHB9YmvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/423] drm/ssd130x: ensure ssd132x pitch is correct
Date: Tue,  8 Apr 2025 12:46:16 +0200
Message-ID: <20250408104846.914413091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d071a2f7a460..06f5057690bd8 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -1037,7 +1037,7 @@ static int ssd132x_fb_blit_rect(struct drm_framebuffer *fb,
 				struct drm_format_conv_state *fmtcnv_state)
 {
 	struct ssd130x_device *ssd130x = drm_to_ssd130x(fb->dev);
-	unsigned int dst_pitch = drm_rect_width(rect);
+	unsigned int dst_pitch;
 	struct iosys_map dst;
 	int ret = 0;
 
@@ -1046,6 +1046,8 @@ static int ssd132x_fb_blit_rect(struct drm_framebuffer *fb,
 	rect->x2 = min_t(unsigned int, round_up(rect->x2, SSD132X_SEGMENT_WIDTH),
 			 ssd130x->width);
 
+	dst_pitch = drm_rect_width(rect);
+
 	ret = drm_gem_fb_begin_cpu_access(fb, DMA_FROM_DEVICE);
 	if (ret)
 		return ret;
-- 
2.39.5



