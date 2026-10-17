Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12597381B0D;
	Sat, 17 Oct 2026 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254843; cv=none; b=cHiVj/NEgj4QNO0TAAxWVlLt0KoEFeLJAFueRZL7HazDOsHx6brFZJNXhqCqPFC7ixUxpB/Y92AdJ73x5Rt1sPqGCkcL4/B3+zlVb89iTIT+R9/fcR/tsTvWLbWRTbdfE73MbCbvrpSUVA0DTL6nweaTWciD6+SEQWPBQUxpOFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254843; c=relaxed/simple;
	bh=uINR23QvW9NgdZezft3VBKO3wxwMi71NY2C0XWFKOgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKlptbGaIR2iNj/w2iPvZohPlf2gC0K0p3+tacxxelheNOhUBUXguhjVyt242mhSEyIROBzhjdwz8mu4QWBQVczT0j+n6c6P/ewobWMzkQW9XcF9S56sKuI9m519K5I4abxXSt2Arvf+cbMjUUrTJoPhY9WxJDW3ENir0uadwzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEcx3qH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEcx3qH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8161F000C4;
	Sat, 17 Oct 2026 16:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254842;
	bh=/gAEr2+yxA369VDbTsBbzwcqevwwWKJN91SisXOiQoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEcx3qH4LMXwiHjTY4pMAqHb0jOSP83An1MVQQr5h/7EbYQYjtCua6J2YqYQeesOl
	 7mz36R5rv226YRkQHXyNKE+NYoJhyk0wfcAaVIxQ+fZtkaAoVCehpJDnAmhoIAohd+
	 epjfr2I4V90B9sgerpXButB7pZfEiKTG24BVrsdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 580/869] drm/amdkfd: Fix partial migrate issue
Date: Sat, 17 Oct 2026 17:57:01 +0200
Message-ID: <20261017160051.929785519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Emily Deng <Emily.Deng@amd.com>

[ Upstream commit b5f022fe8ec58540e29a32e328f89b7298f70313 ]

For partial migrate from ram to vram, the migrate->cpages is not
equal to migrate->npages, should use migrate->npages to check all needed
migrate pages which could be copied or not.

And only need to set those pages could be migrated to migrate->dst[i], or
the migrate_vma_pages will migrate the wrong pages based on the migrate->dst[i].

v2:
Add mpages to break the loop earlier.

v3:
Uses MIGRATE_PFN_MIGRATE to identify whether page could be migrated.

v4:
Correct the error part.

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Philip Yang<Philip.Yang@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 520e345ffe05 ("drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index ca6c48e3703cc..c61b4ec4e141f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -279,10 +279,11 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 			 struct migrate_vma *migrate, struct dma_fence **mfence,
 			 dma_addr_t *scratch, uint64_t ttm_res_offset)
 {
-	uint64_t npages = migrate->cpages;
+	uint64_t npages = migrate->npages;
 	struct amdgpu_device *adev = node->adev;
 	struct device *dev = adev->dev;
 	struct amdgpu_res_cursor cursor;
+	uint64_t mpages = 0;
 	dma_addr_t *src;
 	uint64_t *dst;
 	uint64_t i, j;
@@ -296,14 +297,16 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 
 	amdgpu_res_first(prange->ttm_res, ttm_res_offset,
 			 npages << PAGE_SHIFT, &cursor);
-	for (i = j = 0; i < npages; i++) {
+	for (i = j = 0; (i < npages) && (mpages < migrate->cpages); i++) {
 		struct page *spage;
 
-		dst[i] = cursor.start + (j << PAGE_SHIFT);
-		migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
-		svm_migrate_get_vram_page(prange, migrate->dst[i]);
-		migrate->dst[i] = migrate_pfn(migrate->dst[i]);
-
+		if (migrate->src[i] & MIGRATE_PFN_MIGRATE) {
+			dst[i] = cursor.start + (j << PAGE_SHIFT);
+			migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
+			svm_migrate_get_vram_page(prange, migrate->dst[i]);
+			migrate->dst[i] = migrate_pfn(migrate->dst[i]);
+			mpages++;
+		}
 		spage = migrate_pfn_to_page(migrate->src[i]);
 		if (spage && !is_zone_device_page(spage)) {
 			src[i] = dma_map_page(dev, spage, 0, PAGE_SIZE,
@@ -354,9 +357,12 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 out_free_vram_pages:
 	if (r) {
 		pr_debug("failed %d to copy memory to vram\n", r);
-		while (i--) {
+		for (i = 0; i < npages && mpages; i++) {
+			if (!dst[i])
+				continue;
 			svm_migrate_put_vram_page(adev, dst[i]);
 			migrate->dst[i] = 0;
+			mpages--;
 		}
 	}
 
-- 
2.53.0



