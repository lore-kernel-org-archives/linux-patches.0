Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69366CDA8;
	Mon,  8 Apr 2024 13:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581273; cv=none; b=P2YLw4AMkAyqk6h1MRjTISx4Hy/fcP7NcX6I12xv5JYA5z5BW1m0lGx7j17/JpzlvGwtwcIBhmqk9otk9uzw2EqdMiA8lN76QLgQANl4UV2vI0MKYwbKidMhF7K8EUkIPo++BqhoO4TDxBGtCoEpEEyGEsoafvmBY4GJLjnTsdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581273; c=relaxed/simple;
	bh=0SuGBsuVsq9kRwpetWNvUjteVZdtCHwmn2c8m5ijG6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG9P3/Q8kNozr8jNzPSd2jAUZospq9o+m/vq216jqEPPi8lsMehyzLGRkuUapp1U0wH29Hl0rpAvHxKQe/WyrK5IsoXQYgXEG5mKng5RcNj5+0WirLv4NKglopmjXLo7R8mDJq7GOXSW9VlcspaF8gsk/H3tprGLyYm01ZtaZOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO1WOIC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO1WOIC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0194BC433F1;
	Mon,  8 Apr 2024 13:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581273;
	bh=0SuGBsuVsq9kRwpetWNvUjteVZdtCHwmn2c8m5ijG6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO1WOIC9gmXHMcevgWF1aUhCVsTpAJtBKkwuzwSo6A7WdlPh0Ycv/qOGGOE40TD3w
	 M+1umLfcRABuqaDRnwKGrirmSRNJCROy/tt2rQhYn8KuhFxFK4GdxVwAQyx4IkpmzK
	 hlQKl6Ct++MMO66bufBolIzhTW5ScCy+2RsMwdYs=
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
Subject: [PATCH 5.15 016/690] drm/vmwgfx: Fix possible null pointer derefence with invalid contexts
Date: Mon,  8 Apr 2024 14:48:02 +0200
Message-ID: <20240408125400.132490561@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
index b91f8d17404d6..21134c7f18382 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -472,7 +472,7 @@ static int vmw_resource_context_res_add(struct vmw_private *dev_priv,
 	    vmw_res_type(ctx) == vmw_res_dx_context) {
 		for (i = 0; i < cotable_max; ++i) {
 			res = vmw_context_cotable(ctx, i);
-			if (IS_ERR(res))
+			if (IS_ERR_OR_NULL(res))
 				continue;
 
 			ret = vmw_execbuf_res_noctx_val_add(sw_context, res,
@@ -1277,6 +1277,8 @@ static int vmw_cmd_dx_define_query(struct vmw_private *dev_priv,
 		return -EINVAL;
 
 	cotable_res = vmw_context_cotable(ctx_node->ctx, SVGA_COTABLE_DXQUERY);
+	if (IS_ERR_OR_NULL(cotable_res))
+		return cotable_res ? PTR_ERR(cotable_res) : -EINVAL;
 	ret = vmw_cotable_notify(cotable_res, cmd->body.queryId);
 
 	return ret;
@@ -2455,6 +2457,8 @@ static int vmw_cmd_dx_view_define(struct vmw_private *dev_priv,
 		return ret;
 
 	res = vmw_context_cotable(ctx_node->ctx, vmw_view_cotables[view_type]);
+	if (IS_ERR_OR_NULL(res))
+		return res ? PTR_ERR(res) : -EINVAL;
 	ret = vmw_cotable_notify(res, cmd->defined_id);
 	if (unlikely(ret != 0))
 		return ret;
@@ -2540,8 +2544,8 @@ static int vmw_cmd_dx_so_define(struct vmw_private *dev_priv,
 
 	so_type = vmw_so_cmd_to_type(header->id);
 	res = vmw_context_cotable(ctx_node->ctx, vmw_so_cotables[so_type]);
-	if (IS_ERR(res))
-		return PTR_ERR(res);
+	if (IS_ERR_OR_NULL(res))
+		return res ? PTR_ERR(res) : -EINVAL;
 	cmd = container_of(header, typeof(*cmd), header);
 	ret = vmw_cotable_notify(res, cmd->defined_id);
 
@@ -2660,6 +2664,8 @@ static int vmw_cmd_dx_define_shader(struct vmw_private *dev_priv,
 		return -EINVAL;
 
 	res = vmw_context_cotable(ctx_node->ctx, SVGA_COTABLE_DXSHADER);
+	if (IS_ERR_OR_NULL(res))
+		return res ? PTR_ERR(res) : -EINVAL;
 	ret = vmw_cotable_notify(res, cmd->body.shaderId);
 	if (ret)
 		return ret;
@@ -2981,6 +2987,8 @@ static int vmw_cmd_dx_define_streamoutput(struct vmw_private *dev_priv,
 	}
 
 	res = vmw_context_cotable(ctx_node->ctx, SVGA_COTABLE_STREAMOUTPUT);
+	if (IS_ERR_OR_NULL(res))
+		return res ? PTR_ERR(res) : -EINVAL;
 	ret = vmw_cotable_notify(res, cmd->body.soid);
 	if (ret)
 		return ret;
-- 
2.43.0



