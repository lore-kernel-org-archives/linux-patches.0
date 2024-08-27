Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592B31C578D;
	Tue, 27 Aug 2024 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770144; cv=none; b=uqrpqmu2c6nuanRVuYkCLQXLb+IxTqLRDbfMjJV+a9C7Gtp5MKXs23pEww3kOlsdXSmSCM84zg9xEXrWYreEso8aA+68SI4pKaCcXSMPguveUk+mCN1xXSuC2d97+6IQSr3ru8HpOUHNL18Np4WhwOPRKAva9toFwGJ5+YmcMFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770144; c=relaxed/simple;
	bh=ATtyuePT89OZPPFD5WAwa5dYeDiQw+wZZGFdIfBwXuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqPwzzM+L9WcSQDFTUb7kuswwMcLkTNjqZmF2K6ylpREsnu+W3/56Lc3s4fX+tilOIElj1IOlJoaTCwk7pUaOGL6Sk+RjjHxGT6eqbzAP/69XbPVV0rgI26GTWx9ppOBXfCgZKkNoOLE3JhHaAX95ipX03q7fy4oaL60ZNeGUfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyvQbgQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyvQbgQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC72C4AF0E;
	Tue, 27 Aug 2024 14:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770144;
	bh=ATtyuePT89OZPPFD5WAwa5dYeDiQw+wZZGFdIfBwXuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyvQbgQ+xTREptzJDUmtLURGCloLA1SdXEXwUKKQupAS8vR/ku0ACydaltEUoJKcB
	 K2A5d7Mzj8jB1WhDNt4IdI0FO/y2GS/MuJPxuc7wW2nSYLtCdkJlylMUVTd6J3LCTR
	 jU3zsc4tYEoR1mgoNF8j/vum9VuNvS4LAC3jGS44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/341] drm/msm: Reduce fallout of fence signaling vs reclaim hangs
Date: Tue, 27 Aug 2024 16:36:11 +0200
Message-ID: <20240827143848.747180385@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 4bea53b9c7c72fd12a0ceebe88a71723c0a514b8 ]

Until various PM devfreq/QoS and interconnect patches land, we could
potentially trigger reclaim from gpu scheduler thread, and under enough
memory pressure that could trigger a sort of deadlock.  Eventually the
wait will timeout and we'll move on to consider other GEM objects.  But
given that there is still a potential for deadlock/stalling, we should
reduce the timeout to contain the damage.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/568031/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_shrinker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_shrinker.c b/drivers/gpu/drm/msm/msm_gem_shrinker.c
index f38296ad87434..0641f5bb8649a 100644
--- a/drivers/gpu/drm/msm/msm_gem_shrinker.c
+++ b/drivers/gpu/drm/msm/msm_gem_shrinker.c
@@ -76,7 +76,7 @@ static bool
 wait_for_idle(struct drm_gem_object *obj)
 {
 	enum dma_resv_usage usage = dma_resv_usage_rw(true);
-	return dma_resv_wait_timeout(obj->resv, usage, false, 1000) > 0;
+	return dma_resv_wait_timeout(obj->resv, usage, false, 10) > 0;
 }
 
 static bool
-- 
2.43.0



