Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775067;
	b=Eimctl835HAzpV66JFR8Z/gt5ZX6Ii3+UoxICKnMQMdkVpQd8q+Y1uMiurGaKbKgahj1
	 lOZ+ViagTRcQZR9rEpdqpFVcsxL2RD3eS2Sn3Ch+GKNAnBcWdxCUcRgdpVuatxxkOukwA
	 4mKE5+rGl9US56TTlUwpW3uqFvLYWSYyff4N4QM2tblEAocax1UATOb23R0MUs6ldAC7z
	 gToXu5nJQxZSKen2vWixxK0ZIUN1Z7qCzEkMnDCR74VueHkTkPfoC6od7uDmfbfOf6L6h
	 2yXyLchOPH0AJe655Viwk42m5SUarc/OxWHK2J8j575/aWyP6WiBPDmiRtgCZFI1GZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jcc7WQ7GJnAzpgAZPD9t75yHryj1cLb5lXSU1+bjYd0=;
	b=e8GRymKlV/I91Nkq31+ulVw/Pi778TC8D6cebJCO5AjlxJaq0aB4c1hm8NuosL/IHP3H
	 IXW+cSLiGmiPWCXT9psfwS6DItWI+nwhrLli2Db8MnGnaDB8cDfZ1GlMLb821WTRCk3E4
	 gt16366Kwdz6o4SaNPZ+b8FXzlmzyBsJMSRHLC0IYk2xWeYH+Im/BU5JDefx+dBubTMgP
	 ecKA0IFv18+oMv/COE5DLd4hPfVrG+vdXPFspUtXZxDPlpatITiu4G5Kc+L+4LIe0o5Qi
	 K6RVdZoE/sGgLrDFgtHKujo1srpXishhAs8t3qLb/d64WWQAvZLAD6VUnnPvVK9Yhbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgPOP7Bg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582BF606A31A;
	Fri, 23 Oct 2026 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgPOP7Bg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B071F01825;
	Fri, 23 Oct 2026 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775067;
	bh=jcc7WQ7GJnAzpgAZPD9t75yHryj1cLb5lXSU1+bjYd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgPOP7Bg6/SBc0+n3no85TX7IMdBu/i1FoWbphUlM98MLyK9htZx+s/SHT9k0wz9j
	 iVwsnNU654C9iUIPjGejWXcBXxA0XbevpprasvsAH0+oqMfqjuqFuFpNhRHcb9M/A5
	 8WGlqJOcK5dYOpMNkOnORUciXb5wsEE9Sx5G7x1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SimonP <simonp.git@mailbox.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 209/242] KVM: x86/mmu: Cope with the SS bit being set in #NPF exit codes
Date: Fri, 23 Oct 2026 18:40:51 +0200
Message-ID: <20261023163718.740229718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted upstream w and fmt references to the existing mmu structure. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.h             |   16 ++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h |    3 +--
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -198,8 +198,18 @@ static inline u8 permission_fault(struct
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
@@ -223,8 +233,6 @@ static inline u8 permission_fault(struct
 	kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
 
 	fault = (mmu->permissions[index] >> pte_access) & 1;
-
-	WARN_ON_ONCE(pfec & (PFERR_PK_MASK | PFERR_SS_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkru_mask)) {
 		u32 pkru_bits, offset;
 
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -326,7 +326,6 @@ static int FNAME(walk_addr_generic)(stru
 	int offset;
 	u64 walk_nx_mask = 0;
 	const int write_fault = access & PFERR_WRITE_MASK;
-	const int user_fault  = access & PFERR_USER_MASK;
 	const int fetch_fault = access & PFERR_FETCH_MASK;
 	/*
 	 * Note! Track the error_code that's common to legacy shadow paging
@@ -484,7 +483,7 @@ retry_walk:
 	return 1;
 
 error:
-	errcode |= write_fault | user_fault;
+	errcode |= access & (PFERR_WRITE_MASK | PFERR_USER_MASK | PFERR_SS_MASK);
 	if (fetch_fault && has_pferr_fetch(mmu))
 		errcode |= PFERR_FETCH_MASK;
 


