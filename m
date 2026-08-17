Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CA941F5EA;
	Mon, 17 Aug 2026 14:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977221; cv=none; b=hjaKDeKdBSczpEeinQVZ3aFzIYcpSgZotuYYpm4OQ6BeOQriJfvGT1w8If6Iywa6IxrFGFJouA8IJYfH7Hw3/rqLfLK95KDEWeq1ykxT5KIOFJas5KNxpi49wl8WA5XcWqM9Hi28UJThTrpE5SGbLStZrQc11xMmm3xHWLVsBgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977221; c=relaxed/simple;
	bh=1u6AZmJOYoanY4mxV1UUhAIN2N8sX4ET6QDsRmiTxeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy2ddj4ZS1ueNV1xzx8F4O1HeDmS+JtEIQPCYrRpROCbJBaIpQZVN8hXfKn9PBpRdhZEhhPIUhSO64CQeQecDZB+7VOojgNNnAq927HwWse3CMcQtwXNjTxgwT2GsTUN26hUtdjwG/EMexLjZ8jUFu79CWJc63P76l08P0QzWH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHrUpqDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHrUpqDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FA61F000E9;
	Mon, 17 Aug 2026 14:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977220;
	bh=ZgWTh49Z8a98Xp5MKzcbIeuiSjqfMqkR9xiwJEws7Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHrUpqDOgat/VW8L8yNXk6E1TkffSVnZnmgHhDh5spDGd8kyson1OQFYRWq2K5qVl
	 aOpaiCfWv711bDYV0wOJzCqK67flL2fBCS26OBv/J0ADr65KQvrESw7z7oCblcbTvH
	 +xPcLp1hXn3q9rPTsnEEPY6KsOJyENtXMq5cAJjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/456] drm/mediatek: Check CRTC state before freeing
Date: Mon, 17 Aug 2026 15:30:44 +0200
Message-ID: <20260817132549.984697246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 233a4d3a39fc1585f5e271b2adab43c6af025ae0 ]

mtk_crtc_reset() destroys the current CRTC state only when crtc->state
is non-NULL, but it always converts crtc->state to struct mtk_crtc_state
and passes the result to kfree().

When reset is called without an existing state, container_of(NULL, ...)
does not produce NULL. Keep the mtk state free in the same crtc->state
guard as the helper state destruction.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 2d267b81898e ("drm/mtk: Use __drm_atomic_helper_crtc_reset")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260707150528.2270739-1-ruoyuw560@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 27f3e91425580..993c5743192b3 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -172,10 +172,10 @@ static void mtk_drm_crtc_reset(struct drm_crtc *crtc)
 {
 	struct mtk_crtc_state *state;
 
-	if (crtc->state)
+	if (crtc->state) {
 		__drm_atomic_helper_crtc_destroy_state(crtc->state);
-
-	kfree(to_mtk_crtc_state(crtc->state));
+		kfree(to_mtk_crtc_state(crtc->state));
+	}
 	crtc->state = NULL;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-- 
2.53.0



