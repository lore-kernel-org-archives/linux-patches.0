Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC34435C681;
	Thu, 20 Aug 2026 17:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247328; cv=none; b=NQXvoupQVpJ3XabGVCE9BhNLdzWCbHo475BPvGGARlh0KdE7dsvSt/FhzaP17eNGnrFXJD4PH5/S1Y4z7e551PZ7Vmskqp0I36uBWtTOHepXjucMnniA2VHfKG8PYbCzxPdNXvZaBGVKSduDzGLGmw0s+/JJfb8HAnvT2BKLy5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247328; c=relaxed/simple;
	bh=3NQnqVh8HXzzhSYwRTX3He7/4JBf8Ts+1PL8wcTiwfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVtOYduTNf6FeYbkmA9ZVABZw5MgjkmK7sTpDp756+Z0Ck4TEr5avSSonhOgWW3DU8lnhc7H4lwLZIRJN+zrMewCU4OdVjY+b+zebdiE9uGXEnnQ8Q1Pxv4zlf72TrjP6HPyW18PUhgvjRdciYiZSweNh9QVPFVm/F0ao5Idc9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPuFiDyi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPuFiDyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8B11F000E9;
	Thu, 20 Aug 2026 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247326;
	bh=RrCnsb5QmpeNijgXTAshjac21Kq5ckFr8sb+oINp+w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPuFiDyiF7+PLO23Z9bJd3ethTLieHMkQfGKMphNOvu3ylZOw4zPUPC6/JkmyYf1w
	 Vtkhdek2fRuzcIy5RARvMxGtVsUn7XMMx6MMRTC7dlfnbGTHrHFOtLjOtN9DbyPZ2G
	 aLoluEHprRr67/MNt0YQ6zeDhpRllQFddVkj0AxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shen Yongchao <grayhat@foxmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/220] KVM: SVM: Serialize accesses to the owner and mirror list with separate lock
Date: Thu, 20 Aug 2026 16:56:12 +0200
Message-ID: <20260820145228.959242643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 1d78d33275ef2a16c6d080910b291d0a97a0e613 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   39 +++++++++++++++++++++++++++------------
 arch/x86/kvm/svm/svm.h |    1 +
 2 files changed, 28 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -82,6 +82,8 @@ static u64 sev_supported_vmsa_features;
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
+/* Protects kvm_sev_info's enc_context_owner, mirror_vms and mirror_entry.  */
+static DEFINE_MUTEX(sev_mirror_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long sev_me_mask;
@@ -1989,7 +1991,6 @@ static void sev_migrate_from(struct kvm
 	dst->asid = src->asid;
 	dst->handle = src->handle;
 	dst->pages_locked = src->pages_locked;
-	dst->enc_context_owner = src->enc_context_owner;
 	dst->es_active = src->es_active;
 	dst->vmsa_features = src->vmsa_features;
 
@@ -1997,11 +1998,12 @@ static void sev_migrate_from(struct kvm
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
@@ -2018,13 +2020,15 @@ static void sev_migrate_from(struct kvm
 	 * If this VM is a mirror, remove the old mirror from the owners list
 	 * and add the new mirror to the list.
 	 */
-	if (is_mirroring_enc_context(dst_kvm)) {
-		struct kvm_sev_info *owner_sev_info =
-			&to_kvm_svm(dst->enc_context_owner)->sev_info;
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
@@ -2843,13 +2847,16 @@ int sev_vm_copy_enc_context_from(struct
 	 * The mirror kvm holds an enc_context_owner ref so its asid can't
 	 * disappear until we're done with it
 	 */
-	source_sev = &to_kvm_svm(source_kvm)->sev_info;
-	kvm_get_kvm(source_kvm);
-	mirror_sev = &to_kvm_svm(kvm)->sev_info;
-	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
+	source_sev = to_kvm_sev_info(source_kvm);
+	mirror_sev = to_kvm_sev_info(kvm);
 
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
@@ -2909,11 +2916,19 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
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
@@ -103,6 +103,7 @@ struct kvm_sev_info {
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	u64 vmsa_features;
 	u16 ghcb_version;	/* Highest guest GHCB protocol version allowed */
+	/* The three fields below are protected by sev_mirror_lock */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct list_head mirror_vms; /* List of VMs mirroring */
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */


