Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591219;
	b=YXuSlby8SiJDKRTQtVHH6DHgOb/YJ3xabkx6k8zTwD1LSfXFI9QUn+JQ2hrdWzFH0cFs
	 YNXkQRbvb4HD6N2jYuTVjNbgDrgUwzW26I+bgDT/OoWyeJxUV1n9XUJpwsNhNPjPtqjPm
	 Kto6o0Iq5w4mjA9/qQQGCTvqg7ZLRFZ8mGgXGOXXydgsfOv7k1SnkwBOv7CqlJJ3audqv
	 ED8DYr4YzxYCc+eRzygccH+bgfaeOd+38vw8BUHrDUXfN7IdMsjoBAX/PAhgrlylYRxoG
	 ULjuEevOlQ7wYRIRfzQ7AowEyUY3wBO7cD1Q/gcJmm9fWhaF+LIMdYCpq3EOzxHyc7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G2pwzWKshYsdvE+jv2/lsBIvgtSBSCGgpteyoGRFA4Q=;
	b=H5JucObT6br9ZkZsMjLpxdB9JSXEcni0rKnPaHCQtSjtTFySSRo+/clSqgIYtk1Mqooh
	 RgdSCdOMwGT8jmEz2OkjC4N1RiD+ByYzflK2J0F46xqViSJPZHqih5AtBJ5MngupO3n0i
	 H5w4PPg2dycQAsb5udVYx+Eky8nnLCSv8SQ46jCStZ9B2dY1OFH3NiJ6xHk58Xdk2oot2
	 +bW8E8USNlWsLtR0dIZJoTYgTqTa9rysUYcrrzoQH/SGXjWc0VcJqQzaIUKXR63K6kTkB
	 pocLrmInZQBX/6eUhKwlQyQ8lsG4ZxJvSAhKIlsd8OV3OM745QLdoMmBxz3BQCe1qGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttzOopGS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923516075E04;
	Fri, 13 Nov 2026 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttzOopGS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0021F000CD;
	Fri, 13 Nov 2026 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591219;
	bh=G2pwzWKshYsdvE+jv2/lsBIvgtSBSCGgpteyoGRFA4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttzOopGSwg9nOQ95DFletKPb2l2NFLOMMn0y+zuudoKvemwonZBSWdyCuYoFM7wUZ
	 higFgz1FwUB8vcoAt5w8Pc3D0ArDE8p3rx/GbEAkewm9VAgvrq0O10Lb/5LM4K121q
	 DrTnVu9IjZd/88LXzQWmOi2JP4sDdGNKety8tk8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 352/670] drm/amdgpu: drop the dma-buf reference when a KFD import fails
Date: Fri, 13 Nov 2026 10:48:36 -0500
Message-ID: <20261113153823.752260061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit fb900f8bfd8a16126affd186d21001e4c6533324 ]

import_obj_create() takes a reference on the dma-buf for the new kgd_mem,
but the error path after validating the BO doesn't drop it. Since the
validation reserves the BO interruptibly, an import failing with
-ERESTARTSYS leaks the exported BO with its memory, and keeps the module
in use.

Importing a 64 MiB VRAM BO in a loop while getting SIGUSR1
every 20 us and another thread changes the BO's mappings:

  INFO: 171821 imports, VRAM used before 65 MiB, after 129 MiB
  modprobe: FATAL: Module amdgpu is in use.

Drop the reference, and free the sync object and the mutex of the kgd_mem
as well. With that VRAM usage returns to 65 MiB after the same test.

Fixes: 0e2e7c5b3d71 ("drm/amdgpu: Attach eviction fence on alloc")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b4d1eca2729840148ff2ea957724ce764ca5a94e)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index bc284939cf66d..ef4d8dca3c7af 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2441,6 +2441,9 @@ static int import_obj_create(struct amdgpu_device *adev,
 
 err_remove_mem:
 	remove_kgd_mem_from_kfd_bo_list(*mem, avm->process_info);
+	amdgpu_sync_free(&(*mem)->sync);
+	mutex_destroy(&(*mem)->lock);
+	dma_buf_put(dma_buf);
 	drm_vma_node_revoke(&obj->vma_node, drm_priv);
 err_free_mem:
 	kfree(*mem);
-- 
2.53.0



