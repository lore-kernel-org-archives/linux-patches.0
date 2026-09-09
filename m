Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F83156E043;
	Wed,  9 Sep 2026 14:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962666; cv=none; b=PxB1cE9otzTdIBPMxYkCfHj5swVROVHSdAdM8OPZ7L4XeGXuy0XCz/4dTiQQMzgkg9WllXmOJIPeJNRuoaf9QlPy1IDkHzHNF3KrLovrp8rNaHCMBup23YBmdIDtBsygdYVyA1JvuKIEzGLKOTAjZ/li+sN0M9rWAIb6LrWUA4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962666; c=relaxed/simple;
	bh=KbqeVb5FTt72GhO/YSw5mc2xxyw+VbIkQ+z9ZCi9KcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bw70d+d15L3fDkjsRkQrog3jUZ5fCV9coaY/IcIvtxNOsKx6+J/zY8NhiLBzhOpBIbIPBsww1kLKBC4OzMKejB8U6eg+xUy8njhyKhQ6Fo80YNzuVKJFctq85+R9CFst8PD6XhFGVfpGvmw0Xib5bdnROT+5KjQebmMWyym/w1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUGMgu4A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUGMgu4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020E11F00A3E;
	Wed,  9 Sep 2026 14:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962665;
	bh=Y7tAUIkG4fEQyLgusG/EIuGPSxwbkGnXOs0HYnUJaLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUGMgu4AiqhB1EKGwNB1TZ4blaB7VkftUtcBNym+Y6ydmCWiddI1dwIdmXKWsfVNC
	 yoGGCfae5zA90eo2XwAlFc4cnSqQZdxfsrSd4P0cyubVFSnxjjSlaydBXCrDSD7IaK
	 xw5G61teL0cqSViBuLumNd/UuHRdLWRB1VhKKxAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 369/556] media: i2c: vd55g1: Fix media bus code initialization
Date: Wed,  9 Sep 2026 15:40:49 +0200
Message-ID: <20260909134243.663945314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Mugnier <benjamin.mugnier@foss.st.com>

commit e4a4f2e3b9bc65e0b82ae8c3a2945955870df36f upstream.

In the driver initialization, the index of the default media bus code
from the supported media bus code array is passed directly to the
vd55g1_get_fmt_code() function instead of the proper media bus code.

This works correctly as a proper media bus code is set after
initialization but could not have been the case. This also resulted in
mutliple "Unsupported mbus format" error messages.

Retrieve the media bus code from the media bus code array, and pass this
media bus code to vd55g1_get_fmt_code() instead of the code index.

Rename VD55G1_MBUS_CODE_DEF to VD55G1_MBUS_CODE_IDX_DEF and
VD55G1_MODE_DEF to VD55G1_MODE_IDX_DEF while at it to avoid future
confusions. Display the guilty error code in warning message.

Cc: stable@vger.kernel.org
Fixes: e138e7f00042 ("media: i2c: vd55g1: Add support for vd65g4 RGB variant")
Signed-off-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/vd55g1.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/media/i2c/vd55g1.c
+++ b/drivers/media/i2c/vd55g1.c
@@ -117,9 +117,8 @@
 
 #define VD55G1_WIDTH					804
 #define VD55G1_HEIGHT					704
-#define VD55G1_MODE_DEF					0
+#define VD55G1_MODE_IDX_DEF				0
 #define VD55G1_NB_GPIOS					4
-#define VD55G1_MBUS_CODE_DEF				0
 #define VD55G1_DGAIN_DEF				256
 #define VD55G1_AGAIN_DEF				19
 #define VD55G1_EXPO_MAX_TERM				64
@@ -637,7 +636,7 @@ static u32 vd55g1_get_fmt_code(struct vd
 				goto adapt_bayer_pattern;
 		}
 	}
-	dev_warn(sensor->dev, "Unsupported mbus format\n");
+	dev_warn(sensor->dev, "Unsupported mbus format: 0x%x\n", code);
 
 	return code;
 
@@ -1357,6 +1356,7 @@ static int vd55g1_init_state(struct v4l2
 {
 	struct vd55g1 *sensor = to_vd55g1(sd);
 	struct v4l2_subdev_format fmt = { 0 };
+	int code;
 	struct v4l2_subdev_route routes[] = {
 		{ .flags = V4L2_SUBDEV_ROUTE_FL_ACTIVE }
 	};
@@ -1371,9 +1371,13 @@ static int vd55g1_init_state(struct v4l2
 	if (ret)
 		return ret;
 
-	vd55g1_update_pad_fmt(sensor, &vd55g1_supported_modes[VD55G1_MODE_DEF],
-			      vd55g1_get_fmt_code(sensor, VD55G1_MBUS_CODE_DEF),
-			      &fmt.format);
+	if (sensor->id == VD55G1_MODEL_ID_VD55G1)
+		code = vd55g1_mbus_formats_mono[0];
+	else
+		code = vd55g1_mbus_formats_bayer[0][0];
+	vd55g1_update_pad_fmt(sensor,
+			      &vd55g1_supported_modes[VD55G1_MODE_IDX_DEF],
+			      vd55g1_get_fmt_code(sensor, code), &fmt.format);
 
 	return vd55g1_set_pad_fmt(sd, sd_state, &fmt);
 }


