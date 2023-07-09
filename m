Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD8E522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CE9C433C7;
	Sun,  9 Jul 2023 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901925;
	bh=kSwWEuHZH4v7RbCGNvEiW/j4GFuGkz2LIvxEC+cR2x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjL/NgXPbTg2bLGIpEZx4gvEh3IG+HLR8vuyZIU6oSrSkSmkr1Jbul66YMlGxD1OW
	 0ayTgBuwxysrP1VV4hQhrUio2wlyRkcehHZwb70koT0CPuGs8Mcb/j862kREtiQQnt
	 n3aT+XljXiqJDwq5QNSXb7PzTW7HrPTDXB/twhPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Arthur Grillo <arthurgrillo@riseup.net>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mairacanal@riseup.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 194/431] drm/vkms: Fix RGB565 pixel conversion
Date: Sun,  9 Jul 2023 13:12:22 +0200
Message-ID: <20230709111455.723439375@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit ab87f558dcfb2562c3497e89600dec798a446665 ]

Currently, the pixel conversion isn't rounding the fixed-point values
before assigning it to the RGB coefficients, which is causing the IGT
pixel-format tests to fail. So, use the drm_fixp2int_round() fixed-point
helper to round the values when assigning it to the RGB coefficients.

Tested with igt@kms_plane@pixel-format and igt@kms_plane@pixel-format-source-clamping.

[v2]:
    * Use drm_fixp2int_round() to fix the pixel conversion instead of
      casting the values to s32 (Melissa Wen).

Fixes: 89b03aeaef16 ("drm/vkms: fix 32bit compilation error by replacing macros")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Arthur Grillo <arthurgrillo@riseup.net>
Signed-off-by: Maíra Canal <mairacanal@riseup.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20230512104044.65034-2-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_formats.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vkms/vkms_formats.c b/drivers/gpu/drm/vkms/vkms_formats.c
index 8d948c73741ef..b11342026485f 100644
--- a/drivers/gpu/drm/vkms/vkms_formats.c
+++ b/drivers/gpu/drm/vkms/vkms_formats.c
@@ -97,9 +97,9 @@ static void RGB565_to_argb_u16(u8 *src_pixels, struct pixel_argb_u16 *out_pixel)
 	s64 fp_b = drm_int2fixp(rgb_565 & 0x1f);
 
 	out_pixel->a = (u16)0xffff;
-	out_pixel->r = drm_fixp2int(drm_fixp_mul(fp_r, fp_rb_ratio));
-	out_pixel->g = drm_fixp2int(drm_fixp_mul(fp_g, fp_g_ratio));
-	out_pixel->b = drm_fixp2int(drm_fixp_mul(fp_b, fp_rb_ratio));
+	out_pixel->r = drm_fixp2int_round(drm_fixp_mul(fp_r, fp_rb_ratio));
+	out_pixel->g = drm_fixp2int_round(drm_fixp_mul(fp_g, fp_g_ratio));
+	out_pixel->b = drm_fixp2int_round(drm_fixp_mul(fp_b, fp_rb_ratio));
 }
 
 void vkms_compose_row(struct line_buffer *stage_buffer, struct vkms_plane_state *plane, int y)
@@ -216,9 +216,9 @@ static void argb_u16_to_RGB565(struct vkms_frame_info *frame_info,
 		s64 fp_g = drm_int2fixp(in_pixels[x].g);
 		s64 fp_b = drm_int2fixp(in_pixels[x].b);
 
-		u16 r = drm_fixp2int(drm_fixp_div(fp_r, fp_rb_ratio));
-		u16 g = drm_fixp2int(drm_fixp_div(fp_g, fp_g_ratio));
-		u16 b = drm_fixp2int(drm_fixp_div(fp_b, fp_rb_ratio));
+		u16 r = drm_fixp2int_round(drm_fixp_div(fp_r, fp_rb_ratio));
+		u16 g = drm_fixp2int_round(drm_fixp_div(fp_g, fp_g_ratio));
+		u16 b = drm_fixp2int_round(drm_fixp_div(fp_b, fp_rb_ratio));
 
 		*dst_pixels = cpu_to_le16(r << 11 | g << 5 | b);
 	}
-- 
2.39.2



