Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199033711C;
	Fri, 17 Oct 2025 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713543; cv=none; b=D0u6NjPmfHFv/meQ4+Fkq8AXouTSi0XpxX0oFixUeFct2c2lwxj/emdfO+z3w8LR/tXbe3jtHzYf0iUmuxROn0IJ8BfX+tpdEP73xSo+520vgQ11yeRF6UKRfeeCWh+rrirVAieLTclzLfQ4QHcwQh0RxGvPWMwrXHL+L95yXuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713543; c=relaxed/simple;
	bh=jd2Oz//zHIxBpGFXepWRdskcnPG6U7GEtIK76+QESCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uu/2IsAguv7VZ7s+BXicISvLpgNJoJ+KI8Dw0pathpl6EPABrIeZcPz/k8iGb9hzy/j5GapgZ99CbAHA5ghLyV66CpwvqgeQmhUAFZP9Il2fR+teQzMJ8O/v8EZefOJlRSGTALhzMYC1r+L9U9jkjcuG2kj5w/iuBlWhUmdy/W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHxYZTvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHxYZTvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F015C4CEE7;
	Fri, 17 Oct 2025 15:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713542;
	bh=jd2Oz//zHIxBpGFXepWRdskcnPG6U7GEtIK76+QESCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHxYZTvFLiZNn4iJRPnYJzc895Hhh9m31REP7yKsAoaAGpGpjfG6w/lGnQXGvJSoa
	 POrPPnXQObj7rwadO5ZpLAfVRQWN8ekPr2v4nYk824dYm2njkgOLiqy2cgxCtjT9Xl
	 kvDEqeacj6UFWWnRjx0a1sF6uDmq05zArWbtAYog=
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
Subject: [PATCH 6.6 033/201] drm/vmwgfx: Fix a null-ptr access in the cursor snooper
Date: Fri, 17 Oct 2025 16:51:34 +0200
Message-ID: <20251017145135.961739138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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
index b129ce873af3f..b235e7cc41f3f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1514,6 +1514,7 @@ static int vmw_cmd_dma(struct vmw_private *dev_priv,
 		       SVGA3dCmdHeader *header)
 {
 	struct vmw_bo *vmw_bo = NULL;
+	struct vmw_resource *res;
 	struct vmw_surface *srf = NULL;
 	VMW_DECLARE_CMD_VAR(*cmd, SVGA3dCmdSurfaceDMA);
 	int ret;
@@ -1549,18 +1550,24 @@ static int vmw_cmd_dma(struct vmw_private *dev_priv,
 
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



