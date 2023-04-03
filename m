Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2914D6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64E7C433EF;
	Mon,  3 Apr 2023 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533449;
	bh=gJ016sqzJQxqEjvfTMBfOhvk6EinTxxMh5BJM1UUeJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofX5NGaeuuKYjxFo5h1m5cWDwRerUyACdk0oR9YMn7Xl1KffX999kLpIElXoya7Hi
	 5g2s6uFLjdAUeDryXwD2Po04kHQdPqSbfZE/+6lyX43PaUaYytZ4ke+D6Sh4381PQB
	 n7LFxo3ZdSIfLhfkxrAIXQlZ4t3dtfQT/V2UaV+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.2 180/187] KVM: arm64: Check for kvm_vma_mte_allowed in the critical section
Date: Mon,  3 Apr 2023 16:10:25 +0200
Message-Id: <20230403140422.230511109@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 8c2e8ac8ad4be68409e806ce1cc78fc7a04539f3 upstream.

On page fault, we find about the VMA that backs the page fault
early on, and quickly release the mmap_read_lock. However, using
the VMA pointer after the critical section is pretty dangerous,
as a teardown may happen in the meantime and the VMA be long gone.

Move the sampling of the MTE permission early, and NULL-ify the
VMA pointer after that, just to be on the safe side.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230316174546.3777507-3-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1218,7 +1218,7 @@ static int user_mem_abort(struct kvm_vcp
 {
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
-	bool exec_fault;
+	bool exec_fault, mte_allowed;
 	bool device = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
@@ -1309,6 +1309,10 @@ static int user_mem_abort(struct kvm_vcp
 		fault_ipa &= ~(vma_pagesize - 1);
 
 	gfn = fault_ipa >> PAGE_SHIFT;
+	mte_allowed = kvm_vma_mte_allowed(vma);
+
+	/* Don't use the VMA after the unlock -- it may have vanished */
+	vma = NULL;
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
@@ -1379,7 +1383,7 @@ static int user_mem_abort(struct kvm_vcp
 
 	if (fault_status != ESR_ELx_FSC_PERM && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (kvm_vma_mte_allowed(vma)) {
+		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
 			ret = -EFAULT;


