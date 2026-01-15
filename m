Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7836186334;
	Thu, 15 Jan 2026 17:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498513; cv=none; b=OEECqWIZXB2tzwvy6GNsnn9DpXpKlOcJUHxCCzN3HL+KzwO2SR2PXiiFs8CULKPnfM3rzNDkoiDyYDq/l3gquLCiC43nKIyewZwZXfF1lXtk+9vt3LB+HecV9PGif8WLi1K8h+GjA24qMWUlGjbIp2PCaWsC4kpYRPR6BIKOHbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498513; c=relaxed/simple;
	bh=CuQjundJQb6vx3EIMlIveNPl6Aabfx8Kuu9FZIBp4YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntQqucPwAK1FInVZPTI9uKuJjsBELpYj1eDvC2WIOgZQh8aZsEBftOvRf5lN+auDFPtgqkq6KyH3b1C4UMwXlLJaArjUtLRgcOzPMc8YjzKaeuB5MZGrWZKOGvZW92KTpMlOLXg/YWg/tC9eDncYW6Lx08AGR3vgCj62ocBtEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtJ5nq76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtJ5nq76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AB6C116D0;
	Thu, 15 Jan 2026 17:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498513;
	bh=CuQjundJQb6vx3EIMlIveNPl6Aabfx8Kuu9FZIBp4YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtJ5nq76evpv6UtU6x8tYUBjnW4uJm+1wL1KKwCbec3TDLqdvecndqbMIR2BZwniq
	 AYHBL1HMCzcQutklFFNLNo3WXl1fee6r8HSl1r+p7Crru6kitHsfF24eUWzsTLLQvg
	 nFV+eJJPqjIKjUt3BPmxyD+m/yqiuArJywC0ZdKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Ian Forbes <ian.forbes@broadcom.com>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.15 425/554] drm/vmwgfx: Fix a null-ptr access in the cursor snooper
Date: Thu, 15 Jan 2026 17:48:11 +0100
Message-ID: <20260115164301.642687055@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[Shivani: Modified to apply on v5.10.y-v6.1.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1525,6 +1525,7 @@ static int vmw_cmd_dma(struct vmw_privat
 		       SVGA3dCmdHeader *header)
 {
 	struct vmw_buffer_object *vmw_bo = NULL;
+	struct vmw_resource *res;
 	struct vmw_surface *srf = NULL;
 	VMW_DECLARE_CMD_VAR(*cmd, SVGA3dCmdSurfaceDMA);
 	int ret;
@@ -1560,18 +1561,24 @@ static int vmw_cmd_dma(struct vmw_privat
 
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
 
-	vmw_kms_cursor_snoop(srf, sw_context->fp->tfile, &vmw_bo->base, header);
+	srf = vmw_res_to_srf(res);
+	vmw_kms_cursor_snoop(srf, sw_context->fp->tfile, &vmw_bo->base,
+			     header);
 
 	return 0;
 }


