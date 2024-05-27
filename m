Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB9117E90E;
	Mon, 27 May 2024 19:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837066; cv=none; b=IVXGaG6Cl7pxqbUytXd2FTIArCVNUqy/BGF2cvjIa40UzI3BrLiLwpatDynRHZzklT5lzAYFg+Vwxxech/ApQ+Np0hzwOSNiWtwF25KQo+zYELwZaJmZ2O23fN6G5WhPczEbrZveLPomtCM7bYzPpLYvCctijVBsWnTcl7qEjOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837066; c=relaxed/simple;
	bh=hhKgb8BmeJAemlR8Z++8wD3pnyw6uzcHpL7x80CSQdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMdWNWb3Csz5SOXC8G7pODcSXEYLxpjnW/EprPhpuldF+K2k96wnSppRJ06zu8HWjcc9m0jOYG0iXpvRDfMTwxPfzax6Gpb0qbC3boGQIqetVr5/wpDFwM0Av5o1cwFKzZaR7+Gb/Qph20hRxL+kozxguWVXen+tViwJSBD6DtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U08cepV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U08cepV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E17C2BBFC;
	Mon, 27 May 2024 19:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837065;
	bh=hhKgb8BmeJAemlR8Z++8wD3pnyw6uzcHpL7x80CSQdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U08cepV73sARNN5SFjRn4PywSKEby35ctP3KbpBJzp95YBlEvG65cZMPIxuhzcVu+
	 zYjnEU8FaOuhyn362VRM8/aFSrHOCamTaT2U9/6Uv6LLnDxQJ6nMktfQIWhF/iuiwD
	 6Kv8wMwFdnrfcXqPLcy/SZCqMiP605JJ9D5hOOVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Green <greenjustin@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 297/427] drm/mediatek: Add 0 size check to mtk_drm_gem_obj
Date: Mon, 27 May 2024 20:55:44 +0200
Message-ID: <20240527185629.995500195@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



