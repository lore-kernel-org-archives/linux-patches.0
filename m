Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622FF2882CE;
	Tue, 12 Aug 2025 19:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025873; cv=none; b=ZsS+SNZ1daB4CqnzVR3XYqoYnLWW21CNT1L3AKF7Wz9fzQf9Sxb39rhA7QJzF9F6ILiTTaHrSAJcfPuTrNW4EmQ3Ykgt/gBFpvP5bXkeka8aRSmxlNVAxZPOHiqfr7DBWwMRq8BbiJcCTFJrB1+4ulTKa5eGY7/fnkCvoWoZh/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025873; c=relaxed/simple;
	bh=hgbjKm8YfSmQyBWO4Oq9x0ePVgFDtuCZl9zbJVjq/wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LSC/Mm+kNOpFgkDqAu84hvDGzaQhk+1Yqv6bFp8kENuUSS8fWjxqpKIQ2wsCG9BUIMv9zWvIpIlJ+X4VGg5ajsmZpa97R4SVr8zkqmqEcfLKHCv5K9i0/mo5e2z7aAUQVxlgJR+dib0EwT0GEnYD5HlWRBaaADV/YTms6OtmJ0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2wKGMjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2wKGMjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDBFC4CEF0;
	Tue, 12 Aug 2025 19:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025873;
	bh=hgbjKm8YfSmQyBWO4Oq9x0ePVgFDtuCZl9zbJVjq/wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2wKGMjfnBKCLP/JGTtcDtGTxAX9zJB0fDImEepcmG2+uzOUD0JTetN0HBX+N8T6m
	 hbsUdqGvoU3ZfrDLxLDWP/Va7iR6//62/hzBUixhobiY4ebeycjwBHR7uBAx09jMOc
	 Ep4NH+G+RuMboSsOLPiQ/3w3dS1LJVEm2fw+tvs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 169/480] drm/amdgpu/gfx9.4.3: fix kiq locking in KCQ reset
Date: Tue, 12 Aug 2025 19:46:17 +0200
Message-ID: <20250812174404.490245598@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 08f116c59310728ea8b7e9dc3086569006c861cf ]

The ring test needs to be inside the lock.

Fixes: 4c953e53cc34 ("drm/amdgpu/gfx_9.4.3: wait for reset done before remap")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jiadong Zhu <Jiadong.Zhu@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index 53fbf6ca7cdb..c386b2f4cbcc 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -3572,9 +3572,8 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 	}
 	kiq->pmf->kiq_map_queues(kiq_ring, ring);
 	amdgpu_ring_commit(kiq_ring);
-	spin_unlock_irqrestore(&kiq->ring_lock, flags);
-
 	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r) {
 		dev_err(adev->dev, "fail to remap queue\n");
 		return r;
-- 
2.39.5



