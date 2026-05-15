Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EC52609EE;
	Fri, 15 May 2026 16:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862330; cv=none; b=Ifad5VCQ462cnJXFuf4sbGmDkav6E//iCB/NFvryw7mIkHUI3qdjDWvdNMlYcCPoLNhtaW1hSy6CkjqF2hjlm832w8GuBRKDwM96eWD/zwjZmOSqZ5VoCBf/Hgi2TjUcY4symwQbgTdYV9CZeAdC9vK4ODRFv5oHIBGc9X0Jm88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862330; c=relaxed/simple;
	bh=BnlkmxlQm/B8roJr2aO6i3SVsnhxeARUqCgr9Oyvk2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqrsDxj7dQqvwbLvvj+lM5Z6YFEiFGAWJbwog11XWKE0fGDP3THCu8Ex3kGXtaDKhHwwl0Rt8zSG+mRzHfBpGKS+9VvwQSP116Ci6LCgF2/jGXA1Tw9a9DkrK7yqeyrlNw+5047T9enCXgSXAe7jtrZJgT0YB2zl2lkLpyKyy+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l81+KJTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l81+KJTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B381C2BCB0;
	Fri, 15 May 2026 16:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862330;
	bh=BnlkmxlQm/B8roJr2aO6i3SVsnhxeARUqCgr9Oyvk2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l81+KJTLDa57adtBfrzJMVe0SBnhafEao2rvNA7HqJPgSUdxfsbgpxixS/4+2l9br
	 KeleFeuYzGcJ0u0IyJl7ukmvbq9sMf2QZ4W4YYD/6e9WZZV/aLRD/XvMuTZm31QHMJ
	 u6llOChxQQ9oGK32IizSqtB1MVrpF9ILjLTWFrac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 152/188] drm/amdgpu: validate the flush_gpu_tlb_pasid()
Date: Fri, 15 May 2026 17:49:29 +0200
Message-ID: <20260515154700.621875793@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

commit f4db9913e4d3dabe9ff3ea6178f2c1bc286012b8 upstream.

Validate flush_gpu_tlb_pasid() availability before flushing tlb.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -737,6 +737,10 @@ int amdgpu_gmc_flush_gpu_tlb_pasid(struc
 		return 0;
 
 	if (!adev->gmc.flush_pasid_uses_kiq || !ring->sched.ready) {
+
+		if (!adev->gmc.gmc_funcs->flush_gpu_tlb_pasid)
+			return 0;
+
 		if (adev->gmc.flush_tlb_needs_extra_type_2)
 			adev->gmc.gmc_funcs->flush_gpu_tlb_pasid(adev, pasid,
 								 2, all_hub,


