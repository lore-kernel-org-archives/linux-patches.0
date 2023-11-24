Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A77E381D4;
	Fri, 24 Nov 2023 18:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rb3epQTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC2BC433C8;
	Fri, 24 Nov 2023 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850329;
	bh=RD0jKt94bLZsgzd91+2LY/UANdEO4uS166WrUpP0S6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rb3epQTEC3BD7HzC3ywhKNqQKkCj5PoNhS0iowfDHi1jRH+DXshkM507mIhJJfHvM
	 vqHnnvLXicrQtpWCACOgspTleq6mpGdVeh9/UpbAAoS/vpvyD7clPTV0rk3Dax6udt
	 nL3agvxZ+owYn70pH5p0T+Rviz78iFR+rOiFdG8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>
Subject: [PATCH 6.6 518/530] drm/amdgpu: fix GRBM read timeout when do mes_self_test
Date: Fri, 24 Nov 2023 17:51:24 +0000
Message-ID: <20231124172043.955737625@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Tim Huang <Tim.Huang@amd.com>

commit 36e7ff5c13cb15cb7b06c76d42bb76cbf6b7ea75 upstream.

Use a proper MEID to make sure the CP_HQD_* and CP_GFX_HQD_* registers
can be touched when initialize the compute and gfx mqd in mes_self_test.
Otherwise, we expect no response from CP and an GRBM eventual timeout.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -556,8 +556,20 @@ static void amdgpu_mes_queue_init_mqd(st
 	mqd_prop.hqd_queue_priority = p->hqd_queue_priority;
 	mqd_prop.hqd_active = false;
 
+	if (p->queue_type == AMDGPU_RING_TYPE_GFX ||
+	    p->queue_type == AMDGPU_RING_TYPE_COMPUTE) {
+		mutex_lock(&adev->srbm_mutex);
+		amdgpu_gfx_select_me_pipe_q(adev, p->ring->me, p->ring->pipe, 0, 0, 0);
+	}
+
 	mqd_mgr->init_mqd(adev, q->mqd_cpu_ptr, &mqd_prop);
 
+	if (p->queue_type == AMDGPU_RING_TYPE_GFX ||
+	    p->queue_type == AMDGPU_RING_TYPE_COMPUTE) {
+		amdgpu_gfx_select_me_pipe_q(adev, 0, 0, 0, 0, 0);
+		mutex_unlock(&adev->srbm_mutex);
+	}
+
 	amdgpu_bo_unreserve(q->mqd_obj);
 }
 
@@ -993,9 +1005,13 @@ int amdgpu_mes_add_ring(struct amdgpu_de
 	switch (queue_type) {
 	case AMDGPU_RING_TYPE_GFX:
 		ring->funcs = adev->gfx.gfx_ring[0].funcs;
+		ring->me = adev->gfx.gfx_ring[0].me;
+		ring->pipe = adev->gfx.gfx_ring[0].pipe;
 		break;
 	case AMDGPU_RING_TYPE_COMPUTE:
 		ring->funcs = adev->gfx.compute_ring[0].funcs;
+		ring->me = adev->gfx.compute_ring[0].me;
+		ring->pipe = adev->gfx.compute_ring[0].pipe;
 		break;
 	case AMDGPU_RING_TYPE_SDMA:
 		ring->funcs = adev->sdma.instance[0].ring.funcs;


