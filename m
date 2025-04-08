Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DA3264614;
	Tue,  8 Apr 2025 11:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111167; cv=none; b=W0U016MV9SA8OBGwGLAVQUbokj5xh0ElNRD9Sxl45UYMCJX5IEywzTjyefONdLmXL+4M5o9gjSUxaBsepKnukVuhTA9N6R1siVXkPR0mxDxBsp/iF+tFbJR3lVgVHFhqKXmX3dlYiCcN6BFrrtPOVhOvwiPHX8EO4Ilxao/7xII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111167; c=relaxed/simple;
	bh=TOiR5OtvSyOkJI+yvSHKl0vLx47GT/YqxgsGJLmCuGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPdYgjSHqt0SwinZbV8P8Uy/0RpWo2rQNGuBFQScpX4aJcfH5nRdMssdRBBhMgwsDVkDzeXXUXz4gMlI1HOrFef4wOwEBSVj12pZ1vXzC1R9sawsD2BSAJdMOoLRtF6lz+9z4IKyyxd7stJWovcI4eMH6AA2IiAF74nlqrxMFSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcwEPTrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcwEPTrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F473C4CEE5;
	Tue,  8 Apr 2025 11:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111167;
	bh=TOiR5OtvSyOkJI+yvSHKl0vLx47GT/YqxgsGJLmCuGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcwEPTrEoaBdU92fMO3mCe+uADIttG1scTIYGfFT9WfnzU72FPEXrar28H69A93zW
	 hXXJv562pyvIKrqvHoYgBkn+Wrbuy0+EFFbm2LJUFQ3nF0JMDv63KSn/lOTDxPpMVW
	 XFtxLtATdRpUgoxepy4Hf/tzNDhEXMQfe62wqobc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 332/731] drm/mediatek: Fix config_updating flag never false when no mbox channel
Date: Tue,  8 Apr 2025 12:43:49 +0200
Message-ID: <20250408104921.997136663@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 4ba973c8bad04d59fd4efa62512f4d9cee131714 ]

When CONFIG_MTK_CMDQ is enabled, if the display is controlled by the CPU
while other hardware is controlled by the GCE, the display will encounter
a mbox request channel failure.
However, it will still enter the CONFIG_MTK_CMDQ statement, causing the
config_updating flag to never be set to false. As a result, no page flip
event is sent back to user space, and the screen does not update.

Fixes: da03801ad08f ("drm/mediatek: Move mtk_crtc_finish_page_flip() to ddp_cmdq_cb()")
Signed-off-by: Jason-JH Lin <jason-jh.lin@mediatek.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250224051301.3538484-1-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_crtc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.c b/drivers/gpu/drm/mediatek/mtk_crtc.c
index 5674f5707cca8..8f6fba4217ece 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.c
@@ -620,13 +620,16 @@ static void mtk_crtc_update_config(struct mtk_crtc *mtk_crtc, bool needs_vblank)
 
 		mbox_send_message(mtk_crtc->cmdq_client.chan, cmdq_handle);
 		mbox_client_txdone(mtk_crtc->cmdq_client.chan, 0);
+		goto update_config_out;
 	}
-#else
+#endif
 	spin_lock_irqsave(&mtk_crtc->config_lock, flags);
 	mtk_crtc->config_updating = false;
 	spin_unlock_irqrestore(&mtk_crtc->config_lock, flags);
-#endif
 
+#if IS_REACHABLE(CONFIG_MTK_CMDQ)
+update_config_out:
+#endif
 	mutex_unlock(&mtk_crtc->hw_lock);
 }
 
-- 
2.39.5



