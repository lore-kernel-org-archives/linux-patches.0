Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6828A3A6F1C;
	Wed, 23 Sep 2026 14:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173370; cv=none; b=P29NhiHeMhM6gjx4VGNP8MMozFJZ5tVcXOcUOHMrhvWW+vQ64AzSQhkznflw7FdFhxVdxxzwolIYc1XTwpdep9rmzpVFAyTBqmwv7msPi27GEqmnn1s+7JjkdMv+mmJ6959WZkw0s4MkfkL/4bGtRSwHokUp3kMhBRdPDWQtOM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173370; c=relaxed/simple;
	bh=1vhnUcODRObO/cfoLvPsCtO6h/l1+ykK64Wzk4355uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKP1IHpNxvRLQg3e+8rd5kIapJE9BGjEVKRvItOvutvAdRblojZmYo4ze5Q3RQzYbuN+t70UG6sWRQvYJBFKuLlfK6DFjvJnf2G7YQTF1ppAFueZ/lP0+uO1KmRc/qUER3vTHhNBBTL65pnC+OqSao16paX6U6i9f4q6s5nHOME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CoXc353; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CoXc353"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0AE1F000FF;
	Wed, 23 Sep 2026 14:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173369;
	bh=pHSoLYiXNDkKlDwXbG15kJ74/gzgVY9rRpRJSylAPVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0CoXc3534OQCl1fY2KEK3eyWx7WvqTOgMNo3K0mk6XU6PiAybjF5RHPFIJv6sDkeS
	 H+GDF63TAmjaeMx3MjpO7q8xCsAtaXwXBcoylDdh9VbVz/EP/HHnUAt6rkMmXCCa/s
	 SWnQuGIj8tpo1oPLISht2ui9bvE6FhiaYM/wdD2g=
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
Subject: [PATCH 7.2 190/438] KVM: PPC: Book3S HV: fix use-after-free in kvmhv_emulate_tlbie_all_lpid()
Date: Wed, 23 Sep 2026 16:03:31 +0200
Message-ID: <20260923140649.687505081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 22e6166622556..a6ff42d7666c1 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1204,8 +1204,10 @@ static void kvmhv_emulate_tlbie_all_lpid(struct kvm_vcpu *vcpu, int ric)
 
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



