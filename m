Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51E14B0492;
	Mon, 17 Aug 2026 13:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973990; cv=none; b=o5OO5G4dq4g0Gnsr3FF9HWmGj+w6fGzmHpZcb1huJGvqV6IgClztO2m+dmeog5jlIPaFT7hWTOUZ4P6iUMFOV1YaprlF8rz+AB5ER2ybwaMdPeijLmDZ51wws3qKlhVawogLpUi/6eeQTetuJNLeWQaaPFCE9ay9BJM7YFPiLig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973990; c=relaxed/simple;
	bh=KWoQTIQcWzqpPTP/vV0Vz6xQthSXx2bn4PF74p3tCQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PFyBX3yrBT6judPdpgI0pc4lwIVx0NtyuOWdr10Xoj85Z9MRxHWbdXoKAmYgos18RDQb8U2sBteGS9ycUr3dC7sdFuWih15YTCAfPucODQYXdGBHjSzHIEOtXoqySUnx0+7yT1Eps+WJZXPwtcb/coTq9joqQ2bfIFOhElpoq7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkTKLNM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkTKLNM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75C81F000E9;
	Mon, 17 Aug 2026 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973988;
	bh=fau163k163BwZjktE4fIJdOl0e1vFAJ5412ZQIZOifs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkTKLNM5aVEPsicFD493Zua/C0UhlF0XoXGY68WG4YV+3x967LZThjnxgS1m9Iyps
	 6yhzB7fvoLn3gvy2Acu/1qd+p/LOVCYieJoaIPo5nOj8GWduWQadxsVh2L/U7eeUfy
	 CA5l4UPxMp0LCkyGvTXeeZ3Bcg6WGmgAKWIKTg/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 051/271] accel/amxdna: Fix page-insertion errors in amdxdna_insert_pages()
Date: Mon, 17 Aug 2026 15:29:36 +0200
Message-ID: <20260817132538.837294384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index cdf113dadc4db..41fb39d095749 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -371,6 +371,23 @@ static void amdxdna_gem_dev_obj_free(struct drm_gem_object *gobj)
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
@@ -392,8 +409,7 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
 				      &num_pages);
 		if (ret) {
 			XDNA_ERR(xdna, "Failed insert pages %d", ret);
-			vma->vm_ops->close(vma);
-			return ret;
+			amdxdna_mark_mapp_invalid(abo, vma);
 		}
 
 		return 0;
@@ -413,9 +429,9 @@ static int amdxdna_insert_pages(struct amdxdna_gem_obj *abo,
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



