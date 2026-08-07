Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C31314B6D;
	Fri,  7 Aug 2026 15:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116346; cv=none; b=lIaqIldbxyMRQoAn4kqDzxO+S42p0LFLISdnt5I3amgD+QF/Vl4SpLk9T0qFqBNPKBhh5VpcX4Wc6T6NKEivGUE+vZgNiQwTWGYRxvXlARXRvjTVQnSMKtkMTxwjK3SP1cGJvVmHBzMJatOMKxjVUknwH7yJePq8mDS/eHgoFzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116346; c=relaxed/simple;
	bh=IwsL4dAekIpvv9+7F+e/ko0rD0dJhSO0fsO6wATBhnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okMBGmjHnxpPAJNbe2CJ4sAdkwDAsr2wuovGV78kCxD6DrUSynygekJ5g0vbXZkqp3Bg0ZzksqX6QaE+eDH40OvffqddAXtAZdAlAxSfOjfkbwQ3X7xcStG5IOvL0ck6Oy3Gymi6nP8RpCTyy6Uo1TDUYdj6kH4IQc7K2zYDzmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbJwNB00; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbJwNB00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFED11F000E9;
	Fri,  7 Aug 2026 15:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116345;
	bh=4rSZDnk8jQnvFcUin7CPOE10ADESHhiZuuhO2AVRSFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbJwNB00pwkX0v07GEQd/o/Dr1dAc93uSIHUI0NNOYUuFlRsME29+QnRihVxXtjjs
	 mFsD4+bPl03pPeR0ABzZ5vvrR7fHYIjKiywO6oApxc0um4dqLu5DwJkks/e82KHF/p
	 m7Ow6AicGi3EyIj323Az4IgVveVXEL5zoylzkOOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.6 198/261] drm/vmwgfx: reject DX_BIND_QUERY without a DX context
Date: Fri,  7 Aug 2026 16:39:15 +0200
Message-ID: <20260807143419.640355359@linuxfoundation.org>
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
@@ -1289,9 +1289,13 @@ static int vmw_cmd_dx_bind_query(struct
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
@@ -1305,7 +1309,7 @@ static int vmw_cmd_dx_bind_query(struct
 		return ret;
 
 	sw_context->dx_query_mob = vmw_bo;
-	sw_context->dx_query_ctx = sw_context->dx_ctx_node->ctx;
+	sw_context->dx_query_ctx = ctx_node->ctx;
 	return 0;
 }
 


