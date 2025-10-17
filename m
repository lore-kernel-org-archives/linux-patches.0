Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B93C33711F;
	Fri, 17 Oct 2025 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715067; cv=none; b=PkxQK6eRnLygXG/CXek80sv3b/Qn2NMJzZQJHpkcQeI3LqOFIoqBvbasIV3XwUC26GaNox26mM9yr3qeotuh+PeE2IVOGsdLOD+UY9oKYUATc5VLOQ2FnZ6VXzA/I+r/gIz72+QlBV74d0m6UcjuulfxCAX6eQSuz2sHNipVYnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715067; c=relaxed/simple;
	bh=8MB0VEECLqUOz874kLsTLnzq23KMQ1l3ZOQ1jFCWMxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pe1l4w3ENxsCAXy3fifx9yS3uATLrkBC6beI3RcA3v7/FHYBEIeFhvT9sgtY4j4OnsrXlDIO47GMZdLDUgI1qlqyKX2omIrEDLsETF1/swBfuonaUdkvhPBX2Jva8DbN7iYCJezYypvudxCXbBTqF22ovvwJGwiC1Y0vPzpX4XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQzaeh3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQzaeh3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C08C4CEFE;
	Fri, 17 Oct 2025 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715067;
	bh=8MB0VEECLqUOz874kLsTLnzq23KMQ1l3ZOQ1jFCWMxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQzaeh3OjPecv0VfE3ITZ3IFFpAGvMh3sBuWE5lzuA8c45QlQbrPhSQSScCKmRm3C
	 qE46k8nsEaVFsQWHbVlf5bK9gtUG9kSHbdzYHoOOzNforZbfdvaPaPnagbCx70AyO4
	 y4ot7VMML3FXbmiVFEDKVtSGQESgBMDkQ1ASgEVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Ian Forbes <ian.forbes@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 085/371] drm/vmwgfx: Fix a null-ptr access in the cursor snooper
Date: Fri, 17 Oct 2025 16:51:00 +0200
Message-ID: <20251017145205.014199888@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit 5ac2c0279053a2c5265d46903432fb26ae2d0da2 ]

Check that the resource which is converted to a surface exists before
trying to use the cursor snooper on it.

vmw_cmd_res_check allows explicit invalid (SVGA3D_INVALID_ID) identifiers
because some svga commands accept SVGA3D_INVALID_ID to mean "no surface",
unfortunately functions that accept the actual surfaces as objects might
(and in case of the cursor snooper, do not) be able to handle null
objects. Make sure that we validate not only the identifier (via the
vmw_cmd_res_check) but also check that the actual resource exists before
trying to do something with it.

Fixes unchecked null-ptr reference in the snooping code.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: c0951b797e7d ("drm/vmwgfx: Refactor resource management")
Reported-by: Kuzey Arda Bulut <kuzeyardabulut@gmail.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://lore.kernel.org/r/20250917153655.1968583-1-zack.rusin@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 819704ac675d0..d539f25b5fbe0 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1497,6 +1497,7 @@ static int vmw_cmd_dma(struct vmw_private *dev_priv,
 		       SVGA3dCmdHeader *header)
 {
 	struct vmw_bo *vmw_bo = NULL;
+	struct vmw_resource *res;
 	struct vmw_surface *srf = NULL;
 	VMW_DECLARE_CMD_VAR(*cmd, SVGA3dCmdSurfaceDMA);
 	int ret;
@@ -1532,18 +1533,24 @@ static int vmw_cmd_dma(struct vmw_private *dev_priv,
 
 	dirty = (cmd->body.transfer == SVGA3D_WRITE_HOST_VRAM) ?
 		VMW_RES_DIRTY_SET : 0;
-	ret = vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface,
-				dirty, user_surface_converter,
-				&cmd->body.host.sid, NULL);
+	ret = vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface, dirty,
+				user_surface_converter, &cmd->body.host.sid,
+				NULL);
 	if (unlikely(ret != 0)) {
 		if (unlikely(ret != -ERESTARTSYS))
 			VMW_DEBUG_USER("could not find surface for DMA.\n");
 		return ret;
 	}
 
-	srf = vmw_res_to_srf(sw_context->res_cache[vmw_res_surface].res);
+	res = sw_context->res_cache[vmw_res_surface].res;
+	if (!res) {
+		VMW_DEBUG_USER("Invalid DMA surface.\n");
+		return -EINVAL;
+	}
 
-	vmw_kms_cursor_snoop(srf, sw_context->fp->tfile, &vmw_bo->tbo, header);
+	srf = vmw_res_to_srf(res);
+	vmw_kms_cursor_snoop(srf, sw_context->fp->tfile, &vmw_bo->tbo,
+			     header);
 
 	return 0;
 }
-- 
2.51.0



