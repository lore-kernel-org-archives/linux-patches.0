Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00412400987;
	Thu, 30 Jul 2026 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425982; cv=none; b=YE6U6i8796L9rdivl6qJK/FJYETG1Njl3Gh4CFiHAYUPsJLuK9CQAvPvlVLjtKgjePJtnHKF9n0whXi3JJi0Hl9JNyprf/n4OsNF0Q+whPo6nBsB5W8oDrVLDKujN+u1bG3DrEqiKz6yZRATul7A4WwmKuD1qnD1zeVbB9qiyYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425982; c=relaxed/simple;
	bh=Ajciz/kJUQ9DeT3Po/ygCw/AxbKivlB+6wBhu5f7nxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OHSrMWTYb+YrrZOwvosyLjnn05IoChDNragOlD0HxdlpjkeO6WmqndNsTBdo55rZc27KgO8cVjsnDMig2TiKF2ewIbcIA0/lojbngQDaxQAFUQ4SVkf5AJWcOzuoy3pHmTPPuJvI7yyMDuqdPShOi4MDDEBMH+WT4d4UrhbzVOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzSeRnV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzSeRnV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB5E1F000E9;
	Thu, 30 Jul 2026 15:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425980;
	bh=csicjA8SHX6tDWkX0RpQbpvsxiVwEojHzWfMELanjAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzSeRnV6ou/UlKOyFikaig7wEBF4CdgK3EnYZw1walR0RH3wFZi0sWPOVkAnDRbi0
	 KeRq8bh+vhtjK0m+Ag0lM0/KCPkE4TmnFAxS4FtGvKA1o8u3EN+Y11VcBmm11OICK/
	 7hG1f44v6df5EYjljLOGuNaulF8NgZw6csZBd60E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 259/602] drm/amdgpu/uvd: Fix forcing MSG, FB BOs into VCPU segment when it isnt at 0 (v2)
Date: Thu, 30 Jul 2026 16:10:51 +0200
Message-ID: <20260730141441.414254804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 32bd35f068a3507a1b3922cd12ea2985fc58c85b upstream.

UVD 4.x and older can only access MSG, FEEDBACK buffers from a
specific 256M VRAM segment that the VCPU BO is also located in.
We already modify all placements of the given BO to ensure
the BO is placed within this segment.

Previously, it always assumed that the VCPU segment is
the first 256M of VRAM, even though under some conditions
the VCPU BO could be allocated outside this segment,
which made UVD non-functional as the BOs were
not inside the same segment as the UVD VCPU BO.

Solve that by using the segment where the VCPU BO actually is.

This fixes an issue with UVD failing to initialize on SI/CIK
when resizable BAR is enabled and the VCPU BO is allocated
in a different segment.

v2:
- For other BOs, keep using the same UVD segment as before.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/3851
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cbfd4d3fc2061a1ec8e9d36e65973ac3e813358a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |   33 +++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -135,7 +135,7 @@ MODULE_FIRMWARE(FIRMWARE_VEGA12);
 MODULE_FIRMWARE(FIRMWARE_VEGA20);
 
 static void amdgpu_uvd_idle_work_handler(struct work_struct *work);
-static void amdgpu_uvd_force_into_uvd_segment(struct amdgpu_bo *abo);
+static void amdgpu_uvd_force_into_vcpu_segment(struct amdgpu_bo *abo);
 
 static int amdgpu_uvd_create_msg_bo_helper(struct amdgpu_device *adev,
 					   uint32_t size,
@@ -158,7 +158,7 @@ static int amdgpu_uvd_create_msg_bo_help
 	amdgpu_bo_kunmap(bo);
 	amdgpu_bo_unpin(bo);
 	amdgpu_bo_placement_from_domain(bo, AMDGPU_GEM_DOMAIN_VRAM);
-	amdgpu_uvd_force_into_uvd_segment(bo);
+	amdgpu_uvd_force_into_vcpu_segment(bo);
 	r = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
 	if (r)
 		goto err;
@@ -544,6 +544,24 @@ void amdgpu_uvd_free_handles(struct amdg
 	}
 }
 
+static void amdgpu_uvd_force_into_vcpu_segment(struct amdgpu_bo *bo)
+{
+	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
+	struct amdgpu_bo *vcpu_bo = adev->uvd.inst[0].vcpu_bo;
+	struct amdgpu_res_cursor vcpu_cur;
+
+	amdgpu_res_first(vcpu_bo->tbo.resource, 0,
+			 amdgpu_bo_size(vcpu_bo), &vcpu_cur);
+
+	bo->placement.num_placement = 1;
+	bo->placement.placement = &bo->placements[0];
+	bo->placements[0].fpfn = ALIGN_DOWN(vcpu_cur.start, SZ_256M) >> PAGE_SHIFT;
+	bo->placements[0].lpfn = bo->placements[0].fpfn + (SZ_256M >> PAGE_SHIFT);
+	bo->placements[0].mem_type = vcpu_bo->tbo.resource->mem_type;
+	if (bo->placements[0].mem_type == TTM_PL_VRAM)
+		bo->placements[0].flags |= TTM_PL_FLAG_CONTIGUOUS;
+}
+
 static void amdgpu_uvd_force_into_uvd_segment(struct amdgpu_bo *abo)
 {
 	int i;
@@ -594,13 +612,10 @@ static int amdgpu_uvd_cs_pass1(struct am
 	if (!ctx->parser->adev->uvd.address_64_bit) {
 		/* check if it's a message or feedback command */
 		cmd = amdgpu_ib_get_value(ctx->ib, ctx->idx) >> 1;
-		if (cmd == 0x0 || cmd == 0x3) {
-			/* yes, force it into VRAM */
-			uint32_t domain = AMDGPU_GEM_DOMAIN_VRAM;
-
-			amdgpu_bo_placement_from_domain(bo, domain);
-		}
-		amdgpu_uvd_force_into_uvd_segment(bo);
+		if (cmd == 0x0 || cmd == 0x3)
+			amdgpu_uvd_force_into_vcpu_segment(bo);
+		else
+			amdgpu_uvd_force_into_uvd_segment(bo);
 
 		r = ttm_bo_validate(&bo->tbo, &bo->placement, &tctx);
 	}


