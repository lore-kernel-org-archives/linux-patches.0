Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3931B51357D;
	Wed, 30 Sep 2026 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786663; cv=none; b=UAu6SfOCHZROg/j3O4HjVVDPawi+5JTSvHE0ujw1QjaQS+5ScAuMrWxGJl5XPouP4nWR0JGMEZlqPYCb+Tzt7xV/3p52bpqv4LqpWVExrNr8pgQkDlmiFly95jbIFyYA7zsiKEOD/+IYe+HvgBjZcpSAaP588JR2fUyHLW8sHTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786663; c=relaxed/simple;
	bh=rtLJBJWwl1m/AAEaUhVtxhus9vwIVdV0rbTJeGyMzgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4tZG9UtFbEI6AqUpuWpY82jB+fR9BXtbULVZ87qmqMyGsP+QUMA20NPLVlgZeJmmCwfKJ7gZ+BWw7S5Rpm/BPw0bKgQXryYnybcRkoxpC20U3IMVwfjGqEAkw+RFtiDu8WH/rO+KXI6YXBhWPi1b5jpfu4xfQW8SCkFkBMbhzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUU3iVjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUU3iVjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926DE1F000FF;
	Wed, 30 Sep 2026 16:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786662;
	bh=EFATSCfaMVDHJNzME99FA5p0xvtD9PV7aC5Y3VwhwYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUU3iVjWDzn7a0R1E8H8Bhgxnmg5VykRvSyRj91cP2zjIE0wCC71hpFON5lcWy7Jr
	 YWdFae8S7ETeNZQcPTwucvhNQOU4v6XpZpvAK81FTLrprwxozK1atz4XhpOawwpJMS
	 ZFJP1pY/xjC6sr5SBznV519w/5hUpZfm8NUf2bsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 942/982] drm/amdgpu: Fix vmid_wait fence leak in amdgpu_ring_init()
Date: Wed, 30 Sep 2026 17:27:58 +0200
Message-ID: <20260930152436.972467740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -201,7 +201,6 @@ int amdgpu_ring_init(struct amdgpu_devic
 		ring->adev = adev;
 		ring->num_hw_submission = sched_hw_submission;
 		ring->sched_score = sched_score;
-		ring->vmid_wait = dma_fence_get_stub();
 
 		if (!ring->is_mes_queue) {
 			ring->idx = adev->num_rings++;
@@ -323,6 +322,7 @@ int amdgpu_ring_init(struct amdgpu_devic
 
 	ring->max_dw = max_dw;
 	ring->hw_prio = hw_prio;
+	ring->vmid_wait = dma_fence_get_stub();
 
 	if (!ring->no_scheduler && ring->funcs->type < AMDGPU_HW_IP_NUM) {
 		hw_ip = ring->funcs->type;


