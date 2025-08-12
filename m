Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3995B260583;
	Tue, 12 Aug 2025 19:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025870; cv=none; b=YG5/GeZxJLPQyiEgsRutjqaUdvWmO7K/otpqsV4xqUhYRmsbpP7JuY1w/pgPZEW6bTJ68hmcBPvqU9sSliC9SW8xSTPPLucEKkOjMu14MCBGCoVrAI7UYlMTlR+x2x74mDAAU4lS6SxDzDRbdhEvwqTiU/+n5WPSMHAgsJ6ZZZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025870; c=relaxed/simple;
	bh=F1OBx+nR+eSLfnRwHF19LRoGMDRPkExIL3aX3de0LdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uoFOSmqAcHy2KIu/UQ0hcADTbXZiiinL8X/YX1MpXcLxU1VEx/05az4MOf7265eHvOruPOzqUMoiQn2GQ0lkdoiGtyt4qH7zAcWehc4DsB3vO+FJji0fVsogCCR4X7n0PyjN9lNIfQ/rCKqW5N5JocDjtxfQYv9v8gfSFxub/m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaMlD+yY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaMlD+yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B390EC4CEF0;
	Tue, 12 Aug 2025 19:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025870;
	bh=F1OBx+nR+eSLfnRwHF19LRoGMDRPkExIL3aX3de0LdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaMlD+yYfbb/Sh5RyJrg130kdpJ1aLOMtUI6o9rgwZQiFE+FtvbevSazmKBdl9RUm
	 SqeFZiEXw9YPQUB8rlUCojz5Eam/eDxmKnOJJcqvYTBOw99HnB1p1DcFFfrWUkiJjN
	 17TSl/iMFrcZ09OlPpJhLaiX2D4NrAT1Yd7zwHAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 168/480] drm/amdgpu/gfx9: fix kiq locking in KCQ reset
Date: Tue, 12 Aug 2025 19:46:16 +0200
Message-ID: <20250812174404.449981451@linuxfoundation.org>
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

[ Upstream commit 730ea5074dac1b105717316be5d9c18b09829385 ]

The ring test needs to be inside the lock.

Fixes: fdbd69486b46 ("drm/amdgpu/gfx9: wait for reset done before remap")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jiadong Zhu <Jiadong.Zhu@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index d725e2e230a3..59ea6e88bd9e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -7299,8 +7299,8 @@ static int gfx_v9_0_reset_kcq(struct amdgpu_ring *ring,
 	}
 	kiq->pmf->kiq_map_queues(kiq_ring, ring);
 	amdgpu_ring_commit(kiq_ring);
-	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r) {
 		DRM_ERROR("fail to remap queue\n");
 		return r;
-- 
2.39.5



