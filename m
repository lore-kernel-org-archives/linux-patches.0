Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4F1101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C14C433EF;
	Mon, 15 May 2023 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173156;
	bh=wXzA0DZSC9uBx6sxgPe19lisLeu920AdyBdZyVZ1oP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lr917zRYlN1gp9iGu839p7HYpycVARU8VNwxDcuh5snXDuDL1Gf5BdMpjWpVIRshr
	 55Ws68pnL0lzjxd0TsYngC/Iri7nG5j9y/O7sGsPJ3wSAjK4+/A5Cp9wusXhTNZade
	 TCThwOy+uMN4D98zP70wKNR0yhnpGrVn+huYNbvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 356/381] KVM: x86: hyper-v: Avoid calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL
Date: Mon, 15 May 2023 18:30:07 +0200
Message-Id: <20230515161752.961975295@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 6470accc7ba948b0b3aca22b273fe84ec638a116 upstream.

In preparation to making kvm_make_vcpus_request_mask() use for_each_set_bit()
switch kvm_hv_flush_tlb() to calling kvm_make_all_cpus_request() for 'all cpus'
case.

Note: kvm_make_all_cpus_request() (unlike kvm_make_vcpus_request_mask())
currently dynamically allocates cpumask on each call and this is suboptimal.
Both kvm_make_all_cpus_request() and kvm_make_vcpus_request_mask() are
going to be switched to using pre-allocated per-cpu masks.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210903075141.403071-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Sean Christopherson <seanjc@google.com>
Fixes: 6100066358ee ("KVM: Optimize kvm_make_vcpus_request_mask() a bit")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1562,16 +1562,19 @@ static u64 kvm_hv_flush_tlb(struct kvm_v
 
 	cpumask_clear(&hv_vcpu->tlb_flush);
 
-	vcpu_mask = all_cpus ? NULL :
-		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
-					vp_bitmap, vcpu_bitmap);
-
 	/*
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
-	kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
-				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
+	if (all_cpus) {
+		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
+	} else {
+		vcpu_mask = sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
+						    vp_bitmap, vcpu_bitmap);
+
+		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
+					    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
+	}
 
 ret_success:
 	/* We always do full TLB flush, set rep_done = rep_cnt. */


