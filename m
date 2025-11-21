Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA621F09B3;
	Fri, 21 Nov 2025 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731578; cv=none; b=jROKV+OtFWNS93Fi1DG16k8LlrcQQCNVd2KSai2psbD7ovJKkkwtn8odQkfWmE0L4EkUFRinCEvaim3HE6MUFH3A4kcsSiUpcM1BEa1Yli55UVy4RuPG0j1neRDHonOj8hnW0twq9cdYT5vgHH7WMe648xw06r1nHGJjdB0Ykis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731578; c=relaxed/simple;
	bh=HOgVGsVeckMvPSKWSh9i0Abkj/X7bchOA8lajCCYHkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFsNrBq+A2fzHblCnRDeVsiJYn/0FbIMD05u6dQ8iRhUcb2R0pDvjmuYdVBviQWx8dhOSXCxhyoXqRfOp9BaIAPCpPVXNFdUadF+rkcUDPdqU40mSv6HX8xHYwO/dhYjtYAZsdOmcqvCKHCsczJS4ygjJG0lfVz9KUfv/TBjCUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISx08xlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISx08xlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A1BC4CEF1;
	Fri, 21 Nov 2025 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731578;
	bh=HOgVGsVeckMvPSKWSh9i0Abkj/X7bchOA8lajCCYHkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISx08xlJXYkUzy8OyJ4KcXhRVxzNEDNk+c4YR1OXy6XkOP8UOtkD23I4u0LyUu0y2
	 4fPyN9+flCQt4bnCya2TU+b54n4cKejMAirTQ4V/n12bOZGcE3WQaRhuRgT8gc7dqy
	 oTA/Z0dOrMSTJaemPieGt06zHlFFc6kNXv+mIvmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/185] drm/mediatek: Add pm_runtime support for GCE power control
Date: Fri, 21 Nov 2025 14:10:28 +0100
Message-ID: <20251121130143.917026781@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Jason-JH Lin <jason-jh.lin@mediatek.com>

[ Upstream commit afcfb6c8474d9e750880aaa77952cc588f859613 ]

Call pm_runtime_resume_and_get() before accessing GCE hardware in
mbox_send_message(), and invoke pm_runtime_put_autosuspend() in the
cmdq callback to release the PM reference and start autosuspend for
GCE. This ensures correct power management for the GCE device.

Fixes: 8afe816b0c99 ("mailbox: mtk-cmdq-mailbox: Implement Runtime PM with autosuspend")
Signed-off-by: Jason-JH Lin <jason-jh.lin@mediatek.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250829091727.3745415-3-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_crtc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.c b/drivers/gpu/drm/mediatek/mtk_crtc.c
index bc7527542fdc6..c4c6d0249df56 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.c
@@ -283,6 +283,10 @@ static void ddp_cmdq_cb(struct mbox_client *cl, void *mssg)
 	unsigned int i;
 	unsigned long flags;
 
+	/* release GCE HW usage and start autosuspend */
+	pm_runtime_mark_last_busy(cmdq_cl->chan->mbox->dev);
+	pm_runtime_put_autosuspend(cmdq_cl->chan->mbox->dev);
+
 	if (data->sta < 0)
 		return;
 
@@ -618,6 +622,9 @@ static void mtk_crtc_update_config(struct mtk_crtc *mtk_crtc, bool needs_vblank)
 		mtk_crtc->config_updating = false;
 		spin_unlock_irqrestore(&mtk_crtc->config_lock, flags);
 
+		if (pm_runtime_resume_and_get(mtk_crtc->cmdq_client.chan->mbox->dev) < 0)
+			goto update_config_out;
+
 		mbox_send_message(mtk_crtc->cmdq_client.chan, cmdq_handle);
 		mbox_client_txdone(mtk_crtc->cmdq_client.chan, 0);
 		goto update_config_out;
-- 
2.51.0



