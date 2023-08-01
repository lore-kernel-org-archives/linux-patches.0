Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56701F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28229C433C7;
	Tue,  1 Aug 2023 09:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881776;
	bh=GNdKgJxuowbyAv/D/vRL51PkOhBjmxl8r1fYHYUh01c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiDbRD2NGULD288Vnx3Gp2dZ7EqcBB2VOxKxICCLRIubwFIMwj9cp9qngMcOF7e8G
	 BMK2GkaVIIVgr3mEqeHwNaGL6ddlbpl0Pg/1tIpzoZBYRZBsxxi6UA53Ef1l6gi7J4
	 eobGOBQcHlF0YixJLL/tpiP+blMweEfbS0NcnMYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pelloux-Prayer, Pierre-Eric" <Pierre-eric.Pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Pelloux-Prayer
Subject: [PATCH 5.15 026/155] drm/ttm: never consider pinned BOs for eviction&swap
Date: Tue,  1 Aug 2023 11:18:58 +0200
Message-ID: <20230801091911.133834346@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

[ Upstream commit a2848d08742c8e8494675892c02c0d22acbe3cf8 ]

There is a small window where we have already incremented the pin count
but not yet moved the bo from the lru to the pinned list.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reported-by: Pelloux-Prayer, Pierre-Eric <Pierre-eric.Pelloux-prayer@amd.com>
Tested-by: Pelloux-Prayer, Pierre-Eric <Pierre-eric.Pelloux-prayer@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20230707120826.3701-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 6080f4b5c450c..4d0ef5ab25319 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -604,6 +604,12 @@ static bool ttm_bo_evict_swapout_allowable(struct ttm_buffer_object *bo,
 {
 	bool ret = false;
 
+	if (bo->pin_count) {
+		*locked = false;
+		*busy = false;
+		return false;
+	}
+
 	if (bo->base.resv == ctx->resv) {
 		dma_resv_assert_held(bo->base.resv);
 		if (ctx->allow_res_evict)
-- 
2.39.2



