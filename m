Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F8D44E021;
	Tue, 16 Jun 2026 15:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624489; cv=none; b=lAIYU7AmBlPRa9rbGb+h2UXM1s7mj29CZQlXFHBQq/fRsHGDVVS0K8VlG/Vgx+APYnp8RCb5B7dHHg+yoYzvxV84sywwvndkljKn8oS/dD0EDY1JYIAC5hvw1D9n/Qgld9lNpn2Db4SkeUE9Uv07XEdUmfzMxkqu66zKBJwsAv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624489; c=relaxed/simple;
	bh=AjksXOS2H0DdijgZbpkH7GoAO3wwhnv0xKk80J5nqOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aoCvSozREBCD8j77iZsCddaDWIkfehLYSmc5/1ygh+Manom7a0Uo5dASlGQ3CHyE2xyaRQywUfWhyJ+uub9DSyInQFkB2Azxm6IQR9PLCruGTrQ15rilCWqaTgJFkywaw4GIYc5bivCFB8hpDgOiXl4G0EtfFvdYSa7KSd0kokQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bTGzFJh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bTGzFJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF081F000E9;
	Tue, 16 Jun 2026 15:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624488;
	bh=9+d7yA6Wpo6n/h1x2ScXz8N+gnBuxlEXz8ItrPMRj+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bTGzFJhtnCP+XZoSCtmtHeiem6OsPYahaOEMqbEnTAcaafvsiFjbaz7GQRAxLjIi
	 M3LYgzw13eq9a2qeiyUHs1bjgVcZiuwewsjcmfyCr9bNqLpo7TG0Y6Zueb3KCj2bzW
	 6kO8yZ4L6s2uHLAZwzB5cGzJ1NvUocvqSvEjWj6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 347/378] drm/amdgpu: Fix incorrect VRAM GART mappings on non-4K page size systems
Date: Tue, 16 Jun 2026 20:29:38 +0530
Message-ID: <20260616145128.432529886@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donet Tom <donettom@linux.ibm.com>

commit ec4c462e2d8161b32038e21e7187f4a15fe1661d upstream.

When mapping VRAM pages into the GART page table,
amdgpu_gart_map_vram_range() assumes that the system page size is the
same as the GPU page size.

On systems with non-4K page sizes, multiple GPU pages can exist within
a single CPU page. As a result, the mappings are created incorrectly
because fewer page table entries are programmed than required.

Fix this by programming the mappings correctly for non-4K page size
systems.

Fixes: 237d623ae659 ("drm/amdgpu/gart: Add helper to bind VRAM pages (v2)")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a8f0bc22388f74e0cf4ed8b7d1846c580eaf44cc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
@@ -394,7 +394,8 @@ void amdgpu_gart_map_vram_range(struct a
 				uint64_t start_page, uint64_t num_pages,
 				uint64_t flags, void *dst)
 {
-	u32 i, idx;
+	u32 i, j, t, idx;
+	u64 page_base;
 
 	/* The SYSTEM flag indicates the pages aren't in VRAM. */
 	WARN_ON_ONCE(flags & AMDGPU_PTE_SYSTEM);
@@ -402,9 +403,12 @@ void amdgpu_gart_map_vram_range(struct a
 	if (!drm_dev_enter(adev_to_drm(adev), &idx))
 		return;
 
-	for (i = 0; i < num_pages; ++i) {
-		amdgpu_gmc_set_pte_pde(adev, dst,
-			start_page + i, pa + AMDGPU_GPU_PAGE_SIZE * i, flags);
+	page_base = pa;
+	for (i = 0, t = 0; i < num_pages; i++) {
+		for (j = 0; j < AMDGPU_GPU_PAGES_IN_CPU_PAGE; j++, t++) {
+			amdgpu_gmc_set_pte_pde(adev, dst, start_page + t, page_base, flags);
+			page_base += AMDGPU_GPU_PAGE_SIZE;
+		}
 	}
 
 	drm_dev_exit(idx);


