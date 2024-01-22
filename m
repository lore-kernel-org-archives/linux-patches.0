Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF68145338;
	Tue, 23 Jan 2024 00:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969573; cv=none; b=roxeQKskFPTx48CoQbd6/uAyZskMq6H6oTC8FHpBnPscDXwT8vPUKXg5V83xBab9fzcCMIYnynXv8s9k75iB51AcRzKO4G8APmtKJ+Vuo8RQZLI4Nes2s89a4vc4DtAB/dlebnTJsnYc/0WPxK4wNSCk9M9N6Y52M7gbKeqRQQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969573; c=relaxed/simple;
	bh=8FSu8sGthVfwCoUyG8acwJGBq5iF/3VrwKosFSzh3Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alnhBjv+hVn2qbgwlaUs8fBbgPELyTySeyCTXowb7Nafgu6oAtRs//37jjMRTGsjHybhEYB8fqRHbR1r0KlWf1F2DkCYb8OLPrNbzsXql451gN7FjwiwISXgWoNFLqSBF2TqOjI6091kxGXUvQhmG9z+fS9e5IkgDcYm6YnPBBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yANhtUKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yANhtUKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AB9C43399;
	Tue, 23 Jan 2024 00:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969572;
	bh=8FSu8sGthVfwCoUyG8acwJGBq5iF/3VrwKosFSzh3Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yANhtUKnmGsgo3nL7cuEnUHYi9gUDvXZN0YVR7w0B0cmzN6pgUX+aFMRUNTMdNGdv
	 eyk3epGBz6SYwSAtfAYbO/CVkTao9ZiQAbe7Ffjua7MUMXiu/sTs1rRo4YMxzKFtgX
	 EtXhwMcrj5JJuYvc0yXqNYSoohY9m3Yks7AzbJ3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 330/641] gpu/drm/radeon: fix two memleaks in radeon_vm_init
Date: Mon, 22 Jan 2024 15:53:54 -0800
Message-ID: <20240122235828.226182227@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 987cabbf1318..c38b4d5d6a14 100644
--- a/drivers/gpu/drm/radeon/radeon_vm.c
+++ b/drivers/gpu/drm/radeon/radeon_vm.c
@@ -1204,13 +1204,17 @@ int radeon_vm_init(struct radeon_device *rdev, struct radeon_vm *vm)
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



