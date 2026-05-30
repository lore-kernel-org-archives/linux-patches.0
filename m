Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BDD481DD;
	Sat, 30 May 2026 17:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160805; cv=none; b=cGH5RRUo4y4/9mBLCvjSKYHUZ/2D5fhc8hn/L+EA+v0QOftifMgZ9z74h6k1W30SuTY3cmrSJ7W/MYGg6AqFylD/B6oB6PDImutk0YbFrxHRoioCaDAXX6Ls/ASKukTq0snrbgiJ2DNf2AjSjpV7HBWxzk6mgZF8hJRrUBdiugI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160805; c=relaxed/simple;
	bh=0+mK1fSbvDglIYNrK55rLXE/dd/R2fN0Eh/Z2+Ocku4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C+pTi3EA+6Gfc2Rw8kJWRqE6YYmWDsncC8BAIkpEKsvrK8ySqcHyV9+TMU8ArJ4uW4OlgSSY3SlqVt/NevspIWYwIiadIDNff+u4q+oTpAtAdv1n14H664OC+RylSSPmfP+WQ/HaG++PEBLfZquO6ZoGxojm2TvHImTrdITt08M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EswgRxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EswgRxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393BF1F00893;
	Sat, 30 May 2026 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160803;
	bh=r7Km+oDBdGzxGX1TpQH+rPoMpWV/XtWx1bI8Cus9pfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EswgRxrJiM8cYoNEgmuFSOzut6rrAIG3zYcXSfpHVYQnb3TEFCmx3pOal0MkH/gl
	 aGCFBi0h4Y7YKr4YIEB1rzFpkxgBiEcdM+g1uAwDfx28qAfKE3qtenfo8vJWtwXFNl
	 lgLjmrdHXL7qzKdpFmiXcv8azcSC+XBDZC2U47/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 410/969] drm/amdgpu: zero-initialize GART table on allocation
Date: Sat, 30 May 2026 17:58:54 +0200
Message-ID: <20260530160311.604199030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit e6c2e6c2e1fa066968a16aca1cb66cd1bdde7741 upstream.

GART TLB is flushed after unmapping but not after mapping. Since
amdgpu_bo_create_kernel() does not zero-initialize the buffer, when a
single PTE is written the TLB may speculatively load other uninitialized
entries from the same cacheline. Those garbage entries can appear valid,
and a subsequent write to another PTE in the same cacheline may cause the
GPU to use a stale garbage PTE from the TLB.

Fix this by calling memset_io() to zero-initialize the GART table with
gart_pte_flags immediately after allocation.

Using AMDGPU_GEM_CREATE_VRAM_CLEARED, SDMA-based clear will not work
since SDMA needs GART to be initialized to work.

Suggested-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d9af8263b82b6eaa60c5718e0c6631c5037e4b24)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
@@ -114,12 +114,19 @@ void amdgpu_gart_dummy_page_fini(struct
  */
 int amdgpu_gart_table_vram_alloc(struct amdgpu_device *adev)
 {
+	int r;
+
 	if (adev->gart.bo != NULL)
 		return 0;
 
-	return amdgpu_bo_create_kernel(adev,  adev->gart.table_size, PAGE_SIZE,
-				       AMDGPU_GEM_DOMAIN_VRAM, &adev->gart.bo,
-				       NULL, (void *)&adev->gart.ptr);
+	r = amdgpu_bo_create_kernel(adev,  adev->gart.table_size, PAGE_SIZE,
+				    AMDGPU_GEM_DOMAIN_VRAM, &adev->gart.bo,
+				    NULL, (void *)&adev->gart.ptr);
+	if (r)
+		return r;
+
+	memset_io(adev->gart.ptr, adev->gart.gart_pte_flags, adev->gart.table_size);
+	return 0;
 }
 
 /**


