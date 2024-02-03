Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42767171C1;
	Sat,  3 Feb 2024 04:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933908; cv=none; b=HfYT8nx5C6sHoPV/jfqtWsXfCDkRzDSr9RQ0fczpJwk22boGCqqb61RGvIVnjN8oVTCi5uMOEC9bWVxlQbaVdOVtxIwUHcIlpGiXdvHWIfeXDY9FtOUkJjgkdcVPW5JqcmkEON/ec55U8SsEMkcGKFm7XEeLM1wcs/oUy2r910A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933908; c=relaxed/simple;
	bh=cB9EXEPIGwZDtCuctSYQFLI/krxeLLKq0suRpbq0Ap4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h0XhJpUnbTOlKWzOV9PHqi5UX6bvjVPU+0kKakgY1cLjn6N1zKACppcKWc7FRKUEAi2lRcDBJKLgm9huvYHe3FatsPrHXhIvme/G1L36KhYHbwW2kh47ORnArRmDv4v6VFDwSUI52XEetLEv71V8sEEXL5bpoWsfxDwv3xlHM44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0p1rf5GG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0p1rf5GG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2DEC433F1;
	Sat,  3 Feb 2024 04:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933908;
	bh=cB9EXEPIGwZDtCuctSYQFLI/krxeLLKq0suRpbq0Ap4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0p1rf5GGzCEAuitIEcCXENKyUeebzwFuFST9RkDG1qTUPewdRKQIwpK2wVKPXW+jW
	 DW32sb+5HQUUEZy66xIPRg1GwF7Q0JnDzQBjfXeJAwf613U69id6ptDISK4LZrIErj
	 1J6s4shBAWBAGSAEvo3na+1lisQS4N4LRfJYVshQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 231/353] drm/amdgpu: Fix variable mca_funcs dereferenced before NULL check in amdgpu_mca_smu_get_mca_entry()
Date: Fri,  2 Feb 2024 20:05:49 -0800
Message-ID: <20240203035410.973088261@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 4f32504a2f85a7b40fe149436881381f48e9c0c0 ]

Fixes the below:

drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c:377 amdgpu_mca_smu_get_mca_entry() warn: variable dereferenced before check 'mca_funcs' (see line 368)

357 int amdgpu_mca_smu_get_mca_entry(struct amdgpu_device *adev,
				     enum amdgpu_mca_error_type type,
358                                  int idx, struct mca_bank_entry *entry)
359 {
360         const struct amdgpu_mca_smu_funcs *mca_funcs =
						adev->mca.mca_funcs;
361         int count;
362
363         switch (type) {
364         case AMDGPU_MCA_ERROR_TYPE_UE:
365                 count = mca_funcs->max_ue_count;

mca_funcs is dereferenced here.

366                 break;
367         case AMDGPU_MCA_ERROR_TYPE_CE:
368                 count = mca_funcs->max_ce_count;

mca_funcs is dereferenced here.

369                 break;
370         default:
371                 return -EINVAL;
372         }
373
374         if (idx >= count)
375                 return -EINVAL;
376
377         if (mca_funcs && mca_funcs->mca_get_mca_entry)
	        ^^^^^^^^^

Checked too late!

Cc: Yang Wang <kevinyang.wang@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c
index cf33eb219e25..061d88f4480d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c
@@ -351,6 +351,9 @@ int amdgpu_mca_smu_get_mca_entry(struct amdgpu_device *adev, enum amdgpu_mca_err
 	const struct amdgpu_mca_smu_funcs *mca_funcs = adev->mca.mca_funcs;
 	int count;
 
+	if (!mca_funcs || !mca_funcs->mca_get_mca_entry)
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case AMDGPU_MCA_ERROR_TYPE_UE:
 		count = mca_funcs->max_ue_count;
@@ -365,10 +368,7 @@ int amdgpu_mca_smu_get_mca_entry(struct amdgpu_device *adev, enum amdgpu_mca_err
 	if (idx >= count)
 		return -EINVAL;
 
-	if (mca_funcs && mca_funcs->mca_get_mca_entry)
-		return mca_funcs->mca_get_mca_entry(adev, type, idx, entry);
-
-	return -EOPNOTSUPP;
+	return mca_funcs->mca_get_mca_entry(adev, type, idx, entry);
 }
 
 #if defined(CONFIG_DEBUG_FS)
-- 
2.43.0



