Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8EC2F8EA2;
	Mon, 17 Aug 2026 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974550; cv=none; b=Mmq3HPVnQaa/fWb1lK/nb6eq4FPdXF83eTrL7L76OUscx13NLZGwvGViuGvwznhFkj/kTz4cS+Q8SUK8f5GN7QOH7kwszJM3y60scdVJ5gd2ebH+V4oSW24ZuwtAbzOJ/8fhcortmlGyZP2OZNsjfhefzxUO0M0Nh2LcMMXlA/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974550; c=relaxed/simple;
	bh=7qjDNor0hsZSU0oSr/9Jh8KpJ740O1t1gprYKAOw9nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JK9q9kY/+7TOiO3nyD76uHxsJNsAucpRItvw8bYj/MHnMGdcrm5iqLKn0c7hkNwVfVbg3j9QkvjMlWJHfJg4FCpNmMxY4Sy9GxDuTJBPXDQvtndPZLZjzrqFo18Vd4rC8Jtd2qdw8Z4ED8rcUcg+0P6RmvcSgQX9fzMERSXA6Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNjKhj16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNjKhj16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE2B1F00A3A;
	Mon, 17 Aug 2026 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974546;
	bh=1jRrj6FGt47lpdH4McZE0qXT7X0qFMpzPf+K87Xb8w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNjKhj16HZJQUagZ6lnLNMsntxL2B5iFgkZUHaFfHs2gIHyofSe0bQazS7ITPHrxa
	 GaWQrN2pBIxaX+LTxmCEasDO5wJ8ex5ZwiZ+6Z0q3lL8LW6uPAS49UyVnwT2Nlb/Pf
	 aHXvW1y5PUDacilhnHyc6rvR3SP3JGErcUD4xZhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shen Yongchao <grayhat@foxmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.1 242/271] KVM: SVM: Serialize accesses to the owner and mirror list with separate lock
Date: Mon, 17 Aug 2026 15:32:47 +0200
Message-ID: <20260817132546.710389615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 1d78d33275ef2a16c6d080910b291d0a97a0e613 upstream.

Interaction between KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM and
KVM_CAP_VM_COPY_ENC_CONTEXT_FROM can cause two separate issues:

- in sev_migrate_from(), when the destination KVM is a mirror, the mirror
  entry is moved from the source's list to the owner's mirror_vms list,
  without holding the owner's lock unlike other writers of the owner's
  mirror list (sev_vm_copy_enc_context_from(), sev_vm_destroy()).
  A concurrent COPY or destroy can race with sev_migrate_from() and
  corrupt the list.

- In sev_vm_destroy(), the *owner* is still active and could receive
  concurrently a KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM that causes
  sev->enc_context_owner to change.  In this case the incorrect VM
  receives kvm_put_kvm().

The second issue needs particular care because the owner could disappear
altogether (even though the race window is impossibly small) between
reading it and locking it.  There is thus no way to perform the checks
under the owner lock without putting struct kvm under SLAB_TYPESAFE_BY_RCU
(which would allow kvm_get_kvm_safe() under RCU critical section).

It is much simpler to just use a global lock, since the critical
sections are so small and the new lock is always a leaf lock.

Fixes: b2125513dfc0 ("KVM: SEV: Allow SEV intra-host migration of VM with mirrors")
Cc: stable@vger.kernel.org
Reported-by: Shen Yongchao <grayhat@foxmail.com>
Link: https://lore.kernel.org/kvm/tencent_625C0F42824E542C72B34733392AF2C49709@qq.com/
Link: https://lore.kernel.org/kvm/tencent_DDC4E4352EC91CAC05A9A8F4E55E8C96730A@qq.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   34 +++++++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.h |    1 +
 2 files changed, 26 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -96,6 +96,8 @@ static u64 sev_supported_vmsa_features _
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
+/* Protects kvm_sev_info's enc_context_owner, mirror_vms and mirror_entry.  */
+static DEFINE_MUTEX(sev_mirror_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned int max_sev_es_asid;
@@ -2031,7 +2033,6 @@ static void sev_migrate_from(struct kvm
 	dst->asid = src->asid;
 	dst->handle = src->handle;
 	dst->pages_locked = src->pages_locked;
-	dst->enc_context_owner = src->enc_context_owner;
 	dst->es_active = src->es_active;
 	dst->vmsa_features = src->vmsa_features;
 
@@ -2039,11 +2040,12 @@ static void sev_migrate_from(struct kvm
 	src->active = false;
 	src->handle = 0;
 	src->pages_locked = 0;
-	src->enc_context_owner = NULL;
 	src->es_active = false;
 
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 
+	mutex_lock(&sev_mirror_lock);
+
 	/*
 	 * If this VM has mirrors, "transfer" each mirror's refcount of the
 	 * source to the destination (this KVM).  The caller holds a reference
@@ -2060,12 +2062,15 @@ static void sev_migrate_from(struct kvm
 	 * If this VM is a mirror, remove the old mirror from the owners list
 	 * and add the new mirror to the list.
 	 */
-	if (is_mirroring_enc_context(dst_kvm)) {
-		struct kvm_sev_info *owner_sev_info = to_kvm_sev_info(dst->enc_context_owner);
+	if (is_mirroring_enc_context(src_kvm)) {
+		struct kvm_sev_info *owner_sev_info = to_kvm_sev_info(src->enc_context_owner);
 
+		dst->enc_context_owner = src->enc_context_owner;
+		src->enc_context_owner = NULL;
 		list_del(&src->mirror_entry);
 		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
 	}
+	mutex_unlock(&sev_mirror_lock);
 
 	kvm_for_each_vcpu(i, dst_vcpu, dst_kvm) {
 		dst_svm = to_svm(dst_vcpu);
@@ -2885,11 +2890,14 @@ int sev_vm_copy_enc_context_from(struct
 	 * disappear until we're done with it
 	 */
 	source_sev = to_kvm_sev_info(source_kvm);
-	kvm_get_kvm(source_kvm);
-	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
 
 	/* Set enc_context_owner and copy its encryption context over */
+	mutex_lock(&sev_mirror_lock);
+	kvm_get_kvm(source_kvm);
+	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
 	mirror_sev->enc_context_owner = source_kvm;
+	mutex_unlock(&sev_mirror_lock);
+
 	mirror_sev->active = true;
 	mirror_sev->asid = source_sev->asid;
 	mirror_sev->fd = source_sev->fd;
@@ -2977,11 +2985,19 @@ void sev_vm_destroy(struct kvm *kvm)
 	 * Note, mirror VMs don't support registering encrypted regions.
 	 */
 	if (is_mirroring_enc_context(kvm)) {
-		struct kvm *owner_kvm = sev->enc_context_owner;
+		struct kvm *owner_kvm;
 
-		mutex_lock(&owner_kvm->lock);
+		mutex_lock(&sev_mirror_lock);
+		owner_kvm = sev->enc_context_owner;
 		list_del(&sev->mirror_entry);
-		mutex_unlock(&owner_kvm->lock);
+		sev->enc_context_owner = NULL;
+
+		/*
+		 * The reference to owner_kvm cannot move after sev_mirror_lock is
+		 * released.  Release it before kvm_put_kvm() so that owner_kvm is
+		 * never destroyed inside sev_mirror_lock.
+		 */
+		mutex_unlock(&sev_mirror_lock);
 		kvm_put_kvm(owner_kvm);
 		return;
 	}
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -106,6 +106,7 @@ struct kvm_sev_info {
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	u64 vmsa_features;
 	u16 ghcb_version;	/* Highest guest GHCB protocol version allowed */
+	/* The three fields below are protected by sev_mirror_lock */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct list_head mirror_vms; /* List of VMs mirroring */
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */


