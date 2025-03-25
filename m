Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08402580E4;
	Tue, 25 Mar 2025 12:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906048; cv=none; b=spcBdjy8gP7Kietln0/6dJQRkc08vvZlypPhbq+6olAdJZGrgnsdvmN9dcerZY26XTI0Qs2C6PI4BmVRirwenP3oirwQ0MpFGZyMNoY2GT6zUkjBaPRrSWLrn48M5AL93wsXccRAr2KQGzjsLdiGjQcxtFQurZD3MBpBoqNhCos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906048; c=relaxed/simple;
	bh=JGDHWmAOMK9r8rWkCvaLrzW9ZB+RckxkBKPTGPI6IDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDMWFSSfnIx0mZG0aL8xxqk4HFcY2OnBdyW7DxaNMcsRK2bZ/DSNGln6NnHFbBK9bOApVk3/e3Ec2c93bFzF1Bh5PWpNo4ouxo+4H5H7rjCefoGpKP9Dlp8srf+vDWEJ59mb3d+x5iMXtB0iGoaiGgxM/Rtqy7/4/2/0tZHdPKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEzN8IxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEzN8IxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D26C4CEE4;
	Tue, 25 Mar 2025 12:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906047;
	bh=JGDHWmAOMK9r8rWkCvaLrzW9ZB+RckxkBKPTGPI6IDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEzN8IxXcXK7FH3f8LkJcNqUBQwQEevzK+O6jSjwYWT4L0fCUBdo4uHv4hgeb1hky
	 a4TLocbMjGsrSP7fESoH0u/5gR7RJgUyqvdt6v1XVu7iGoch1BQ8W5PQxj+7yErKjT
	 tco0BRuz4RFLLokvA4NvMbvZwf8sdY8efnabfaNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Trnka?= <trnka@scm.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 106/119] drm/amdkfd: Fix user queue validation on Gfx7/8
Date: Tue, 25 Mar 2025 08:22:44 -0400
Message-ID: <20250325122151.760743041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit 542c3bb836733a1325874310d54d25b4907ed10e upstream.

To workaround queue full h/w issue on Gfx7/8, when application create
AQL queue, the ring buffer bo allocate size is queue_size/2 and
map queue_size ring buffer to GPU in 2 pieces using 2 attachments, each
attachment map size is queue_size/2, with same ring_bo backing memory.

For Gfx7/8, user queue buffer validation should use queue_size/2 to
verify ring_bo allocation and mapping size.

Fixes: 68e599db7a54 ("drm/amdkfd: Validate user queue buffers")
Suggested-by: Tomáš Trnka <trnka@scm.com>
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e7a477735f1771b9a9346a5fbd09d7ff0641723a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -233,6 +233,7 @@ void kfd_queue_buffer_put(struct amdgpu_
 int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_properties *properties)
 {
 	struct kfd_topology_device *topo_dev;
+	u64 expected_queue_size;
 	struct amdgpu_vm *vm;
 	u32 total_cwsr_size;
 	int err;
@@ -241,6 +242,15 @@ int kfd_queue_acquire_buffers(struct kfd
 	if (!topo_dev)
 		return -EINVAL;
 
+	/* AQL queues on GFX7 and GFX8 appear twice their actual size */
+	if (properties->type == KFD_QUEUE_TYPE_COMPUTE &&
+	    properties->format == KFD_QUEUE_FORMAT_AQL &&
+	    topo_dev->node_props.gfx_target_version >= 70000 &&
+	    topo_dev->node_props.gfx_target_version < 90000)
+		expected_queue_size = properties->queue_size / 2;
+	else
+		expected_queue_size = properties->queue_size;
+
 	vm = drm_priv_to_vm(pdd->drm_priv);
 	err = amdgpu_bo_reserve(vm->root.bo, false);
 	if (err)
@@ -255,7 +265,7 @@ int kfd_queue_acquire_buffers(struct kfd
 		goto out_err_unreserve;
 
 	err = kfd_queue_buffer_get(vm, (void *)properties->queue_address,
-				   &properties->ring_bo, properties->queue_size);
+				   &properties->ring_bo, expected_queue_size);
 	if (err)
 		goto out_err_unreserve;
 


