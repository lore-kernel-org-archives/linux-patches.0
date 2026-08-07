Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DD2474275;
	Fri,  7 Aug 2026 15:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116360; cv=none; b=R3D4k0NM9GcF5PXYcZJ4hG2a757ONRv6I4mOGTQQVRn7nzWSoWy2mI7COBg1AaNNn87T2je/P4jIXezyLyIVuFHmykj9/DxUL66SVux8VVA9jfa3cJZFXXgio/b0Qp5uQEPujMOHxIQ1j5NQKPfE/vFh3uHLgudLWexVld2RXXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116360; c=relaxed/simple;
	bh=kJ1RePxFWvXvDdX+PbtqMO2vVKbTmkFTd+QJ76+Sx/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqwwRPbnAYOnBrZGxMWsbEwzCWTtZuea5KdeiK6k4gLazm+14WV4j0Imnm7VP2ImIhUHjae1QD262/d33zECV5MZ4F6vM+C7f5bcPoNsQmd6F5T7+DzB239WGRKzcQAzQOzvAbxMGlBtZ5wKMROw3IupQfMEs1aWy7/aWDHNs74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcN/Aj+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcN/Aj+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55631F000E9;
	Fri,  7 Aug 2026 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116359;
	bh=F2JAZU98+t+l83UDVufrg0PV1Z0NU8xcGgfuroeP0o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcN/Aj+YFNLvqHeev6CBNNiV2RpIv20M10sxewXneMLrjQQJu5c597ePe+lfk8eDQ
	 phRWn/5o7qn1txuXby65XkkCNhegC+Fp7DM1XRePifukn78yyAw16ldRPoliWXtIfL
	 npvTN6POjtNc+iDYDuDbUBbYy5ycACfj1u4M9vIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.6 202/261] drm/vmwgfx: use check_add_overflow for shader size+offset bound
Date: Fri,  7 Aug 2026 16:39:19 +0200
Message-ID: <20260807143419.723250149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


