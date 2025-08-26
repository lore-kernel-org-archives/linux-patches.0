Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F79B350D4D;
	Tue, 26 Aug 2025 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219154; cv=none; b=b0RkO+GrQx87QU7TGsyEHWK4ujspHQyK9gUH7b/E0dHby05ZR7HHoGW38JuHBaT7ube8qxodyVN+PJwulEbpT9ibbxjW9RvGy3EZ9EDnTvt7T67TdRUkdE4yzcJHTHe+nikFYpVvQdfTg26TLzeDWNs6xoWagzs8PXtGRtM4jk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219154; c=relaxed/simple;
	bh=tYGdkpdPsOaEneMUYRbASqaZpnKrzJngt7IjhF+GfCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVw85jZMXBu7MxHfQdxBDGuLHCprOhQ1yLKJKXcRq2VSqln5mGDawFIaS2w2K7yDFWplwnXtVNlqnkOk5x++29DwdAz6O/N/YoeCwPgIxbV7eUm11C3offKEfiaS+m/H3Z67r3iEnH/N8JmJ1Mqax3/so4UfFykLntGjkZ8UgkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBn7CeTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBn7CeTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28E6C113D0;
	Tue, 26 Aug 2025 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219154;
	bh=tYGdkpdPsOaEneMUYRbASqaZpnKrzJngt7IjhF+GfCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBn7CeTRpL7kE9Mz6ta017URXx/hb9KjmzQgjhqRpjv5kjvQuZ24sDWNnEfyPvZTW
	 0t6S5th8kc0bS1Nzk7tMLYJTn2EcbTLYfWRWsALPPFv1cC84+kkZQ7Cum60KR48oI4
	 LiK497eOB/OPKvh2844gOuDbDmjXYL6lAt2kiPA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 273/403] drm/amdgpu: fix incorrect vm flags to map bo
Date: Tue, 26 Aug 2025 13:09:59 +0200
Message-ID: <20250826110914.343656035@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit 040bc6d0e0e9c814c9c663f6f1544ebaff6824a8 ]

It should use vm flags instead of pte flags
to specify bo vm attributes.

Fixes: 7946340fa389 ("drm/amdgpu: Move csa related code to separate file")
Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b08425fa77ad2f305fe57a33dceb456be03b653f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -94,8 +94,8 @@ int amdgpu_map_static_csa(struct amdgpu_
 	}
 
 	r = amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
-			     AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE |
-			     AMDGPU_PTE_EXECUTABLE);
+			     AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
+			     AMDGPU_VM_PAGE_EXECUTABLE);
 
 	if (r) {
 		DRM_ERROR("failed to do bo_map on static CSA, err=%d\n", r);


