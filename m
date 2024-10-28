Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706851DFFD;
	Mon, 28 Oct 2024 06:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097938; cv=none; b=OpgBDhyuQYEfKjaNvYzxylNDcmDT4ALBfXXP9p+w3LJHTwmhoK/OuC1rvobmMGbSV0SMORyAa+nCSvnFQ4hSWSxLD5S5oNhbLZ6YcEv1hQKmJS4akFyzVUvrkoJzuZXWG8f6r5+1AXDmaAK7PybjMFKCcrgT5Brmm+t3OotLhLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097938; c=relaxed/simple;
	bh=wMu9xjZi9c+J4cYi5RomqO+OfTe1y7C3HM1rLdJf1B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h807ahA4hUybmXliOY138Rqgjnrvq4TUsyEoO9odKoPu3w/65u1MbitVNfPPxUdQE5zHXGo/fK3Iw9J1Q+R6/po9M0Q7ST7KNQBDqWIfvH7rhxR2dUx75SURzhMs0h1DNimq+uLsN7Vy8Wc4dFjBCVaVdjBTN5Vm817VWzbcGlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Unb1gJ0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Unb1gJ0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13147C4CEC3;
	Mon, 28 Oct 2024 06:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097938;
	bh=wMu9xjZi9c+J4cYi5RomqO+OfTe1y7C3HM1rLdJf1B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Unb1gJ0U/uJlhzgJkewbJuR+KLOWCCRQLhNuv71A8vA4D2qf4DOHiuzJp3NFitdK5
	 D4EhFRu/LpicAAIX7EtX1bxN1CtSrIbNNwry7mnnYZqgOT5aF6LGlyuVCaprL2vSxd
	 KsPlD8mH+dJjyGsJhs3zRFaauXwjdZVmg3WhsT5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kirk Swidowski <swidowski@google.com>,
	Andy Nguyen <theflow@google.com>,
	3pvd <3pvd@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 185/208] KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory
Date: Mon, 28 Oct 2024 07:26:05 +0100
Message-ID: <20241028062311.185022430@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -63,8 +63,12 @@ static u64 nested_svm_get_tdp_pdptr(stru
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


