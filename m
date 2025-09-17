Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C7D2F361A;
	Wed, 17 Sep 2025 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113610; cv=none; b=Rn+FyeBlrITtebvwQ5LBdZl+Hhy88aAE2gIE2OjPoxLhuK3DlrmfwLm9OgT3PNJvwXiTCtekisTWq46iQ0FJ3i/l7Po3dtEnJkVrrP53N8N7S0SnyOOo4V9vVb1nK7bypGHF5dRYO1ZGhLjTbzU23R/2Oly5uR8a9Dve7gAH/4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113610; c=relaxed/simple;
	bh=uTgFQ6t8W8aSmgHaDZDaMq8L/UEe/Zg8zGn+FnHUnek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PfPuvdEhPgC77QhRw/CJmai/ZlunmIiC8hRTuV2lzee0UzjwgNnZE9EJ2JPeq7+TGauHd5yA1bq25UHXZ24w1360ahlxcuCCHby8JZjlUjOw62tIFkEFlosbQYKkvnMHaqy/u3RqrfiH2rorbioxfdL9qm5Rohv4km06EiplOJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDahmoQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDahmoQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AC3C4CEF5;
	Wed, 17 Sep 2025 12:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113610;
	bh=uTgFQ6t8W8aSmgHaDZDaMq8L/UEe/Zg8zGn+FnHUnek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDahmoQM0RTlc/wQqegLs7uXRuJmvBv5YOGPQyIalrhvfvCehCmBye8rZchRkPpXa
	 EdltDJ53Bi8w0AVGXBb6cSfgW/gA7LQjODAukLPazScFcpJpvj7HGdda6L4z6DYOEh
	 xDn+7tbLOQlviFhPSfK39qp5kwB4vff0PB3Bidug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/140] drm/amdgpu: fix a memory leak in fence cleanup when unloading
Date: Wed, 17 Sep 2025 14:35:12 +0200
Message-ID: <20250917123347.745396297@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

commit 7838fb5f119191403560eca2e23613380c0e425e upstream.

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
@@ -400,9 +400,6 @@ void amdgpu_ring_fini(struct amdgpu_ring
 	dma_fence_put(ring->vmid_wait);
 	ring->vmid_wait = NULL;
 	ring->me = 0;
-
-	if (!ring->is_mes_queue)
-		ring->adev->rings[ring->idx] = NULL;
 }
 
 /**


