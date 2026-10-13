Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B9E4FDE44;
	Tue, 13 Oct 2026 12:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893790; cv=none; b=VtqdaMFKoDlG+ZIZZsbhwM5bk1QxgQI2UUa77uM6IidWKqRBL0c2iyzvF89n+mZzsNSjqkTcXsyvkZScstYKzN8lNw2CTbDfSi58j1bM01h1V8PiGJaegf0RfX93kNvaOgpxBsDFbDDG9p40u+YH4a0InR0Y47TmPyC46E/HG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893790; c=relaxed/simple;
	bh=kWmepwZ0WnUnUh/BNzaKPq1lUPM9UesMtJdELUcnQDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9vkmoMRUlCvQZEMwP/GQ6wzIpfSoNpRAMKG9BHiQJCZpc3yaGcDiRBiDywKrClF+1e+7Cpz5fYUoUulTfwPwH4PIb3Cnk4xK55+KLNyIVaX2KKz++2CYSN6Ejrk0TfB3EgIv4veQehWwsH30GqjSSeHEdfVE7vZIbOHwbJHosY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDIIQX04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDIIQX04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04C51F000FF;
	Tue, 13 Oct 2026 12:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893789;
	bh=13+3S441h5eclF/hETuLuegcUkHidEDKeqXrGZ+5YiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EDIIQX041PsSuBFRUf0SlAjjYKa62K9n49yB1DKZ4d3ro/JCypzFD1xq3fxkkwKCm
	 7itC/eGz4k/LM9/blwTeLDe91k7CB7DG0+FX0HhI3elCm22O7kV7C85dgEMt8o/j5r
	 Sq0CtUIWA6vxPR2agYRVcURMX3tFbDRHS6vdpSDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 341/621] accel/amxdna: Fix page-insertion errors in amdxdna_insert_pages()
Date: Tue, 13 Oct 2026 13:35:36 +0200
Message-ID: <20261013112928.945710217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 8d51e0fd3e698919d2adeff71936377f0c0d4aa0 ]

Two error paths in amdxdna_insert_pages() called vma->vm_ops->close(vma)
before returning an error code to the caller.  This is incorrect:
amdxdna_gem_obj_mmap() registers an HMM interval notifier before calling
amdxdna_insert_pages(), and on a hard error it jumps to hmm_unreg to undo
that registration.  Calling vm_ops->close() manually — which drops the
shmem pages_pin_count and the GEM object reference that backs the VMA —
before the mmap syscall has even returned causes those resources to be
released while the VMA is still alive.  The kernel VMA teardown will call
vm_ops->close() a second time when the process later unmaps the range,
producing a reference count underflow.

Replace both hard-error returns with a deferred-fault approach that keeps
the VMA alive and retries page insertion through the HMM range-fault path.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260723074256.2435143-1-lizhi.hou@amd.com
Stable-dep-of: 4a19f7ab5972 ("accel/amdxdna: Fix locally exploitable BUG_ON in amdxdna_insert_pages()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 9834b9199ef8c..9e5abad84d86d 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -279,6 +279,23 @@ static void amdxdna_gem_dev_obj_free(struct drm_gem_object *gobj)
 	amdxdna_gem_destroy_obj(abo);
 }
 
+static void amdxdna_mark_mapp_invalid(struct amdxdna_gem_obj *abo,
+				      struct vm_area_struct *vma)
+{
+	struct amdxdna_dev *xdna = to_xdna_dev(to_gobj(abo)->dev);
+	struct amdxdna_umap *mapp;
+
+	down_write(&xdna->notifier_lock);
+	abo->mem.map_invalid = true;
+	list_for_each_entry(mapp, &abo->mem.umap_list, node) {
+		if (compare_range(mapp, vma->vm_mm, vma->vm_start, vma->vm_end)) {
+			mapp->invalid = true;
+			break;
+		}
+	}
+	up_write(&xdna->notifier_lock);
+}
+
 static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
 				struct vm_area_struct *vma)
 {
@@ -300,8 +317,7 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
 				      &num_pages);
 		if (ret) {
 			XDNA_ERR(xdna, "Failed insert pages %d", ret);
-			vma->vm_ops->close(vma);
-			return ret;
+			amdxdna_mark_mapp_invalid(abo, vma);
 		}
 
 		return 0;
@@ -321,9 +337,9 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
 		fault_ret = handle_mm_fault(vma, vma->vm_start + offset,
 					    FAULT_FLAG_WRITE, NULL);
 		if (fault_ret & VM_FAULT_ERROR) {
-			vma->vm_ops->close(vma);
 			XDNA_ERR(xdna, "Fault in page failed");
-			return -EFAULT;
+			amdxdna_mark_mapp_invalid(abo, vma);
+			break;
 		}
 
 		offset += PAGE_SIZE;
-- 
2.53.0



