Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033352DF3C9;
	Tue, 17 Jun 2025 15:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174349; cv=none; b=rrkuP3JHpEtQ+2gJtDT0YvxCnobx2iDCVLgezQ2MbKZ4AJl2LFOJLuRTMeXsxYgAydOie4DaxQ3JJL/yJ3jp9crdIkqOrBnjoS3QXjk4QqDO/MPbDOOACuk9BBL0nBMjudlIO422yfap1C2zYahYMZ58yyLIbroZSAQqZvAkdX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174349; c=relaxed/simple;
	bh=V/Udh08FOJYOZrZATy2l6UaqUu3RRobnvxwJJK9YkrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEssJZ9pp3vnkPzh/nf7Zy7o1fOWJ+/F2NoX2k7o3Z8oNjy1bAy5vDDsr2Xf+v5xXjIytGj0c32GVDQEb5ieASlTmI6YGARnMR423v1H7ndkXZ3zQ6+0aVfidD6AVxOa5TPDzvPq9hmD3Waibw/CJRBU3Hx3X2p7MBeCBuKxOIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kZRqyar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kZRqyar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65919C4CEF0;
	Tue, 17 Jun 2025 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174348;
	bh=V/Udh08FOJYOZrZATy2l6UaqUu3RRobnvxwJJK9YkrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kZRqyarBHqppn/3jqVpdPwqlOcQllAcTqinY5TffDbcEMZDq3GKYE+r0HPNSM+hy
	 VJPrmVIBggfmk6qFMHVEifVzBuFoPRsGSFq7s6A8whoiMP06twN7x1bOUn5r5tJG2u
	 oQ3Z0/1LXPObH17Cmw5xzp7CQiv7cPFFwTYDT/P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/356] drm/vmwgfx: Add seqno waiter for sync_files
Date: Tue, 17 Jun 2025 17:22:50 +0200
Message-ID: <20250617152340.449168079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5fef0b31c1179..b129ce873af3f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -4083,6 +4083,23 @@ static int vmw_execbuf_tie_context(struct vmw_private *dev_priv,
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
@@ -4263,6 +4280,15 @@ int vmw_execbuf_process(struct drm_file *file_priv,
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



