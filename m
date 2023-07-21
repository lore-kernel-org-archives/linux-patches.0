Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE00A1F942
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D91CC433CA;
	Fri, 21 Jul 2023 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956498;
	bh=ViVK/A1ivXTOnHA73U5uv1cUvjuK/tk1XdW8eHlOPEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajNgj4iVg2TmFLLYRVVYpXc8F+chTat5zUZJZZycgrNrPB6EgmspaPWZdg+Z05srN
	 HrMaPD6RYk4O45fsTlQLXDiMFmvrmGhlDPybkKErR77DY+5vnSJzqkrTi74u2B1PJm
	 mlSviPF6HzI8B/UHH9bLQ0xiSJzvE7SSszckHBW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pelloux-Prayer, Pierre-Eric" <Pierre-eric.Pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Pelloux-Prayer
Subject: [PATCH 6.4 213/292] drm/ttm: never consider pinned BOs for eviction&swap
Date: Fri, 21 Jul 2023 18:05:22 +0200
Message-ID: <20230721160538.025887603@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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

commit a2848d08742c8e8494675892c02c0d22acbe3cf8 upstream.

There is a small window where we have already incremented the pin count
but not yet moved the bo from the lru to the pinned list.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reported-by: Pelloux-Prayer, Pierre-Eric <Pierre-eric.Pelloux-prayer@amd.com>
Tested-by: Pelloux-Prayer, Pierre-Eric <Pierre-eric.Pelloux-prayer@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20230707120826.3701-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -517,6 +517,12 @@ static bool ttm_bo_evict_swapout_allowab
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


