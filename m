Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD817AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEBEC433C9;
	Wed,  9 Aug 2023 11:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580875;
	bh=Ih7jwljwqF7FHpCt1QpekAWEWE+1zbGA+JXF/GwXh9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piNPcD1AMFa81ER4QiJnlAKS3cAxyylpnwR9M0ph6wSE/16GJucUOovrTyS/cSXqY
	 hJI8hAf1OiS9LOx8JvGcr+r5a+yx7SqH0xXt6mWI/eECc9pvW7fpNrIMP/m4hpS/bn
	 UaAkiX2mmXV6XQjjz9gDCgeU+174g699B8slndNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pelloux-Prayer, Pierre-Eric" <Pierre-eric.Pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Pelloux-Prayer
Subject: [PATCH 5.10 018/201] drm/ttm: never consider pinned BOs for eviction&swap
Date: Wed,  9 Aug 2023 12:40:20 +0200
Message-ID: <20230809103644.436934371@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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
index 9a05caec3c996..dca4dfdd332d3 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -672,6 +672,12 @@ static bool ttm_bo_evict_swapout_allowable(struct ttm_buffer_object *bo,
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
 		if (ctx->flags & TTM_OPT_FLAG_ALLOW_RES_EVICT)
-- 
2.39.2



