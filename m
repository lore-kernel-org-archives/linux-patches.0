Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14ED253924;
	Mon, 23 Jun 2025 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684743; cv=none; b=M8vDI1faYFZvVT75BYZa8yiHALgNDnl+RB2fgjNaORPpW33KL4BC7SbPIlV3T1snIlNys+tbO87CSqjj+ChtKOxmuW/FfVBJSzvIATajpOJ/dSGiYoXxooGNY4Uvhhx0ohT9N07/jgTYScVGJaGRlD+ErjcWydJSejzC0Cy0rOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684743; c=relaxed/simple;
	bh=bbXdAdImmPT+Te8fye4PpdTBbR6TfFSjSznkhex9ySU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2ILvZXCOpQZj2JC+BCucC86k4J05KxRRttUHQymZTN2ra+7zOFmH8CUB6sPeBO/L6NPVEIUarTbJqjdH2pmj8vNtZK7ZiSFdMRrolGi9wHfKt5e4moR4hDsx+5EgYU8hnsQA4TlcUPAHqGVlUmBKI7AhgLbeuPTQ782JHPUkKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsL4Ef/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsL4Ef/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21091C4CEEA;
	Mon, 23 Jun 2025 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684743;
	bh=bbXdAdImmPT+Te8fye4PpdTBbR6TfFSjSznkhex9ySU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsL4Ef/8Mb6NhO0wWownKjd5ASXYbZOzTxHrrA7Ajq+F9XUwIQP0GQj1sPx3109SB
	 uvt2SdTffIkYdUoRaD4cpdm2OYh2R7uhPw+1C47HgI2gfaxOqJnJ9w4db9pPCx2pg3
	 n7+mHIaQpQ6XnPGr007JYeeHO2ce53O1NbyACxug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/222] drm/vmwgfx: Add seqno waiter for sync_files
Date: Mon, 23 Jun 2025 15:05:54 +0200
Message-ID: <20250623130612.482312429@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8db3b3ddbb644..0d29fe6f60358 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3621,6 +3621,23 @@ static int vmw_execbuf_tie_context(struct vmw_private *dev_priv,
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
@@ -3814,6 +3831,15 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 		} else {
 			/* Link the fence with the FD created earlier */
 			fd_install(out_fence_fd, sync_file->file);
+			struct seqno_waiter_rm_context *ctx =
+				kmalloc(sizeof(*ctx), GFP_KERNEL);
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
2.39.5



