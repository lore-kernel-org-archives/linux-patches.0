Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B9617727;
	Mon, 27 May 2024 19:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838388; cv=none; b=CNkr4iYJIXB0EN7MQIrcn2HZ57RuX5sTE8Q/xRdVkIYB+uyKIxlDcdNP7jK658ZnnCdyfgF+0spAsHe5XhJ4R9FVql1KK14YhsjzOcP+MxaIO9VCElc6hI+NTaREhxwJ5XpNtfCj9FdiEPHAunmTw5URZeq3BZczNyeAtm47HQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838388; c=relaxed/simple;
	bh=Ao8Ld2Y51rvM9pvyOLG63SfwK1HtYKFoavkJxEjPcHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkOE0580aUaz4cXmH1RJ1LHm221h6CSQb3h+WzXPWcl+VVgI2YM/0wthpynjyXVvPvwi0CPvZBun8R1IYA5Z5matCs1YPAxG45jSuoE0M6c7P2X3aHjyHK98mwt8A9F+hJQ4wj/jtG5EWWQbyWaJc4Q1OJQRuuDnVVDyhVuE3fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZISlgFxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZISlgFxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0FDC2BBFC;
	Mon, 27 May 2024 19:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838387;
	bh=Ao8Ld2Y51rvM9pvyOLG63SfwK1HtYKFoavkJxEjPcHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZISlgFxsK3ses5s0MQPT5KoOHaurFrUtLfO+YeirJI9EsTm9530CQg6G+atSzNdul
	 tV7xmIgpNIgMhXcSXlR2sglGucP3BhH8WF6F1Mc5FqtwRJ6dPR0EfCSvPS6LUaT58B
	 ZLxBnYKDzK+XMpSRjou/9zJNpSlO4uEtvh2d1HC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Green <greenjustin@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 373/493] drm/mediatek: Add 0 size check to mtk_drm_gem_obj
Date: Mon, 27 May 2024 20:56:15 +0200
Message-ID: <20240527185642.476828963@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Green <greenjustin@chromium.org>

[ Upstream commit 1e4350095e8ab2577ee05f8c3b044e661b5af9a0 ]

Add a check to mtk_drm_gem_init if we attempt to allocate a GEM object
of 0 bytes. Currently, no such check exists and the kernel will panic if
a userspace application attempts to allocate a 0x0 GBM buffer.

Tested by attempting to allocate a 0x0 GBM buffer on an MT8188 and
verifying that we now return EINVAL.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Justin Green <greenjustin@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240307180051.4104425-1-greenjustin@chromium.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_gem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index 4f2e3feabc0f8..1bf229615b018 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -38,6 +38,9 @@ static struct mtk_drm_gem_obj *mtk_drm_gem_init(struct drm_device *dev,
 
 	size = round_up(size, PAGE_SIZE);
 
+	if (size == 0)
+		return ERR_PTR(-EINVAL);
+
 	mtk_gem_obj = kzalloc(sizeof(*mtk_gem_obj), GFP_KERNEL);
 	if (!mtk_gem_obj)
 		return ERR_PTR(-ENOMEM);
-- 
2.43.0



