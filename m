Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E054A391E51;
	Sat, 17 Oct 2026 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255588; cv=none; b=a8B9jkrTnDeSAH78DmIRDzBipbNp82i4ktEKtyJCkcP8RS38CfyKLddj4F/6xFluwxo6Nt9euRI1tcINw6KVAaHoK7/b9T30QLvnHxwdCudaZL2/Fl9ZPSHlYmAtK7M/wZM8cCWGpaVIgGD4MKN7EeOubZ7dYizZipJFDifmkuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255588; c=relaxed/simple;
	bh=jpGVcvAgpybzCH6/6+qWNuAbwFyyE+gB3hvUYqmiFI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SokExWqNklz+d1c/9MTBaMoPdL6BDuRd3z3WBD28tdXYIFYwqo3TtQE/gAziGBxjCmL0aSDxjqL/4gvncacYzK97F6MFYFcUnD8LoWvUisr2NDqhEu1bedfFSXrAKD3lwUgJ1AQ7Nop7HGkMAkvn7EKR1xp4IK2imBk1VzftTzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahRV1BaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahRV1BaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431AB1F000C4;
	Sat, 17 Oct 2026 16:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255586;
	bh=TPwut/8rzDGGlX58FTTsgygXty/QDLo295tq85SN02c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahRV1BaNBQY3Bf7R+G5Ng94SFgaNg81eTp2HQne4xBRNx5wUBrqmsXOSNuz6F5oQm
	 1RXqdU3zW4WYLZ/DbevZewtojmTzut7cEjpayqd7GV9UuyzK25ye1Mw+cSpb2AX32m
	 tC0zUZSz0vkmxS7eHCeITiVqP0iWYaQULz/VW/0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janosch Frank <frankja@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 824/869] KVM: s390: use __kvm_faultin_pfn()
Date: Sat, 17 Oct 2026 18:01:05 +0200
Message-ID: <20261017160058.009360985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 3762e905ec2e498c96464e094b7d46be98151d3b ]

Refactor the existing page fault handling code to use __kvm_faultin_pfn().

This possible now that memslots are always present.

Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20250123144627.312456-7-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-7-imbrenda@linux.ibm.com>
Stable-dep-of: 5f9df945d4e8 ("KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 126 ++++++++++++++++++++++++++++++---------
 arch/s390/kvm/kvm-s390.h |   6 ++
 arch/s390/mm/gmap.c      |   1 +
 3 files changed, 106 insertions(+), 27 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 49d967bde326a..6224e4188c6d6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4743,11 +4743,104 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
 		current->thread.gmap_int_code, current->thread.gmap_teid.val);
 }
 
+/*
+ * __kvm_s390_handle_dat_fault() - handle a dat fault for the gmap of a vcpu
+ * @vcpu: the vCPU whose gmap is to be fixed up
+ * @gfn: the guest frame number used for memslots (including fake memslots)
+ * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
+ * @flags: FOLL_* flags
+ *
+ * Return: 0 on success, < 0 in case of error.
+ * Context: The mm lock must not be held before calling. May sleep.
+ */
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags)
+{
+	struct kvm_memory_slot *slot;
+	unsigned int fault_flags;
+	bool writable, unlocked;
+	unsigned long vmaddr;
+	struct page *page;
+	kvm_pfn_t pfn;
+	int rc;
+
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+		return vcpu_post_run_addressing_exception(vcpu);
+
+	fault_flags = flags & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
+	if (vcpu->arch.gmap->pfault_enabled)
+		flags |= FOLL_NOWAIT;
+	vmaddr = __gfn_to_hva_memslot(slot, gfn);
+
+try_again:
+	pfn = __kvm_faultin_pfn(slot, gfn, flags, &writable, &page);
+
+	/* Access outside memory, inject addressing exception */
+	if (is_noslot_pfn(pfn))
+		return vcpu_post_run_addressing_exception(vcpu);
+	/* Signal pending: try again */
+	if (pfn == KVM_PFN_ERR_SIGPENDING)
+		return -EAGAIN;
+
+	/* Needs I/O, try to setup async pfault (only possible with FOLL_NOWAIT) */
+	if (pfn == KVM_PFN_ERR_NEEDS_IO) {
+		trace_kvm_s390_major_guest_pfault(vcpu);
+		if (kvm_arch_setup_async_pf(vcpu))
+			return 0;
+		vcpu->stat.pfault_sync++;
+		/* Could not setup async pfault, try again synchronously */
+		flags &= ~FOLL_NOWAIT;
+		goto try_again;
+	}
+	/* Any other error */
+	if (is_error_pfn(pfn))
+		return -EFAULT;
+
+	/* Success */
+	mmap_read_lock(vcpu->arch.gmap->mm);
+	/* Mark the userspace PTEs as young and/or dirty, to avoid page fault loops */
+	rc = fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlocked);
+	if (!rc)
+		rc = __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
+	scoped_guard(spinlock, &vcpu->kvm->mmu_lock) {
+		kvm_release_faultin_page(vcpu->kvm, page, false, writable);
+	}
+	mmap_read_unlock(vcpu->arch.gmap->mm);
+	return rc;
+}
+
+static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int flags)
+{
+	unsigned long gaddr_tmp;
+	gfn_t gfn;
+
+	gfn = gpa_to_gfn(gaddr);
+	if (kvm_is_ucontrol(vcpu->kvm)) {
+		/*
+		 * This translates the per-vCPU guest address into a
+		 * fake guest address, which can then be used with the
+		 * fake memslots that are identity mapping userspace.
+		 * This allows ucontrol VMs to use the normal fault
+		 * resolution path, like normal VMs.
+		 */
+		mmap_read_lock(vcpu->arch.gmap->mm);
+		gaddr_tmp = __gmap_translate(vcpu->arch.gmap, gaddr);
+		mmap_read_unlock(vcpu->arch.gmap->mm);
+		if (gaddr_tmp == -EFAULT) {
+			vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
+			vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
+			vcpu->run->s390_ucontrol.pgm_code = PGM_SEGMENT_TRANSLATION;
+			return -EREMOTE;
+		}
+		gfn = gpa_to_gfn(gaddr_tmp);
+	}
+	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
+}
+
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned int flags = 0;
 	unsigned long gaddr;
-	int rc = 0;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
@@ -4799,37 +4892,14 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
 		kvm_s390_assert_primary_as(vcpu);
-		if (vcpu->arch.gmap->pfault_enabled) {
-			rc = gmap_fault(vcpu->arch.gmap, gaddr, flags | FAULT_FLAG_RETRY_NOWAIT);
-			if (rc == -EFAULT)
-				return vcpu_post_run_addressing_exception(vcpu);
-			if (rc == -EAGAIN) {
-				trace_kvm_s390_major_guest_pfault(vcpu);
-				if (kvm_arch_setup_async_pf(vcpu))
-					return 0;
-				vcpu->stat.pfault_sync++;
-			} else {
-				return rc;
-			}
-		}
-		rc = gmap_fault(vcpu->arch.gmap, gaddr, flags);
-		if (rc == -EFAULT) {
-			if (kvm_is_ucontrol(vcpu->kvm)) {
-				vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
-				vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
-				vcpu->run->s390_ucontrol.pgm_code = 0x10;
-				return -EREMOTE;
-			}
-			return vcpu_post_run_addressing_exception(vcpu);
-		}
-		break;
+		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
 			current->thread.gmap_int_code, current->thread.gmap_teid.val);
 		send_sig(SIGSEGV, current, 0);
 		break;
 	}
-	return rc;
+	return 0;
 }
 
 static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
@@ -5710,7 +5780,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 #endif
 	case KVM_S390_VCPU_FAULT: {
-		r = gmap_fault(vcpu->arch.gmap, arg, 0);
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		r = vcpu_dat_fault_handler(vcpu, arg, 0);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
 	case KVM_ENABLE_CAP:
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 597d7a71deebe..3f72a217ee995 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -408,6 +408,12 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
 int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc);
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags);
+
+static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int flags)
+{
+	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
+}
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 2527c6574ad12..fb975e72a81ae 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -635,6 +635,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	radix_tree_preload_end();
 	return rc;
 }
+EXPORT_SYMBOL(__gmap_link);
 
 /**
  * gmap_fault - resolve a fault on a guest address
-- 
2.53.0



