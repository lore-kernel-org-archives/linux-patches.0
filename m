Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE5926B087;
	Thu, 13 Feb 2025 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460538; cv=none; b=W3qTqz1RyqvTLf9NPa7gggtFu+5wd1WxdQ3m46+ZhOe7FAO7mCUNQaun8ZvoCK3w0WCKJ8SXxN3aXEAhy3Jyz1TN5uskYlkxMtFQ3+D0pNhW7S0LO3Ra0WJvwBo6/DrGS45xdEKVsz7emNTIrvrX5eYDriw+IIjnYszInKp6eZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460538; c=relaxed/simple;
	bh=E9yBQrpaG7eZqL0D8ZLTTudCntzY1V5ZspNvj/Rc55o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZA0aJy444a8T9i15ilvHFsHb0ByaJv+Xg54s+o3OfatW3h30q6VGzuLzk8+6ryhWRChsxD+hOUzwQoDc7FAEjisSNAzrLClU0iU6Lb4R04JTjhIWMNLk1qfdoca3OdjqDez6/k6Ku2eH+AfB+Vd3Kzac1eAWGJ6COkJe2A6ewB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmPBkSNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmPBkSNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE646C4CEE4;
	Thu, 13 Feb 2025 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460538;
	bh=E9yBQrpaG7eZqL0D8ZLTTudCntzY1V5ZspNvj/Rc55o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmPBkSNJh5jSdY0nnlKdUk0ZZZwCzxb7u/IHympIBWkszwMbLBCf0z/dmku5NIIIp
	 MukYHgNZylCc8ZEQGqfwe0/7Jsqa9wKj6KextARDROfmqsNM+XnXCEffUjlr64tDpm
	 n2RrDhyGVt+6NmZjCBHh/PVFqogcuKhJ6/3Br2XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 098/273] drm/amdkfd: only flush the validate MES contex
Date: Thu, 13 Feb 2025 15:27:50 +0100
Message-ID: <20250213142411.216876739@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Prike Liang <Prike.Liang@amd.com>

commit 9078a5bfa21e78ae68b6d7c365d1b92f26720c55 upstream.

The following page fault was observed duringthe KFD process release.
In this particular error case, the HIP test (./MemcpyPerformance -h)
does not require the queue. As a result, the process_context_addr was
not assigned when the KFD process was released, ultimately leading to
this page fault during the execution of the function
kfd_process_dequeue_from_all_devices().

[345962.294891] amdgpu 0000:03:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:153 vmid:0 pasid:0)
[345962.295333] amdgpu 0000:03:00.0: amdgpu:   in page starting at address 0x0000000000000000 from client 10
[345962.295775] amdgpu 0000:03:00.0: amdgpu: GCVM_L2_PROTECTION_FAULT_STATUS:0x00000B33
[345962.296097] amdgpu 0000:03:00.0: amdgpu:     Faulty UTCL2 client ID: CPC (0x5)
[345962.296394] amdgpu 0000:03:00.0: amdgpu:     MORE_FAULTS: 0x1
[345962.296633] amdgpu 0000:03:00.0: amdgpu:     WALKER_ERROR: 0x1
[345962.296876] amdgpu 0000:03:00.0: amdgpu:     PERMISSION_FAULTS: 0x3
[345962.297135] amdgpu 0000:03:00.0: amdgpu:     MAPPING_ERROR: 0x1
[345962.297377] amdgpu 0000:03:00.0: amdgpu:     RW: 0x0
[345962.297682] amdgpu 0000:03:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:169 vmid:0 pasid:0)

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Jonathan Kim <jonathan.kim@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -86,9 +86,12 @@ void kfd_process_dequeue_from_device(str
 
 	if (pdd->already_dequeued)
 		return;
-
+	/* The MES context flush needs to filter out the case which the
+	 * KFD process is created without setting up the MES context and
+	 * queue for creating a compute queue.
+	 */
 	dev->dqm->ops.process_termination(dev->dqm, &pdd->qpd);
-	if (dev->kfd->shared_resources.enable_mes &&
+	if (dev->kfd->shared_resources.enable_mes && !!pdd->proc_ctx_gpu_addr &&
 	    down_read_trylock(&dev->adev->reset_domain->sem)) {
 		amdgpu_mes_flush_shader_debugger(dev->adev,
 						 pdd->proc_ctx_gpu_addr);


