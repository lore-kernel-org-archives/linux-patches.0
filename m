Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650ED282E1;
	Tue, 12 Aug 2025 18:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022292; cv=none; b=b9EDQwYsTq19/t2Kd32BUn6J5FAUHSvWpb+rNFB6iSuXgeLbGDb1z1q2m5VyUli9se3xH9dIXueWUs0StkB9vlZyRGxu+UDQ33foA2P6t6G9XeCdSAx2g4s5BaGxLx9rIHrkJ1XlTMADq0T5pswJgk0xT2FE5qLQSEZwxVjSh0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022292; c=relaxed/simple;
	bh=NZ3l61PZEE1aiw2X679Ql84QjNUAF5/6tfIUQqE0Li0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckg0QTd4cGFvIyzVsr7Bbuicg5kj1y8MFLvbZkPvFBPGtoTjgNuacA5cnJgJC2WDOUAg3n8/Z6slx69/KGkk7JZH87n1zTgkXqnX5wZleLBdyPAtdVYOObgusQ7HaZP3ohNsrMQZmNqpMdV1GUc1B3qhRLNEBCM2YOQpPKqc8jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hb7TmIZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hb7TmIZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B83C4CEF0;
	Tue, 12 Aug 2025 18:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022292;
	bh=NZ3l61PZEE1aiw2X679Ql84QjNUAF5/6tfIUQqE0Li0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hb7TmIZyNUdAhNiZz3mM8i0bEejkiSjmPqwzlhGrdb31r2gQ6BKod1DYbujppTQHc
	 ROQQ1DzSp9YglcwzBp85YhhaXKjOTq7nrarzbkURDRmAr6RQqLAIVn26Z0UohhMwGL
	 W7xmPmTgf+10lSIkQlEjdVWACjzrMHr4pliO/fGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/369] drm/amdgpu/gfx9: fix kiq locking in KCQ reset
Date: Tue, 12 Aug 2025 19:26:50 +0200
Message-ID: <20250812173019.023597167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 114653a0b570..91af1adbf5e8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -7318,8 +7318,8 @@ static int gfx_v9_0_reset_kcq(struct amdgpu_ring *ring,
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



