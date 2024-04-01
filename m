Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA64E43AD6;
	Mon,  1 Apr 2024 16:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987956; cv=none; b=i6AlMgPgyrp5Pi8OZ77rnWZ0fzDhWmRhC71GDxhi5ZsC2f6ylGNfF8LrX7Dj+bYE3uwT1pHrVOvUxsG0vQrkuiyPydEYcPYkqL+ic7kZPYg7x957H7/Ljvou5uu/kukgwMCcxlCM53mWKNPamh2GeBIheohVIv27d0RcEeQkFd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987956; c=relaxed/simple;
	bh=sPJWptY32kuDf2hmqpD+uAYmrWDcuP9OpCFFQlaH+V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYkVzimJ+5mPuAvOWHxzl9EzHnOzkFx1Fr6wfXfvMl8ubZenDl2TQTFuYYim72WYVR012gLeJFB0Yh4uzDFrNVeQJxuiia7fOuSGQ12EAx/fAwXbqWCshDFfTuAOzSowQ+7WmRKUi7VxnbumMn+mHcsx4mroHXl8ExpJoDi5MRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+en/EFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+en/EFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2B2C433C7;
	Mon,  1 Apr 2024 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987956;
	bh=sPJWptY32kuDf2hmqpD+uAYmrWDcuP9OpCFFQlaH+V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+en/EFWDor8K6mrVL6cx6ZIp6HBvog0WBRPYoUnB4V/IsKc/dJY0XBb88nOAKnHo
	 kOwHn0LAn5xuGFa9m3CbEaQHUNh3QUARNJnV9kXTkTbZ5W/0ir6zuzUfMvzkz5+BQi
	 QXkJsolXxRZia31phc6EayA6AyQgAeDYfVmV5vvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niels De Graef <ndegraef@redhat.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 013/432] drm/vmwgfx: Fix possible null pointer derefence with invalid contexts
Date: Mon,  1 Apr 2024 17:40:00 +0200
Message-ID: <20240401152553.524082033@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

[ Upstream commit 517621b7060096e48e42f545fa6646fc00252eac ]

vmw_context_cotable can return either an error or a null pointer and its
usage sometimes went unchecked. Subsequent code would then try to access
either a null pointer or an error value.

The invalid dereferences were only possible with malformed userspace
apps which never properly initialized the rendering contexts.

Check the results of vmw_context_cotable to fix the invalid derefs.

Thanks:
ziming zhang(@ezrak1e) from Ant Group Light-Year Security Lab
who was the first person to discover it.
Niels De Graef who reported it and helped to track down the poc.

Fixes: 9c079b8ce8bf ("drm/vmwgfx: Adapt execbuf to the new validation api")
Cc: <stable@vger.kernel.org> # v4.20+
Reported-by: Niels De Graef  <ndegraef@redhat.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Cc: Martin Krastev <martin.krastev@broadcom.com>
Cc: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Cc: Ian Forbes <ian.forbes@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240110200305.94086-1-zack.rusin@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 36987ef3fc300..5fef0b31c1179 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -447,7 +447,7 @@ static int vmw_resource_context_res_add(struct vmw_private *dev_priv,
 	    vmw_res_type(ctx) == vmw_res_dx_context) {
 		for (i = 0; i < cotable_max; ++i) {
 			res = vmw_context_cotable(ctx, i);
-			if (IS_ERR(res))
+			if (IS_ERR_OR_NULL(res))
 				continue;
 
 			ret = vmw_execbuf_res_val_add(sw_context, res,
@@ -1266,6 +1266,8 @@ static int vmw_cmd_dx_define_query(struct vmw_private *dev_priv,
 		return -EINVAL;
 
 	cotable_res = vmw_context_cotable(ctx_node->ctx, SVGA_COTABLE_DXQUERY);
+	if (IS_ERR_OR_NULL(cotable_res))
+		return cotable_res ? PTR_ERR(cotable_res) : -EINVAL;
 	ret = vmw_cotable_notify(cotable_res, cmd->body.queryId);
 
 	return ret;
@@ -2484,6 +2486,8 @@ static int vmw_cmd_dx_view_define(struct vmw_private *dev_priv,
 		return ret;
 
 	res = vmw_context_cotable(ctx_node->ctx, vmw_view_cotables[view_type]);
+	if (IS_ERR_OR_NULL(res))
+		return res ? PTR_ERR(res) : -EINVAL;
 	ret = vmw_cotable_notify(res, cmd->defined_id);
 	if (unlikely(ret != 0))
 		return ret;
@@ -2569,8 +2573,8 @@ static int vmw_cmd_dx_so_define(struct vmw_private *dev_priv,
 
 	so_type = vmw_so_cmd_to_type(header->id);
 	res = vmw_context_cotable(ctx_node->ctx, vmw_so_cotables[so_type]);
-	if (IS_ERR(res))
-		return PTR_ERR(res);
+	if (IS_ERR_OR_NULL(res))
+		return res ? PTR_ERR(res) : -EINVAL;
 	cmd = container_of(header, typeof(*cmd), header);
 	ret = vmw_cotable_notify(res, cmd->defined_id);
 
@@ -2689,6 +2693,8 @@ static int vmw_cmd_dx_define_shader(struct vmw_private *dev_priv,
 		return -EINVAL;
 
 	res = vmw_context_cotable(ctx_node->ctx, SVGA_COTABLE_DXSHADER);
+	if (IS_ERR_OR_NULL(res))
+		return res ? PTR_ERR(res) : -EINVAL;
 	ret = vmw_cotable_notify(res, cmd->body.shaderId);
 	if (ret)
 		return ret;
@@ -3010,6 +3016,8 @@ static int vmw_cmd_dx_define_streamoutput(struct vmw_private *dev_priv,
 	}
 
 	res = vmw_context_cotable(ctx_node->ctx, SVGA_COTABLE_STREAMOUTPUT);
+	if (IS_ERR_OR_NULL(res))
+		return res ? PTR_ERR(res) : -EINVAL;
 	ret = vmw_cotable_notify(res, cmd->body.soid);
 	if (ret)
 		return ret;
-- 
2.43.0



