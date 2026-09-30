Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239B73B71B6;
	Wed, 30 Sep 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792017; cv=none; b=Q+VhTpMhkCSN6Dg6nf5pbYpis1hAXu1sc52BbOXlWXg+ybTj6KyRsZZ/b5M/dlwhqIaAx+uqQd2hIW7sKawXKz9YsuPZDNgmKcBKc5YlystOhDku9atr8nA687izYe4VSsGTsJkvmwfuawBxUSyKxf2iaLC2izg2GGnNRx3CiZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792017; c=relaxed/simple;
	bh=hgJ4GwG3X1rOT2h0X3tBxuw50yuTRO/nlRaEzC+ChtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQedLN6OoTjj3yDG2Q2EYbKTqjkT4FALf/nEVVYaaMuQ5z1aPUB1iXEqaZoged2lcHD9zkcmHLFnwy0REf7E3ccNDClS/RQQ6o+Y3co/UfUAFJB8YtET2zVtlfAxmKUqjwR4ZEL6Jm9NbloSmhf9JjGNcFI+LsisewZ9xr+t5fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ryb4N0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ryb4N0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5DB1F000FF;
	Wed, 30 Sep 2026 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792016;
	bh=MyvtOhNB6PRDnr0PkQglETCl9P6eSZEX66vnL7ziS4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ryb4N0Nn0rVOrXeb8KuDEP0+CLQqBnIYoAt/SWc1MOJebFIq8VTYCYSQANZd5SS+
	 Kf5eZ6tQPs0RVC0vQb+Noo7VPUf3D2xx6G3J6fu5TEINIPejZ5FXtSGb1MebInKCbL
	 Yekm4dR9qhGBaPSEbNiDvIKUoGlWBpkuEGgD+BYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 504/752] KVM: PPC: Book3S HV Nested: Change nested guest lookup to use idr
Date: Wed, 30 Sep 2026 17:26:14 +0200
Message-ID: <20260930152409.166173375@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit c0f00a18e2a8c350a9d263aaf9a2c8bc86caa1b0 ]

This removes the fixed sized kvm->arch.nested_guests array.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220123120043.3586018-5-npiggin@gmail.com
Stable-dep-of: 51938dfa8a51 ("KVM: PPC: Book3S HV: fix use-after-free in kvmhv_emulate_tlbie_all_lpid()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_host.h |   3 +-
 arch/powerpc/kvm/book3s_hv_nested.c | 110 +++++++++++++++-------------
 2 files changed, 59 insertions(+), 54 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 0d81a9bf37650..55bef6efb6e30 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -327,8 +327,7 @@ struct kvm_arch {
 	struct list_head uvmem_pfns;
 	struct mutex mmu_setup_lock;	/* nests inside vcpu mutexes */
 	u64 l1_ptcr;
-	int max_nested_lpid;
-	struct kvm_nested_guest *nested_guests[KVM_MAX_NESTED_GUESTS];
+	struct idr kvm_nested_guest_idr;
 	/* This array can grow quite large, keep it at the end */
 	struct kvmppc_vcore *vcores[KVM_MAX_VCORES];
 #endif
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index e31b3c20a9d49..8b70134578cbf 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -522,11 +522,6 @@ static void kvmhv_set_nested_ptbl(struct kvm_nested_guest *gp)
 	kvmhv_set_ptbl_entry(gp->shadow_lpid, dw0, gp->process_table);
 }
 
-void kvmhv_vm_nested_init(struct kvm *kvm)
-{
-	kvm->arch.max_nested_lpid = -1;
-}
-
 /*
  * Handle the H_SET_PARTITION_TABLE hcall.
  * r4 = guest real address of partition table + log_2(size) - 12
@@ -661,6 +656,35 @@ static void kvmhv_update_ptbl_cache(struct kvm_nested_guest *gp)
 	kvmhv_set_nested_ptbl(gp);
 }
 
+void kvmhv_vm_nested_init(struct kvm *kvm)
+{
+	idr_init(&kvm->arch.kvm_nested_guest_idr);
+}
+
+static struct kvm_nested_guest *__find_nested(struct kvm *kvm, int lpid)
+{
+	return idr_find(&kvm->arch.kvm_nested_guest_idr, lpid);
+}
+
+static bool __prealloc_nested(struct kvm *kvm, int lpid)
+{
+	if (idr_alloc(&kvm->arch.kvm_nested_guest_idr,
+				NULL, lpid, lpid + 1, GFP_KERNEL) != lpid)
+		return false;
+	return true;
+}
+
+static void __add_nested(struct kvm *kvm, int lpid, struct kvm_nested_guest *gp)
+{
+	if (idr_replace(&kvm->arch.kvm_nested_guest_idr, gp, lpid))
+		WARN_ON(1);
+}
+
+static void __remove_nested(struct kvm *kvm, int lpid)
+{
+	idr_remove(&kvm->arch.kvm_nested_guest_idr, lpid);
+}
+
 static struct kvm_nested_guest *kvmhv_alloc_nested(struct kvm *kvm, unsigned int lpid)
 {
 	struct kvm_nested_guest *gp;
@@ -721,13 +745,8 @@ static void kvmhv_remove_nested(struct kvm_nested_guest *gp)
 	long ref;
 
 	spin_lock(&kvm->mmu_lock);
-	if (gp == kvm->arch.nested_guests[lpid]) {
-		kvm->arch.nested_guests[lpid] = NULL;
-		if (lpid == kvm->arch.max_nested_lpid) {
-			while (--lpid >= 0 && !kvm->arch.nested_guests[lpid])
-				;
-			kvm->arch.max_nested_lpid = lpid;
-		}
+	if (gp == __find_nested(kvm, lpid)) {
+		__remove_nested(kvm, lpid);
 		--gp->refcnt;
 	}
 	ref = gp->refcnt;
@@ -744,24 +763,22 @@ static void kvmhv_remove_nested(struct kvm_nested_guest *gp)
  */
 void kvmhv_release_all_nested(struct kvm *kvm)
 {
-	int i;
+	int lpid;
 	struct kvm_nested_guest *gp;
 	struct kvm_nested_guest *freelist = NULL;
 	struct kvm_memory_slot *memslot;
 	int srcu_idx;
 
 	spin_lock(&kvm->mmu_lock);
-	for (i = 0; i <= kvm->arch.max_nested_lpid; i++) {
-		gp = kvm->arch.nested_guests[i];
-		if (!gp)
-			continue;
-		kvm->arch.nested_guests[i] = NULL;
+	idr_for_each_entry(&kvm->arch.kvm_nested_guest_idr, gp, lpid) {
+		__remove_nested(kvm, lpid);
 		if (--gp->refcnt == 0) {
 			gp->next = freelist;
 			freelist = gp;
 		}
 	}
-	kvm->arch.max_nested_lpid = -1;
+	idr_destroy(&kvm->arch.kvm_nested_guest_idr);
+	/* idr is empty and may be reused at this point */
 	spin_unlock(&kvm->mmu_lock);
 	while ((gp = freelist) != NULL) {
 		freelist = gp->next;
@@ -798,7 +815,7 @@ struct kvm_nested_guest *kvmhv_get_nested(struct kvm *kvm, int l1_lpid,
 		return NULL;
 
 	spin_lock(&kvm->mmu_lock);
-	gp = kvm->arch.nested_guests[l1_lpid];
+	gp = __find_nested(kvm, l1_lpid);
 	if (gp)
 		++gp->refcnt;
 	spin_unlock(&kvm->mmu_lock);
@@ -809,17 +826,19 @@ struct kvm_nested_guest *kvmhv_get_nested(struct kvm *kvm, int l1_lpid,
 	newgp = kvmhv_alloc_nested(kvm, l1_lpid);
 	if (!newgp)
 		return NULL;
+
+	if (!__prealloc_nested(kvm, l1_lpid)) {
+		kvmhv_release_nested(newgp);
+		return NULL;
+	}
+
 	spin_lock(&kvm->mmu_lock);
-	if (kvm->arch.nested_guests[l1_lpid]) {
-		/* someone else beat us to it */
-		gp = kvm->arch.nested_guests[l1_lpid];
-	} else {
-		kvm->arch.nested_guests[l1_lpid] = newgp;
+	gp = __find_nested(kvm, l1_lpid);
+	if (!gp) {
+		__add_nested(kvm, l1_lpid, newgp);
 		++newgp->refcnt;
 		gp = newgp;
 		newgp = NULL;
-		if (l1_lpid > kvm->arch.max_nested_lpid)
-			kvm->arch.max_nested_lpid = l1_lpid;
 	}
 	++gp->refcnt;
 	spin_unlock(&kvm->mmu_lock);
@@ -842,20 +861,13 @@ void kvmhv_put_nested(struct kvm_nested_guest *gp)
 		kvmhv_release_nested(gp);
 }
 
-static struct kvm_nested_guest *kvmhv_find_nested(struct kvm *kvm, int lpid)
-{
-	if (lpid > kvm->arch.max_nested_lpid)
-		return NULL;
-	return kvm->arch.nested_guests[lpid];
-}
-
 pte_t *find_kvm_nested_guest_pte(struct kvm *kvm, unsigned long lpid,
 				 unsigned long ea, unsigned *hshift)
 {
 	struct kvm_nested_guest *gp;
 	pte_t *pte;
 
-	gp = kvmhv_find_nested(kvm, lpid);
+	gp = __find_nested(kvm, lpid);
 	if (!gp)
 		return NULL;
 
@@ -961,7 +973,7 @@ static void kvmhv_remove_nest_rmap(struct kvm *kvm, u64 n_rmap,
 
 	gpa = n_rmap & RMAP_NESTED_GPA_MASK;
 	lpid = (n_rmap & RMAP_NESTED_LPID_MASK) >> RMAP_NESTED_LPID_SHIFT;
-	gp = kvmhv_find_nested(kvm, lpid);
+	gp = __find_nested(kvm, lpid);
 	if (!gp)
 		return;
 
@@ -1153,16 +1165,13 @@ static void kvmhv_emulate_tlbie_all_lpid(struct kvm_vcpu *vcpu, int ric)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *gp;
-	int i;
+	int lpid;
 
 	spin_lock(&kvm->mmu_lock);
-	for (i = 0; i <= kvm->arch.max_nested_lpid; i++) {
-		gp = kvm->arch.nested_guests[i];
-		if (gp) {
-			spin_unlock(&kvm->mmu_lock);
-			kvmhv_emulate_tlbie_lpid(vcpu, gp, ric);
-			spin_lock(&kvm->mmu_lock);
-		}
+	idr_for_each_entry(&kvm->arch.kvm_nested_guest_idr, gp, lpid) {
+		spin_unlock(&kvm->mmu_lock);
+		kvmhv_emulate_tlbie_lpid(vcpu, gp, ric);
+		spin_lock(&kvm->mmu_lock);
 	}
 	spin_unlock(&kvm->mmu_lock);
 }
@@ -1314,7 +1323,7 @@ long do_h_rpt_invalidate_pat(struct kvm_vcpu *vcpu, unsigned long lpid,
 	 * H_ENTER_NESTED call. Since we can't differentiate this case from
 	 * the invalid case, we ignore such flush requests and return success.
 	 */
-	if (!kvmhv_find_nested(vcpu->kvm, lpid))
+	if (!__find_nested(vcpu->kvm, lpid))
 		return H_SUCCESS;
 
 	/*
@@ -1658,15 +1667,12 @@ long int kvmhv_nested_page_fault(struct kvm_vcpu *vcpu)
 
 int kvmhv_nested_next_lpid(struct kvm *kvm, int lpid)
 {
-	int ret = -1;
+	int ret = lpid + 1;
 
 	spin_lock(&kvm->mmu_lock);
-	while (++lpid <= kvm->arch.max_nested_lpid) {
-		if (kvm->arch.nested_guests[lpid]) {
-			ret = lpid;
-			break;
-		}
-	}
+	if (!idr_get_next(&kvm->arch.kvm_nested_guest_idr, &ret))
+		ret = -1;
 	spin_unlock(&kvm->mmu_lock);
+
 	return ret;
 }
-- 
2.53.0



