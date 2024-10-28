Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B164718A92C;
	Mon, 28 Oct 2024 06:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098502; cv=none; b=WknUz54ovh5HxUEnNinjXh+lAb5P/CFgZaIHReSCjQOW5MzKY0i3npF7GIk9cAzgw1ORMu+8eBxUQaov0xY31q0/AZW0gaKZyNS2r2Zd9fx972NcrrsFqGhEwYo4V2YAfZCDdvwukNQ1tYK3C4S8lP5zi2rLOWmEZJdVQYU2XEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098502; c=relaxed/simple;
	bh=R9NNrVNQUN4352aDOzl2wqzV07+eSXowpWuUuxICJX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuBqo2dBwgaT+7OJ/7kd/UE7q6ztgFSlAeTbG31N2F7gLaFmqFk8rewGwNYqJfoI5WhW+ZX4kUdGtRarx0s5kVbwNJ13wQ5AtAFQ/eislztejyamYl7lsNgXD5YQkkCphy1LyZmtQF0lKTuaPHap9beem5rwceck9qrgoVRsgZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OErq11q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OErq11q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BC3C4CEC3;
	Mon, 28 Oct 2024 06:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098502;
	bh=R9NNrVNQUN4352aDOzl2wqzV07+eSXowpWuUuxICJX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OErq11q1kTUAtE+0wA0OtiDdj5nBFS6Qv9ztyJc/xsdhohxBCZs6Axt7Py7Vy4trd
	 2GqXQAubsCNRmYDhOKWfycXsB4Rvbq12Z9Wgtzgja2sREd5frGvo1c/599lgrPi7Ym
	 dfQ/34z5g2IIXEuBZ7P+xesrMzoJLdMvR4upFIJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kirk Swidowski <swidowski@google.com>,
	Andy Nguyen <theflow@google.com>,
	3pvd <3pvd@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.11 218/261] KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory
Date: Mon, 28 Oct 2024 07:26:00 +0100
Message-ID: <20241028062317.567686507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


