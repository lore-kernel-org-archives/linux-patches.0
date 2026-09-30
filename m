Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE9A3DD849;
	Wed, 30 Sep 2026 19:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796282; cv=none; b=KBTX8mtP5E4m7bdCKSSern660XKPKr+hh2e6HMABSiM3mzqFFwjwRNQQYbQ7UQoZh2X1QQKTHRhKptcsJHlcukQDmYad3rUPfSfSZRkAHH4WONvc1Asf4VPzoNk7xdhnjDGugQ3aw+44ACEb+n7O1/rT7GdK06tD8zh0TihA+Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796282; c=relaxed/simple;
	bh=WrCBdep+duoi0m+6Eag49GgsvR+vPf5gKbzl0X3uadU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGjK233802uix+frXCxoIV8XaS3+2P++aFkzUvfDpZ5F2kaI6wgZjnIzpdebQr/fuyKMPcRmxnodgdU+siQ6qtXsHoxP1pUmmppdBtGf6ElR5eeT4+juV8aHGXAz0H4QJr1i8wWMaT9ouEzLeYFQB5shHBJ1lLIwOpoQdgHFYUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGj4PghK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGj4PghK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D331F000FF;
	Wed, 30 Sep 2026 19:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796281;
	bh=9pztGcWNja0KkN8/MJTY95LBGMI3L06MFwu2i/edmZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGj4PghKHoxohTYp61vcVYckXVhbsoJViSzNqMwZjPLXZBf/KLD6QSAbAQ98a6V0j
	 OoO6uhWdjl8bGDP7zmOgmuAHL39husFkaLJeWY39iaM++05kHcd0mJHytn5OGpx5qd
	 IzO7giEhmO9PHmLurAm4N0NO9quHE/YvUD1JF9Oo=
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
Subject: [PATCH 6.6 0813/1193] KVM: PPC: Book3S HV: fix use-after-free in kvmhv_emulate_tlbie_all_lpid()
Date: Wed, 30 Sep 2026 17:24:57 +0200
Message-ID: <20260930152452.307859225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 49144129da420..6c7d483e1c184 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1172,8 +1172,10 @@ static void kvmhv_emulate_tlbie_all_lpid(struct kvm_vcpu *vcpu, int ric)
 
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



