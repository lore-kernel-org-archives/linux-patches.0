Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B00A3FB060;
	Wed, 20 May 2026 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300484; cv=none; b=kSPI/VfyRzTT6zVHnPWhhzSmfNX8rWJdUWvSsxltt9RY81E2lMSfPYNvbzn/KlO3dij6F0uE/2QRjSXTOt2C8vR++BVnEIXc5IFX9fnJVWy3uet2cwHLjCUZzpUw3jH9vntjJO2NS9WV9kLL7pG/U8DvR/tGZp/FemH8NEhv6T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300484; c=relaxed/simple;
	bh=BqAlOKuyrjrwOm2g/cjMiAbpe2uF8PJlrATHQJafH6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THqlPNH9xekD02n7VVEF72brTpj9dMZj02AC++raQnhNNIlzYQQGqsUyIE28UvDefqbi0tp1MYTLCNXv+kKfQ6cHF+t4PudiT5UwII8YqqOnzRwC4Awzqd+m290u0/O5ybZ/Zm25LIi0uHxGJTRbQ2kP3EIlqzrJTTnNiz+DP20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/K3GGCi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/K3GGCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54301F000E9;
	Wed, 20 May 2026 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300483;
	bh=TC1oIZCyxhLVcJR1Eq8d4IlPY/oPKOWq7+GYtnOCS/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/K3GGCiikYN/kLUiSrfC//Jp38HAPRjuBVZCXmeRxyqGcG5DDECdy9xHhRe42cqT
	 N0EVS94M3Zerps+/0Wj378+DYDlfxuAAMucfw/lE+r2iR1LCbP6HEoouXvMbL6VKGX
	 vQwyEOjLHOpeGn3dqQlbPsXH1hXqyxpUCwn6dOEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/666] drm/msm/shrinker: Fix can_block() logic
Date: Wed, 20 May 2026 18:16:43 +0200
Message-ID: <20260520162115.362087197@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit df0f439e3926817cf577ca6272aad68468ff7624 ]

The intention here was to allow blocking if DIRECT_RECLAIM or if called
from kswapd and KSWAPD_RECLAIM is set.

Reported by Claude code review: https://lore.gitlab.freedesktop.org/drm-ai-reviews/review-patch9-20260309151119.290217-10-boris.brezillon@collabora.com/ on a panthor patch which had copied similar logic.

Reported-by: Boris Brezillon <boris.brezillon@collabora.com>
Fixes: 7860d720a84c ("drm/msm: Fix build break with recent mm tree")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Patchwork: https://patchwork.freedesktop.org/patch/714238/
Message-ID: <20260325184106.1259528-1-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_shrinker.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_shrinker.c b/drivers/gpu/drm/msm/msm_gem_shrinker.c
index 07ca4ddfe4e37..89c0ea8ddeaac 100644
--- a/drivers/gpu/drm/msm/msm_gem_shrinker.c
+++ b/drivers/gpu/drm/msm/msm_gem_shrinker.c
@@ -26,9 +26,8 @@ static bool can_swap(void)
 
 static bool can_block(struct shrink_control *sc)
 {
-	if (!(sc->gfp_mask & __GFP_DIRECT_RECLAIM))
-		return false;
-	return current_is_kswapd() || (sc->gfp_mask & __GFP_RECLAIM);
+	return (sc->gfp_mask & __GFP_DIRECT_RECLAIM) ||
+	       (current_is_kswapd() && (sc->gfp_mask & __GFP_KSWAPD_RECLAIM));
 }
 
 static unsigned long
-- 
2.53.0



