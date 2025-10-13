Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943052F9D82;
	Mon, 13 Oct 2025 15:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369396; cv=none; b=XYIw1R6CO/xOp6cObhrm8tGvvpDqlWkG/HTB0LYyagQUpdME2aXtoV9zggMiutjBSNSmxeO8f1NVZ4eDJy/bK7IbOx1mfd7BFFSfxxg6QQtHRdhj5dSk/dlFx4Cxm8XdiXNQo8pMFnGhHT9+Dyv0/FcqZOsat1ncn1WaIcUyOLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369396; c=relaxed/simple;
	bh=BJqrm4wJOjXzULBitfsV2VCiqRWpaeGdrYQ89U/D1W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXRFpJ4f7L3PgoBBrQQAO7MH0Pmi5ZdeN5U9Tu2Qb308AAx+9tP7nu4a7o8NCY6ZM2HMa+xQvKpZRN8CO8tv6qan7oZTLWcmf1NPHuKoXj2kSHwckftoq7KDEI26NcQuitLXegixMi+wxfdJOTsygt6qliUVmhltWZ5eJVHQcX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYdgkGNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYdgkGNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC78C4CEFE;
	Mon, 13 Oct 2025 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369396;
	bh=BJqrm4wJOjXzULBitfsV2VCiqRWpaeGdrYQ89U/D1W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYdgkGNU7vdOFxxoXbTTT/XtfxQPlvXaxkUUJfb9hiatHF6w9GqXJLNWSXv42hazP
	 tdi/nvt1iD2LuNg+U/ENobsppxUvncRJrxcubagUqFvUnfp/eNguCgiAv332JkIU2N
	 dfnNxk4zFd/zaWhHiJwhVhEA7ZOkZz0xUn5/fnhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 230/563] drm/amdgpu: fix incorrect vm flags to map bo
Date: Mon, 13 Oct 2025 16:41:31 +0200
Message-ID: <20251013144419.612649904@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit b08425fa77ad2f305fe57a33dceb456be03b653f ]

It should use vm flags instead of pte flags
to specify bo vm attributes.

Fixes: 7946340fa389 ("drm/amdgpu: Move csa related code to separate file")
Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
index 02138aa557935..dfb6cfd837606 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -88,8 +88,8 @@ int amdgpu_map_static_csa(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 	}
 
 	r = amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
-			     AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE |
-			     AMDGPU_PTE_EXECUTABLE);
+			     AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
+			     AMDGPU_VM_PAGE_EXECUTABLE);
 
 	if (r) {
 		DRM_ERROR("failed to do bo_map on static CSA, err=%d\n", r);
-- 
2.51.0



