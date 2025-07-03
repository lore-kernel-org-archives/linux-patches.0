Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BC615442C;
	Thu,  3 Jul 2025 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555283; cv=none; b=JgXupDselC55t0kVGiLgqpavz7IBVbjDFvkdgWIHK1pJlJGFq2ou+5mt7R5LBSFhiKbhOGiDWZ9RJrX+H+n+gZvnRHAa7nPWHPGZS3vqGcMyICVOqEM99qT7Dvs3swzuakfsKQebv27wT0mx3APetaiGFWJ1rSS/KokmkP7l0A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555283; c=relaxed/simple;
	bh=S3ZeoCBbZMUz4m1cNEdv7mqnRRNm1vWgk/nzAwGAT+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OMP3cQz7hViecXSR4H/5V3rFj3gglYgMmYN9prHPydUyRoZ4/evxcGJP3FGYWF06R/Lqd6/eT2ABdXmfgM5tcrHEJiJp1WsblirKzroLyP/PggQure47uN6NMFPvLem/mX7cxsJXmTQM9J8BTgjnliw7nClpVLj18gpMXE622X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5nAmvvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5nAmvvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690DDC4CEE3;
	Thu,  3 Jul 2025 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555282;
	bh=S3ZeoCBbZMUz4m1cNEdv7mqnRRNm1vWgk/nzAwGAT+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5nAmvvV5cLV/jfgHlBEE4BvpEweDvErvDmi2/+cUtOZK7CKoN1vXiy7vNoJE5WL6
	 i27n1ZAvGVVoe1L8JAUqM0iUvVxyNYPKxedeorxDbljMMhUaWZA50y35v9cqTwePVD
	 pPrT5XcfqHXNYT8VAurdM3KuF2xqnXJofv4+PphU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.15 223/263] drm/xe/vm: move rebind_work init earlier
Date: Thu,  3 Jul 2025 16:42:23 +0200
Message-ID: <20250703144013.321705167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit a63e99b4d6d3a0353ef47146dd5bd562f08e1786 upstream.

In xe_vm_close_and_put() we need to be able to call
flush_work(rebind_work), however during vm creation we can call this on
the error path, before having actually set up the worker, leading to a
splat from flush_work().

It looks like we can simply move the worker init step earlier to fix
this.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250514152424.149591-3-matthew.auld@intel.com
(cherry picked from commit 96af397aa1a2d1032a6e28ff3f4bc0ab4be40e1d)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1678,8 +1678,10 @@ struct xe_vm *xe_vm_create(struct xe_dev
 	 * scheduler drops all the references of it, hence protecting the VM
 	 * for this case is necessary.
 	 */
-	if (flags & XE_VM_FLAG_LR_MODE)
+	if (flags & XE_VM_FLAG_LR_MODE) {
+		INIT_WORK(&vm->preempt.rebind_work, preempt_rebind_work_func);
 		xe_pm_runtime_get_noresume(xe);
+	}
 
 	if (flags & XE_VM_FLAG_FAULT_MODE) {
 		err = xe_svm_init(vm);
@@ -1730,10 +1732,8 @@ struct xe_vm *xe_vm_create(struct xe_dev
 		vm->batch_invalidate_tlb = true;
 	}
 
-	if (vm->flags & XE_VM_FLAG_LR_MODE) {
-		INIT_WORK(&vm->preempt.rebind_work, preempt_rebind_work_func);
+	if (vm->flags & XE_VM_FLAG_LR_MODE)
 		vm->batch_invalidate_tlb = false;
-	}
 
 	/* Fill pt_root after allocating scratch tables */
 	for_each_tile(tile, xe, id) {


