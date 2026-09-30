Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB94F51617E;
	Wed, 30 Sep 2026 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787617; cv=none; b=advWd11AVv8TpqCIeLqdtk7URxn4WHtu+koEab+PEt0rFaduqKL/ubxC95SdwPynKEekgqI4wlbsFUr0uBboMz1N7ZBHu0SGWyRA04FPYiZP21YEgLTWsg5cfvnxCRlIXfV9Wa5EPZJ9R7OQ9sd+3HdcjfdVGpv+f/xQqn/wuTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787617; c=relaxed/simple;
	bh=AhSHw44VONSSiPYkT52bGZO3qy/jpxZRpebKAWVdKGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF4D6FmpyZRYaeWRFEyjJoqg3zw4TsvkkwfQXXscB9fgkZXZrq0AAGAq9U8D9kXYhCzXWKQPCmm1giZ3j9djN3Uo9AtQf6+o/b+YqI+79ljxzNBCWlvSkzj9MByEaS9rWiC+kckFkHjRDTBR9xOEw8ZLEWgNr9mSeQbWiMoNlqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7Rep5Bp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7Rep5Bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208441F000FF;
	Wed, 30 Sep 2026 17:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787616;
	bh=feUdd3YZIJd63BmrZKkhkiJZOTiZ4o5s2ctQOW9ViyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7Rep5Bpw/K0Ks6D22tF1edZCjd4FQz35ldtpdz6XHk/k65b1g1qA3ol1yxP/8hiV
	 kwzC04kacn1sYYlawwApJ/I11RrxwNwT6uQcPaL2CgFBVWjzRtD7NB6/WWSr/IdMqa
	 o1Ba7CYzDiZRjmQfO7fNr98bulQ3MD3Pgdw33jEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 291/457] drm/amdgpu: Fix vmid_wait fence leak in amdgpu_ring_init()
Date: Wed, 30 Sep 2026 17:26:36 +0200
Message-ID: <20260930152352.314471669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -254,7 +254,6 @@ int amdgpu_ring_init(struct amdgpu_devic
 		ring->adev = adev;
 		ring->num_hw_submission = sched_hw_submission;
 		ring->sched_score = sched_score;
-		ring->vmid_wait = dma_fence_get_stub();
 
 		ring->idx = adev->num_rings++;
 		adev->rings[ring->idx] = ring;
@@ -374,6 +373,7 @@ int amdgpu_ring_init(struct amdgpu_devic
 
 	ring->max_dw = max_dw;
 	ring->hw_prio = hw_prio;
+	ring->vmid_wait = dma_fence_get_stub();
 
 	if (!ring->no_scheduler && ring->funcs->type < AMDGPU_HW_IP_NUM) {
 		hw_ip = ring->funcs->type;


