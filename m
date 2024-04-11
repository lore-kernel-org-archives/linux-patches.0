Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C253134CC2;
	Thu, 11 Apr 2024 10:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831782; cv=none; b=idn8tqXukQSGC2Y7jaTfDxSHqVhlnF4D+W+2PnZ4YEMDSXZuQ4YeQ3luPx2tUsqE7Z1wIZUUoJmNW5e3+jYHHSE5ECWyZEO0hn3Bh4b9vm2Z0XpBhbMyzC7aX5gPreZ+++SgSnvm8FUWy+1irNWa0ljhvPCUDxfykw1v1PuaTNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831782; c=relaxed/simple;
	bh=XNByPdH7noUFgo9oynGOmg954fkE/jFM59QL9ZkMG5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxFEKVrHl6MDSpGxxWy7Y2X2Kl3dUZbyd89s8k/qwxDr/+bac8GbtODb7xokffg1vZ9xHRflF6aXlOFB+2B7bxFl0losill/uwmBV+n8RIDdQdykYdqEOziqgZ+k+eG2tOUK3sYuz3goNpQ/mDnd81ZPrBE5wIfupJmaxNuolVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tr0wu5Y1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tr0wu5Y1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13334C433F1;
	Thu, 11 Apr 2024 10:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831782;
	bh=XNByPdH7noUFgo9oynGOmg954fkE/jFM59QL9ZkMG5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tr0wu5Y1SVzITv3lw+BJ5G9C/IRgI4hP580nKeq+fmVfyBEp3erDeql5KcNN8j8d/
	 0IdQYpgjPtgWPRUiREexs2wxRdsVoI4uc9cxC67xtj3vIl6HJ36HyBP/oN717VWNj2
	 fWHRyLuARs4HBEN2lGzIIfTMLHxeBKh3DiqGfPuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabe Kirkpatrick <gkirkpatrick@google.com>,
	Josh Eads <josheads@google.com>,
	Peter Gonda <pgonda@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 124/294] KVM: SVM: Flush pages under kvm->lock to fix UAF in svm_register_enc_region()
Date: Thu, 11 Apr 2024 11:54:47 +0200
Message-ID: <20240411095439.397273661@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 5ef1d8c1ddbf696e47b226e11888eaf8d9e8e807 upstream.

Do the cache flush of converted pages in svm_register_enc_region() before
dropping kvm->lock to fix use-after-free issues where region and/or its
array of pages could be freed by a different task, e.g. if userspace has
__unregister_enc_region_locked() already queued up for the region.

Note, the "obvious" alternative of using local variables doesn't fully
resolve the bug, as region->pages is also dynamically allocated.  I.e. the
region structure itself would be fine, but region->pages could be freed.

Flushing multiple pages under kvm->lock is unfortunate, but the entire
flow is a rare slow path, and the manual flush is only needed on CPUs that
lack coherency for encrypted memory.

Fixes: 19a23da53932 ("Fix unsynchronized access to sev members through svm_register_enc_region")
Reported-by: Gabe Kirkpatrick <gkirkpatrick@google.com>
Cc: Josh Eads <josheads@google.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20240217013430.2079561-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1024,20 +1024,22 @@ int svm_register_enc_region(struct kvm *
 		goto e_free;
 	}
 
-	region->uaddr = range->addr;
-	region->size = range->size;
-
-	list_add_tail(&region->list, &sev->regions_list);
-	mutex_unlock(&kvm->lock);
-
 	/*
 	 * The guest may change the memory encryption attribute from C=0 -> C=1
 	 * or vice versa for this memory range. Lets make sure caches are
 	 * flushed to ensure that guest data gets written into memory with
-	 * correct C-bit.
+	 * correct C-bit.  Note, this must be done before dropping kvm->lock,
+	 * as region and its array of pages can be freed by a different task
+	 * once kvm->lock is released.
 	 */
 	sev_clflush_pages(region->pages, region->npages);
 
+	region->uaddr = range->addr;
+	region->size = range->size;
+
+	list_add_tail(&region->list, &sev->regions_list);
+	mutex_unlock(&kvm->lock);
+
 	return ret;
 
 e_free:


