Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084FF30FC33;
	Thu, 16 Jul 2026 14:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211534; cv=none; b=dJ05UUw9YEBBCbPE/BmaNc7JlcK2O2kTIwoKFKWwiuESnVJS5esngc97ka+S4IU8e/z3NYptq39t4JvSWYeK6oJcdz9i3lNY7EUK6ySNxHnHG3cLwNDv206Srw/UzrMKNP+qRNa9BtKH8P4XSdZc+PQHOClPJ4qcEud5VGGBp7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211534; c=relaxed/simple;
	bh=mdiASAFWKwtHVncUsZ0Y/f/nQVBFoZKVtulodsHg5Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTkGdkdJd8ggja18rqN6NGuIZmJBCOZMVarkMUpFXKV5pm22iE8iDcih0J7evdl9qsJIwlLJ5UbQ2Sfr5D79RRY6Ya6SO8gkw2ChTbFGD+FTA+u/KBpTMxarAdiwoFhhkQFs3gxhTWrynIuVN80gsMh084DqLutMnEoK5OQ1hlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuRVNACc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuRVNACc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC021F000E9;
	Thu, 16 Jul 2026 14:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211532;
	bh=ilrZaSXBckPZWIGOwPzuEvm/pfUcZc1MOXG8wxpWXGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vuRVNACcv+/oqGZuaWr9sGrIoJlpERD0jcBwNaQq5cPJLZK6uQ4NHlQCBi6ZLbaj1
	 uUm9Xpj3Tz/iA7C+NXmJHRHXfCMtWs7hi7eANWBEynqzyG8T/EhuUFOzpXtscW6BK6
	 XR3f1tJfUPNJmRgLY4DnuV77Tt5oiOOXyNDWeJfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 420/480] KVM: arm64: nv: Avoid dereferencing NULL VNCR pseudo-TLB
Date: Thu, 16 Jul 2026 15:32:47 +0200
Message-ID: <20260716133053.900866421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 4be6cbeb93d26994bd1827ddbce391e3c4395c8f upstream.

VNCR TLB invalidation occurs from MMU notifiers or TLBI instructions,
and either can race against a vcpu not being onlined yet (no pseudo-TLB
allocated). Similarly, the TLB might be invalid, and the invalidation
should be skipped in this case.

Both kvm_invalidate_vncr_ipa() and kvm_invalidate_vncr_va() are
expected to perform the same checks, except that the latter doesn't
check for the allocation and blindly dereferences the pointer.

Solve this by introducing a new iterator built on top of the usual
kvm_for_each_vcpu() that checks for both of the above conditions,
and convert the two users to it.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/r/aiUvSbrWndQeUPc8@v4bel
Fixes: 4ffa72ad8f37 ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
Cc: stable@vger.kernel.org
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260607175745.297793-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -824,9 +824,21 @@ static void invalidate_vncr(struct vncr_
 		clear_fixmap(vncr_fixmap(vt->cpu));
 }
 
+/*
+ * VNCR TLB invalidation occurs from MMU notifiers or TLBI instructions, and
+ * either can race against a vcpu not being onlined yet (no pseudo-TLB
+ * allocated). Similarly, the TLB might be invalid.  Skip those, as they
+ * obviously don't participate in the invalidation at this stage.
+ */
+#define kvm_for_each_vncr_tlb(idx, vcpup, tlbp, kvm)	\
+	kvm_for_each_vcpu(idx, vcpup, kvm)		\
+		if (((tlbp) = vcpup->arch.vncr_tlb) &&	\
+		    (tlbp)->valid)
+
 static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
 {
 	struct kvm_vcpu *vcpu;
+	struct vncr_tlb *vt;
 	unsigned long i;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
@@ -834,24 +846,9 @@ static void kvm_invalidate_vncr_ipa(stru
 	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
 		return;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
+	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
 		u64 ipa_start, ipa_end, ipa_size;
 
-		/*
-		 * Careful here: We end-up here from an MMU notifier,
-		 * and this can race against a vcpu not being onlined
-		 * yet, without the pseudo-TLB being allocated.
-		 *
-		 * Skip those, as they obviously don't participate in
-		 * the invalidation at this stage.
-		 */
-		if (!vt)
-			continue;
-
-		if (!vt->valid)
-			continue;
-
 		ipa_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
 							    vt->wr.level));
 		ipa_start = vt->wr.pa & ~(ipa_size - 1);
@@ -881,17 +878,14 @@ static void invalidate_vncr_va(struct kv
 			       struct s1e2_tlbi_scope *scope)
 {
 	struct kvm_vcpu *vcpu;
+	struct vncr_tlb *vt;
 	unsigned long i;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
+	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
 		u64 va_start, va_end, va_size;
 
-		if (!vt->valid)
-			continue;
-
 		va_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
 							   vt->wr.level));
 		va_start = vt->gva & ~(va_size - 1);


