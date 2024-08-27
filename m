Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945051C4EDD;
	Tue, 27 Aug 2024 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772222; cv=none; b=Z0XPUxEJbYRfWBxAvxsrSjFu8z+EMMON92Qi11D2N8k+gYQj7TRTYcImHAUjB+AusYMmxmyvkcM1ju5HqEKuPuilfXXiFeDdaRE9O5kaJOVVkQptK/3vkWQfi5i3hoTCyabVjTWKAR50LuDScBMopoyLZimrdqcRdMPXGQwitBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772222; c=relaxed/simple;
	bh=6DQPxvNU43e3ul66GNl32/NOOOKiHdnygOnQlbloqiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMYik+SJJyzLcKso1Ihw/Z+dlPbo9a0wXSxBm9JGYCCshHN2SwkPqOIZ8m9BxWcOoC6NMzFQEPdBdsBRCyteZYhdI2eVK5CIM+EkNrlf5EHG9Z5RV5MiN/AvCIhbjYXxcbbkJfjTTqbgyacvqyZFImXX6uVPedqzV+4IMUjRirE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6Yyy/Sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6Yyy/Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F0FC61062;
	Tue, 27 Aug 2024 15:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772221;
	bh=6DQPxvNU43e3ul66GNl32/NOOOKiHdnygOnQlbloqiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6Yyy/Syp4g8ljAAFHb6lzsFcscEtd5vH8OVezPXOCGDiS10TfOeZUD8Uif8B+j0p
	 dR6uk+eWwYcbX/eUvrHsF7I5BvtaYw8VCh4vspn+/dRN/HX15O6oXv0/MFlaGsbnby
	 VV/oB0Ih4kmWWIt5fEEYn6aU016LhFYgfGN4qfl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/321] drm/msm: Reduce fallout of fence signaling vs reclaim hangs
Date: Tue, 27 Aug 2024 16:37:38 +0200
Message-ID: <20240827143843.945918438@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 31f054c903a43..a35c98306f1e5 100644
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



