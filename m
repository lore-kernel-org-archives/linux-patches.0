Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CC331F9BC;
	Mon, 13 Apr 2026 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099563; cv=none; b=PHzb1RTL9P+ZgYFINJdk54BdsCSvAdxhJ5jM4gpYPkMwhZrQckojzFKxM5tLVPZtxwq24UncK4mX95VgvXFZAB0H1wmVZSD/HYIhLRGoHg5w+nHy+J1tbe04AzzUACMxi2WPai16fJbHyS2A020vOHYzvHaNI+DhIBP2WQTfR1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099563; c=relaxed/simple;
	bh=5yxucoSJjyZyDLdSkOjP1nhi38mz8E+J1qH4lLO8D4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAfW7BK0mxB98q8ulBEwnsAv2zCtXV4RTzy5/o9P5K2aubpXUe06LJ9PhLbZqJMVS2JNiYdaFyeg4U4BwTzQdYkKDKFJBdEbam/yRv07EVG68K5DyAfw+ylbeNGXJSoWqRYz2LtQelwz2af7LjVTgYOrjGSCqpKHkBEaWpjLONs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbgdIx0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbgdIx0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B93C2BCAF;
	Mon, 13 Apr 2026 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099563;
	bh=5yxucoSJjyZyDLdSkOjP1nhi38mz8E+J1qH4lLO8D4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbgdIx0IN6aQ8ux6CbrZqjYJ5vHTJ9pFWAdCKkDqZCT+vby2v7KNHZ1cpcN/qcEXy
	 cg8Q8PWcLeomViMJQ3+bt6Ry0tqjL0q/+8/cXxD8CDaJZCafUlyH9x1FKomofpTO+1
	 8UrrZKj53DijbxxFl9ZFRpkRUtn2sirQLcRJXn+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/491] drm/vmwgfx: Add seqno waiter for sync_files
Date: Mon, 13 Apr 2026 18:00:01 +0200
Message-ID: <20260413155832.365848176@linuxfoundation.org>
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 0039a3b35b10d9c15d3d26320532ab56cc566750 ]

Because sync_files are passive waiters they do not participate in
the processing of fences like the traditional vmw_fence_wait IOCTL.
If userspace exclusively uses sync_files for synchronization then
nothing in the kernel actually processes fence updates as interrupts
for fences are masked and ignored if the kernel does not indicate to the
SVGA device that there are active waiters.

This oversight results in a bug where the entire GUI can freeze waiting
on a sync_file that will never be signalled as we've masked the interrupts
to signal its completion. This bug is incredibly racy as any process which
interacts with the fencing code via the 3D stack can process the stuck
fences on behalf of the stuck process causing it to run again. Even a
simple app like eglinfo is enough to resume the stuck process. Usually
this bug is seen at a login screen like GDM because there are no other
3D apps running.

By adding a seqno waiter we re-enable interrupt based processing of the
dma_fences associated with the sync_file which is signalled as part of a
dma_fence_callback.

This has likely been broken since it was initially added to the kernel in
2017 but has gone unnoticed until mutter recently started using sync_files
heavily over the course of 2024 as part of their explicit sync support.

Fixes: c906965dee22 ("drm/vmwgfx: Add export fence to file descriptor support")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250228200633.642417-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 26 +++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index daea547704ddc..9bec26fda14cb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -4039,6 +4039,23 @@ static int vmw_execbuf_tie_context(struct vmw_private *dev_priv,
 	return 0;
 }
 
+/*
+ * DMA fence callback to remove a seqno_waiter
+ */
+struct seqno_waiter_rm_context {
+	struct dma_fence_cb base;
+	struct vmw_private *dev_priv;
+};
+
+static void seqno_waiter_rm_cb(struct dma_fence *f, struct dma_fence_cb *cb)
+{
+	struct seqno_waiter_rm_context *ctx =
+		container_of(cb, struct seqno_waiter_rm_context, base);
+
+	vmw_seqno_waiter_remove(ctx->dev_priv);
+	kfree(ctx);
+}
+
 int vmw_execbuf_process(struct drm_file *file_priv,
 			struct vmw_private *dev_priv,
 			void __user *user_commands, void *kernel_commands,
@@ -4230,8 +4247,17 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 			fput(sync_file->file);
 			put_unused_fd(out_fence_fd);
 		} else {
+			struct seqno_waiter_rm_context *ctx;
 			/* Link the fence with the FD created earlier */
 			fd_install(out_fence_fd, sync_file->file);
+			ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+			ctx->dev_priv = dev_priv;
+			vmw_seqno_waiter_add(dev_priv);
+			if (dma_fence_add_callback(&fence->base, &ctx->base,
+						   seqno_waiter_rm_cb) < 0) {
+				vmw_seqno_waiter_remove(dev_priv);
+				kfree(ctx);
+			}
 		}
 	}
 
-- 
2.53.0



