Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4AB3431F8;
	Fri,  9 Oct 2026 14:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556634; cv=none; b=bk3zU8OD45TNoGauv6fjGxE8y65EIQns0FZWEFrGqbnceSusXmXGEUn0RtXOtfAjC4dV42R0iohqWQfAo/c4+SwASOeNC3y/70eEtDGeGcSCOgUl8ARFU9CgvPK/kSBehODhRDfhXz3wOTZ5FqA9lkkTNBSAxQQ8RMwo1dGucEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556634; c=relaxed/simple;
	bh=9qZDHGRVf2Meteq1fbZ36aioEZ6CBHMpdMznRP4KIR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNaWqRsitgjvhG/X/juG23i5nzhPkhpGucObcDntM17/qSMqt6PF4e+AonuM36f9Vv65dwZkJjOlV3Q4qkrYRqTHcZ2pWqZ0eTZ/woOLMZvi+m4/WAj9q6Fe8pKMUcTfgTDS5dRevsmnGnApEuqh/eowsiPWOihe3dtxDI7/GKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTnN082G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTnN082G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AB91F000FF;
	Fri,  9 Oct 2026 14:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556633;
	bh=/vI8cGCaI5G4MsGoGC3wW2W5ryTMKiVyY4pQkxFTPL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTnN082GDl/2Jp/OcKz7FdDFxWy/kvF3loYMXaOcm4tceOkPD8sj91pJleUjgcDhy
	 1dzPaN+SnzRI3y38uAsQ+hZUPK9VfJCA810KR7iXSdd3PNCyxsaKnB621qR97w/IMA
	 Ovuo6M8KRUfFovnAwL0OzPG1scTKxc70vkDKnDuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 7.2 186/428] drm/amdgpu: implement workaround for sdma dcc corruption
Date: Fri,  9 Oct 2026 16:08:43 +0200
Message-ID: <20261009140950.229832077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

commit eaeac1498b289b342449b678a567a9012360f91a upstream.

For unknown reasons, on gfx12 using multiple entities can causes
random corruption of BOs with DCC.
This workaround seems to prevent the issue until the root cause
is understood and fixed.

Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5663
Fixes: 3a6f6eeb3db5 ("drm/amdgpu: give ttm entities access to all the sdma scheds")
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cd647796ac1334acec0468fae49a0dacbba2a34c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2320,7 +2320,7 @@ void amdgpu_ttm_fini(struct amdgpu_devic
 void amdgpu_ttm_enable_buffer_funcs(struct amdgpu_device *adev)
 {
 	struct ttm_resource_manager *man = ttm_manager_type(&adev->mman.bdev, TTM_PL_VRAM);
-	u32 num_clear_entities, num_move_entities;
+	u32 num_clear_entities, num_move_entities, sdma_ip_version;
 	int r, i, j;
 
 	if (!adev->mman.initialized || amdgpu_in_reset(adev) ||
@@ -2345,6 +2345,12 @@ void amdgpu_ttm_enable_buffer_funcs(stru
 
 	num_clear_entities = MIN(adev->mman.num_buffer_funcs_scheds, TTM_NUM_MOVE_FENCES);
 	num_move_entities = MIN(adev->mman.num_buffer_funcs_scheds, TTM_NUM_MOVE_FENCES);
+	/* TODO: workaround for DCC corruption when moving BOs from multiple queues at
+	 * the same time: use a single queue until the root cause is identified and fixed.
+	 */
+	sdma_ip_version = amdgpu_ip_version(adev, SDMA0_HWIP, 0);
+	if (sdma_ip_version == IP_VERSION(7, 0, 0) || sdma_ip_version == IP_VERSION(7, 0, 1))
+		num_move_entities = 1;
 
 	adev->mman.clear_entities = kcalloc(num_clear_entities,
 						sizeof(struct amdgpu_ttm_buffer_entity),


