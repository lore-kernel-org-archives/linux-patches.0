Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F128651AECC;
	Wed, 30 Sep 2026 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788494; cv=none; b=swA/+CrMl11WSCGwzmFft5MkEY1rU3VyNuY4a3MPra9dFhi8Xm4eIlKzsDmVtFlrHp96CIPYKLiaV3yjNOW7UOU5MHWh7l/0No04caryjX0b/rjGCjDHNeW/8Ldw1MdPnwoZnoajsZJFrDFxfOxQUPPKV5K+8TqVMzEIRIlCJbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788494; c=relaxed/simple;
	bh=NpW+EhX9djvqNy3G+cUOieKSTVBj8DWyvgYuO/ze/GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7n4BI6K1o/+3oxbWZt4n/gCwJHFrciQkL+ar/DyTu2SkDOXb5U2HopK9U/eqccTWR3jU7pO+IiA1oaOxKItl+70rTBZGRSnHKu8wo/GmKee2I8K23XI/dgVSjSczQZb+DnXkmF8S/RgdmpDv1q59L5eFIxQ8bgBYMX3skHisZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hfy7+ls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hfy7+ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAA01F000FF;
	Wed, 30 Sep 2026 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788492;
	bh=/C3SU68k1Cb5wYCFpVvFUpdKZVdvx0dgjEZhDtwMShQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1hfy7+lsi/AD+RiGPtwJRzQZXL8Y/BPcp0ge78rTgeD6Gkjl8uS9HZ56GgP1KVK3Q
	 xlDXcx31c0h9fSmvLc/Sy8mwS0+3izZ0iAEMkEUzHdszuymBAsK1eChKZ/xd/3lNyG
	 i3FcMgt418uzmqiHFI9T1CN3IE/5L20mPSKyXWrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/877] KVM: PPC: Book3S HV: fix use-after-free in kvmhv_emulate_tlbie_all_lpid()
Date: Wed, 30 Sep 2026 17:17:34 +0200
Message-ID: <20260930152417.812843773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Machhiwal <amachhiw@linux.ibm.com>

[ Upstream commit 51938dfa8a51a4f85328413fca9b6e21f9d2d088 ]

kvmhv_emulate_tlbie_all_lpid() iterates the nested-guest IDR and drops
mmu_lock before calling kvmhv_emulate_tlbie_lpid(), but does not hold a
reference on the kvm_nested_guest pointer obtained from the IDR.  A
concurrent vCPU issuing a single-LPID tlbie (is=2, ric=2) can race
through kvmhv_flush_nested() -> kvmhv_remove_nested() -> idr_remove /
--refcnt -> kvmhv_release_nested() -> kfree(gp) in that window, leaving
the iterating vCPU with a dangling pointer.  The subsequent
mutex_lock(&gp->tlb_lock) and accesses to gp->shadow_pgtable,
gp->shadow_lpid and gp->l1_host all touch freed memory.  The free path
is fully L1-controlled.

Fix this by incrementing gp->refcnt inside the loop before dropping
mmu_lock, mirroring what kvmhv_get_nested() does, and releasing the
reference with kvmhv_put_nested() after the per-guest work completes.
This is the same get/put discipline already used at every other
call site that drops mmu_lock while holding a nested-guest pointer.

Fixes: e3b6b4661527 ("KVM: PPC: Book3S HV: Implement H_TLB_INVALIDATE hcall")
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 125440a606ee3..a4dd8d983ec76 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1202,8 +1202,10 @@ static void kvmhv_emulate_tlbie_all_lpid(struct kvm_vcpu *vcpu, int ric)
 
 	spin_lock(&kvm->mmu_lock);
 	idr_for_each_entry(&kvm->arch.kvm_nested_guest_idr, gp, lpid) {
+		++gp->refcnt;
 		spin_unlock(&kvm->mmu_lock);
 		kvmhv_emulate_tlbie_lpid(vcpu, gp, ric);
+		kvmhv_put_nested(gp);
 		spin_lock(&kvm->mmu_lock);
 	}
 	spin_unlock(&kvm->mmu_lock);
-- 
2.53.0



