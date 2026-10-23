Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774175;
	b=32cAa1kkyhu9TUK/nxTAYyxlhl/q9HZOPXLJnkERh6xpAhrq2+EIZXz6dD7HA5Bk1LLY
	 ZbzrxEpLO1yxKbWSO9i/eayI2ayP0AtgQlQbAWWCe21G8Fd1gbxlIL+Cnd05cE1N8FR5s
	 4uhVlt41Bu7Hez4I7GS3cTm29cIeugH8bNXD0jg6zk5mrsFANkaDDP3IbzsFf0Yfv9VaV
	 ohFxVOZ7RSzdSRjZAt6Ku3tD1csyPqPhB92sHGI9UUcGNvtsB+ZFqBTyuXSd1cI18Dma8
	 N6VDM/c/n5rjqoslmQQHrDOLviHTT/5aBsYlGb54VjbNAwrCLLbWdCYaYQO73V98RlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p1H1nbhBGopwnlFRqvDZUtx//a3UJHS2RyZjCHMJR8g=;
	b=jIC9cjRWDaPpv+GpY5c71aTfVW4ycr5JWexCVzkGqh0iRdBKso7Zi1Y63ay5dTWzegVd
	 OfIiZtiSRsTgaZ/aaxoojf9IXrTaD0ItWzXc7lWZaTdOBDy+0BVnwvt5G+jkM3K/H3tJP
	 p56vVjCR09zpG8xWVUZ63NDNezjpkNwgigN5rbLyN14fpdJkjT6XOxSkeI6QqXGl4iVqr
	 R+Se0Ekn+b+Wy0luYpzBJm+77LIe/8mbk+hiF4aXsgmUETAz/RL/snzFx4ONRFqQRO+1k
	 oOpEAf4f0f2jsk47wOWTJNoPq7MKqDH2QGZYfo0FkVe1bTFy083yHaIvp8wG/S+gg8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFrGo1BS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0BB606A31E;
	Fri, 23 Oct 2026 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFrGo1BS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5711F01828;
	Fri, 23 Oct 2026 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774175;
	bh=p1H1nbhBGopwnlFRqvDZUtx//a3UJHS2RyZjCHMJR8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFrGo1BSPxiBB66Qericbm1rKmSzCc46LevkBynqD2Fmb4y0ZYqioAAyZMiGjAMJF
	 6X92k3sR+lCEbTytzDfG9sRrg/uvhQOrwCwrQ8Aip9/b9egDNu+7CN5xhOKZucqClj
	 LHwr6+AFmYv8TN1mCevVb6NBXaOZEk/O4QvNnwow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SimonP <simonp.git@mailbox.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 147/193] KVM: x86/mmu: Cope with the SS bit being set in #NPF exit codes
Date: Fri, 23 Oct 2026 18:37:04 +0200
Message-ID: <20261023163717.686576939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit e90ab3669181c6469e3647ef2b30ae408275f496 ]

When running Hyper-V from Windows 11, KVM is seeing the SS bit set
in nested page fault error codes produced for shadowed NPT.  The AMD
manual is unclear about when SS is set, including whether it can be set
when SupervisorShadowStackEn (bit 6) is not set in the MISC_CTL field
of the VMCB.

Nevertheless, the unexpected SS bit causes out of bounds accesses in
permission_fault(), seen as either WARNs or UBSAN reports:

  kernel: UBSAN: array-index-out-of-bounds in arch/x86/kvm/mmu.h:225:27
  kernel: index 34 is out of range for type 'u16 [16]'

(in this case, the page fault error code is 34*2=0x44, i.e. SS|U; the
report shows SS|U|W happening as well).  Fix the handling of unknown
error codes by dropping SS and (with a WARN) any bits not among those
that permission_fault() expects to receive.

At the same time, given the uncertainty about when hardware sets SS,
follow the processor's behavior when constructing the fault's error
code, and preserve the SS bit as passed to FNAME(walk_addr_generic).
While the behavior is surprising, there's a possibility that Hyper-V
expects it (Hyper-V does not even enable CET unless it finds MBEC/GMET!),
so retain the information when reflecting the fault to L1 instead of
unconditionally discarding it.

Bisection shows that this started happening with commit 687ee95c1b6d ("KVM:
nSVM: enable GMET for guests"), even though SHSTK was available to guests
since Linux 6.18.  However, this is not because bit 1 of MISC_CTL (GMET)
somehow enables reporting the SS bit; rather, it's simply that Hyper-V
never uses CET unless GMET is also present.  The WARN is reproducible
even with gmet=0, with some hacking of kvm-unit-tests's cet.c testcase
to ensure that the first access to the shadow stack triggers a page fault.

Reported-by: SimonP <simonp.git@mailbox.org>
Fixes: 8db428fd5229 ("KVM: SVM: Enable shadow stack virtualization for SVM")
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Closes: https://lore.kernel.org/all/asUqYEisPp9MJ8mQ@rika.bernkas.tel
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ sashal: Adapted permission checks to use mmu->permissions and mmu->pkru_mask instead of the newer page-walk structures. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.h             |   16 ++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h |    2 +-
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -186,8 +186,18 @@ static inline u8 permission_fault(struct
 				  unsigned pte_access, unsigned pte_pkey,
 				  u64 access)
 {
-	/* strip nested paging fault error codes */
-	unsigned int pfec = access;
+	/*
+	 * Of the error codes that do not contribute to the index in
+	 * mmu->permissions, PK and SS are not supported by shadow paging
+	 * and also not provided to EPT violations, but SS *is* included
+	 * in the NPT exit code.  RSVD faults are handled elsewhere.
+	 */
+	unsigned int pfec = access & ~PFERR_SS_MASK;
+	if (WARN_ON_ONCE(pfec & ~(PFERR_PRESENT_MASK | PFERR_WRITE_MASK |
+				  PFERR_USER_MASK | PFERR_FETCH_MASK)))
+		pfec &= (PFERR_PRESENT_MASK | PFERR_WRITE_MASK |
+			 PFERR_USER_MASK | PFERR_FETCH_MASK);
+
 	unsigned long rflags = kvm_x86_call(get_rflags)(vcpu);
 
 	/*
@@ -211,8 +221,6 @@ static inline u8 permission_fault(struct
 	kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
 
 	fault = (mmu->permissions[index] >> pte_access) & 1;
-
-	WARN_ON_ONCE(pfec & (PFERR_PK_MASK | PFERR_SS_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkru_mask)) {
 		u32 pkru_bits, offset;
 
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -474,7 +474,7 @@ retry_walk:
 	return 1;
 
 error:
-	errcode |= write_fault | user_fault;
+	errcode |= write_fault | user_fault | (access & PFERR_SS_MASK);
 	if (fetch_fault && (is_efer_nx(mmu) || is_cr4_smep(mmu)))
 		errcode |= PFERR_FETCH_MASK;
 


