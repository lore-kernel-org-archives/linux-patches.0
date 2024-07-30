Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E609878276;
	Tue, 30 Jul 2024 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357944; cv=none; b=NuBrlqLzfgsvqVx1vRkNfwVOv8vHXJarjcggURhF950fOTVIMWkV5ftVwY9tXM3aAXNKQp5A13tqo1+fFsDc3245MMXrwdOg4Eks1K5B4kywISfaa+2LejKJfaWD5xr2yV+YtdtRqn9ZMgPMYNIBdjmXyKdtzoa1vTCfzRO+jbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357944; c=relaxed/simple;
	bh=K0m91PcOlPg48vrlUsoLq0NUHMr2DNPYfeQsdPd83xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tnNaCHcpe73XCsF+6lF0YchZ4se0PUYgc4jA3j7NkndWHCNOi6GdqiTtSaK1eFJJXrDN4ILmE93j5mx+bEhmbJDJ7p1jdPAPsLV6B7hS+3bTaf/XTij2EgYRPqFK3VGGSaUBs+RozWiSF82Lagt3aWgGIX/QMcE86x5lMQDHBfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCJBEYoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCJBEYoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680C6C4AF0F;
	Tue, 30 Jul 2024 16:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357943;
	bh=K0m91PcOlPg48vrlUsoLq0NUHMr2DNPYfeQsdPd83xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCJBEYoe0KEs5+QvrcDDUDoCaTvTWFkmLg9dp1m3DVOeoRnlvBufs5rrspu+AFzXO
	 GWLFOGa4yAAEoC2AZfxq+beCAjE80SVGLvWS9qXbJasbPfXpNDQ0Js6zJIA4G6tzTZ
	 F2HvYGvy2e+QPluJzImQ1/ID/zR4iXZcG/z0hNvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 283/809] drm/amdgpu: Fix snprintf usage in amdgpu_gfx_kiq_init_ring
Date: Tue, 30 Jul 2024 17:42:39 +0200
Message-ID: <20240730151735.766443575@linuxfoundation.org>
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

[ Upstream commit 0ea55445554209913a72eab86b60f5788776c4d6 ]

This commit fixes a format truncation issue arosed by the snprintf
function potentially writing more characters into the ring->name buffer
than it can hold, in the amdgpu_gfx_kiq_init_ring function

The issue occurred because the '%d' format specifier could write between
1 and 10 bytes into a region of size between 0 and 8, depending on the
values of xcc_id, ring->me, ring->pipe, and ring->queue. The snprintf
function could output between 12 and 41 bytes into a destination of size
16, leading to potential truncation.

To resolve this, the snprintf line was modified to use the '%hhu' format
specifier for xcc_id, ring->me, ring->pipe, and ring->queue. The '%hhu'
specifier is used for unsigned char variables and ensures that these
values are printed as unsigned decimal integers.

Fixes the below with gcc W=1:
drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c: In function ‘amdgpu_gfx_kiq_init_ring’:
drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c:332:61: warning: ‘%d’ directive output may be truncated writing between 1 and 10 bytes into a region of size between 0 and 8 [-Wformat-truncation=]
  332 |         snprintf(ring->name, sizeof(ring->name), "kiq_%d.%d.%d.%d",
      |                                                             ^~
drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c:332:50: note: directive argument in the range [0, 2147483647]
  332 |         snprintf(ring->name, sizeof(ring->name), "kiq_%d.%d.%d.%d",
      |                                                  ^~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c:332:9: note: ‘snprintf’ output between 12 and 41 bytes into a destination of size 16
  332 |         snprintf(ring->name, sizeof(ring->name), "kiq_%d.%d.%d.%d",
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  333 |                  xcc_id, ring->me, ring->pipe, ring->queue);
      |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 345a36c4f1ba ("drm/amdgpu: prefer snprintf over sprintf")
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 1d955652f3ba6..2cb8ab86efae8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -329,7 +329,7 @@ int amdgpu_gfx_kiq_init_ring(struct amdgpu_device *adev, int xcc_id)
 
 	ring->eop_gpu_addr = kiq->eop_gpu_addr;
 	ring->no_scheduler = true;
-	snprintf(ring->name, sizeof(ring->name), "kiq_%d.%d.%d.%d",
+	snprintf(ring->name, sizeof(ring->name), "kiq_%hhu.%hhu.%hhu.%hhu",
 		 xcc_id, ring->me, ring->pipe, ring->queue);
 	r = amdgpu_ring_init(adev, ring, 1024, irq, AMDGPU_CP_KIQ_IRQ_DRIVER0,
 			     AMDGPU_RING_PRIO_DEFAULT, NULL);
-- 
2.43.0



