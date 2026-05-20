Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767A136A357;
	Wed, 20 May 2026 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295270; cv=none; b=e2EtRji56GjW5V5YyO26EVxTxzPHY3vUn03DrjsGSQqCOU36J25reysSI4Zk7buz87tXdzwMAcYYVStTr8AoiU4sSvS648qsAu6pygyVGM6bxehLh3N/8HcOFaqAasWIGyG0B2+LlJUqIXBwqyf0AdTWXoP7yV0N5CtX7dN7yUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295270; c=relaxed/simple;
	bh=Bfdy6274z0RnlzblHJ++X3P+v5pavGJhh6QMuNol+uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJw3hGTApLsQQ0kjGVt6odHaFbtQUyxuHJFehhE9ih9DHHYOAbzD5x+dISrmRlZn/massASUyXCnXUyJYVOMSKwMuv04E/X91MjnyKcUemOLUNOaMuH14wtTW62T1SyHZtsC6I8CNbYOOh/4mNz83MUmVRx2jlGN/uBoy1Q5qcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWVq1CHp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWVq1CHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38261F000E9;
	Wed, 20 May 2026 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295269;
	bh=6iBVLFNXuuI1yAj5mkkGN2Rm0SjAIOmlzgkbqO/kFxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWVq1CHprPRQLXKt5ItxNo/lgxCRbnV6D7mjKS7zAlPNq4urzlqGAOg7izgCt5LfN
	 jypeHCvBtCaZKPx2ynGSp/BdaOrffR2vyHBb55GH7XyjlSYP5neVCquduVe5Dx78wX
	 moqx86gBD6bYaZw8086u3yyvpCD0vIQ1IOfi5ra8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0356/1146] drm/msm/shrinker: Fix can_block() logic
Date: Wed, 20 May 2026 18:10:06 +0200
Message-ID: <20260520162156.258434025@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 1039e3c0a47bf..31fa51a44f86e 100644
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



