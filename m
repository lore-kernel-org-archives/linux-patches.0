Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5309D1A619E;
	Tue, 30 Jul 2024 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357806; cv=none; b=EQZSwpB9DFCS1ZHF0deSXLVPZwdUJcBBUQfLpUrG9/l7XCfChbgrV8S5toRj0z5ZOjZG9Z7SBzhPVzMYZFWV2+CtCyC8GCFXVuRL4eTXB/YBo4oO2GTKAl783d4ttI1XUY1mFS4rMdgFwpifgqVXsyJDfnCkHaGJBkVnYg+oJNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357806; c=relaxed/simple;
	bh=kHNuDDc9hHyB+NjNaXTBofctOmnMEkjboZWyt0SS1IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rBzmk4lRRs+oEX8ladiuEq8Il5ydoAeJCGMcx1eaPItjQimtpJqmZuuVPzDHt/xgK6QcGsVyc1NnqtOrZkvuNd8Ktu9tuaK72fMNFUeeN8GOUFh1hR/yEzzigq4+9BeML5yPs67YYb2muHMR5Rq433JvoX8imYoiM23djSvJ2vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0ebKW3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0ebKW3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB27EC32782;
	Tue, 30 Jul 2024 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357806;
	bh=kHNuDDc9hHyB+NjNaXTBofctOmnMEkjboZWyt0SS1IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0ebKW3nAO7PvoMF9W63O4OCoVmeWq8cquVBxhtPFWsmEXFKdJczz0VQi4+xYRzr5
	 S80uLUTFTI37+rYM/H6365t10sZdEu5dP4XuXz6ivSxnz9UmH1zX46+EKqKSIgGFIe
	 hSWYUHLE0bdqODf+0WEiCHF/ujM8fKqZmseLF3bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 294/809] drm/amdgpu: Fix type mismatch in amdgpu_gfx_kiq_init_ring
Date: Tue, 30 Jul 2024 17:42:50 +0200
Message-ID: <20240730151736.204149364@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 745f7170db4ffd2f2e9751a2c719a97c9a5fc438 ]

This commit fixes a type mismatch in the amdgpu_gfx_kiq_init_ring
function triggered by the snprintf function expecting unsigned char
arguments due to the '%hhu' format specifier, but receiving int and u32
arguments.

The issue occurred because the arguments xcc_id, ring->me, ring->pipe,
and ring->queue were of type int and u32, not unsigned char. This led to
a type mismatch when these arguments were passed to snprintf.

To resolve this, the snprintf line was modified to cast these arguments
to unsigned char. This ensures that the arguments are of the correct
type for the '%hhu' format specifier and resolves the warning.

Fixes the below:
>> drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c:333:4: warning: format
>> specifies type 'unsigned char' but the argument has type 'int'
>> [-Wformat]
                    xcc_id, ring->me, ring->pipe, ring->queue);
                    ^~~~~~
>> drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c:333:12: warning: format
>> specifies type 'unsigned char' but the argument has type 'u32' (aka
>> 'unsigned int') [-Wformat]
                    xcc_id, ring->me, ring->pipe, ring->queue);
                            ^~~~~~~~
   drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c:333:22: warning: format specifies type 'unsigned char' but the argument has type 'u32' (aka 'unsigned int') [-Wformat]
                    xcc_id, ring->me, ring->pipe, ring->queue);
                                      ^~~~~~~~~~
   drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c:333:34: warning: format specifies type 'unsigned char' but the argument has type 'u32' (aka 'unsigned int') [-Wformat]
                    xcc_id, ring->me, ring->pipe, ring->queue);
                                                  ^~~~~~~~~~~
   4 warnings generated.

Fixes: 0ea554455542 ("drm/amdgpu: Fix snprintf usage in amdgpu_gfx_kiq_init_ring")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405250446.XeaWe66u-lkp@intel.com/
Cc: Lijo Lazar <lijo.lazar@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 2cb8ab86efae8..e92bdc9a39d35 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -330,7 +330,8 @@ int amdgpu_gfx_kiq_init_ring(struct amdgpu_device *adev, int xcc_id)
 	ring->eop_gpu_addr = kiq->eop_gpu_addr;
 	ring->no_scheduler = true;
 	snprintf(ring->name, sizeof(ring->name), "kiq_%hhu.%hhu.%hhu.%hhu",
-		 xcc_id, ring->me, ring->pipe, ring->queue);
+		 (unsigned char)xcc_id, (unsigned char)ring->me,
+		 (unsigned char)ring->pipe, (unsigned char)ring->queue);
 	r = amdgpu_ring_init(adev, ring, 1024, irq, AMDGPU_CP_KIQ_IRQ_DRIVER0,
 			     AMDGPU_RING_PRIO_DEFAULT, NULL);
 	if (r)
-- 
2.43.0



