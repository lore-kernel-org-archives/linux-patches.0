Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C211FB3EC;
	Wed,  6 Nov 2024 12:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896714; cv=none; b=odQY/Y0WL17sQgFMW0YTozEBPwSSQCSQ9npqz4t9jqcFiy6oIipZmJ4OtwPfUcN4pkjkT3PAHAoJL7swCuxg3fnZR85E3Hdqj8ijmKvaqwk7ujEZx9Ei8q5KsKSaoFMC8qe1cjY7m47bKPWZcMwqTRCjuejt+yiNjZX2R4fT9sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896714; c=relaxed/simple;
	bh=Eh1ygb2QOP89KLcmWAG6G2WLDfNkHCU3A45e4SK2Cpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6OHChZbcOANPaN9na65dy9FzLMsa/g49u+pvZpoQe5MHO4kBQMbDTqDVdeKq3mLeIEmzod+q3h5zyhUyxj0Csm/403eYjL0/NoebnqQsKSf/aoY9lsXV5h5u4MKaN83MGGW+JvsgKvS8VB5aYgj2eNNjPsfILfS0ExQ8+ZHSWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=np+dvDTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="np+dvDTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18F0C4CED3;
	Wed,  6 Nov 2024 12:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896714;
	bh=Eh1ygb2QOP89KLcmWAG6G2WLDfNkHCU3A45e4SK2Cpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=np+dvDTocJCeF2htSOtBWOGAsmO2gqtM6n6Ybc1Inl56nOtYdNtQGBjErcedrj74F
	 h/AeYuopVjE6aQWTZwCFaRbicg3rZQW7krfQK8zal0OKgPj1OnVGKhKxl8JC3fhLHl
	 Mns2ZtQCnrXNqEYucl/RzeRihoI3pk/CSWQce53w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kirk Swidowski <swidowski@google.com>,
	Andy Nguyen <theflow@google.com>,
	3pvd <3pvd@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 048/110] KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory
Date: Wed,  6 Nov 2024 13:04:14 +0100
Message-ID: <20241106120304.529873068@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit f559b2e9c5c5308850544ab59396b7d53cfc67bd upstream.

Ignore nCR3[4:0] when loading PDPTEs from memory for nested SVM, as bits
4:0 of CR3 are ignored when PAE paging is used, and thus VMRUN doesn't
enforce 32-byte alignment of nCR3.

In the absolute worst case scenario, failure to ignore bits 4:0 can result
in an out-of-bounds read, e.g. if the target page is at the end of a
memslot, and the VMM isn't using guard pages.

Per the APM:

  The CR3 register points to the base address of the page-directory-pointer
  table. The page-directory-pointer table is aligned on a 32-byte boundary,
  with the low 5 address bits 4:0 assumed to be 0.

And the SDM's much more explicit:

  4:0    Ignored

Note, KVM gets this right when loading PDPTRs, it's only the nSVM flow
that is broken.

Fixes: e4e517b4be01 ("KVM: MMU: Do not unconditionally read PDPTE from guest memory")
Reported-by: Kirk Swidowski <swidowski@google.com>
Cc: Andy Nguyen <theflow@google.com>
Cc: 3pvd <3pvd@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20241009140838.1036226-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -75,8 +75,12 @@ static u64 nested_svm_get_tdp_pdptr(stru
 	u64 pdpte;
 	int ret;
 
+	/*
+	 * Note, nCR3 is "assumed" to be 32-byte aligned, i.e. the CPU ignores
+	 * nCR3[4:0] when loading PDPTEs from memory.
+	 */
 	ret = kvm_vcpu_read_guest_page(vcpu, gpa_to_gfn(cr3), &pdpte,
-				       offset_in_page(cr3) + index * 8, 8);
+				       (cr3 & GENMASK(11, 5)) + index * 8, 8);
 	if (ret)
 		return 0;
 	return pdpte;


