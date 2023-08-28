Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4195B469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B826FC433C8;
	Mon, 28 Aug 2023 10:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218792;
	bh=tTYMbkp25MNIwVvkGTRdFXSKfUb/onGkRfkQq7G3Dlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfOnsYlQU+BddUPyfSj3T+tUmNuON0HmvOzYvbl1x6mD3U4CRSGQu4d9uZGB12BH3
	 2RFaZzSkmE2nZ6FfSj+WMkfZnxWbCvkiTko6QYcQIxYUrVKu/vQPTtoTsHDyf0PWLH
	 q8/ug/wFLcdCGNO/l9vq2fKw3HpMgqeur+g/rWbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Rak <brak@vultr.com>,
	Amaan Cheval <amaan.cheval@gmail.com>,
	Eric Wheeler <kvm@lists.ewheeler.net>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 056/122] [PATCH 6.1] KVM: x86/mmu: Fix an sign-extension bug with mmu_seq that hangs vCPUs
Date: Mon, 28 Aug 2023 12:12:51 +0200
Message-ID: <20230828101158.286647136@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

Upstream commit ba6e3fe25543 ("KVM: x86/mmu: Grab mmu_invalidate_seq in
kvm_faultin_pfn()") unknowingly fixed the bug in v6.3 when refactoring
how KVM tracks the sequence counter snapshot.

Take the vCPU's mmu_seq snapshot as an "unsigned long" instead of an "int"
when checking to see if a page fault is stale, as the sequence count is
stored as an "unsigned long" everywhere else in KVM.  This fixes a bug
where KVM will effectively hang vCPUs due to always thinking page faults
are stale, which results in KVM refusing to "fix" faults.

mmu_invalidate_seq (née mmu_notifier_seq) is a sequence counter used when
KVM is handling page faults to detect if userspace mappings relevant to
the guest were invalidated between snapshotting the counter and acquiring
mmu_lock, i.e. to ensure that the userspace mapping KVM is using to
resolve the page fault is fresh.  If KVM sees that the counter has
changed, KVM simply resumes the guest without fixing the fault.

What _should_ happen is that the source of the mmu_notifier invalidations
eventually goes away, mmu_invalidate_seq becomes stable, and KVM can once
again fix guest page fault(s).

But for a long-lived VM and/or a VM that the host just doesn't particularly
like, it's possible for a VM to be on the receiving end of 2 billion (with
a B) mmu_notifier invalidations.  When that happens, bit 31 will be set in
mmu_invalidate_seq.  This causes the value to be turned into a 32-bit
negative value when implicitly cast to an "int" by is_page_fault_stale(),
and then sign-extended into a 64-bit unsigned when the signed "int" is
implicitly cast back to an "unsigned long" on the call to
mmu_invalidate_retry_hva().

As a result of the casting and sign-extension, given a sequence counter of
e.g. 0x8002dc25, mmu_invalidate_retry_hva() ends up doing

	if (0x8002dc25 != 0xffffffff8002dc25)

and signals that the page fault is stale and needs to be retried even
though the sequence counter is stable, and KVM effectively hangs any vCPU
that takes a page fault (EPT violation or #NPF when TDP is enabled).

Reported-by: Brian Rak <brak@vultr.com>
Reported-by: Amaan Cheval <amaan.cheval@gmail.com>
Reported-by: Eric Wheeler <kvm@lists.ewheeler.net>
Closes: https://lore.kernel.org/all/f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com
Fixes: a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4212,7 +4212,8 @@ static int kvm_faultin_pfn(struct kvm_vc
  * root was invalidated by a memslot update or a relevant mmu_notifier fired.
  */
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
-				struct kvm_page_fault *fault, int mmu_seq)
+				struct kvm_page_fault *fault,
+				unsigned long mmu_seq)
 {
 	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
 


