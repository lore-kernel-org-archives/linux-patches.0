Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2BF248BB3;
	Wed, 15 Jan 2025 10:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938086; cv=none; b=HnDN/qqUWRA3JCdxbzzy5HRmCIuBGOfM0WW38lj9Npsy/qP8JMl93zZ2q29rjbR8t6VvShga8KrjygE+cIU2pxlWK/hxubevZauyLhurBFKkvH9kguMQqUaldGQru1Ci7Wlz0swCjUD0SFmgVYh6Xp89ibrnyUHeCHGnuZ2kO80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938086; c=relaxed/simple;
	bh=rwsnnensUPpC0zBgHkgQn7gdPKwwTR0kRf493AiB/+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s16cngSRReJ+9tY/V2BGaLKEgVWn7r0HzgPo8K/oytS4J3wnD7U793w5rr/9FRhnfH/yci3SJwWH80XkXZzymliClIz9xnogSp4KjboNrL536yUUkG7OJDLyv7VSx4WHir+JnRPG3YpkUIWAH8wk1jtageC6f9cXT5r2U4VeSec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DT17ivt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DT17ivt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C725C4CEDF;
	Wed, 15 Jan 2025 10:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938086;
	bh=rwsnnensUPpC0zBgHkgQn7gdPKwwTR0kRf493AiB/+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DT17ivt4FccADGGvinMuV6hRccAHTjPOF6SWmZLvGA5C6JBz7QbRJOjNjalRpZOkA
	 0bLhMuskcpLrVbwO1hGxHXY0gcryeX8jVDjbzcYBSH9bJryq8A87aRJjXYV0iFrH8v
	 2iA7RcRkBbsI1pMWFX9w97KTXPzdwmxlGxICYA2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/189] drm/mediatek: Move mtk_crtc_finish_page_flip() to ddp_cmdq_cb()
Date: Wed, 15 Jan 2025 11:35:57 +0100
Message-ID: <20250115103608.794256748@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit da03801ad08f2488c01e684509cd89e1aa5d17ec ]

mtk_crtc_finish_page_flip() is used to notify userspace that a
page flip has been completed, allowing userspace to free the frame
buffer of the last frame and commit the next frame.

In MediaTek's hardware design for configuring display hardware by using
GCE, `DRM_EVENT_FLIP_COMPLETE` should be notified to userspace after
GCE has finished configuring all display hardware settings for each
atomic_commit().

Currently, mtk_crtc_finish_page_flip() cannot guarantee that GCE has
configured all the display hardware settings of the last frame.
Therefore, to increase the accuracy of the timing for notifying
`DRM_EVENT_FLIP_COMPLETE` to userspace, mtk_crtc_finish_page_flip()
should be moved to ddp_cmdq_cb().

Fixes: 7f82d9c43879 ("drm/mediatek: Clear pending flag when cmdq packet is done")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241211034716.29241-1-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_crtc.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.c b/drivers/gpu/drm/mediatek/mtk_crtc.c
index eb0e1233ad04..5674f5707cca 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.c
@@ -112,6 +112,11 @@ static void mtk_drm_finish_page_flip(struct mtk_crtc *mtk_crtc)
 
 	drm_crtc_handle_vblank(&mtk_crtc->base);
 
+#if IS_REACHABLE(CONFIG_MTK_CMDQ)
+	if (mtk_crtc->cmdq_client.chan)
+		return;
+#endif
+
 	spin_lock_irqsave(&mtk_crtc->config_lock, flags);
 	if (!mtk_crtc->config_updating && mtk_crtc->pending_needs_vblank) {
 		mtk_crtc_finish_page_flip(mtk_crtc);
@@ -284,10 +289,8 @@ static void ddp_cmdq_cb(struct mbox_client *cl, void *mssg)
 	state = to_mtk_crtc_state(mtk_crtc->base.state);
 
 	spin_lock_irqsave(&mtk_crtc->config_lock, flags);
-	if (mtk_crtc->config_updating) {
-		spin_unlock_irqrestore(&mtk_crtc->config_lock, flags);
+	if (mtk_crtc->config_updating)
 		goto ddp_cmdq_cb_out;
-	}
 
 	state->pending_config = false;
 
@@ -315,10 +318,15 @@ static void ddp_cmdq_cb(struct mbox_client *cl, void *mssg)
 		mtk_crtc->pending_async_planes = false;
 	}
 
-	spin_unlock_irqrestore(&mtk_crtc->config_lock, flags);
-
 ddp_cmdq_cb_out:
 
+	if (mtk_crtc->pending_needs_vblank) {
+		mtk_crtc_finish_page_flip(mtk_crtc);
+		mtk_crtc->pending_needs_vblank = false;
+	}
+
+	spin_unlock_irqrestore(&mtk_crtc->config_lock, flags);
+
 	mtk_crtc->cmdq_vblank_cnt = 0;
 	wake_up(&mtk_crtc->cb_blocking_queue);
 }
@@ -606,13 +614,18 @@ static void mtk_crtc_update_config(struct mtk_crtc *mtk_crtc, bool needs_vblank)
 		 */
 		mtk_crtc->cmdq_vblank_cnt = 3;
 
+		spin_lock_irqsave(&mtk_crtc->config_lock, flags);
+		mtk_crtc->config_updating = false;
+		spin_unlock_irqrestore(&mtk_crtc->config_lock, flags);
+
 		mbox_send_message(mtk_crtc->cmdq_client.chan, cmdq_handle);
 		mbox_client_txdone(mtk_crtc->cmdq_client.chan, 0);
 	}
-#endif
+#else
 	spin_lock_irqsave(&mtk_crtc->config_lock, flags);
 	mtk_crtc->config_updating = false;
 	spin_unlock_irqrestore(&mtk_crtc->config_lock, flags);
+#endif
 
 	mutex_unlock(&mtk_crtc->hw_lock);
 }
-- 
2.39.5



