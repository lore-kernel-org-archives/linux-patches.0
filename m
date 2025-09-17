Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FA630CB39;
	Wed, 17 Sep 2025 13:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114218; cv=none; b=k0kTnI2FhbJU/yTecz+WI1MqCTJ8cat7DE8sJ8Jwz2Jg8g34oyJQCHgTrNReSJOEQJ5RMgIHyUrIHUooec3IV9tg5uF0eZ2H1aAzx7T91dnqZd/O3tFd46zgyVZnlJEzBzMF6zSUPQOUlUZCE3lhOiyGHykWcZS1+GqvY8XRnv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114218; c=relaxed/simple;
	bh=BIqZLJju64m1tTSKnQAE1ZaNu5spdrWiAcFvWtsrMjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+kPriLqOxRgFNqMXLFUBlwHPnr342cA81K/kg9dOk3XeDQzAva7TC3SuYoD5uB233RIANWk2wKlUjJ4o0STAfDuGpCuW341CTFYOVWjyQrme6RflLJYkhRzrt5/arFNohR3ETDo2kBxg465gMbxxRP+PDDOLjDpQw+05yZ5v0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuxiUFJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuxiUFJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54ADC4CEF0;
	Wed, 17 Sep 2025 13:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114218;
	bh=BIqZLJju64m1tTSKnQAE1ZaNu5spdrWiAcFvWtsrMjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuxiUFJHAvd66bxOlGwz/CjIuiLtDOpZ0u39yuQ7Fd+PJfbnJ/h9s+HQSmqyAN64C
	 eQjqAgsBIqfbJBvwHquofOYj9MPIxMs38l1UEfBB/emk5EmCsJq1HWDIMMFlKZ2wkx
	 zvJJmDVNhQlJomQEOdV18l7e/7qMl10ClQdY0HS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 75/78] drm/amdgpu: fix a memory leak in fence cleanup when unloading
Date: Wed, 17 Sep 2025 14:35:36 +0200
Message-ID: <20250917123331.416162682@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 7838fb5f119191403560eca2e23613380c0e425e ]

Commit b61badd20b44 ("drm/amdgpu: fix usage slab after free")
reordered when amdgpu_fence_driver_sw_fini() was called after
that patch, amdgpu_fence_driver_sw_fini() effectively became
a no-op as the sched entities we never freed because the
ring pointers were already set to NULL.  Remove the NULL
setting.

Reported-by: Lin.Cao <lincao12@amd.com>
Cc: Vitaly Prosyak <vitaly.prosyak@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Fixes: b61badd20b44 ("drm/amdgpu: fix usage slab after free")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a525fa37aac36c4591cc8b07ae8957862415fbd5)
Cc: stable@vger.kernel.org
[ Adapt to conditional check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -368,9 +368,6 @@ void amdgpu_ring_fini(struct amdgpu_ring
 	dma_fence_put(ring->vmid_wait);
 	ring->vmid_wait = NULL;
 	ring->me = 0;
-
-	if (!ring->is_mes_queue)
-		ring->adev->rings[ring->idx] = NULL;
 }
 
 /**


