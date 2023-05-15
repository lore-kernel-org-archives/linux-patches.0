Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8685DFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DE5C4339B;
	Mon, 15 May 2023 17:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171140;
	bh=v1rj7E7XGwnPY6b+0GXVEqNUPOMJaPmgGWT6TblS49I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EekGEagWx+rW4VjTcSQd9kFlf1xmaqnwjFZdUu1WLhd2DtAJ1a4VcHqIg2i12EGcU
	 OAI+zZFfpIU52Cqb2w+Lvq/1mNOVB5LI/6eAGgsRog/GcDa+xcdFac1xdv+M952Soi
	 gRWYNVVJJ+Ud5JCMhB6WiOFlS6VGGrXAA0ITM8h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 114/242] KVM: x86/mmu: Replace open coded usage of tdp_mmu_page with is_tdp_mmu_page()
Date: Mon, 15 May 2023 18:27:20 +0200
Message-Id: <20230515161725.330191101@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit aeb568a1a6041e3d69def54046747bbd989bc4ed ]

Use is_tdp_mmu_page() instead of querying sp->tdp_mmu_page directly so
that all users benefit if KVM ever finds a way to optimize the logic.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221012181702.3663607-10-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: edbdb43fc96b ("KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8666e8ff48a6e..dcca08a08bd0c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1942,7 +1942,7 @@ static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return true;
 
 	/* TDP MMU pages do not use the MMU generation. */
-	return !sp->tdp_mmu_page &&
+	return !is_tdp_mmu_page(sp) &&
 	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7e5952e95d3bf..cc1fb9a656201 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -133,7 +133,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
 		return;
 
-	WARN_ON(!root->tdp_mmu_page);
+	WARN_ON(!is_tdp_mmu_page(root));
 
 	/*
 	 * The root now has refcount=0.  It is valid, but readers already
-- 
2.39.2



