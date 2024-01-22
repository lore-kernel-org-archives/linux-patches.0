Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E716FB3;
	Tue, 23 Jan 2024 00:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968427; cv=none; b=ijCuEie94x9Xudo1yYJFnYOVjxtp+xTxQrkl0hDVcsFfE+IWfTuwfdmhSol1PKEqPPv2kmvHkOn0QWRQUg/qzKJh6wqJr3SEHigD23EykquBIvS7N0CUv2PSVLIHAUZen048bw5LRWuF6+UN2efRAn/gQ0RsOujscomAXXkSfBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968427; c=relaxed/simple;
	bh=G8oZ0XAQnMNWBz7ua7mz481KmZgCNMvEl1bO6a9J1F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvzyXCEPwzZJB3S4BsIRRP47UYcX5aCdwMgBG2Z1Ak9/hTf4RYpOWe0hr2onQMnTvx98rsSX6BX6qO/+ymfL5mSX9CnrNLdAnVyxnm3mhnpub1WyfRuTVaL/Z3fvykWcFVn/7rpBqEOb/UWWDp/rXbLkUDyPcxwYXoyqkOFTE1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFtzsA5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFtzsA5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B0EC433C7;
	Tue, 23 Jan 2024 00:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968426;
	bh=G8oZ0XAQnMNWBz7ua7mz481KmZgCNMvEl1bO6a9J1F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFtzsA5W9gJCOT9GyUu6qqdAjtFjxYv3mPdU7WpD22BlmW2mnhTGpGjgnjudAv3r0
	 KfZRj7L+m9ug84ruqr4oHD3qdY9pFOIkRYi1BBCmQTUyGhEFQZ9JVT8C/6xKyqlcxC
	 4jlLyONYplbuB8KQkfCqhZhjmhTzwZKIpPjo8LJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/148] gpu/drm/radeon: fix two memleaks in radeon_vm_init
Date: Mon, 22 Jan 2024 15:57:41 -0800
Message-ID: <20240122235716.672210039@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit c2709b2d6a537ca0fa0f1da36fdaf07e48ef447d ]

When radeon_bo_create and radeon_vm_clear_bo fail, the vm->page_tables
allocated before need to be freed. However, neither radeon_vm_init
itself nor its caller have done such deallocation.

Fixes: 6d2f2944e95e ("drm/radeon: use normal BOs for the page tables v4")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_vm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_vm.c b/drivers/gpu/drm/radeon/radeon_vm.c
index 7f1a9c787bd1..cecbd5282a47 100644
--- a/drivers/gpu/drm/radeon/radeon_vm.c
+++ b/drivers/gpu/drm/radeon/radeon_vm.c
@@ -1206,13 +1206,17 @@ int radeon_vm_init(struct radeon_device *rdev, struct radeon_vm *vm)
 	r = radeon_bo_create(rdev, pd_size, align, true,
 			     RADEON_GEM_DOMAIN_VRAM, 0, NULL,
 			     NULL, &vm->page_directory);
-	if (r)
+	if (r) {
+		kfree(vm->page_tables);
+		vm->page_tables = NULL;
 		return r;
-
+	}
 	r = radeon_vm_clear_bo(rdev, vm->page_directory);
 	if (r) {
 		radeon_bo_unref(&vm->page_directory);
 		vm->page_directory = NULL;
+		kfree(vm->page_tables);
+		vm->page_tables = NULL;
 		return r;
 	}
 
-- 
2.43.0



