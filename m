Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A803101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD0FC433D2;
	Mon, 15 May 2023 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173113;
	bh=IVDuG1KmmyI43mJpXjHeujzRd61qLJcTPiLt7IeGwnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaOsDp5t6tK36btEkEaNJZ+7WOHg7XGBRiZZs5MimlmNkldzdEsIECq/akoUDDRcc
	 sX1i2T6GE6MIBo9LKK5PgUfgpne9FJNhlzzJbzznPybJYFFz722K1qCldm3+xeRKar
	 4D1kuechXZG0XI8vWBy3dy8073zhoJXYHOzU/FEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Rishabh Bhatnagar <risbhat@amazon.com>,
	Allen Pais <apais@linux.microsoft.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 371/381] KVM: x86: Fix recording of guest steal time / preempted status
Date: Mon, 15 May 2023 18:30:22 +0200
Message-Id: <20230515161753.693633800@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rishabh Bhatnagar <risbhat@amazon.com>

From: David Woodhouse <dwmw2@infradead.org>

commit 7e2175ebd695f17860c5bd4ad7616cce12ed4591 upstream.

In commit b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is
not missed") we switched to using a gfn_to_pfn_cache for accessing the
guest steal time structure in order to allow for an atomic xchg of the
preempted field. This has a couple of problems.

Firstly, kvm_map_gfn() doesn't work at all for IOMEM pages when the
atomic flag is set, which it is in kvm_steal_time_set_preempted(). So a
guest vCPU using an IOMEM page for its steal time would never have its
preempted field set.

Secondly, the gfn_to_pfn_cache is not invalidated in all cases where it
should have been. There are two stages to the GFN->PFN conversion;
first the GFN is converted to a userspace HVA, and then that HVA is
looked up in the process page tables to find the underlying host PFN.
Correct invalidation of the latter would require being hooked up to the
MMU notifiers, but that doesn't happen---so it just keeps mapping and
unmapping the *wrong* PFN after the userspace page tables change.

In the !IOMEM case at least the stale page *is* pinned all the time it's
cached, so it won't be freed and reused by anyone else while still
receiving the steal time updates. The map/unmap dance only takes care
of the KVM administrivia such as marking the page dirty.

Until the gfn_to_pfn cache handles the remapping automatically by
integrating with the MMU notifiers, we might as well not get a
kernel mapping of it, and use the perfectly serviceable userspace HVA
that we already have.  We just need to implement the atomic xchg on
the userspace address with appropriate exception handling, which is
fairly trivial.

Cc: stable@vger.kernel.org
Fixes: b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <3645b9b889dac6438394194bb5586a46b68d581f.camel@infradead.org>
[I didn't entirely agree with David's assessment of the
 usefulness of the gfn_to_pfn cache, and integrated the outcome
 of the discussion in the above commit message. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[risbhat@amazon.com: Use the older mark_page_dirty_in_slot api without
kvm argument]
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Tested-by: Allen Pais <apais@linux.microsoft.com>
Acked-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    2 
 arch/x86/kvm/x86.c              |  105 ++++++++++++++++++++++++++++------------
 2 files changed, 76 insertions(+), 31 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -664,7 +664,7 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
-		struct gfn_to_pfn_cache cache;
+		struct gfn_to_hva_cache cache;
 	} st;
 
 	u64 l1_tsc_offset;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3022,53 +3022,92 @@ static void kvm_vcpu_flush_tlb_guest(str
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_map map;
-	struct kvm_steal_time *st;
+	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
+	struct kvm_steal_time __user *st;
+	struct kvm_memslots *slots;
+	u64 steal;
+	u32 version;
 
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
-	/* -EAGAIN is returned in atomic context so we can just return. */
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
-			&map, &vcpu->arch.st.cache, false))
+	if (WARN_ON_ONCE(current->mm != vcpu->kvm->mm))
 		return;
 
-	st = map.hva +
-		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+	slots = kvm_memslots(vcpu->kvm);
+
+	if (unlikely(slots->generation != ghc->generation ||
+		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
+		gfn_t gfn = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
+
+		/* We rely on the fact that it fits in a single page. */
+		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
+
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gfn, sizeof(*st)) ||
+		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
+			return;
+	}
+
+	st = (struct kvm_steal_time __user *)ghc->hva;
+	if (!user_access_begin(st, sizeof(*st)))
+		return;
 
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
 	 */
 	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
-		u8 st_preempted = xchg(&st->preempted, 0);
+		u8 st_preempted = 0;
+		int err = -EFAULT;
+
+		asm volatile("1: xchgb %0, %2\n"
+			     "xor %1, %1\n"
+			     "2:\n"
+			     _ASM_EXTABLE_UA(1b, 2b)
+			     : "+r" (st_preempted),
+			       "+&r" (err)
+			     : "m" (st->preempted));
+		if (err)
+			goto out;
+
+		user_access_end();
+
+		vcpu->arch.st.preempted = 0;
 
 		trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
 				       st_preempted & KVM_VCPU_FLUSH_TLB);
 		if (st_preempted & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
+
+		if (!user_access_begin(st, sizeof(*st)))
+			goto dirty;
 	} else {
-		st->preempted = 0;
+		unsafe_put_user(0, &st->preempted, out);
+		vcpu->arch.st.preempted = 0;
 	}
 
-	vcpu->arch.st.preempted = 0;
-
-	if (st->version & 1)
-		st->version += 1;  /* first time write, random junk */
+	unsafe_get_user(version, &st->version, out);
+	if (version & 1)
+		version += 1;  /* first time write, random junk */
 
-	st->version += 1;
+	version += 1;
+	unsafe_put_user(version, &st->version, out);
 
 	smp_wmb();
 
-	st->steal += current->sched_info.run_delay -
+	unsafe_get_user(steal, &st->steal, out);
+	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	unsafe_put_user(steal, &st->steal, out);
 
-	smp_wmb();
-
-	st->version += 1;
+	version += 1;
+	unsafe_put_user(version, &st->version, out);
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
+ out:
+	user_access_end();
+ dirty:
+	mark_page_dirty_in_slot(ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -4053,8 +4092,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 
 static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_map map;
-	struct kvm_steal_time *st;
+	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
+	struct kvm_steal_time __user *st;
+	struct kvm_memslots *slots;
+	static const u8 preempted = KVM_VCPU_PREEMPTED;
 
 	/*
 	 * The vCPU can be marked preempted if and only if the VM-Exit was on
@@ -4075,16 +4116,23 @@ static void kvm_steal_time_set_preempted
 	if (vcpu->arch.st.preempted)
 		return;
 
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
-			&vcpu->arch.st.cache, true))
+	/* This happens on process exit */
+	if (unlikely(current->mm != vcpu->kvm->mm))
 		return;
 
-	st = map.hva +
-		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+	slots = kvm_memslots(vcpu->kvm);
+
+	if (unlikely(slots->generation != ghc->generation ||
+		     kvm_is_error_hva(ghc->hva) || !ghc->memslot))
+		return;
 
-	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
+	st = (struct kvm_steal_time __user *)ghc->hva;
+	BUILD_BUG_ON(sizeof(st->preempted) != sizeof(preempted));
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
+	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
+		vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
+
+	mark_page_dirty_in_slot(ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -10266,11 +10314,8 @@ void kvm_arch_vcpu_postcreate(struct kvm
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	struct gfn_to_pfn_cache *cache = &vcpu->arch.st.cache;
 	int idx;
 
-	kvm_release_pfn(cache->pfn, cache->dirty, cache);
-
 	kvmclock_reset(vcpu);
 
 	kvm_x86_ops.vcpu_free(vcpu);


