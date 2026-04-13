Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2466A3203B6;
	Mon, 13 Apr 2026 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099561; cv=none; b=Qh7Gra+CORuLqINUjZFQ+WTvis/9HSvLLffUxKi2VFbA+owHNKWkXCZkqkIc4UmDH0tGEVNupTE5lZA8jt9ivFeEcSjkxpCwc6OzzaheJe80BhLwuEsOzRFnZuq/3R5iYUOwwqBsk0IdPnADjUB6cd0eKWHphIPQy+h0sXaA6nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099561; c=relaxed/simple;
	bh=9Dip2lUNe56WJDLRZ5H5BzENCif2zWLL4i8CNDlzoXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMCuj/8CkQz0f6Biwu4wcv+AdNgyqXK2N5+96SHqlXa3F5JgrlSCxHKdrFA/abfzqb4ElEflPOPoOHWv9wbL0ytSTjw45zrS2USf2Aezr2O9lh9mRSxFlIyxoPUJcFCe9c/nHHa1UMKz2BK8Zz8wC5kN/IuwAVQQ/MpIoFT/8vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDgWbFug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDgWbFug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760DAC2BCAF;
	Mon, 13 Apr 2026 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099560;
	bh=9Dip2lUNe56WJDLRZ5H5BzENCif2zWLL4i8CNDlzoXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDgWbFug8Re2f5T3geBu0WbkdVymkCClbS232cpH3l7ArMCQi6ToAYB41yjeQuhh3
	 0YDv0Lyrac2sC/ao0tBONH7tbsKoxcOdXsind1BSSXQQU3RnzXlPtt8/bGajQ0rOv0
	 TEg5IFyRNXl0P9/CvnXpGOJ6mV7t42oL9nnxV7d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/491] Revert "drm/vmwgfx: Add seqno waiter for sync_files"
Date: Mon, 13 Apr 2026 18:00:00 +0200
Message-ID: <20260413155832.329434416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 7db6c88bb52f3b7525a06110cfd208990c49f8b4.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 26 -------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 361f96d09374d..daea547704ddc 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -4039,23 +4039,6 @@ static int vmw_execbuf_tie_context(struct vmw_private *dev_priv,
 	return 0;
 }
 
-/*
- * DMA fence callback to remove a seqno_waiter
- */
-struct seqno_waiter_rm_context {
-	struct dma_fence_cb base;
-	struct vmw_private *dev_priv;
-};
-
-static void seqno_waiter_rm_cb(struct dma_fence *f, struct dma_fence_cb *cb)
-{
-	struct seqno_waiter_rm_context *ctx =
-		container_of(cb, struct seqno_waiter_rm_context, base);
-
-	vmw_seqno_waiter_remove(ctx->dev_priv);
-	kfree(ctx);
-}
-
 int vmw_execbuf_process(struct drm_file *file_priv,
 			struct vmw_private *dev_priv,
 			void __user *user_commands, void *kernel_commands,
@@ -4249,15 +4232,6 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 		} else {
 			/* Link the fence with the FD created earlier */
 			fd_install(out_fence_fd, sync_file->file);
-			struct seqno_waiter_rm_context *ctx =
-				kmalloc(sizeof(*ctx), GFP_KERNEL);
-			ctx->dev_priv = dev_priv;
-			vmw_seqno_waiter_add(dev_priv);
-			if (dma_fence_add_callback(&fence->base, &ctx->base,
-						   seqno_waiter_rm_cb) < 0) {
-				vmw_seqno_waiter_remove(dev_priv);
-				kfree(ctx);
-			}
 		}
 	}
 
-- 
2.53.0



