Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22819227EB3;
	Thu, 13 Feb 2025 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457628; cv=none; b=bT8euSwlK/1ZYkmhJ7m0fJZYkTJlM2zM2naW4krKEO9d2xG3rv8rghyMeFTOcWpcepNtc+gixVpq9MhOOTYp6kSNDxDixkcOX04gSik3LIcUxEkVYtekm22JzMCKn2//H7ZIJgO+cHRAKkiGGgSNsu+p2RdPFzJlG60+NzwaC2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457628; c=relaxed/simple;
	bh=4imPGuRDLxm0YOIv10Y49SUdO+IHzVx4QViHV1wupjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSpxdWLi9IXHigKfyJfyoznO0qqumtCEakF0c4LH1XpC3K4ojz2ieMByeEI/0no5xqwQmGOAZE/VWJJbQT9DyLXmCle61bhYkLSFgU/16VI2m2DFfI8PQXB4PsEmV8f9jMkAfOigGIAPDj5ezrRy6g9y5Psl56tF3bMXyMxDGgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKRQljfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKRQljfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5CBC4CED1;
	Thu, 13 Feb 2025 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457628;
	bh=4imPGuRDLxm0YOIv10Y49SUdO+IHzVx4QViHV1wupjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKRQljfVb7KlpgHKda0BT2yhEmSOZvoO7TLqgMWP0mspB/c7UEF2tBJ9V/R4bjmad
	 v2aPosD4ijJeNW2csnFA3FQ9EGXBGjFnGv5znh5RNBlBg1Z6UZjwOSsggjm+ddIIqx
	 hJlSqPQ2fGTyeQnLmH6N4J9fc696t/1ZQyAUG1+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 159/422] drm/amdkfd: only flush the validate MES contex
Date: Thu, 13 Feb 2025 15:25:08 +0100
Message-ID: <20250213142442.680871947@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


