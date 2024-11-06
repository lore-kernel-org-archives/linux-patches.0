Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DC01DF986;
	Wed,  6 Nov 2024 12:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896056; cv=none; b=rWVFS+TZQoWs/H/4EhouHDVDrLRbox3VvwD6Pac64n90dHwWPsC2x+omaOfGcS46gchiNbUdq43srC/ty9swOpXzLV+mqrxAei04NAsTtaELmhvVdR2qYVzj1i1f1vZcIBfhHahwEgmBg50SDgvO2No5txH1nX9SKAx9njHcHOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896056; c=relaxed/simple;
	bh=U1NHClCjMbrbDxNHR9NenLI5pnPw/IAphJPzti7h098=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZP8dI1F1r/iFewt4Zs8xEU7aVT7tp52eBboxNBnCgNh6i0Vol6A0wBbegj4Bwzpl9j0IFEzX9KmldBesFsH2/jz/kzHgPCUBoWyMMAoZFM8Vu8zCyWluRgVD02v5PBRhyuJgyOPnf2be6B7I5RnTCylR2h5b9aUKtXTCJQNA6OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XG8oe2WD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XG8oe2WD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D80C4CECD;
	Wed,  6 Nov 2024 12:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896056;
	bh=U1NHClCjMbrbDxNHR9NenLI5pnPw/IAphJPzti7h098=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XG8oe2WDDHzlALhpwNAj6HmivPm8AcU6hwmUqNhIoqpz7QHZhyNeMdIcIS3uNtbjW
	 PmPd++ojEEyb/BCsglmnNvy+/xS9MocRC0Tw00Vu/jw8AZNGni9C1H0QSxNjKIgDcE
	 hV7lhCsbz+DxHbfxibgzJpRZToOQYxdTbpz9EU3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 074/245] drm/mediatek: Fix potential NULL dereference in mtk_crtc_destroy()
Date: Wed,  6 Nov 2024 13:02:07 +0100
Message-ID: <20241106120321.027580779@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4018651ba5c409034149f297d3dd3328b91561fd ]

In mtk_crtc_create(), if the call to mbox_request_channel() fails then we
set the "mtk_crtc->cmdq_client.chan" pointer to NULL.  In that situation,
we do not call cmdq_pkt_create().

During the cleanup, we need to check if the "mtk_crtc->cmdq_client.chan"
is NULL first before calling cmdq_pkt_destroy().  Calling
cmdq_pkt_destroy() is unnecessary if we didn't call cmdq_pkt_create() and
it will result in a NULL pointer dereference.

Fixes: 7627122fd1c0 ("drm/mediatek: Add cmdq_handle in mtk_crtc")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/cc537bd6-837f-4c85-a37b-1a007e268310@stanley.mountain/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_crtc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.c b/drivers/gpu/drm/mediatek/mtk_crtc.c
index 4bee0328bdbee..e5d412b2d61b6 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.c
@@ -127,9 +127,8 @@ static void mtk_crtc_destroy(struct drm_crtc *crtc)
 
 	mtk_mutex_put(mtk_crtc->mutex);
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-	cmdq_pkt_destroy(&mtk_crtc->cmdq_client, &mtk_crtc->cmdq_handle);
-
 	if (mtk_crtc->cmdq_client.chan) {
+		cmdq_pkt_destroy(&mtk_crtc->cmdq_client, &mtk_crtc->cmdq_handle);
 		mbox_free_channel(mtk_crtc->cmdq_client.chan);
 		mtk_crtc->cmdq_client.chan = NULL;
 	}
-- 
2.43.0



