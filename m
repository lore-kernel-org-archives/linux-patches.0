Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0819233F374;
	Tue, 16 Dec 2025 11:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884569; cv=none; b=VJYvqu18n7nBk/VlyEaIY95j7YB0w/QZrFpauPMB5vwAZZ4RcXcD3hfJUJSKci7INgIIHdzh4eVC+H/sPPHU2s3xDb1AmxB4EfynV1idYvT1x82ZdwZjuWdfMqkjLY/1nNBkcXghaK4QBz9Mc1V13uUCwfbZcE0pa8F4GTlqn5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884569; c=relaxed/simple;
	bh=yo6g/z5e4SBVAJfCOwaVwcacoELU16SnKmB0Nj07SDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHBYssPohexx4PsDG3BCe8LxUEtcXnsEB4qwNQG6GwED+PRn95P4yC7xZzZ6j5b3ml8+JEbidDBXja9husqr4qoGYhnN+T/FhWl4U4l5wN6DaoxDiF7txQsAo4f5iLSphlWWHrvT1+cMXeoqN1LQ6NgXLHimjCvtVu0h1CVKASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXsahXmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXsahXmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B196C4CEF1;
	Tue, 16 Dec 2025 11:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884568;
	bh=yo6g/z5e4SBVAJfCOwaVwcacoELU16SnKmB0Nj07SDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXsahXmJ5Q+N0H0JbdzsalxpYyTZBgHn4luZOxeb18klZ5VEJ0HoK+VdeLoVMYXqw
	 2yVP0NU9dgageE4aCntm7RF8KW0jouNMCv9KkLAkuwT8E9BWcwbPAKCJf2zVQFYs/c
	 ZemBeBO4iClZ/byCrNkiaPZkbIw00Xs2MRGKSzUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/354] drm/panthor: Avoid adding of kernel BOs to extobj list
Date: Tue, 16 Dec 2025 12:13:20 +0100
Message-ID: <20251216111329.357607398@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit ce04ec03a9c2c4f3e60e26f21311b25d5a478208 ]

The kernel BOs unnecessarily got added to the external objects list
of drm_gpuvm, when mapping to GPU, which would have resulted in few
extra CPU cycles being spent at the time of job submission as
drm_exec_until_all_locked() loop iterates over all external objects.

Kernel BOs are private to a VM and so they share the dma_resv object of
the dummy GEM object created for a VM. Use of DRM_EXEC_IGNORE_DUPLICATES
flag ensured the recursive locking of the dummy GEM object was ignored.
Also no extra space got allocated to add fences to the dma_resv object
of dummy GEM object. So no other impact apart from few extra CPU cycles.

This commit sets the pointer to dma_resv object of GEM object of
kernel BOs before they are mapped to GPU, to prevent them from
being added to external objects list.

v2: Add R-bs and fixes tags

Fixes: 8a1cc07578bf ("drm/panthor: Add GEM logical block")
Signed-off-by: Akash Goel <akash.goel@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251120172118.2741724-1-akash.goel@arm.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 8387a075150bd..0438b80a6434b 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -88,6 +88,9 @@ panthor_kernel_bo_create(struct panthor_device *ptdev, struct panthor_vm *vm,
 	bo = to_panthor_bo(&obj->base);
 	kbo->obj = &obj->base;
 	bo->flags = bo_flags;
+	bo->exclusive_vm_root_gem = panthor_vm_root_gem(vm);
+	drm_gem_object_get(bo->exclusive_vm_root_gem);
+	bo->base.base.resv = bo->exclusive_vm_root_gem->resv;
 
 	/* The system and GPU MMU page size might differ, which becomes a
 	 * problem for FW sections that need to be mapped at explicit address
@@ -105,9 +108,6 @@ panthor_kernel_bo_create(struct panthor_device *ptdev, struct panthor_vm *vm,
 		goto err_free_va;
 
 	kbo->vm = panthor_vm_get(vm);
-	bo->exclusive_vm_root_gem = panthor_vm_root_gem(vm);
-	drm_gem_object_get(bo->exclusive_vm_root_gem);
-	bo->base.base.resv = bo->exclusive_vm_root_gem->resv;
 	return kbo;
 
 err_free_va:
-- 
2.51.0



