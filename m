Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCBE6FAF
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0184EC433D2;
	Mon,  3 Apr 2023 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533462;
	bh=EotIU3jwP+WvqfLrRtuyeKq4ksTkVKWXzyG8n97abb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zK3qK0Oywfp1n0QOCyjmubGBLiyjhFK8mL6hyF7O/FUbWwPj+fccs645x7W4K82zH
	 aQhZCfXymlYWf9PAXEdikFccu0gUguGYflZvifJgT71qnnfFbChSRIFIpLmnC73XVu
	 S9fumc0Sq0rV+bwM3A7NomY9JLcoRWw6eR/0Z6mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <Xiaogang.Chen@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 185/187] drm/amdkfd: Get prange->offset after svm_range_vram_node_new
Date: Mon,  3 Apr 2023 16:10:30 +0200
Message-Id: <20230403140422.459494223@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiaogang Chen <xiaogang.chen@amd.com>

commit 8eeddc0d4200762063e1c66b9cc63afa7b24ebf0 upstream.

During miration to vram prange->offset is valid after vram buffer is located,
either use old one or allocate a new one. Move svm_range_vram_node_new before
migrate for each vma to get valid prange->offset.

v2: squash in warning fix

Fixes: b4ee9606378b ("drm/amdkfd: Fix BO offset for multi-VMA page migration")
Signed-off-by: Xiaogang Chen <Xiaogang.Chen@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -305,12 +305,6 @@ svm_migrate_copy_to_vram(struct amdgpu_d
 	src = scratch;
 	dst = (uint64_t *)(scratch + npages);
 
-	r = svm_range_vram_node_new(adev, prange, true);
-	if (r) {
-		dev_dbg(adev->dev, "fail %d to alloc vram\n", r);
-		goto out;
-	}
-
 	amdgpu_res_first(prange->ttm_res, ttm_res_offset,
 			 npages << PAGE_SHIFT, &cursor);
 	for (i = j = 0; i < npages; i++) {
@@ -391,7 +385,7 @@ out_free_vram_pages:
 		migrate->dst[i + 3] = 0;
 	}
 #endif
-out:
+
 	return r;
 }
 
@@ -520,6 +514,12 @@ svm_migrate_ram_to_vram(struct svm_range
 
 	start = prange->start << PAGE_SHIFT;
 	end = (prange->last + 1) << PAGE_SHIFT;
+
+	r = svm_range_vram_node_new(adev, prange, true);
+	if (r) {
+		dev_dbg(adev->dev, "fail %ld to alloc vram\n", r);
+		return r;
+	}
 	ttm_res_offset = prange->offset << PAGE_SHIFT;
 
 	for (addr = start; addr < end;) {
@@ -543,6 +543,8 @@ svm_migrate_ram_to_vram(struct svm_range
 
 	if (cpages)
 		prange->actual_loc = best_loc;
+	else
+		svm_range_vram_node_free(prange);
 
 	return r < 0 ? r : 0;
 }


