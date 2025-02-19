Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE811DFDBC;
	Wed, 19 Feb 2025 08:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955595; cv=none; b=VNng5G4Ed85cAtWYSxJ/tu2z9+T///2WbxUFv+k0X9NmRHwRzbveQ3/jPai4ha22pBorVVvyBT1MOCnPUW8Mca/kyrEySaIKrtLTtu2p048qcjfwTz7SB1BaTzbqQIyS8lZffaCrwIDFpKyyY8LnYXjpKpucELhvhx9IBulZvVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955595; c=relaxed/simple;
	bh=ZSTUbqYSE9zdQi1smD1JDke+yda+8LL/pSTZkrPlz+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFBj6IjLgIZhT7a/e9TOgMmlvIYwmNJdzZgesmf26f3W90P1BvaBgWXnqxkbuVF8ZuNbpiTVxQfu9mH4ZRa87PZo9sj8kpAQXa/3MNRy+Vy60Yh+deNbr5v57DjincHA4g5dMXWrH4iBIZTQz0BTKPJaWa7u9YOGI+eepV5uScQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwuiFYqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwuiFYqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F246C4CED1;
	Wed, 19 Feb 2025 08:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955594;
	bh=ZSTUbqYSE9zdQi1smD1JDke+yda+8LL/pSTZkrPlz+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwuiFYqgcQS3NAkSv4WGPqHGjKDg0f2x+g0XXWmu0u0RBD/33uPmMOz4smAS3jI8Y
	 91OyDcGI09kSGu3xGmuGClA9VByVZc1z3m/mGQRLvTFq6U37tt8FasV3ZXotBvAF0U
	 2FBT7mXowrW6JoQx2NUOGeA6Ek+HNXcgpsEad/K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 054/152] KVM: nSVM: Enter guest mode before initializing nested NPT MMU
Date: Wed, 19 Feb 2025 09:27:47 +0100
Message-ID: <20250219082552.184281186@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 46d6c6f3ef0eaff71c2db6d77d4e2ebb7adac34f upstream.

When preparing vmcb02 for nested VMRUN (or state restore), "enter" guest
mode prior to initializing the MMU for nested NPT so that guest_mode is
set in the MMU's role.  KVM's model is that all L2 MMUs are tagged with
guest_mode, as the behavior of hypervisor MMUs tends to be significantly
different than kernel MMUs.

Practically speaking, the bug is relatively benign, as KVM only directly
queries role.guest_mode in kvm_mmu_free_guest_mode_roots() and
kvm_mmu_page_ad_need_write_protect(), which SVM doesn't use, and in paths
that are optimizations (mmu_page_zap_pte() and
shadow_mmu_try_split_huge_pages()).

And while the role is incorprated into shadow page usage, because nested
NPT requires KVM to be using NPT for L1, reusing shadow pages across L1
and L2 is impossible as L1 MMUs will always have direct=1, while L2 MMUs
will have direct=0.

Hoist the TLB processing and setting of HF_GUEST_MASK to the beginning
of the flow instead of forcing guest_mode in the MMU, as nothing in
nested_vmcb02_prepare_control() between the old and new locations touches
TLB flush requests or HF_GUEST_MASK, i.e. there's no reason to present
inconsistent vCPU state to the MMU.

Fixes: 69cb877487de ("KVM: nSVM: move MMU setup to nested_prepare_vmcb_control")
Cc: stable@vger.kernel.org
Reported-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://lore.kernel.org/r/20250130010825.220346-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c    |    2 +-
 arch/x86/kvm/svm/nested.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5289,7 +5289,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_
 	union kvm_mmu_page_role root_role;
 
 	/* NPT requires CR0.PG=1. */
-	WARN_ON_ONCE(cpu_role.base.direct);
+	WARN_ON_ONCE(cpu_role.base.direct || !cpu_role.base.guest_mode);
 
 	root_role = cpu_role.base;
 	root_role.level = kvm_mmu_get_tdp_level(vcpu);
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -644,6 +644,11 @@ static void nested_vmcb02_prepare_contro
 	u32 pause_count12;
 	u32 pause_thresh12;
 
+	nested_svm_transition_tlb_flush(vcpu);
+
+	/* Enter Guest-Mode */
+	enter_guest_mode(vcpu);
+
 	/*
 	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
 	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
@@ -760,11 +765,6 @@ static void nested_vmcb02_prepare_contro
 		}
 	}
 
-	nested_svm_transition_tlb_flush(vcpu);
-
-	/* Enter Guest-Mode */
-	enter_guest_mode(vcpu);
-
 	/*
 	 * Merge guest and host intercepts - must be called with vcpu in
 	 * guest-mode to take effect.


