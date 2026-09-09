Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D51D576ED8;
	Wed,  9 Sep 2026 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964391; cv=none; b=SFvyyatSkBsuzcQRJOgWjBvF6j/8faC1rxP8yhGElOoblWbSDPu/TSoK5V2yUB1b0jXp+u1lyA1aExb75zkZ952/KtOo0gI0mUTYuOMzzk2RNX1DYGK9H0MkctrKZPesoC4sWrWEAWs9y5KFu6oMTn8BYO7diT1k9xE88TYHqO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964391; c=relaxed/simple;
	bh=+JTi9Ealuel80jirkdnARgK7WquvB3ovFRkJNdYR/u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bluFOPCuaa2gBr7xwMmQfLoDmCKk8yXyC0IOjp+sDVEMG/8UlzcY8lf4mC1G8eHB/W2lsIICpRmN+1xW3ibRGGpGAtr0roqkOmQ9SpGRCpcOfBX5Hfp9WSlxs7mE9gVYndwjPO3GrC6AXMceNIyb2SJ6EOUmgOwgljVh6BtiOmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxVgnyZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxVgnyZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B331F00A3A;
	Wed,  9 Sep 2026 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964390;
	bh=a3DrK2yzUEndFXROXVBEgCZ/4x92QXIWorFM6OrUc9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxVgnyZkr378ETjU9ks43IQKVsYeIinuGeT41iXVnOSsbtXIV/MBXyzamkMv4Bmip
	 YOIjXIHFtYwzPoK0hpuNXtbCgJJI5Y1M/+XINihGi9YeFMOFlHMrPMLxWDFt30NkCa
	 YLuRGHJfHvh7dQopc+oFDJshAQulWVSYkjU/3Uw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.18 407/583] drm/sysfb: ofdrm: Fix integer overflow in fb_size calculation
Date: Wed,  9 Sep 2026 15:41:32 +0200
Message-ID: <20260909134252.086499650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

commit c6f48e59ece0123f6a11527ad4d89b21c2d65b87 upstream.

The framebuffer size calculation `fb_size = linebytes * height` can
overflow when both values are large (e.g., 46341 * 46341 > INT_MAX).
Since linebytes and height are both int types, the multiplication is
performed as int * int, which results in undefined behavior on overflow.

Use check_mul_overflow() to detect and prevent this overflow, consistent
with the approach used in simpledrm.c and corebootdrm.c.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: c8a17756c425 ("drm/ofdrm: Add ofdrm for Open Firmware framebuffers")
Cc: <stable@vger.kernel.org> # v6.2+
Link: https://patch.msgid.link/20260825104134.669676-1-oushixiong1025@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/ofdrm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/sysfb/ofdrm.c
+++ b/drivers/gpu/drm/sysfb/ofdrm.c
@@ -2,6 +2,7 @@
 
 #include <linux/aperture.h>
 #include <linux/of_address.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 
@@ -910,7 +911,10 @@ static struct ofdrm_device *ofdrm_device
 			return ERR_PTR(-EINVAL);
 	}
 
-	fb_size = linebytes * height;
+	if (check_mul_overflow(linebytes, height, &fb_size)) {
+		drm_err(dev, "framebuffer size exceeds maximum\n");
+		return ERR_PTR(-EINVAL);
+	}
 
 	/*
 	 * Try to figure out the address of the framebuffer. Unfortunately, Open


