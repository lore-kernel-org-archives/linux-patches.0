Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063543;
	b=V1e1LTbhFAJBGYOuaBjs/+IRULUVBozc9g5e0EPmZfzuG4dqdcmfREAFE+9GrFtzsvFX
	 O1vpLEX/u0JBEZu9cC/BgvdFnKrJLxqu98zJYeAAd0VE5WB512AhoIwbADDzAtMJqw4LR
	 MXa1VQhhC9axzxLzQTo1XRWr5yzHe+tVTN1rLxxOwToKvajw+9/xEYCcvJ5XWQyHLudhY
	 +JnHiLIYtuaeY+TjjZYR+tjm4SLliiNk5qXWE35q9Z3fHRQdF736uBHZ4/YUO5TORlru1
	 RuVh9qbVTGNy9aHqddhX07vkzE6V7q/40dPJ/dY3uJgPWVsTo9nmkRoQRI+wrsYJK9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BTdC+bt1SUM3Y/mzx8h77l5VNLLhErhws4LGaMsoWvY=;
	b=J2pHnKKuC5Jf70aVRNpBIbNe0A8/+XFmOQAZbJqazkur5MXmmvTtU9TI//eMqGA7Xvki
	 oD1cSuDlyhk51NR7CqNemDPAHyBuM/2hR5SnkcPeJyuCYNbbpxzMbRg61VQZo30tsr4BE
	 KWJZtqjVxWgkrLBMUHJhnT1z2bghevvHb+sTzH0rwHVhvZvxUAgmxrjpv80139+LuZZGp
	 4wayT8BBeEW2n2VXZjDKthwrz8vEYz6IKymiUFb5244RwgXvfajP6XBuBdH51tKCfXCqg
	 ATBvXQe8ImsyIyxOibTMS7p+m5o1sxTXIDjvEEh/axNJtXUAY9gBKxaNacTTagViYhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1aSLmtz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E170C6082BDB;
	Sat,  7 Nov 2026 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1aSLmtz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEA11F008A6;
	Sat,  7 Nov 2026 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063542;
	bh=BTdC+bt1SUM3Y/mzx8h77l5VNLLhErhws4LGaMsoWvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1aSLmtz6wMT/ReyfcpKlo4DQutXkrajiHWvBy1/6rOIGBC08RqtFKgDksAfML/aHm
	 xU+3of9QrqZlk4Abs+9HCh83gPHkQMjlXPkJ4zMPo68NuwKsa50e5QBJM7c2ZFL5tv
	 w4tAt137BTh26e1Fnanxgud3j59a6oWG94MajCNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 678/869] drm/amdkfd: dont drop an SVM CWSR reference that was never taken
Date: Sat,  7 Nov 2026 08:56:00 -0500
Message-ID: <20261107134916.069128003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 030d47cc6720e0f07b502876cdbd266e309f9461 ]

When kfd_queue_acquire_buffers() fails, its error path calls
kfd_queue_release_buffers(), which also drops a queue_refcount on the
SVM range at ctx_save_restore_area_address. The SVM range is the last
buffer acquired, and kfd_queue_buffer_svm_get() takes no reference when
it fails, so on every error path this reference was never taken. If
another queue of the process uses that CWSR range, its reference is
dropped instead, and unmapping the range no longer evicts that queue
while its CWSR area is unmapped from the GPU.

On navi31, with queue A using an SVM CWSR range: munmap() of the range
logs

  Freeing queue vital buffer 0x..., queue evicted

but after a CREATE_QUEUE that reuses A's CWSR address with an unmapped
write pointer (-EINVAL), the same munmap() leaves A running without the
message.

Only put the BOs on the acquire error path. The warning and the eviction
are back after the failed CREATE_QUEUE.

Fixes: b049504e211e ("drm/amdkfd: Validate user queue svm memory residency")
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9a08122e6361ef73f4b512d5db9596d561305519)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
index 6f06516da32a8..eaa284e551829 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -231,6 +231,15 @@ void kfd_queue_buffer_put(struct amdgpu_bo **bo)
 	amdgpu_bo_unref(bo);
 }
 
+static void kfd_queue_put_bos(struct queue_properties *properties)
+{
+	kfd_queue_buffer_put(&properties->wptr_bo);
+	kfd_queue_buffer_put(&properties->rptr_bo);
+	kfd_queue_buffer_put(&properties->ring_bo);
+	kfd_queue_buffer_put(&properties->eop_buf_bo);
+	kfd_queue_buffer_put(&properties->cwsr_bo);
+}
+
 int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_properties *properties)
 {
 	struct kfd_topology_device *topo_dev;
@@ -341,7 +350,13 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
 	 * dropping the VM reservation.
 	 */
 	kfd_queue_unref_bo_vas(pdd, properties);
-	kfd_queue_release_buffers(pdd, properties);
+	/*
+	 * The SVM CWSR range is the last thing acquired and a failed
+	 * kfd_queue_buffer_svm_get() takes nothing, so only the BOs are held
+	 * here. Dropping the SVM reference would drop the one of another queue
+	 * using the same CWSR address.
+	 */
+	kfd_queue_put_bos(properties);
 	return err;
 }
 
@@ -350,11 +365,7 @@ int kfd_queue_release_buffers(struct kfd_process_device *pdd, struct queue_prope
 	struct kfd_topology_device *topo_dev;
 	u64 total_cwsr_size;
 
-	kfd_queue_buffer_put(&properties->wptr_bo);
-	kfd_queue_buffer_put(&properties->rptr_bo);
-	kfd_queue_buffer_put(&properties->ring_bo);
-	kfd_queue_buffer_put(&properties->eop_buf_bo);
-	kfd_queue_buffer_put(&properties->cwsr_bo);
+	kfd_queue_put_bos(properties);
 
 	topo_dev = kfd_topology_device_by_id(pdd->dev->id);
 	if (!topo_dev)
-- 
2.53.0



