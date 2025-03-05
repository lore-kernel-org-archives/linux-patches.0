Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F33F2517B3;
	Wed,  5 Mar 2025 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198186; cv=none; b=dUyxLDgYf7nq8kWx1jotRcyO70Q9foVMhdtfGJp0+WahtpX42Gi0J4veGPyYOfTZ0WbGGu57Mi8GqkZjHuiwU5DipLcINSqiTeNe9Zff2y3mKy9bqGFoQUtD9NFUn5aWATHnt+5Kg9gbi9c1+Q5i50BEeeMcBAfs0TJBSuGvyTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198186; c=relaxed/simple;
	bh=4Gp9gFrzyAJM4ufknPVueEb+G7Tx0hb0AUEzwza/k+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=px0zD1OI1jSOBl3odKMca0xxAj+HbBZhfe7Ne4F8cuS6YAm6FDNM1/5CJWcmxeY5NW6+CC4A5dlAD+sNCI8RGe9cgULIWBVB0Dy48y98BuPVNbxTuXP8jMvJjq2xi90m5NPJ0GZ/Re5dW0mDtNIoQNBch6ts/AlIfnkVQj/xj68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYki+jKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYki+jKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2A3C4CED1;
	Wed,  5 Mar 2025 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198186;
	bh=4Gp9gFrzyAJM4ufknPVueEb+G7Tx0hb0AUEzwza/k+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYki+jKT28ed+GMXX4j8deC1/mVd6cpLqP8T+sRyvV4S0Jd6DWw4XJiY13tEMRhgE
	 MUWODVSc+5PQPzXwzSCFGTFrC6AEjAIKxgfhLwsx7hOI7Kt82l2PzPw0HWSUmr8usM
	 o8twvgnPI896quCkTlGhndkpqyPr6SGHUaV3qfPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 094/150] drm/xe/userptr: restore invalidation list on error
Date: Wed,  5 Mar 2025 18:48:43 +0100
Message-ID: <20250305174507.585603557@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit e043dc16c28c8446e66c55adfe7c6e862a6a7bb7 upstream.

On error restore anything still on the pin_list back to the invalidation
list on error. For the actual pin, so long as the vma is tracked on
either list it should get picked up on the next pin, however it looks
possible for the vma to get nuked but still be present on this per vm
pin_list leading to corruption. An alternative might be then to instead
just remove the link when destroying the vma.

v2:
 - Also add some asserts.
 - Keep the overzealous locking so that we are consistent with the docs;
   updating the docs and related bits will be done as a follow up.

Fixes: ed2bdf3b264d ("drm/xe/vm: Subclass userptr vmas")
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250221143840.167150-4-matthew.auld@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 4e37e928928b730de9aa9a2f5dc853feeebc1742)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -667,15 +667,16 @@ int xe_vm_userptr_pin(struct xe_vm *vm)
 
 	/* Collect invalidated userptrs */
 	spin_lock(&vm->userptr.invalidated_lock);
+	xe_assert(vm->xe, list_empty(&vm->userptr.repin_list));
 	list_for_each_entry_safe(uvma, next, &vm->userptr.invalidated,
 				 userptr.invalidate_link) {
 		list_del_init(&uvma->userptr.invalidate_link);
-		list_move_tail(&uvma->userptr.repin_link,
-			       &vm->userptr.repin_list);
+		list_add_tail(&uvma->userptr.repin_link,
+			      &vm->userptr.repin_list);
 	}
 	spin_unlock(&vm->userptr.invalidated_lock);
 
-	/* Pin and move to temporary list */
+	/* Pin and move to bind list */
 	list_for_each_entry_safe(uvma, next, &vm->userptr.repin_list,
 				 userptr.repin_link) {
 		err = xe_vma_userptr_pin_pages(uvma);
@@ -691,10 +692,10 @@ int xe_vm_userptr_pin(struct xe_vm *vm)
 			err = xe_vm_invalidate_vma(&uvma->vma);
 			xe_vm_unlock(vm);
 			if (err)
-				return err;
+				break;
 		} else {
-			if (err < 0)
-				return err;
+			if (err)
+				break;
 
 			list_del_init(&uvma->userptr.repin_link);
 			list_move_tail(&uvma->vma.combined_links.rebind,
@@ -702,7 +703,19 @@ int xe_vm_userptr_pin(struct xe_vm *vm)
 		}
 	}
 
-	return 0;
+	if (err) {
+		down_write(&vm->userptr.notifier_lock);
+		spin_lock(&vm->userptr.invalidated_lock);
+		list_for_each_entry_safe(uvma, next, &vm->userptr.repin_list,
+					 userptr.repin_link) {
+			list_del_init(&uvma->userptr.repin_link);
+			list_move_tail(&uvma->userptr.invalidate_link,
+				       &vm->userptr.invalidated);
+		}
+		spin_unlock(&vm->userptr.invalidated_lock);
+		up_write(&vm->userptr.notifier_lock);
+	}
+	return err;
 }
 
 /**
@@ -1066,6 +1079,7 @@ static void xe_vma_destroy(struct xe_vma
 		xe_assert(vm->xe, vma->gpuva.flags & XE_VMA_DESTROYED);
 
 		spin_lock(&vm->userptr.invalidated_lock);
+		xe_assert(vm->xe, list_empty(&to_userptr_vma(vma)->userptr.repin_link));
 		list_del(&to_userptr_vma(vma)->userptr.invalidate_link);
 		spin_unlock(&vm->userptr.invalidated_lock);
 	} else if (!xe_vma_is_null(vma)) {


