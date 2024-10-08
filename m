Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E0D1DF732;
	Tue,  8 Oct 2024 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392924; cv=none; b=X+r7Bw5jf+9irvrJ2pYZKB4MF32RyULFM6iqH2gc/MAUW7EDAGHuzQ/TlOnbi0c/YWhVq7dXLtPpRCTM7jpZAYWetT5hm/cqGhRxGfJkOXGAzo13EzjYC0l7lec08MvHD3j2ctKUzwPfNFaZ27+hnzVkcW1tVuXO8vQ1YTpDDEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392924; c=relaxed/simple;
	bh=2z2s7Z3cBMm5lHNhavD+5cdAOpKirKL5MXjBiU0+9zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW4IyiwG2Gwq5KxEhpERQHTrfd3BW0Kab+VxizzyCchB9/a+l7IXlLTD1sdMq5zeEc1Gv97Lq07ssScZjGZV1qDlK9gN+TGl3VbrVM7gs2U46NirO2S+5ZJNHn3ZOtGm2EZsmn6VHjYBnQ4SJ0PX7u3qCcry+Fo6j+nhtzj4HqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyYXJsI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyYXJsI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA0CC4CEC7;
	Tue,  8 Oct 2024 13:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392924;
	bh=2z2s7Z3cBMm5lHNhavD+5cdAOpKirKL5MXjBiU0+9zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyYXJsI5kgos1GL4V/zFtMklWrXel5m+0cXiXBUB4CnfIvnLCIybaJKSqAG7ZeAdA
	 uLcejZKy3sOradwHHNb9WPgvU5Tyzy2kLtDkzy1Y8VNH+zVU4hlI/U4MfRzKgivW7L
	 WsXq++Z7i7CXGuBZ2NwZl83SKgfICkfch6NjrXeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 547/558] drm/xe/vm: move xa_alloc to prevent UAF
Date: Tue,  8 Oct 2024 14:09:37 +0200
Message-ID: <20241008115723.759277488@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 74231870cf4976f69e83aa24f48edb16619f652f ]

Evil user can guess the next id of the vm before the ioctl completes and
then call vm destroy ioctl to trigger UAF since create ioctl is still
referencing the same vm. Move the xa_alloc all the way to the end to
prevent this.

v2:
 - Rebase

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240925071426.144015-3-matthew.auld@intel.com
(cherry picked from commit dcfd3971327f3ee92765154baebbaece833d3ca9)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 8fb425ad9e4a4..49ba9a1e375f4 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1905,10 +1905,6 @@ int xe_vm_create_ioctl(struct drm_device *dev, void *data,
 	if (IS_ERR(vm))
 		return PTR_ERR(vm);
 
-	err = xa_alloc(&xef->vm.xa, &id, vm, xa_limit_32b, GFP_KERNEL);
-	if (err)
-		goto err_close_and_put;
-
 	if (xe->info.has_asid) {
 		mutex_lock(&xe->usm.lock);
 		err = xa_alloc_cyclic(&xe->usm.asid_to_vm, &asid, vm,
@@ -1916,12 +1912,11 @@ int xe_vm_create_ioctl(struct drm_device *dev, void *data,
 				      &xe->usm.next_asid, GFP_KERNEL);
 		mutex_unlock(&xe->usm.lock);
 		if (err < 0)
-			goto err_free_id;
+			goto err_close_and_put;
 
 		vm->usm.asid = asid;
 	}
 
-	args->vm_id = id;
 	vm->xef = xe_file_get(xef);
 
 	/* Record BO memory for VM pagetable created against client */
@@ -1934,10 +1929,15 @@ int xe_vm_create_ioctl(struct drm_device *dev, void *data,
 	args->reserved[0] = xe_bo_main_addr(vm->pt_root[0]->bo, XE_PAGE_SIZE);
 #endif
 
+	/* user id alloc must always be last in ioctl to prevent UAF */
+	err = xa_alloc(&xef->vm.xa, &id, vm, xa_limit_32b, GFP_KERNEL);
+	if (err)
+		goto err_close_and_put;
+
+	args->vm_id = id;
+
 	return 0;
 
-err_free_id:
-	xa_erase(&xef->vm.xa, id);
 err_close_and_put:
 	xe_vm_close_and_put(vm);
 
-- 
2.43.0



