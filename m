Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46F3525A66;
	Wed, 30 Sep 2026 17:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790485; cv=none; b=TLQbXUcjGP4qJAI3gebEHyRH8cSR6p1y5fQZJZfidODAjRQbNZdtWhyzEGQ/7ua+oRyaBDoRSYXxvkfaVz2SrxIMMIzS2d++tVKpb0dqnKMZU6VkrteXHKoZs7XvVkOJZCsNAv8eBrKDY7FqNSDtDr128OETW5bgAQm5HGm5JQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790485; c=relaxed/simple;
	bh=lLb1O4lGzou+oOicAUea+PL32JR+bshWwUKA4nyycLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/XYRsxB25+E8GWB79c8EqYVh+oMHI/gSw45XpzdYjDEpE9rawmfli2wiyKHPEVRbP12vZ+fRAi7rxJ2CictpLAevy9OAniaWSDsLHPqqKrqnIFE1w+owJOYyf5lJE7FeOGLiNKwDAt5FB3+Ql/sB/TqOK6qIXRkFJ7kdLIBL+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnWSWyJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnWSWyJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046141F000FF;
	Wed, 30 Sep 2026 17:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790483;
	bh=khlZUR+FLu3njJs0gxu8FCQmSn09NFw3y1lIOhhrBQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnWSWyJRH/0L1wZIAIJ4xJb91+dG2/ET+wYeAtWmFs5k0L1Z2h3X3MhjYj/7VXUri
	 VOozq3pm1KaL/RFgZ0BIpSnNwhokOcSObNOtYYDR1Tg2QMdsdxK+UArpcjFY40WyDY
	 X21/etJqRm8THxbrDzddBxlAPsJKKXxf70cPOxdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikanth Aithal <sraithal@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Zheyun Shen <szy0127@sjtu.edu.cn>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 846/877] KVM: SVM: Flush cache only on CPUs running SEV guest
Date: Wed, 30 Sep 2026 17:29:17 +0200
Message-ID: <20260930152432.995135615@linuxfoundation.org>
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

From: Zheyun Shen <szy0127@sjtu.edu.cn>

[ Upstream commit 6f38f8c574642a822f2e85f079fa29a49176c49c ]

On AMD CPUs without ensuring cache consistency, each memory page
reclamation in an SEV guest triggers a call to do WBNOINVD/WBINVD on all
CPUs, thereby affecting the performance of other programs on the host.

Typically, an AMD server may have 128 cores or more, while the SEV guest
might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
to bind these 8 vCPUs to specific physical CPUs.

Therefore, keeping a record of the physical core numbers each time a vCPU
runs can help avoid flushing the cache for all CPUs every time.

Take care to allocate the cpumask used to track which CPUs have run a
vCPU when copying or moving an "encryption context", as nothing guarantees
memory in a mirror VM is a strict subset of the ASID owner, and the
destination VM for intrahost migration needs to maintain it's own set of
CPUs.  E.g. for intrahost migration, if a CPU was used for the source VM
but not the destination VM, then it can only have cached memory that was
accessible to the source VM.  And a CPU that was run in the source is also
used by the destination is no different than a CPU that was run in the
destination only.

Note, KVM is guaranteed to do flush caches prior to sev_vm_destroy(),
thanks to kvm_arch_guest_memory_reclaimed for SEV and SEV-ES, and
kvm_arch_gmem_invalidate() for SEV-SNP.  I.e. it's safe to free the
cpumask prior to unregistering encrypted regions and freeing the ASID.

Opportunistically clean up sev_vm_destroy()'s comment regarding what is
(implicitly, what isn't) skipped  for mirror VMs.

Cc: Srikanth Aithal <sraithal@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
Link: https://lore.kernel.org/r/20250522233733.3176144-9-seanjc@google.com
Link: https://lore.kernel.org/all/935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>

Backport notes for Linux 6.12:

The WBNOINVD prerequisites are not present. Keep WBINVD semantics and
implement sev_writeback_caches as a local macro over the existing
wbinvd_on_cpu API. This preserves per-VM CPU tracking and the interface
needed by 93de2a6a4b91 without adding any functions or x86 cache helpers.
An empty mask naturally performs no flush; CPUs are never removed.

Keep the stable tree's sev_mirror_lock protection, relocated sev_free_vcpu
and GHCB cleanup, void pre_sev_run signature, do_wbinvd label, and existing
all-CPU flush during VM destruction. Add the kvm local needed by tracking.

Allocate the mask after SNP guest-request setup, with matching SNP cleanup
on allocation failure, so failed initialization never leaves a freed mask
in the VM. Free the mask even for a migrated source that is no longer SEV,
as in 12c1f6e03f944, to avoid leaking it on destruction. Destination and
mirror VMs receive independent zeroed masks. Keep the migration allocation
context so 93de2a6a4b91 applies unchanged.

Stable-dep-of: 93de2a6a4b91 ("KVM: SEV: Do cache maintenance on the source VM during intra-host migration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   67 +++++++++++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h |    1 
 2 files changed, 58 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -458,6 +458,13 @@ static int __sev_guest_init(struct kvm *
 			goto e_free;
 	}
 
+	if (!zalloc_cpumask_var(&sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
+		ret = -ENOMEM;
+		if (vm_type == KVM_X86_SNP_VM)
+			snp_guest_req_cleanup(kvm);
+		goto e_free;
+	}
+
 	INIT_LIST_HEAD(&sev->regions_list);
 	INIT_LIST_HEAD(&sev->mirror_vms);
 	sev->need_init = false;
@@ -715,6 +722,19 @@ static void sev_clflush_pages(struct pag
 	}
 }
 
+/*
+ * Write back guest-tagged cache entries before returning memory to the host.
+ * This tree has no WBNOINVD or masked WBINVD helper, so use WBINVD on each CPU
+ * that has entered the guest.  Keep CPUs in the mask to avoid racing concurrent
+ * flushes and VMRUN; callers must serialize memory reclaim against guest access.
+ */
+#define sev_writeback_caches(kvm) do { \
+	const struct cpumask *__mask = to_kvm_sev_info(kvm)->have_run_cpus; \
+	int __cpu; \
+	for_each_cpu(__cpu, __mask) \
+		wbinvd_on_cpu(__cpu); \
+} while (0)
+
 static unsigned long get_num_contig_pages(unsigned long idx,
 				struct page **inpages, unsigned long npages)
 {
@@ -2134,6 +2154,17 @@ int sev_vm_move_enc_context_from(struct
 	if (ret)
 		goto out_source_vcpu;
 
+	/*
+	 * Allocate a new have_run_cpus for the destination, i.e. don't copy
+	 * the set of CPUs from the source.  If a CPU was used to run a vCPU in
+	 * the source VM but is never used for the destination VM, then the CPU
+	 * can only have cached memory that was accessible to the source VM.
+	 */
+	if (!zalloc_cpumask_var(&dst_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
+		ret = -ENOMEM;
+		goto out_source_vcpu;
+	}
+
 	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
 	cg_cleanup_sev = src_sev;
@@ -2795,12 +2826,7 @@ int sev_mem_enc_unregister_region(struct
 		goto failed;
 	}
 
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
+	sev_writeback_caches(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
@@ -2843,12 +2869,17 @@ int sev_vm_copy_enc_context_from(struct
 		goto e_unlock;
 	}
 
+	mirror_sev = to_kvm_sev_info(kvm);
+	if (!zalloc_cpumask_var(&mirror_sev->have_run_cpus, GFP_KERNEL_ACCOUNT)) {
+		ret = -ENOMEM;
+		goto e_unlock;
+	}
+
 	/*
 	 * The mirror kvm holds an enc_context_owner ref so its asid can't
 	 * disappear until we're done with it
 	 */
 	source_sev = to_kvm_sev_info(source_kvm);
-	mirror_sev = to_kvm_sev_info(kvm);
 
 	/* Set enc_context_owner and copy its encryption context over */
 	mutex_lock(&sev_mirror_lock);
@@ -2909,6 +2940,12 @@ void sev_vm_destroy(struct kvm *kvm)
 	struct list_head *head = &sev->regions_list;
 	struct list_head *pos, *q;
 
+	/*
+	 * Free the mask even if the VM is not *currently* an SEV VM, as it may
+	 * have been an SEV VM prior to intra-host migration.
+	 */
+	free_cpumask_var(sev->have_run_cpus);
+
 	if (!sev_guest(kvm))
 		return;
 
@@ -3217,7 +3254,7 @@ static void sev_flush_encrypted_page(str
 	return;
 
 do_wbinvd:
-	wbinvd_on_all_cpus();
+	sev_writeback_caches(vcpu->kvm);
 }
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
@@ -3231,7 +3268,7 @@ void sev_guest_memory_reclaimed(struct k
 	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
-	wbinvd_on_all_cpus();
+	sev_writeback_caches(kvm);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -3550,7 +3587,17 @@ skip_vmsa_free:
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
-	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
+	struct kvm *kvm = svm->vcpu.kvm;
+	unsigned int asid = sev_get_asid(kvm);
+
+	/*
+	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
+	 * track physical CPUs that enter the guest for SEV VMs and thus can
+	 * have encrypted, dirty data in the cache, and flush caches only for
+	 * CPUs that have entered the guest.
+	 */
+	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
+		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
 
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -113,6 +113,7 @@ struct kvm_sev_info {
 	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
 	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
+	cpumask_var_t have_run_cpus; /* CPUs that have done VMRUN for this VM. */
 };
 
 struct kvm_svm {


