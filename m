Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0018E2153DF;
	Thu, 12 Dec 2024 15:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017376; cv=none; b=dhWaPGw19PY3wnvYYEtRoSgHM0EJQX0vm6uz6dpjbui37DciQEpaW2EjernQuLXoJxbXDHvtrho9waJbA4zT7y6IPmQ5fM5Rr6XfVour0cKH5GibcQGizrvHBPf3LBJg8xq2nHg56ehaSoLqhi5jn82xLLjvhsuAslQoVjzVfqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017376; c=relaxed/simple;
	bh=paG7idZL37d3pRzaiGjlOwCuKmmfFJv5Dht1yvCRU1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRwrkDg/YKHTF0n7oZ1aAAqPL6LaxuBOUqHS0/r+Rp6c14zsmQuQ73/wWgR4VzuNToST1V8sHIoMF3zX+0m4BEDFZ6BEL8iHEgnVzHk7sFgZdMJQKvzT2DM1ENA28P8viF78bCXY+AOqC1ars+GUz/p0JmiDxbVi1DDtRtl4jB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5mT5ZLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5mT5ZLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFBBC4CECE;
	Thu, 12 Dec 2024 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017375;
	bh=paG7idZL37d3pRzaiGjlOwCuKmmfFJv5Dht1yvCRU1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5mT5ZLY62bxj2LY767SJx0TXqoUmAoZ6XZHlxuLlNBw9FowUSrgCfWOUShMJSWzI
	 pg0N/BrEqxV9NO3HK2DQESEAUGV3OqK6fT/lsv9C3yfZxbwnQttjPASyjIkqxIfMEe
	 lYFA+4vr1Vx6biEHOhuDHSW4p96n2utGrRLragc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH 6.12 454/466] KVM: x86/mmu: Ensure that kvm_release_pfn_clean() takes exact pfn from kvm_faultin_pfn()
Date: Thu, 12 Dec 2024 16:00:23 +0100
Message-ID: <20241212144324.807059904@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

Since 5.16 and prior to 6.13 KVM can't be used with FSDAX
guest memory (PMD pages). To reproduce the issue you need to reserve
guest memory with `memmap=` cmdline, create and mount FS in DAX mode
(tested both XFS and ext4), see doc link below. ndctl command for test:
ndctl create-namespace -v -e namespace1.0 --map=dev --mode=fsdax -a 2M
Then pass memory object to qemu like:
-m 8G -object memory-backend-file,id=ram0,size=8G,\
mem-path=/mnt/pmem/guestmem,share=on,prealloc=on,dump=off,align=2097152 \
-numa node,memdev=ram0,cpus=0-1
QEMU fails to run guest with error: kvm run failed Bad address
and there are two warnings in dmesg:
WARN_ON_ONCE(!page_count(page)) in kvm_is_zone_device_page() and
WARN_ON_ONCE(folio_ref_count(folio) <= 0) in try_grab_folio() (v6.6.63)

It looks like in the past assumption was made that pfn won't change from
faultin_pfn() to release_pfn_clean(), e.g. see
commit 4cd071d13c5c ("KVM: x86/mmu: Move calls to thp_adjust() down a level")
But kvm_page_fault structure made pfn part of mutable state, so
now release_pfn_clean() can take hugepage-adjusted pfn.
And it works for all cases (/dev/shm, hugetlb, devdax) except fsdax.
Apparently in fsdax mode faultin-pfn and adjusted-pfn may refer to
different folios, so we're getting get_page/put_page imbalance.

To solve this preserve faultin pfn in separate local variable
and pass it in kvm_release_pfn_clean().

Patch tested for all mentioned guest memory backends with tdp_mmu={0,1}.

No bug in upstream as it was solved fundamentally by
commit 8dd861cc07e2 ("KVM: x86/mmu: Put refcounted pages instead of blindly releasing pfns")
and related patch series.

Link: https://nvdimm.docs.kernel.org/2mib_fs_dax.html
Fixes: 2f6305dd5676 ("KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault")
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c         |   10 ++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h |    5 ++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4580,6 +4580,7 @@ static bool is_page_fault_stale(struct k
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	kvm_pfn_t orig_pfn;
 	int r;
 
 	/* Dummy roots are used only for shadowing bad guest roots. */
@@ -4601,6 +4602,8 @@ static int direct_page_fault(struct kvm_
 	if (r != RET_PF_CONTINUE)
 		return r;
 
+	orig_pfn = fault->pfn;
+
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
@@ -4615,7 +4618,7 @@ static int direct_page_fault(struct kvm_
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(orig_pfn);
 	return r;
 }
 
@@ -4675,6 +4678,7 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault)
 static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 				  struct kvm_page_fault *fault)
 {
+	kvm_pfn_t orig_pfn;
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, fault))
@@ -4692,6 +4696,8 @@ static int kvm_tdp_mmu_page_fault(struct
 	if (r != RET_PF_CONTINUE)
 		return r;
 
+	orig_pfn = fault->pfn;
+
 	r = RET_PF_RETRY;
 	read_lock(&vcpu->kvm->mmu_lock);
 
@@ -4702,7 +4708,7 @@ static int kvm_tdp_mmu_page_fault(struct
 
 out_unlock:
 	read_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(orig_pfn);
 	return r;
 }
 #endif
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -778,6 +778,7 @@ static int FNAME(fetch)(struct kvm_vcpu
 static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct guest_walker walker;
+	kvm_pfn_t orig_pfn;
 	int r;
 
 	WARN_ON_ONCE(fault->is_tdp);
@@ -836,6 +837,8 @@ static int FNAME(page_fault)(struct kvm_
 			walker.pte_access &= ~ACC_EXEC_MASK;
 	}
 
+	orig_pfn = fault->pfn;
+
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
@@ -849,7 +852,7 @@ static int FNAME(page_fault)(struct kvm_
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(orig_pfn);
 	return r;
 }
 


