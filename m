Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B933C4CEE53;
	Wed, 30 Sep 2026 18:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793411; cv=none; b=Cs5gg2ucMbPlmyhVYBEdSe+MGqxK4+DqqgB5oxy2SGy++Bm6Tnn4E6phx7rtcQj6lPYcyXPHLiKAR/LGOtL/HLoNEi5VPgTyLF9b079A6tOQ3ooVd+PSPFJ/FoeD0pTpcH/pDRZMFIqp8wfur5U7mKfg2/rjrRUanKzxZyGWt1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793411; c=relaxed/simple;
	bh=bbji+gsgVck4dowcWAc7K0iA9HylXEnh5rjubznm+LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT0gvcAiQoKSCudQN34f8T8eOxKwSD7TfqLJbLVkXhJW5m8LMr/E8hpTCXX49y2yzEqSg7JCpcBM84GdILL1G3F4KOGgsAQtQS1W/YZrV4gbmQ9F0tYaCMoi1cuiAp/ggKzwWF1PvzGJkM0O85+UMfOjPva1s0eOAo0iUN2CSKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09ZS/4aR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09ZS/4aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2165B1F000FF;
	Wed, 30 Sep 2026 18:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793409;
	bh=lG/wEg4cyiABpyF84bP/Uo9pKOkHFIbS8dElUfIAMY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09ZS/4aR8Frzy5ixEvF3EPPwxoEcZv3O6WfAWJH7jlCO3p3d6O0MPJaUrnOyPIeCW
	 8gzzFP/SazU93pAXrRe+EUHo+IpxX12aN7k5PaF9gy8vWRXuf83jcRMXPpKXxNfhdo
	 jhXVSVL78RyGOcZ+ciuzX8jpN1I7kM3Y5c81lbFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 245/395] drm/amdgpu: Fix vmid_wait fence leak in amdgpu_ring_init()
Date: Wed, 30 Sep 2026 17:28:27 +0200
Message-ID: <20260930152345.969598261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit aea841bc62a76242396610d22d8ff40c13065f64 upstream.

amdgpu_ring_init() initializes ring->vmid_wait with a reference to the
stub fence taken via dma_fence_get_stub().  When a later step of the
initialization fails, e.g. amdgpu_fence_driver_init_ring(), a writeback
slot allocation or the ring buffer allocation, the function returns an
error without releasing the stub fence reference and the reference is
leaked if the ring is torn down without amdgpu_ring_fini().

Move the stub fence assignment to the end of the initialization, right
before the ring is registered with the GPU scheduler, where no further
failure is possible.  The stub fence is only consumed by command
submission handling in amdgpu_ids.c once the ring is up and running, so
nothing reads it during the error-prone part of the initialization.

Fixes: 48e9fbd1a284 ("drm/amdgpu: initialize the vmid_wait with the stub fence")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f2b96986851203e9c50ca0d13aaa3581ca3e8ebd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -260,7 +260,6 @@ int amdgpu_ring_init(struct amdgpu_devic
 		ring->adev = adev;
 		ring->num_hw_submission = sched_hw_submission;
 		ring->sched_score = sched_score;
-		ring->vmid_wait = dma_fence_get_stub();
 
 		ring->idx = adev->num_rings++;
 		adev->rings[ring->idx] = ring;
@@ -380,6 +379,7 @@ int amdgpu_ring_init(struct amdgpu_devic
 
 	ring->max_dw = max_dw;
 	ring->hw_prio = hw_prio;
+	ring->vmid_wait = dma_fence_get_stub();
 
 	if (!ring->no_scheduler && ring->funcs->type < AMDGPU_HW_IP_NUM) {
 		hw_ip = ring->funcs->type;


