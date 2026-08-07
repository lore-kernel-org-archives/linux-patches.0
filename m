Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B321333C1AD;
	Fri,  7 Aug 2026 15:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115614; cv=none; b=GXBwgSdXiW0v5udvP7V8o4ttt0j1WQ+7ehHKPHZyHlIwykGLvV0pp0RpzbYgIngbHUBIpi1hGRk012KU8JahltcCK1hpBQ1uJ8XJNq8kxmcWAdai5FgiwueHEwwR/aKiSHLqW5k7Hxe6CtvWE/ekQp7zdcCALooDPh/4Is5S0v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115614; c=relaxed/simple;
	bh=VoXzhB8uFlcobou5vUOTChPoBfWcRr58PSNPbGNWHZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjLjoJI4sUNW5MdwobuJB2qaXNaWy2dVhnm1RpAhv90W4FYuQtrAApaia7E59j6gUtzAnj9qYdR2YyuGwhOpLVDV8SHCR85s4KYlT0lanXMfSjLhlZw0QF5rIGxECZmYf84AAufGENAk4yFWEJ6LtRKIVmWKMWDcdoAD3fsSlaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7XSZ3oC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7XSZ3oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199D51F00A3A;
	Fri,  7 Aug 2026 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115613;
	bh=7stJV/c/rQI03VK5hGzpwts3vMGCryn58MHqUqzCaeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7XSZ3oCOZ3nL6J5RD4mDFCi6uDeDKvBD7058n3Fldbdr7NNxBzLK37ueESpO20AL
	 DmCVRo9vL534CpWtsfyFpz4g4pNDhIWmbiLCtOjHrHyS1bRHfCsFRaa1NNZWgGNKrW
	 cV0bUMhdBfWO4UPJBJk9RXTRBQl6aAqycGsHuXOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.18 339/396] drm/vmwgfx: use check_add_overflow for shader size+offset bound
Date: Fri,  7 Aug 2026 16:38:19 +0200
Message-ID: <20260807143431.598897708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Zack Rusin <zack.rusin@broadcom.com>

commit 54d56d5b42d2e4c72ba6e365e9774da90698aa22 upstream.

vmw_shader_define() validates the user-supplied shader window against
its backing buffer with

	(u64)buffer->tbo.base.size < (u64)size + (u64)offset

drm_vmw_shader_create_arg::offset is __u64 in the uapi; when it is
near U64_MAX the unsigned addition wraps and the resulting tiny value
passes the check.  The unbounded offset is then stored in
res->guest_memory_offset and forwarded to host SVGA shader-create
commands.

Use check_add_overflow() to detect the wrap and compare the resulting
endpoint against the buffer size.

Fixes: 668b206601c5 ("drm/vmwgfx: Stop using raw ttm_buffer_object's")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-12-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -25,6 +25,8 @@
  *
  **************************************************************************/
 
+#include <linux/overflow.h>
+
 #include <drm/ttm/ttm_placement.h>
 
 #include "vmwgfx_binding.h"
@@ -685,7 +687,7 @@ int vmw_shader_destroy_ioctl(struct drm_
 static int vmw_user_shader_alloc(struct vmw_private *dev_priv,
 				 struct vmw_bo *buffer,
 				 size_t shader_size,
-				 size_t offset,
+				 u64 offset,
 				 SVGA3dShaderType shader_type,
 				 uint8_t num_input_sig,
 				 uint8_t num_output_sig,
@@ -739,7 +741,7 @@ out:
 static struct vmw_resource *vmw_shader_alloc(struct vmw_private *dev_priv,
 					     struct vmw_bo *buffer,
 					     size_t shader_size,
-					     size_t offset,
+					     u64 offset,
 					     SVGA3dShaderType shader_type)
 {
 	struct vmw_shader *shader;
@@ -768,7 +770,7 @@ out_err:
 
 static int vmw_shader_define(struct drm_device *dev, struct drm_file *file_priv,
 			     enum drm_vmw_shader_type shader_type_drm,
-			     u32 buffer_handle, size_t size, size_t offset,
+			     u32 buffer_handle, size_t size, u64 offset,
 			     uint8_t num_input_sig, uint8_t num_output_sig,
 			     uint32_t *shader_handle)
 {
@@ -779,13 +781,16 @@ static int vmw_shader_define(struct drm_
 	int ret;
 
 	if (buffer_handle != SVGA3D_INVALID_ID) {
+		u64 end;
+
 		ret = vmw_user_bo_lookup(file_priv, buffer_handle, &buffer);
 		if (unlikely(ret != 0)) {
 			VMW_DEBUG_USER("Couldn't find buffer for shader creation.\n");
 			return ret;
 		}
 
-		if ((u64)buffer->tbo.base.size < (u64)size + (u64)offset) {
+		if (check_add_overflow((u64)size, (u64)offset, &end) ||
+		    end > buffer->tbo.base.size) {
 			VMW_DEBUG_USER("Illegal buffer- or shader size.\n");
 			ret = -EINVAL;
 			goto out_bad_arg;


