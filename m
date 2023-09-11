Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9931F4432
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B485C433C8;
	Mon, 11 Sep 2023 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443444;
	bh=CN1Md9uniynNFvl8vxLJ5LCUB1DJl0PfgWQh3XsGrRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJbsqORZHVqbCb14t/16M8yNv3QkqQyCiUR+4BLvT9hp3uFOiaTJ1/j7YhKIHew2A
	 9vBDFxlmm7ofNEZs1m6I/HlC6cZ1j8gLyYm8rBRDBSc+sK4yQr5hI+NNUvv+jFYjDc
	 NUHkgBTbM6VSH477aKExgTaDxE4lAW6SlWQHWfSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Sui Jingfeng <suijingfeng@loongson.cn>,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 379/737] drm/mediatek: Fix potential memory leak if vmap() fail
Date: Mon, 11 Sep 2023 15:43:58 +0200
Message-ID: <20230911134701.159114401@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sui Jingfeng <suijingfeng@loongson.cn>

[ Upstream commit 379091e0f6d179d1a084c65de90fa44583b14a70 ]

Also return -ENOMEM if such a failure happens, the implement should take
responsibility for the error handling.

Fixes: 3df64d7b0a4f ("drm/mediatek: Implement gem prime vmap/vunmap function")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20230706134000.130098-1-suijingfeng@loongson.cn/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_gem.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index a25b28d3ee902..9f364df52478d 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -247,7 +247,11 @@ int mtk_drm_gem_prime_vmap(struct drm_gem_object *obj, struct iosys_map *map)
 
 	mtk_gem->kvaddr = vmap(mtk_gem->pages, npages, VM_MAP,
 			       pgprot_writecombine(PAGE_KERNEL));
-
+	if (!mtk_gem->kvaddr) {
+		kfree(sgt);
+		kfree(mtk_gem->pages);
+		return -ENOMEM;
+	}
 out:
 	kfree(sgt);
 	iosys_map_set_vaddr(map, mtk_gem->kvaddr);
-- 
2.40.1



