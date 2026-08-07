Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D78238C2C0;
	Fri,  7 Aug 2026 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114434; cv=none; b=Z6Lr1HYrwYtGouqkddlQcrsnzUC0ez4Wys2UXtQqcrQy/6B4yW6RLMu2s7ujEJyKy89hFbKTW+EYobv4Uej+5uJQ40dkJbhB6G+3pcGlImrLwQ8hsON+aDNwtMe3dyVah155LRxCi9r5hdMg5w9NoH3Liqbvmeykn3/pe4L6hCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114434; c=relaxed/simple;
	bh=1lzb0KxznFfktuoYHDikL619+tNd59FLFAlcB6AaHns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9OHlluK/rtWZNPXd8lWmaKAvttOc0R76xB45oMLO5AP4vUTn0P+cy+jkSt0b2DXXts0YCm3TxU3x2eOHPUVCLvnJHMRgv+xOOrWvShpXolBBe23HN+6WR0aemsOBhQZ2bk8B8fgkKlrhKkvlorqMYtd/UvvZE9Fna9FGfLoTcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBU3FRQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBU3FRQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FC91F000E9;
	Fri,  7 Aug 2026 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114433;
	bh=pEfINRxMwVRv0ldlzG042jSjKTwjIIt60EeVR7V8vho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBU3FRQ6pbXb7XJZlTcdFHQNJg7ZnQshUDqvqId2MHurSGh/1H37sN6SC1q9L6s9E
	 UCOtitjV4Wf/DWm/nXZ8TQpxcMONppw1bT4ExBWnl7n2Una673uwO8pgEs9pUkOZ9O
	 TsSaIGlunJMOw3t9hlNO88/S9GQTgySvts4bxSBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.12 260/337] drm/vmwgfx: reject DX_BIND_QUERY without a DX context
Date: Fri,  7 Aug 2026 16:37:43 +0200
Message-ID: <20260807143424.181913661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit 55ec09c9ce10b1272802c7ab6c1be2ea0dbc68db upstream.

vmw_cmd_dx_bind_query() unconditionally dereferences
sw_context->dx_ctx_node->ctx.  Userspace can trigger a NULL pointer
dereference from any render-node fd by submitting an execbuf with
dx_context_handle == SVGA3D_INVALID_ID and a SVGA_3D_CMD_DX_BIND_QUERY
opcode in the command stream: dx_ctx_node is left NULL and the kernel
oopses on the assignment.  The same NULL is then re-read in
vmw_resources_reserve() via vmw_context_get_dx_query_mob().

All sibling DX handlers fail-close on a missing dx_ctx_node using
VMW_GET_CTX_NODE().  Use the same pattern here, returning -EINVAL up
front before any relocation state is published.

Fixes: 9c079b8ce8bf ("drm/vmwgfx: Adapt execbuf to the new validation api")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-3-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1290,9 +1290,13 @@ static int vmw_cmd_dx_bind_query(struct
 				 SVGA3dCmdHeader *header)
 {
 	VMW_DECLARE_CMD_VAR(*cmd, SVGA3dCmdDXBindQuery);
+	struct vmw_ctx_validation_info *ctx_node = VMW_GET_CTX_NODE(sw_context);
 	struct vmw_bo *vmw_bo;
 	int ret;
 
+	if (!ctx_node)
+		return -EINVAL;
+
 	cmd = container_of(header, typeof(*cmd), header);
 
 	/*
@@ -1306,7 +1310,7 @@ static int vmw_cmd_dx_bind_query(struct
 		return ret;
 
 	sw_context->dx_query_mob = vmw_bo;
-	sw_context->dx_query_ctx = sw_context->dx_ctx_node->ctx;
+	sw_context->dx_query_ctx = ctx_node->ctx;
 	return 0;
 }
 


