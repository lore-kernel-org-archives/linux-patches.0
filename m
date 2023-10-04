Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6871C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U188uAQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1AFC433C8;
	Wed,  4 Oct 2023 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444504;
	bh=9EuWmj1clstU/pWazwyQaS+9zHa8ViyRlNMcwbjHIyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U188uAQJTezcZIo4hxgWKe4BRgBIguqGKwZROx3bq5A32ukGaZ13RZ1eHEtiU6HwG
	 JYus5OzycnVAjohQUGCxj2pnvGoStB/qD03jWeZH3eZCYiu07UDzWO03Fw+c22jkKD
	 Gs61ZS32tUdCx9vRpt3iw9dQFtEHCx3Ipw2m6mVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.5 245/321] KVM: x86/mmu: Open code leaf invalidation from mmu_notifier
Date: Wed,  4 Oct 2023 19:56:30 +0200
Message-ID: <20231004175240.606396719@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 50107e8b2a8a59d8cec7e8454e27c1f8e365acdb upstream.

The mmu_notifier path is a bit of a special snowflake, e.g. it zaps only a
single address space (because it's per-slot), and can't always yield.
Because of this, it calls kvm_tdp_mmu_zap_leafs() in ways that no one
else does.

Iterate manually over the leafs in response to an mmu_notifier
invalidation, instead of invoking kvm_tdp_mmu_zap_leafs().  Drop the
@can_yield param from kvm_tdp_mmu_zap_leafs() as its sole remaining
caller unconditionally passes "true".

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230916003916.2545000-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c     |    2 +-
 arch/x86/kvm/mmu/tdp_mmu.c |   13 +++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h |    4 ++--
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6308,7 +6308,7 @@ void kvm_zap_gfn_range(struct kvm *kvm,
 	if (tdp_mmu_enabled) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
-						      gfn_end, true, flush);
+						      gfn_end, flush);
 	}
 
 	if (flush)
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -878,12 +878,12 @@ static bool tdp_mmu_zap_leafs(struct kvm
  * more SPTEs were zapped since the MMU lock was last acquired.
  */
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
-			   bool can_yield, bool flush)
+			   bool flush)
 {
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
-		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
 
 	return flush;
 }
@@ -1146,8 +1146,13 @@ retry:
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
-	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
-				     range->end, range->may_block, flush);
+	struct kvm_mmu_page *root;
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id)
+		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
+					  range->may_block, flush);
+
+	return flush;
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -20,8 +20,8 @@ __must_check static inline bool kvm_tdp_
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush);
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
+			   bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);


