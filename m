Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7CD1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7FEC433D2;
	Wed, 28 Dec 2022 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239382;
	bh=bKfpt6h0GlWOpQsLy7N74+aS0RnUo2HirQTk4nM5Xkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnrODgDwMGIuI9wxTsP4dRmEZE8IRI3EE5kAPs5q9KPjb/6Tv1ISRhocbEmgW7pKs
	 P6Cavj9O00WCZuJoUEJVvfFJ3SgtQAgnjPwMPvTTEunGK3yPNIBEcG9NM5hu9Kzjz9
	 2Ujr103RT6r927DE9k2wKPZdGpHxiHvq6GrsZy4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 202/731] drm/fourcc: Add packed 10bit YUV 4:2:0 format
Date: Wed, 28 Dec 2022 15:35:09 +0100
Message-Id: <20221228144302.417521877@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 006ea1b5822f9019bd722ffc6242bc0880879e3d ]

Adds a format that is 3 10bit YUV 4:2:0 samples packed into
a 32bit word (with 2 spare bits).

Supported on Broadcom BCM2711 chips.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20211215091739.135042-2-maxime@cerno.tech
Stable-dep-of: b230555f3257 ("drm/fourcc: Fix vsub/hsub for Q410 and Q401")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fourcc.c  |  3 +++
 include/uapi/drm/drm_fourcc.h | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index eda832f9200d..aa747111476f 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -266,6 +266,9 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		  .num_planes = 3, .char_per_block = { 2, 2, 2 },
 		  .block_w = { 1, 1, 1 }, .block_h = { 1, 1, 1 }, .hsub = 0,
 		  .vsub = 0, .is_yuv = true },
+		{ .format = DRM_FORMAT_P030,            .depth = 0,  .num_planes = 2,
+		  .char_per_block = { 4, 8, 0 }, .block_w = { 3, 3, 0 }, .block_h = { 1, 1, 0 },
+		  .hsub = 2, .vsub = 2, .is_yuv = true},
 	};
 
 	unsigned int i;
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 808c73c52820..a50e4646bd6d 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -308,6 +308,13 @@ extern "C" {
  */
 #define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cr:Cb plane 16 bits per channel */
 
+/* 2 plane YCbCr420.
+ * 3 10 bit components and 2 padding bits packed into 4 bytes.
+ * index 0 = Y plane, [31:0] x:Y2:Y1:Y0 2:10:10:10 little endian
+ * index 1 = Cr:Cb plane, [63:0] x:Cr2:Cb2:Cr1:x:Cb1:Cr0:Cb0 [2:10:10:10:2:10:10:10] little endian
+ */
+#define DRM_FORMAT_P030		fourcc_code('P', '0', '3', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel packed */
+
 /* 3 plane non-subsampled (444) YCbCr
  * 16 bits per component, but only 10 bits are used and 6 bits are padded
  * index 0: Y plane, [15:0] Y:x [10:6] little endian
@@ -842,6 +849,10 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
  * and UV.  Some SAND-using hardware stores UV in a separate tiled
  * image from Y to reduce the column height, which is not supported
  * with these modifiers.
+ *
+ * The DRM_FORMAT_MOD_BROADCOM_SAND128_COL_HEIGHT modifier is also
+ * supported for DRM_FORMAT_P030 where the columns remain as 128 bytes
+ * wide, but as this is a 10 bpp format that translates to 96 pixels.
  */
 
 #define DRM_FORMAT_MOD_BROADCOM_SAND32_COL_HEIGHT(v) \
-- 
2.35.1



