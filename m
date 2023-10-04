Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F811D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZ8Hal//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6602FC433C7;
	Wed,  4 Oct 2023 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443602;
	bh=4S32jdxQm18dphcujgKTN6UYbeEiQl+5Uf4ChwgpaSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZ8Hal//pUYns+M6rwIFD39l13FSSQLirb1tyWnA8Lcu9Li5hpasfCcGW+cEIxy/h
	 VTywwBna1jcyrzbsvCWxKShSWEJTw/GI5PSghHEpFxJbDnOU0UmVtBrraV8urEzoRG
	 UYRepSUxTpk8bs+3A8AOub8IxgL5cENyhsherrFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 214/259] KVM: x86/mmu: Do not filter address spaces in for_each_tdp_mmu_root_yield_safe()
Date: Wed,  4 Oct 2023 19:56:27 +0200
Message-ID: <20231004175227.135993273@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 441a5dfcd96854cbcb625709e2694a9c60adfaab upstream.

All callers except the MMU notifier want to process all address spaces.
Remove the address space ID argument of for_each_tdp_mmu_root_yield_safe()
and switch the MMU notifier to use __for_each_tdp_mmu_root_yield_safe().

Extracted out of a patch by Sean Christopherson <seanjc@google.com>

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c     |    8 ++------
 arch/x86/kvm/mmu/tdp_mmu.c |   22 +++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.h |    3 +--
 3 files changed, 14 insertions(+), 19 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6079,7 +6079,6 @@ static bool kvm_rmap_zap_gfn_range(struc
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	bool flush;
-	int i;
 
 	if (WARN_ON_ONCE(gfn_end <= gfn_start))
 		return;
@@ -6090,11 +6089,8 @@ void kvm_zap_gfn_range(struct kvm *kvm,
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
-	if (is_tdp_mmu_enabled(kvm)) {
-		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
-						      gfn_end, flush);
-	}
+	if (is_tdp_mmu_enabled(kvm))
+		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end, flush);
 
 	if (flush)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -222,8 +222,12 @@ static struct kvm_mmu_page *tdp_mmu_next
 #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
 	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
 
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)			\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, false, false)
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)			\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, false, false);		\
+	     _root;								\
+	     _root = tdp_mmu_next_root(_kvm, _root, false, false))		\
+		if (!kvm_lockdep_assert_mmu_lock_held(_kvm, false)) {		\
+		} else
 
 /*
  * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
@@ -955,12 +959,11 @@ static bool tdp_mmu_zap_leafs(struct kvm
  * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
  * more SPTEs were zapped since the MMU lock was last acquired.
  */
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
-			   bool flush)
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
+	for_each_tdp_mmu_root_yield_safe(kvm, root)
 		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
 
 	return flush;
@@ -969,7 +972,6 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *k
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *root;
-	int i;
 
 	/*
 	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
@@ -983,10 +985,8 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
 	 */
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		for_each_tdp_mmu_root_yield_safe(kvm, root, i)
-			tdp_mmu_zap_root(kvm, root, false);
-	}
+	for_each_tdp_mmu_root_yield_safe(kvm, root)
+		tdp_mmu_zap_root(kvm, root, false);
 }
 
 /*
@@ -1223,7 +1223,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id)
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false, false)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -15,8 +15,7 @@ __must_check static inline bool kvm_tdp_
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
-			   bool flush);
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);


