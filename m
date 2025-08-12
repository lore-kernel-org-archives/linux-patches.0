Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8E12FF143;
	Tue, 12 Aug 2025 18:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023947; cv=none; b=FKyJ/Ydz3R4Ma1Ig5HtK+QE3CXZjY6GVyLKcdFKpc/kBib7BLebAhFqZpHNW/XjDi4KWXpm5Td8E5D1GpynJxEMRrKNigvBtudLmsK2iIA6nrew8N9nfdL+46F6hiuxtZGHV1dTDnXWSJG9h3LiPPa/m8eJXhOYFERsBun0REQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023947; c=relaxed/simple;
	bh=AWEc45cdnKpS8h1bPb89EyDcABTD9owMPFb4kFKEm60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h8Zk1P+/WPFpOQWXbueZ0jNPie0Bz/WJq/PfoXWR91UC8BzB5RQLi61MNKTOeV5GiUG/fM/kfjT8sZkx/WFW4WUld3agr8Y5RNPCUTK+SHNTe03cSDGvoBfIn0NZ0OrDXborkIcXvwNIEibFx1oqeneqtARZWxH/c4O0FKqXPXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdrehX3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdrehX3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69374C4CEF1;
	Tue, 12 Aug 2025 18:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023947;
	bh=AWEc45cdnKpS8h1bPb89EyDcABTD9owMPFb4kFKEm60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdrehX3Qj/+v42jzcP1SP/xQ1MrFY+ddbmmTZOzIFqVh4rqFKjhnyEIDtXGDUNuVs
	 hmWMuF59jwpPU+aQRRayD1nWN7M2bb0zeJvAmeOTuDTfDdQdKar5Y2AveBdf/Aovzv
	 awNIfTMrHWglO8hxWo3zeqhJwxL5u3slHgVnNBIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 228/627] drm/amdgpu/gfx9: fix kiq locking in KCQ reset
Date: Tue, 12 Aug 2025 19:28:43 +0200
Message-ID: <20250812173427.963041251@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 23f998181561..f768c407771a 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -7280,8 +7280,8 @@ static int gfx_v9_0_reset_kcq(struct amdgpu_ring *ring,
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



