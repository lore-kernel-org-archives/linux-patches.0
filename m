Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7E81991CF;
	Thu,  6 Jun 2024 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683163; cv=none; b=USVfvBZPigi2u+ObqmmoJ+pKSKkv/cR5dlbGlZle7yZiSEqchyDF56omA82ean6S4IueCOQDWFDXC1c5aWZrOTmu4/yUo1d+gQGI4Ozx9297ZM1nqoPAsedmeATBSd4QRXEYRQX0dEGXtD3HdyT8JdYvoYW4Y+H3206WcPjnLdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683163; c=relaxed/simple;
	bh=xKx7RX6PP1V4CN7ZEiPV+y+dy9qm9JMLQjpnm1lKB38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YNFFAFYZMa052W+jujQ7pYglldg6Bvwq1PMbQ+H4uanSwus7BQj7GPXYWhcOD8LOlO6F+Jw6i2VN+q4qyu2A5htbkmtEBwrR2QVEav1SRgR4kEPUWcHIDLNyXZNFSLnr5gm4R3gy0OM1YE4vQtjl07hpcmMqz220GcAkTMi6miI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUvYg7+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUvYg7+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC42C32782;
	Thu,  6 Jun 2024 14:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683162;
	bh=xKx7RX6PP1V4CN7ZEiPV+y+dy9qm9JMLQjpnm1lKB38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUvYg7+Bws40UEvX7E561tOVDv6qEmbpzyz4F/zS4c70mASPE7Z/OBcEgj+VbMHqe
	 JKlG2CvRrLPFV3tDp3slsFYfdg8dE31PrGTK4aH4kWNEJQfqi0TPZg5FrgIIm4Dts4
	 4N13ujXRjRhsYq74V9Rn5WVxk+YN3t0qsQ5wb6dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/473] drm/amdgpu: Update BO eviction priorities
Date: Thu,  6 Jun 2024 15:59:22 +0200
Message-ID: <20240606131700.989868875@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <felix.kuehling@amd.com>

[ Upstream commit b0b13d532105e0e682d95214933bb8483a063184 ]

Make SVM BOs more likely to get evicted than other BOs. These BOs
opportunistically use available VRAM, but can fall back relatively
seamlessly to system memory. It also avoids SVM migrations evicting
other, more important BOs as they will evict other SVM allocations
first.

Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Acked-by: Mukul Joshi <mukul.joshi@amd.com>
Tested-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 9a111988b7f15..7acf1586882e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -585,6 +585,8 @@ int amdgpu_bo_create(struct amdgpu_device *adev,
 	else
 		amdgpu_bo_placement_from_domain(bo, bp->domain);
 	if (bp->type == ttm_bo_type_kernel)
+		bo->tbo.priority = 2;
+	else if (!(bp->flags & AMDGPU_GEM_CREATE_DISCARDABLE))
 		bo->tbo.priority = 1;
 
 	if (!bp->destroy)
-- 
2.43.0



