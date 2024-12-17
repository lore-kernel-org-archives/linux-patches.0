Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36B614A4E7;
	Tue, 17 Dec 2024 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456454; cv=none; b=JTike8l/weLR6qL7B7ESS26zXRE7HsnA8HdiHoW2w4/bvQBRJGc9yxX3I5uIip2Ak578i5d8rZtAiQ1ouudUe1ch1B6qwaupAsrePAz4d+HM8sXYiuqs0uecRsAc2MXu5fd+zFlrIyFkXa4sxGkP6w4ycp/AvptnjMgqhE9xI6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456454; c=relaxed/simple;
	bh=JS03GM9u0cmm3ecdM8fqg9og9S/Z8giiFKhfw6V13P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4LrmzuMHSxpRyuADNxLjQvFnC4fPemPqjfeWnAU+sKaHYqgMWBqLKJ6BN2M3nX1l7S04SKljMM2W/qqAW0+ADQ5zKSARDJGrD2PChbC+a0mDarNPqeWI+Bv3Oq+suY5MMIsNs4mtQw6F+gNbHCjde61fs6qM4dMWjD3R2q6GTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXrw8YQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXrw8YQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174D5C4CED7;
	Tue, 17 Dec 2024 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456454;
	bh=JS03GM9u0cmm3ecdM8fqg9og9S/Z8giiFKhfw6V13P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXrw8YQyb6w6XQ3mMM+xNb9yroOQSljary6QmAQgPxZ3K3uLenv96lPtXowvpGFjT
	 p9Ck4PbsuDiUBO18/ZRZu2t6jc4x8XcEGkS7cZVp1Y0XCP9GnVA2ernH2a1uPUupmr
	 yXHV0pwjyN3TVqV/IYXKfzB6GV4PzVcIUbS9uaPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	David Belanger <david.belanger@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 065/172] drm/amdkfd: hard-code cacheline size for gfx11
Date: Tue, 17 Dec 2024 18:07:01 +0100
Message-ID: <20241217170548.976211477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

commit 321048c4a3e375416b51b4093978f9ce2aa4d391 upstream.

This information is not available in ip discovery table.

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: David Belanger <david.belanger@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1422,6 +1422,7 @@ err:
 
 
 static int kfd_fill_gpu_cache_info_from_gfx_config(struct kfd_dev *kdev,
+						   bool cache_line_size_missing,
 						   struct kfd_gpu_cache_info *pcache_info)
 {
 	struct amdgpu_device *adev = kdev->adev;
@@ -1436,6 +1437,8 @@ static int kfd_fill_gpu_cache_info_from_
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
 		pcache_info[i].num_cu_shared = adev->gfx.config.gc_num_tcp_per_wpg / 2;
 		pcache_info[i].cache_line_size = adev->gfx.config.gc_tcp_cache_line_size;
+		if (cache_line_size_missing && !pcache_info[i].cache_line_size)
+			pcache_info[i].cache_line_size = 128;
 		i++;
 	}
 	/* Scalar L1 Instruction Cache per SQC */
@@ -1448,6 +1451,8 @@ static int kfd_fill_gpu_cache_info_from_
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
 		pcache_info[i].num_cu_shared = adev->gfx.config.gc_num_sqc_per_wgp * 2;
 		pcache_info[i].cache_line_size = adev->gfx.config.gc_instruction_cache_line_size;
+		if (cache_line_size_missing && !pcache_info[i].cache_line_size)
+			pcache_info[i].cache_line_size = 128;
 		i++;
 	}
 	/* Scalar L1 Data Cache per SQC */
@@ -1459,6 +1464,8 @@ static int kfd_fill_gpu_cache_info_from_
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
 		pcache_info[i].num_cu_shared = adev->gfx.config.gc_num_sqc_per_wgp * 2;
 		pcache_info[i].cache_line_size = adev->gfx.config.gc_scalar_data_cache_line_size;
+		if (cache_line_size_missing && !pcache_info[i].cache_line_size)
+			pcache_info[i].cache_line_size = 64;
 		i++;
 	}
 	/* GL1 Data Cache per SA */
@@ -1471,7 +1478,8 @@ static int kfd_fill_gpu_cache_info_from_
 					CRAT_CACHE_FLAGS_DATA_CACHE |
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
 		pcache_info[i].num_cu_shared = adev->gfx.config.max_cu_per_sh;
-		pcache_info[i].cache_line_size = 0;
+		if (cache_line_size_missing)
+			pcache_info[i].cache_line_size = 128;
 		i++;
 	}
 	/* L2 Data Cache per GPU (Total Tex Cache) */
@@ -1483,6 +1491,8 @@ static int kfd_fill_gpu_cache_info_from_
 					CRAT_CACHE_FLAGS_SIMD_CACHE);
 		pcache_info[i].num_cu_shared = adev->gfx.config.max_cu_per_sh;
 		pcache_info[i].cache_line_size = adev->gfx.config.gc_tcc_cache_line_size;
+		if (cache_line_size_missing && !pcache_info[i].cache_line_size)
+			pcache_info[i].cache_line_size = 128;
 		i++;
 	}
 	/* L3 Data Cache per GPU */
@@ -1568,6 +1578,7 @@ static int kfd_fill_gpu_cache_info_from_
 int kfd_get_gpu_cache_info(struct kfd_node *kdev, struct kfd_gpu_cache_info **pcache_info)
 {
 	int num_of_cache_types = 0;
+	bool cache_line_size_missing = false;
 
 	switch (kdev->adev->asic_type) {
 	case CHIP_KAVERI:
@@ -1691,10 +1702,17 @@ int kfd_get_gpu_cache_info(struct kfd_no
 		case IP_VERSION(11, 5, 0):
 		case IP_VERSION(11, 5, 1):
 		case IP_VERSION(11, 5, 2):
+			/* Cacheline size not available in IP discovery for gc11.
+			 * kfd_fill_gpu_cache_info_from_gfx_config to hard code it
+			 */
+			cache_line_size_missing = true;
+			fallthrough;
 		case IP_VERSION(12, 0, 0):
 		case IP_VERSION(12, 0, 1):
 			num_of_cache_types =
-				kfd_fill_gpu_cache_info_from_gfx_config(kdev->kfd, *pcache_info);
+				kfd_fill_gpu_cache_info_from_gfx_config(kdev->kfd,
+									cache_line_size_missing,
+									*pcache_info);
 			break;
 		default:
 			*pcache_info = dummy_cache_info;


