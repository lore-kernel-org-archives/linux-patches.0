Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F1D32E731;
	Wed, 17 Sep 2025 12:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113944; cv=none; b=qBOZR+KFvkY0E9vYytz7J8GPteYuAAk7lbAS+fp15HhihIOC0KPpY5XVyvYrEazBFLDMlxWcQ7nSVIA24pKRaBhfT3AriMmP9MtTOKtVKcl80K9ks4D64nVsZpWTiDpw4oPUSK51Y9H75SQhMPIjtkc76YKoZvzYiZheK3L0isU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113944; c=relaxed/simple;
	bh=Mh1L/KrHGLRNDBTJQxsPh2iY69nczT4j0+XCUYoU0Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gd5IIyNL5EcgkUiqL3imqLKjn0mwjk+4ulbukOUD64s3pgCLPAm0FJUFkWdC6bm4CIHd0DNzhRp1QOzl2S/z2L12Ay80usYo9xVBF8sh9JRf01eaUPWM4Of7ZDwQinJnjy0qx4cUY8pc/kKis896CMSk2fpxe4gscLxyCMqLXIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm5I1dnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm5I1dnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7143C4CEF0;
	Wed, 17 Sep 2025 12:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113944;
	bh=Mh1L/KrHGLRNDBTJQxsPh2iY69nczT4j0+XCUYoU0Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xm5I1dnnKuhg8Tz9sXI+648QUgkbpZEmbLRDRP222AGJcU1c8RQcUDAGV6ajwYriG
	 sHzqY3qk/y/24/DQlajPxNMy8z91Zdnu5XRm2bpglsD0HS8/hGOWvLOWGzSRT5I+ef
	 l8ytR2VSYb2WfHaMVdoLP1ObB91JKX3r5s/XCoAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/101] drm/amdgpu: fix a memory leak in fence cleanup when unloading
Date: Wed, 17 Sep 2025 14:35:23 +0200
Message-ID: <20250917123339.245422525@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -396,9 +396,6 @@ void amdgpu_ring_fini(struct amdgpu_ring
 	dma_fence_put(ring->vmid_wait);
 	ring->vmid_wait = NULL;
 	ring->me = 0;
-
-	if (!ring->is_mes_queue)
-		ring->adev->rings[ring->idx] = NULL;
 }
 
 /**


