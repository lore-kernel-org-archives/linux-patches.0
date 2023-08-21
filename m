Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89CF1170E
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3049CC433C8;
	Mon, 21 Aug 2023 19:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647437;
	bh=eYwNrDYQnkl2Ex8mL5fDXEkPQbrkYdeSzbVx/RL6+7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEjUXqFnp3LB5jFHnZ1sFjngeZAz/VmkZoR1l0Un5fA3h0UxBRysJWMCV45RhIsu4
	 Y5/xxGRWnKAHwsevrZhS/uHx5/pWQbiRBX1MyCtKheqJORc+fVku0r0qW8YHKdprnh
	 OKcnpwG8li0cN8dNt7Dj5kjkHFYsmdIaTrTUif6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/194] drm/amdgpu: fix memory leak in mes self test
Date: Mon, 21 Aug 2023 21:39:53 +0200
Message-ID: <20230821194123.372913760@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit 31d7c3a4fc3d312a0646990767647925d5bde540 ]

The fences associated with mes queue have to be freed
up during amdgpu_ring_fini.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index d3558c34d406c..296b2d5976af7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -361,6 +361,8 @@ void amdgpu_ring_fini(struct amdgpu_ring *ring)
 		amdgpu_bo_free_kernel(&ring->ring_obj,
 				      &ring->gpu_addr,
 				      (void **)&ring->ring);
+	} else {
+		kfree(ring->fence_drv.fences);
 	}
 
 	dma_fence_put(ring->vmid_wait);
-- 
2.40.1



