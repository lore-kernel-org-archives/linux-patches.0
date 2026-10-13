Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70604D7D30;
	Tue, 13 Oct 2026 12:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893945; cv=none; b=PTOkJ+2epbiHo6QMNLbS1ahSsZNYRdQX9IZh/wZ9o5GxjAE0+pUZR6lfrihySY2MnIF934NllXHqk7tbraYf7mzMVLYWXdmvyL/urD6ckQw42JsuimlODXSWuA58PtrK/Ra2RowAAqZAcczpK3/YjrKSdAsy6Mitk05aD80pkRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893945; c=relaxed/simple;
	bh=1ubtsfYz4aubIEP/k1fRX6tdAejfKZT1qJ3kPskQ/zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPbi43Sp03XIHx2vCEYTStwJPj7HLDLq/kgi6PkT/NzUmBYD3sxUHSf1hIt8JfWnViVt09kvYsFPYyobCpcbMQRwTmUqOTdyTq1OJVhSanu5jaQ4T4g/w1kLa/GSWWiUeANBSbZUo5Ywd+OoVhTOm5SNgwTSJ4aJjpvv/VOcAqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=He13fUxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="He13fUxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D741F000FF;
	Tue, 13 Oct 2026 12:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893944;
	bh=Y1HhdBGbBl0W3WnM4ex9HxZOr/46pNiyqlmjcCBuFjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=He13fUxERg74EuDkR/GVrAOrycThvZz+kOSrMCcZ2LQZAMbEpwgdkl3c63mS5Rgpn
	 DY2zULC09oB+EoWmQg7DSGYxZ72lE/yJcT/UzFeIH723SCXSXr11Gs5fLbOrdkDmqk
	 i6+Loyn2sDHZ4tquqlBMRXS82wC0NGbIi371ZgCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 342/621] accel/amdxdna: Fix locally exploitable BUG_ON in amdxdna_insert_pages()
Date: Tue, 13 Oct 2026 13:35:37 +0200
Message-ID: <20261013112928.969224439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 4a19f7ab5972ef608b31ae921419bc3e04b3f8ad ]

In amdxdna_insert_pages(), vm_flags_mod() sets VM_MIXEDMAP and clears
VM_PFNMAP. If an unprivileged userspace process mmaps a non-imported GEM
object and then calls madvise(MADV_DONTNEED), the PTEs will be
successfully cleared because VM_MIXEDMAP allows this (unlike VM_PFNMAP).

When userspace subsequently accesses the memory, drm_gem_shmem_fault()
handles the page fault and attempts to map the backing shmem page via
vmf_insert_pfn() which calls vmf_insert_pfn_prot(). Because the backing
shmem page is normal system memory (pfn_valid(pfn) is true) and the VMA
now has VM_MIXEDMAP set, won't this predictably trigger the explicit
assertion BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn))

Fix by removing the vm_flags_mod() call and replacing the vm_insert_pages()
pre-population with the handle_mm_fault() loop that was already used for
the import (dma-buf) path.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260731185955.3449311-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 9e5abad84d86d..147c4c66be4cb 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -310,25 +310,17 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
 			XDNA_ERR(xdna, "Failed shmem mmap %d", ret);
 			return ret;
 		}
-
-		/* The buffer is based on memory pages. Fix the flag. */
-		vm_flags_mod(vma, VM_MIXEDMAP, VM_PFNMAP);
-		ret = vm_insert_pages(vma, vma->vm_start, abo->base.pages,
-				      &num_pages);
+	} else {
+		vma->vm_private_data = NULL;
+		vma->vm_ops = NULL;
+		ret = dma_buf_mmap(abo->dma_buf, vma, 0);
 		if (ret) {
-			XDNA_ERR(xdna, "Failed insert pages %d", ret);
-			amdxdna_mark_mapp_invalid(abo, vma);
+			XDNA_ERR(xdna, "Failed to mmap dma buf %d", ret);
+			return ret;
 		}
 
-		return 0;
-	}
-
-	vma->vm_private_data = NULL;
-	vma->vm_ops = NULL;
-	ret = dma_buf_mmap(abo->dma_buf, vma, 0);
-	if (ret) {
-		XDNA_ERR(xdna, "Failed to mmap dma buf %d", ret);
-		return ret;
+		/* Drop the reference drm_gem_mmap_obj() acquired.*/
+		drm_gem_object_put(to_gobj(abo));
 	}
 
 	do {
@@ -345,9 +337,6 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
 		offset += PAGE_SIZE;
 	} while (--num_pages);
 
-	/* Drop the reference drm_gem_mmap_obj() acquired.*/
-	drm_gem_object_put(to_gobj(abo));
-
 	return 0;
 }
 
-- 
2.53.0



