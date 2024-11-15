Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E6A52F9E;
	Fri, 15 Nov 2024 07:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654047; cv=none; b=hI8thuQ3OPY57o2FNaKmU7302hV0HyyD4i1SHhzal8SNahBfaTcKhLgNQWveCrjIOo8EgW+Rnu8vUbrixPybxr6WOkFVMmJFooCyUKMQ6n5pvzkgy7MIfTDGI8JtOB/mGdFQcxnzUYp1F2fOXAXWwkL4hCHXsZcsP322Sdv2kCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654047; c=relaxed/simple;
	bh=9VX4fUmCyqlcA4Ea0lVieasOomNLqmCUG66SLSAwTpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZmPTz2RVAs7euCZp2kWXT8WMxELDGedfgNoqkT+arELY5+9ttpRiMNjvViN3Sm65M0aFrfEd3QJz0VkoXA2WIX/eNiTaBOn1IK1B4lsd8sxnRP67uCgRlBcRPjSvvXcM1ost+iH5nEFSdCVJlfgl9J9Qlnxa2TXo5XtpifBBS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USmekDv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USmekDv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B273EC4CECF;
	Fri, 15 Nov 2024 07:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654047;
	bh=9VX4fUmCyqlcA4Ea0lVieasOomNLqmCUG66SLSAwTpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USmekDv4Z1+kQ9X7EVmYpaGM3bIhWVCvPdMH24hjjl8+Bs/m38DkdSidd++OZJTXa
	 4B14Yan8AQI6+8bAcvXChwFMjv6kN4eho6PGFZuqXrqLtYDT04QqrogcVH5TBvfRuH
	 0ZMfLI5zBZsoC80ghOBEOTRUTtTNcVFgPOnbsHLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/22] drm/vmwgfx: Limit display layout ioctl array size to VMWGFX_NUM_DISPLAY_UNITS
Date: Fri, 15 Nov 2024 07:38:55 +0100
Message-ID: <20241115063721.511159187@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 28a5dfd4f615539fb22fb6d5c219c199c14e6eb6 ]

Currently the array size is only limited by the largest kmalloc size which
is incorrect. This change will also return a more specific error message
than ENOMEM to userspace.

Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240808200634.1074083-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h | 4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h | 3 ---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 7bb7a69321d30..9c60bb2aefe1f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -59,7 +59,7 @@
 #define VMWGFX_DRIVER_MINOR 19
 #define VMWGFX_DRIVER_PATCHLEVEL 0
 #define VMWGFX_FIFO_STATIC_SIZE (1024*1024)
-#define VMWGFX_MAX_DISPLAYS 16
+#define VMWGFX_NUM_DISPLAY_UNITS 8
 #define VMWGFX_CMD_BOUNCE_INIT_SIZE 32768
 
 #define VMWGFX_PCI_ID_SVGA2              0x0405
@@ -71,7 +71,7 @@
 #define VMWGFX_NUM_GB_CONTEXT 256
 #define VMWGFX_NUM_GB_SHADER 20000
 #define VMWGFX_NUM_GB_SURFACE 32768
-#define VMWGFX_NUM_GB_SCREEN_TARGET VMWGFX_MAX_DISPLAYS
+#define VMWGFX_NUM_GB_SCREEN_TARGET VMWGFX_NUM_DISPLAY_UNITS
 #define VMWGFX_NUM_DXCONTEXT 256
 #define VMWGFX_NUM_DXQUERY 512
 #define VMWGFX_NUM_MOB (VMWGFX_NUM_GB_CONTEXT +\
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 23010d60edfe4..8a9b61920496a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2295,7 +2295,7 @@ int vmw_kms_update_layout_ioctl(struct drm_device *dev, void *data,
 	struct drm_mode_config *mode_config = &dev->mode_config;
 	struct drm_vmw_update_layout_arg *arg =
 		(struct drm_vmw_update_layout_arg *)data;
-	void __user *user_rects;
+	const void __user *user_rects;
 	struct drm_vmw_rect *rects;
 	struct drm_rect *drm_rects;
 	unsigned rects_size;
@@ -2308,6 +2308,8 @@ int vmw_kms_update_layout_ioctl(struct drm_device *dev, void *data,
 			      def_rect.x2, def_rect.y2);
 		vmw_du_update_layout(dev_priv, 1, &def_rect);
 		return 0;
+	} else if (arg->num_outputs > VMWGFX_NUM_DISPLAY_UNITS) {
+		return -E2BIG;
 	}
 
 	rects_size = arg->num_outputs * sizeof(struct drm_vmw_rect);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
index 23c2dc943caf0..85595d0bcfcec 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
@@ -198,9 +198,6 @@ struct vmw_kms_dirty {
 	s32 unit_y2;
 };
 
-#define VMWGFX_NUM_DISPLAY_UNITS 8
-
-
 #define vmw_framebuffer_to_vfb(x) \
 	container_of(x, struct vmw_framebuffer, base)
 #define vmw_framebuffer_to_vfbs(x) \
-- 
2.43.0



