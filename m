Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065492;
	b=sCPmXnpkM0BDPc5s3bAjhWhSsuohvxDy/eG/T6uNYwhLa6VBCP9av3Nwvzg8lMF6cXxw
	 wvxOceRlZQXrPPk1AA7HfvMR70d1wXuo76eRS+yYzDSflfFKoKLyFLNe3ipmirXqZUZ+A
	 oJWNuBWr8xmbAclu9QdUAtDGwso/7zGzkHC5BNfuAOu3yoC4FJouEavIdU9ORlOKnpFa4
	 PfeItJEtzlMTHf5XlphOS43Zxy1TnzmB95D3+/Vk3qh9v+0wnFDe+/0FScDmRYDGoG7wW
	 AmFqvwGAgkTCK1Tyqc/L8dxEcCsxojTg46xILVwsT9MM2ufxiabWMoBTIv02eS/wxug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Lu2A6vSzob+KeqiNXnN5aVBCd8HYe8YJu8VK5sNiNE=;
	b=Z+w2jqaPZSHnkZfqrnoX6skWpgxTciH7O+bjwToSQEHkGAbF2R9SRjNBupqlHspyVcdo
	 +rt6bnJOQDLKuN7MM9pfdq/Nmv0W6pL1f4uvS5B/h2D6t+lXg8xVnQ3/uLPkZgU3Q9/bL
	 nOutVL3cTWJD48GCTy/GtKFxrebV+G67CyfeHpRNYb1HsEIDH9yce3k+wZwTSB2tZIZwO
	 CAsWNyfAdlByhcKd3aopVHLgFX4b0RFB6Q92uHimQl24DmT1V7M5w6o6NDzR4PZCyf6qw
	 FmNpOUyG0Oh3NrnOyQ0IbiJ8Q2gm2Up9N0xkMHf3C21EleBome/CSvzp88LT/CTIryQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ezH/dmt0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BFC606A335;
	Sat,  7 Nov 2026 15:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezH/dmt0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F771F008A1;
	Sat,  7 Nov 2026 15:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065492;
	bh=1Lu2A6vSzob+KeqiNXnN5aVBCd8HYe8YJu8VK5sNiNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezH/dmt0d1e7QQP6VOrcJpxgLiEgO8uvwla8UyuhYWzkE4tvok+tZAQ+sCpGDiI+X
	 FQ053KujEboCj2xD68tyXXX/HyFj8tAtSKzU6k7vlia9ieaN+jYHa6nxeha+oDaRKl
	 A14hi06yU4bq8i3NkKx3jjSXKGxYh2ZeHjn353pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <philip.yang@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1182/1257] drm/amdkfd: split vram_pages of SVM ranges prefetched without a GPU mapping
Date: Sat,  7 Nov 2026 08:57:58 -0500
Message-ID: <20261107135011.816949214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 52957e813f2f025c86e4aa6e86cb4963ef94fd00 ]

When an SVM range is split, svm_range_split_pages() gives the new range
the number of VRAM pages counted in its part of the dma_addr arrays and
subtracts it from the old range. Pages migrated to VRAM by a prefetch
have no dma_addr entries until the range is mapped on a GPU, e.g. with
no ACCESS attribute, or with XNACK off before the delayed restore worker
mapped it, so the new range gets 0 and the old one keeps the count for
both.

Migrating the parts back to system memory then gets the accounting
wrong: the old part keeps a VRAM page count after all its pages are
gone, so its svm_bo is never freed, and the new part underflows. On
navi31, as an unprivileged process: prefetch 4 MiB to the GPU, prefetch
the upper 2 MiB and then the lower 2 MiB back to system memory:

  Recorded vram pages(0x0) should not be less than migration pages(0x200).
  WARNING: ../amdkfd/kfd_migrate.c:922 at svm_migrate_vram_to_ram+0xbdc/0xcd0 [amdgpu]

and /sys/class/kfd/kfd/proc/<pid>/vram_<gpu_id> stays at 4194304 until
the process exits.

Without dma_addr arrays, the split is still exact when the old range is
completely in VRAM, which is what a prefetch of the whole range leaves.
Give the new range all its pages in that case. The warning is gone and
the VRAM usage drops back to 0.

This doesn't cover a range that is only partly in VRAM without dma_addr
arrays, e.g. after a partial migration, since svm_migrate_ram_to_vram()
only counts the pages it actually migrated. That would need VRAM
residency to be tracked per page independently of dma_addr.

v2:
- Rename counted to has_dma_addr and compare against old->npages (Philip)
- Mention the XNACK off case and the partial migration limitation (Philip)

Fixes: 006ad514a50c ("drm/amdkfd: Use partial hmm page walk during buffer validation in SVM")
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7ca6f3359b557a267c7b07a2fd748b1473395e10)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 54bdae99d4971..ff7a895bdd7cd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1019,9 +1019,12 @@ svm_range_split_pages(struct svm_range *new, struct svm_range *old,
 		      uint64_t start, uint64_t last)
 {
 	uint64_t npages = last - start + 1;
+	bool has_dma_addr = false;
 	int i, r;
 
 	for (i = 0; i < MAX_GPU_INSTANCE; i++) {
+		if (old->dma_addr[i])
+			has_dma_addr = true;
 		r = svm_range_split_array(&new->dma_addr[i], &old->dma_addr[i],
 					  sizeof(*old->dma_addr[i]), old->start,
 					  npages, new->start, new->npages,
@@ -1029,8 +1032,16 @@ svm_range_split_pages(struct svm_range *new, struct svm_range *old,
 		if (r)
 			return r;
 	}
-	if (old->actual_loc)
+	if (old->actual_loc) {
+		/*
+		 * Pages migrated by prefetch have no dma_addr until they are
+		 * mapped on a GPU. A fully resident range still splits exactly,
+		 * old->npages isn't adjusted yet here.
+		 */
+		if (!has_dma_addr && old->vram_pages == old->npages)
+			new->vram_pages = new->npages;
 		old->vram_pages -= new->vram_pages;
+	}
 
 	return 0;
 }
-- 
2.53.0



