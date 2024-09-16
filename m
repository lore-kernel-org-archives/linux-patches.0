Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CA8149E0B;
	Mon, 16 Sep 2024 12:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488145; cv=none; b=i4724+sZKBhuBgWCYgug7lSU1AWS1TM1d9EKOzXuqC0IXaaWdAVlyXoroRO9XNB7ErvmNmTLXSekz0Xe41Xu1A3pcDo4iyf+9WLlgdK61S4f4DYRwgW0f3dOS04ot1hwHtJE1Vblfgcqz0p9mB5NeInvg/oO0SdpJmuuVLciTCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488145; c=relaxed/simple;
	bh=PoBuOfUcBfZiNJo4dghOsOqGnHaMX1EgwfTnOQpdk/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjkAJHVUPhMTxFyzYSZ3UALHjpnMCATqZYB0CvoNqVRctWhlwHYQiog+xHCjuhDOpZns8BzEMjpikSJM6mlQgiVD1XlZQAcNypExaeMbnZQSixUTLxhxlLvSE5ewNEiTwFiALKJpM0HfkZXzlpY3R1nHBgbQvU25sX/ToVgmQ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJlxrVxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJlxrVxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D58C4CEC4;
	Mon, 16 Sep 2024 12:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488144;
	bh=PoBuOfUcBfZiNJo4dghOsOqGnHaMX1EgwfTnOQpdk/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJlxrVxm1Tb8xHuPISwTtutgz0QAb+JbXYxvMEBeZ+hnW13vmHJEaUqZEl+62D+lD
	 y2ExNf0flIxrE9D+9VcP61qAbSXQT7z0+OB8bpApdbVzgrO3gcxD33SHFNGFI54G3e
	 uxO6fNGN3AAuCH2boOyONfyCziP3+HnYCDcz5VjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Daniel Stone <daniels@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 003/121] drm/mediatek: Set sensible cursor width/height values to fix crash
Date: Mon, 16 Sep 2024 13:42:57 +0200
Message-ID: <20240916114229.047515602@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 042b8711a0beafb2c3b888bebe3c300ab4c817fa ]

Hardware-speaking, there is no feature-reduced cursor specific
plane, so this driver reserves the last all Overlay plane as a
Cursor plane, but sets the maximum cursor width/height to the
maximum value that the full overlay plane can use.

While this could be ok, it raises issues with common userspace
using libdrm (especially Mutter, but other compositors too) which
will crash upon performing allocations and/or using said cursor
plane.

Reduce the maximum width/height for the cursor to 512x512 pixels,
value taken from IGT's maximum cursor size test, which succeeds.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Tested-by: Fei Shao <fshao@chromium.org>
Reviewed-by: Daniel Stone <daniels@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240718082410.204459-1-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 56f409ad7f39..ab2bace792e4 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -539,8 +539,8 @@ static int mtk_drm_kms_init(struct drm_device *drm)
 	}
 
 	/* IGT will check if the cursor size is configured */
-	drm->mode_config.cursor_width = drm->mode_config.max_width;
-	drm->mode_config.cursor_height = drm->mode_config.max_height;
+	drm->mode_config.cursor_width = 512;
+	drm->mode_config.cursor_height = 512;
 
 	/* Use OVL device for all DMA memory allocations */
 	crtc = drm_crtc_from_index(drm, 0);
-- 
2.43.0



