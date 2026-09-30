Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B417528423;
	Wed, 30 Sep 2026 17:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789960; cv=none; b=V/w3pN79jP9ClIt0dkV4J8QtEZ4LPFf8U698JYgqllhC+ENdNAWhIBWUuHdwvanuSQAsHuvGFWGBqZmdxsN2r3FH0XXRAmGfv6pbRNBLhglyAui4yj5EwY/7r2ASArmWta5DBtTY+7Y1NJ7d91ZJwurrAY1OPmzvKVWQTUsXkY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789960; c=relaxed/simple;
	bh=HG3f559JaQsHAEaXs+wdI15vMhnw3CVQSj+KZ74UiH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClDhvgH4fti40L/1sF7Ksq457bqtCq1cpK42QG/RUEp7+2jrrR0l5AGZ6WRWoq/RU7wtOnwdJsqn262AIoiiU7Aez4LhuHj3ruzri36I+XnXlN6omszN/338Ek1DGUHfDVSIR4Oav6TMgZ86aXDTrfa2vS4GPcMG6jv7YT6n8aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wqc78erq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wqc78erq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CF01F000FF;
	Wed, 30 Sep 2026 17:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789959;
	bh=4qlLuvrKpLrElhRChPaRJGrWochmIK5lu9J3RtCM+Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wqc78erqeTL2WBUK4hRsj+TFJzGmGt3rJOvNNZ//aEtNVsAB5/0AkBKpqpiJyDe5j
	 0YIOtg1kiMYwZ981ZQpUKwO4kZ8LeUolLrhS2BhyWVWSkpP5r+x/Pok+wh0oroBFp+
	 G5du7vsNrsW7EnYsMj21Y4nKbo1UIMKFBkUkKfP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 661/877] KVM: x86/mmu: Split kvm_mmu_zap_all_fast() into "front" and "back" halves
Date: Wed, 30 Sep 2026 17:26:12 +0200
Message-ID: <20260930152428.927441146@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit b27622c4eeb125814081baaefe9175191be5b94d ]

Split kvm_mmu_zap_all_fast() into a "front half" and a "back half", where
the front half is everything that runs with mmu_lock held for write, and
the back half is the code that runs outside of mmu_lock.  This will allow
putting more code inside kvm_arch_flush_shadow_memslot()'s critical section
without having to take mmu_lock twice in quick succession.

No functional change intended.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-9-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6489,20 +6489,11 @@ restart:
 	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 }
 
-/*
- * Fast invalidate all shadow pages and use lock-break technique
- * to zap obsolete pages.
- *
- * It's required when memslot is being deleted or VM is being
- * destroyed, in these cases, we should ensure that KVM MMU does
- * not use any resource of the being-deleted slot or all slots
- * after calling the function.
- */
-static void kvm_mmu_zap_all_fast(struct kvm *kvm)
+static void __kvm_mmu_zap_all_fast_front_half(struct kvm *kvm)
 {
 	lockdep_assert_held(&kvm->slots_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	write_lock(&kvm->mmu_lock);
 	trace_kvm_mmu_zap_all_fast(kvm);
 
 	/*
@@ -6534,8 +6525,12 @@ static void kvm_mmu_zap_all_fast(struct
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
 
 	kvm_zap_obsolete_pages(kvm);
+}
 
-	write_unlock(&kvm->mmu_lock);
+static void __kvm_mmu_zap_all_fast_back_half(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->slots_lock);
+	lockdep_assert_not_held(&kvm->mmu_lock);
 
 	/*
 	 * Zap the invalidated TDP MMU roots, all SPTEs must be dropped before
@@ -6554,6 +6549,24 @@ static bool kvm_has_zapped_obsolete_page
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
+/*
+ * Fast invalidate all shadow pages and use lock-break technique
+ * to zap obsolete pages.
+ *
+ * It's required when memslot is being deleted or VM is being
+ * destroyed, in these cases, we should ensure that KVM MMU does
+ * not use any resource of the being-deleted slot or all slots
+ * after calling the function.
+ */
+static void kvm_mmu_zap_all_fast(struct kvm *kvm)
+{
+	write_lock(&kvm->mmu_lock);
+	__kvm_mmu_zap_all_fast_front_half(kvm);
+	write_unlock(&kvm->mmu_lock);
+
+	__kvm_mmu_zap_all_fast_back_half(kvm);
+}
+
 int kvm_mmu_init_vm(struct kvm *kvm)
 {
 	int r;


