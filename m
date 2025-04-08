Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9531C267B15;
	Tue,  8 Apr 2025 11:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110994; cv=none; b=XWjM6g/QYwrezMU9EG6xfQRowst0wo0eFTBBQVSxp6pB4wdkKzGjSV5hwoky2cEPRwp23QmwDSt3nryxyzfXh9CnZoqh29owitOswEsGPrRKsP13EBm1SKQbkbT1ZTLfnuuhzB3cMLtX1l8ctWjgpT1O6qiYxxgzQpe6jY6ze2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110994; c=relaxed/simple;
	bh=iIPTBeyySwME6tiISeHaT9TUMHFIMR4FqPAEQzx3uKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBIzNoD8Y0e+ckWnWCjAYhpPdg93fzCXUVaeumXUONiI7mxQbNqqpLZZlhzGKslagcOQ/9V2g8sXAHiRcGa2oMPAgyBszJ250khMidI04BH1hXqemXROj/gBT0GFxszRhe5mgwu3xxKrLpp2jGn/0pQ3iKc14ZwExFp2wdxEGHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dmqhmZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dmqhmZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA0FC4CEE5;
	Tue,  8 Apr 2025 11:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110994;
	bh=iIPTBeyySwME6tiISeHaT9TUMHFIMR4FqPAEQzx3uKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dmqhmZSRSoOQSLBGFjpOVECVyHA0eyc7xDoq9RMpEOxKJqEtGRcXGNgn9CmrUTM4
	 vhdWxg17XcsSJnEGo+Wb+Xc7UaWMqWsQ16SEjG5uLRA9Q0W5ytdr0iPSv3XYu5RTbv
	 PN0jyG0nml/etchyVidJcvXp+/7Hn+HS11wppnnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 271/731] drm/ssd130x: ensure ssd132x pitch is correct
Date: Tue,  8 Apr 2025 12:42:48 +0200
Message-ID: <20250408104920.581349259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 4bb663f984ce3..dd2006d51c7a2 100644
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



