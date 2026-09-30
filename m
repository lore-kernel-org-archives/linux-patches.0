Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CBE36D4E1;
	Wed, 30 Sep 2026 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792020; cv=none; b=rDNME7K+XvU6fHDh6+CFuTDOKgBMsi0Z2izC6yOOd/7uv0K+WvEwN5jsXsljVXjqG0F3J8y16IjygKTgsxgL+DEmLSdEMrWaZZvoUm837sLG54aICVJv3O7kCqXdVD7GcbXgwUD5oGJTCBJpjKWpQWQOWYnW4kxffI6LwH+bYJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792020; c=relaxed/simple;
	bh=wGF2qGSXPvyp46Stfq7it4yPVwWk9LgBqQfgiv7jPFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMMLv0ywy7k/bye1hd7+A7rplp0OqYmezbWFmBbpBfBeoffCQV/tEA7XAWBndkNMJO3fDuOnnCuA2aVp5PhnbFvU8QqGpvcOBQ/aD270LC0z7KYi1/FQSe4dqNyalFnds4O784eY+6bdOUGxTVoiq7D4q4uffiWqgNSM/rqe0jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuHrvUxT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuHrvUxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5339D1F000FF;
	Wed, 30 Sep 2026 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792018;
	bh=ak9f2GKg4Kndp2SWVSsN7xovLOFY4CLEHw1nFM50+cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuHrvUxTLPXuSqPb33yHYwfYOYFWFZ/mT5EBV+eegitk96xf7ZnDZFx+tK0X/vq7O
	 5wsUK9u8aweBI3iBO/m1Q12t/tfw13k0drS399BjydUCfMNOWa6U2O/j2SaEK2zbLO
	 U+QDD4NHwC9NpFN1XcsSuNryideEcDvhLt0FL8B8=
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
Subject: [PATCH 5.15 505/752] KVM: PPC: Book3S HV: fix use-after-free in kvmhv_emulate_tlbie_all_lpid()
Date: Wed, 30 Sep 2026 17:26:15 +0200
Message-ID: <20260930152409.187085284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b70134578cbf..bf49bd671d1d8 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1169,8 +1169,10 @@ static void kvmhv_emulate_tlbie_all_lpid(struct kvm_vcpu *vcpu, int ric)
 
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



