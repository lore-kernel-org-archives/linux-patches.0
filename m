Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A5B2F5481;
	Tue, 12 Aug 2025 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023686; cv=none; b=ogtemryvaDW67fY8JPMdf2sgXorCSvaDNT6uv2WW5BoFByDAgv+9KSYSxKzvfuOFCDsFZ8+e1YakBmxI0CHcIL7Z+01GneQakwlRDE0syyBYwFI4Hs8w6INrxL6qBucLhv4JlOZG/UWWGJgEPp7Oj+p7dcwR4Tp1TG4LZuQMu10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023686; c=relaxed/simple;
	bh=T39/9jqDhUqVUtwEXKs+R/UpGNWJdIuJ9K+88Gk6r8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXBlsj391oK3IKZ7noM5fRJdXTg4M6IJhzDvDF6cm0vDkf7uQjgbrPJO6dBbHLl2KaHZo7SAqT2ZMWPXOcOrsdAfpyvLTqLaEvCbD74KPGJLOQ5KmENOWDFhksSQkK13vF+RClP7CVglkuo9jvYAE3BirUdFHjuDv07d5TA6td0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gaCBGfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gaCBGfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056D1C4CEF0;
	Tue, 12 Aug 2025 18:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023686;
	bh=T39/9jqDhUqVUtwEXKs+R/UpGNWJdIuJ9K+88Gk6r8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gaCBGfoBrXQzNhylT72FiklAZeKqtoXAfl5AOP/Ki+GUk1R3ymIx9tOl4ztSHuQM
	 rYjn6w39Hw86shIUNVIfROY9KHTQz36YwzrFjL/StDOzZGcUYKgRTowpkjt3UFip0d
	 oFd5cOe9nGzU8B14XEDmbdwouBzmanrfB8FraY50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 152/627] drm/amdgpu/sdma: handle paging queues in amdgpu_sdma_reset_engine()
Date: Tue, 12 Aug 2025 19:27:27 +0200
Message-ID: <20250812173425.072719788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 9a9e87d15297ce72507178e93cbb773510c061cd ]

Need to properly start and stop paging queues if they are present.

This is not an issue today since we don't support a paging queue
on any chips with queue reset.

Fixes: b22659d5d352 ("drm/amdgpu: switch amdgpu_sdma_reset_engine to use the new sdma function pointers")
Reviewed-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
index 9b54a1ece447..f7decf533bae 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
@@ -597,8 +597,11 @@ int amdgpu_sdma_reset_engine(struct amdgpu_device *adev, uint32_t instance_id)
 		page_sched_stopped = true;
 	}
 
-	if (sdma_instance->funcs->stop_kernel_queue)
+	if (sdma_instance->funcs->stop_kernel_queue) {
 		sdma_instance->funcs->stop_kernel_queue(gfx_ring);
+		if (adev->sdma.has_page_queue)
+			sdma_instance->funcs->stop_kernel_queue(page_ring);
+	}
 
 	/* Perform the SDMA reset for the specified instance */
 	ret = amdgpu_sdma_soft_reset(adev, instance_id);
@@ -607,8 +610,11 @@ int amdgpu_sdma_reset_engine(struct amdgpu_device *adev, uint32_t instance_id)
 		goto exit;
 	}
 
-	if (sdma_instance->funcs->start_kernel_queue)
+	if (sdma_instance->funcs->start_kernel_queue) {
 		sdma_instance->funcs->start_kernel_queue(gfx_ring);
+		if (adev->sdma.has_page_queue)
+			sdma_instance->funcs->start_kernel_queue(page_ring);
+	}
 
 exit:
 	/* Restart the scheduler's work queue for the GFX and page rings
-- 
2.39.5



