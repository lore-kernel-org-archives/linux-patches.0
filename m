Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5C11096A
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AC3C433C0;
	Mon, 19 Jun 2023 10:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170857;
	bh=4k3pDR9DQdCDrCnrxZgNgOQ0Y3BMlPys7q1ey9lMpvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruelD03mhRFYsgg6u4i3Rdzq1VbeTmvzrpe99r/SP/iGwB1DYpuIhBYcaW1Mfai4v
	 W8YaHT5lLjUZMT7kH5fyA0k6JNoY92PvhMn5IGwg/bL14RzSdHZ17CE/iJTXwMiwgP
	 NgUiYOS4ZMXKAmmeNrSy5Xqr32F5t6WQmTs8rsSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 060/187] Revert "drm/amdgpu: remove TOPDOWN flags when allocating VRAM in large bar system"
Date: Mon, 19 Jun 2023 12:27:58 +0200
Message-ID: <20230619102200.579966355@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 34e5a54327dce5033582f3609eb54812a8c61b90 upstream.

This reverts commit c105518679b6e87232874ffc989ec403bee59664.

This patch disables the TOPDOWN flag for APU and few dGPU cards
which has the VRAM size equal to the BAR size.

When we enable the TOPDOWN flag, we get the free blocks at
the highest available memory region and we don't split the
lower order blocks. This change is required to keep off
the fragmentation related issues particularly in ASIC
which has VRAM space <= 500MiB

Hence, we are reverting this patch.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2270
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 3b225be89cb7..a70103ac0026 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -140,7 +140,7 @@ void amdgpu_bo_placement_from_domain(struct amdgpu_bo *abo, u32 domain)
 
 		if (flags & AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED)
 			places[c].lpfn = visible_pfn;
-		else if (adev->gmc.real_vram_size != adev->gmc.visible_vram_size)
+		else
 			places[c].flags |= TTM_PL_FLAG_TOPDOWN;
 
 		if (flags & AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS)
-- 
2.41.0



