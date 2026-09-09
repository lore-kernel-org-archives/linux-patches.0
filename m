Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2197C4FDE6C;
	Wed,  9 Sep 2026 14:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962515; cv=none; b=rovU88BmfMuHE5RZKgObuP1Hw6isHwMlUfO434T0jWeehGBvaXJL0lL9a34NAyisdUeIjkHDO6lrMftf5CHhXBk7n7PNdRaWgn8Bh6QPPb6UxfO4PyO2oaSKAvMw4485DyUvYCPDgPWj21iuI3cTCXZ714cePM2VbsN4ao6iD7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962515; c=relaxed/simple;
	bh=8b0UH91YZrRLcNbpA+vELLwmKuJ7gOL4t9gkAcwRECY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Am/uAf7KnyshXyQLYeqb57e0CsAchG9adHAfPQPu208XycoFHijJGSoZblxuxDvtNHhojQcVDZClILIf0/JSuQE3HR8IsbfsizR5VRsV2Kqxt3Tbg4BwzQPhu8YtciwCO1378Mz1cKbY4dcCOXkcuUh6WUQqgKERyzOjSuVfJRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ds5YL0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ds5YL0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE781F00A3A;
	Wed,  9 Sep 2026 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962514;
	bh=qjz2fM0XELxB9aPBHSdOjPLSk2sukMmacYJcNjYFel0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Ds5YL0ssBb66mpWM1wW9RA9MBSW2MTvhvWfhG+pZM0CDJfQl9hgAuUzon3Aae0c6
	 t7RUG77+PTSl9BTazt0hqRny+YJ5Bnmse4iSDBcydB26fvnMXQ+/7g25k/BNb7Lv1z
	 n/insZL0Qr1BuOY2fuTWGAhKtwC4/nu+oEIKREiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 317/556] KVM: arm64: Handle VNCR TLB invalidation race with vcpu_put() VNCR unmapping
Date: Wed,  9 Sep 2026 15:39:57 +0200
Message-ID: <20260909134241.814060157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 38640bc32be3fcf9526d477155bc19d3f146231f upstream.

While VNCR TLB invalidation always occurs under the MMU lock,
vcpu_put() doesn't, while it unmaps the VNCR page.

The problem is that the invalidation evaluates vncr_tlb::cpu to
decide whether an unmapping needs to take place (cpu != -1) before
performing it. On the other hand, this_cpu_reset_vncr_fixmap()
unconditionally unmaps if L1_VNCR_MAPPED is set.

These two obviously can race, with a TOCTOU pattern on the TLBI
path, and a BUG_ON() on the vcpu_put() path. And the two can end-up
calling vncr_fixmap(-1), with extra lethal effects.

Move the reset of vncr_tlb::cpu to -1 to a common function, and make
this update atomic so that only a single thread can reset the field
and perform the corresponding unmap. The vcpu_put() still need to
unconditionally unmap the current VNCR to close another ugly race.

Finally, the assignment of vncr_tlb::cpu is moved to be kept in sync
with the actual mapping, similar to L1_VNCR_MAPPED being set.

Fixes: 7270cc9157f47 ("KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260801130237.0FD8F1F00ACA@smtp.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Link: https://patch.msgid.link/20260806091026.620700-6-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |   42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -27,7 +27,7 @@ struct vncr_tlb {
 	bool			hpa_writable;
 
 	/* -1 when not mapped on a CPU */
-	int			cpu;
+	atomic_t		cpu;
 
 	/*
 	 * true if the TLB is valid. Can only be changed with the
@@ -895,16 +895,40 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcp
 	}
 }
 
+/*
+ * Unmapping an L1 VNCR can happen concurrently without the mmu lock being
+ * effective (vcpu_put() vs TLBI handling). The atomic_xchg below ensures
+ * that only one CPU sets it to -1 while getting a valid CPU number back.
+ */
+static int unmap_l1_vncr(struct vncr_tlb *vt)
+{
+	int cpu = atomic_xchg_relaxed(&vt->cpu, -1);
+
+	if (cpu != -1)
+		clear_fixmap(vncr_fixmap(cpu));
+
+	return cpu;
+}
+
 static void this_cpu_reset_vncr_fixmap(struct kvm_vcpu *vcpu)
 {
 	if (!host_data_test_flag(L1_VNCR_MAPPED))
 		return;
 
-	BUG_ON(vcpu->arch.vncr_tlb->cpu != smp_processor_id());
 	BUG_ON(is_hyp_ctxt(vcpu));
 
-	clear_fixmap(vncr_fixmap(vcpu->arch.vncr_tlb->cpu));
-	vcpu->arch.vncr_tlb->cpu = -1;
+	/*
+	 * Unconditionally unmap the local VNCR if we have lost the race
+	 * against a concurrent TLBI. Otherwise we could end-up running
+	 * another vcpu with VNCR still mapped if the TLBI thread is
+	 * preempted between the exchange and the clear_fixmap().
+	 *
+	 * Note that we do not care about the TLBI nuking the fixmap behind
+	 * the back of an running vcpu. This will only generate a fault and
+	 * possibly a retranslation.
+	 */
+	if (unmap_l1_vncr(vcpu->arch.vncr_tlb) == -1)
+		clear_fixmap(vncr_fixmap(smp_processor_id()));
 	host_data_clear_flag(L1_VNCR_MAPPED);
 	atomic_dec(&vcpu->kvm->arch.vncr_map_count);
 }
@@ -997,8 +1021,7 @@ u16 get_asid_by_regime(struct kvm_vcpu *
 static void invalidate_vncr(struct vncr_tlb *vt)
 {
 	vt->valid = false;
-	if (vt->cpu != -1)
-		clear_fixmap(vncr_fixmap(vt->cpu));
+	unmap_l1_vncr(vt);
 }
 
 static bool vncr_tlb_intersects(struct vncr_tlb *vt, u64 addr,
@@ -1454,7 +1477,7 @@ static int kvm_translate_vncr(struct kvm
 		vt->hpa = pfn << PAGE_SHIFT;
 		vt->hpa_writable = writable;
 		vt->valid = true;
-		vt->cpu = -1;
+		atomic_set(&vt->cpu, -1);
 
 		kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu);
 		kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw && vt->hpa_writable);
@@ -1585,8 +1608,6 @@ static void kvm_map_l1_vncr(struct kvm_v
 	if (vt->wr.nG && get_asid_by_regime(vcpu, TR_EL20) != vt->wr.asid)
 		return;
 
-	vt->cpu = smp_processor_id();
-
 	if (vt->hpa_writable && vt->wr.pw && vt->wr.pr)
 		prot = PAGE_KERNEL;
 	else if (vt->wr.pr)
@@ -1601,7 +1622,8 @@ static void kvm_map_l1_vncr(struct kvm_v
 	 * FIXME: WO doesn't work at all, need POE support in the kernel.
 	 */
 	if (pgprot_val(prot) != pgprot_val(PAGE_NONE)) {
-		__set_fixmap(vncr_fixmap(vt->cpu), vt->hpa, prot);
+		atomic_set(&vt->cpu, smp_processor_id());
+		__set_fixmap(vncr_fixmap(atomic_read(&vt->cpu)), vt->hpa, prot);
 		host_data_set_flag(L1_VNCR_MAPPED);
 		atomic_inc(&vcpu->kvm->arch.vncr_map_count);
 	}


