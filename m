Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA0D3A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2j3hRZYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31398C433C8;
	Wed, 15 Nov 2023 19:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077372;
	bh=sEI0SMAA/ghzqjjVL4ADxakBvJZ0YSzw6MJhKbnWD/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2j3hRZYCIVhmwDvFyPEBg1TqQVmEz3iqAjxgp0hwUNekfyyoiTI50tH0mGZ4ZAR7k
	 lR7zR+YgFtOD1TSWBsh5TEjIhzOcgmZs77lHVUIywRcWAHlsiDWyGLwi859S2L3ISR
	 xXO0CecD0Frq7jBKtt6D1saS1TG0sb7xrd5AXVlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 261/603] drm/rockchip: Fix type promotion bug in rockchip_gem_iommu_map()
Date: Wed, 15 Nov 2023 14:13:26 -0500
Message-ID: <20231115191631.376859194@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6471da5ee311d53ef46eebcb7725bc94266cc0cf ]

The "ret" variable is declared as ssize_t and it can hold negative error
codes but the "rk_obj->base.size" variable is type size_t.  This means
that when we compare them, they are both type promoted to size_t and the
negative error code becomes a high unsigned value and is treated as
success.  Add a cast to fix this.

Fixes: 38f993b7c59e ("drm/rockchip: Do not use DMA mapping API if attached to IOMMU domain")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/2bfa28b5-145d-4b9e-a18a-98819dd686ce@moroto.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
index b8f8b45ebf594..93ed841f5dcea 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -40,7 +40,7 @@ static int rockchip_gem_iommu_map(struct rockchip_gem_object *rk_obj)
 
 	ret = iommu_map_sgtable(private->domain, rk_obj->dma_addr, rk_obj->sgt,
 				prot);
-	if (ret < rk_obj->base.size) {
+	if (ret < (ssize_t)rk_obj->base.size) {
 		DRM_ERROR("failed to map buffer: size=%zd request_size=%zd\n",
 			  ret, rk_obj->base.size);
 		ret = -ENOMEM;
-- 
2.42.0



