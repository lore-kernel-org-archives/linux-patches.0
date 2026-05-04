Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3DC3E0C76;
	Mon,  4 May 2026 14:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904662; cv=none; b=BDKViTBPAjAk8e67ryr/GkC1AQKowApriAC7QPPTXK0Mv3OZrt8GJlrPUjHdJy3Wvd9ym97R5nHCBNQAMC38jGed+BxnjA/tctySoY2KU/TYPN9E2WpqdIAy26Ni4pa9Vn4fOzgBNe7LVqX0iVm1BfsVAZgwsnKtr+LVciwQY6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904662; c=relaxed/simple;
	bh=jqtYbaUF3P7APqsMsPDtW/P4JfR3t9G9WDN7kkma1zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCvxi1jPaTlcfV/1aSsTfJBHcvI0EsTF7dQ0lIJSRqgV2v/Blyj9aMZHR1wbGvwenFV4S0ZgoXmeBwNjOyrVyDK1bCKUR8Q4P0Cy4TKW1eFPzpZZ8RuhNibiXOekepO2XNajb4xATrx1WKMnEpgm4IHoUmb67xhDgmTF8AtsGNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krOrDzrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krOrDzrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2C4C2BCF6;
	Mon,  4 May 2026 14:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904661;
	bh=jqtYbaUF3P7APqsMsPDtW/P4JfR3t9G9WDN7kkma1zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krOrDzrkEe9ihcrORZwXxGs7pb8kK4uHpT5dJjOinRas5sR0fVSOqrbQo1+oSU8oU
	 cyBDHBztCq1wHQjbTB7DOmDHlw2forykKaZOxHMIlFBED/911aOa3iLK0i1ghfc/E3
	 BOz0prx6IqSOtbVE2LS6WOYXTA/+miTzbcX1/E2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 125/215] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on nested #VMEXIT
Date: Mon,  4 May 2026 15:52:24 +0200
Message-ID: <20260504135134.716740059@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit 5c247d08bc81bbad4c662dcf5654137a2f8483ec upstream.

KVM currently uses the value of CR2 from vmcb02 to update vmcb12 on
nested #VMEXIT. This value is incorrect in some cases, causing L1 to run
L2 with a corrupted CR2. This could lead to segfaults or data corruption
if L2 is in the middle of handling a #PF and reads a corrupted CR2. Use
the correct value in vcpu->arch.cr2 instead.

The value in vcpu->arch.cr2 is sync'd to vmcb02 shortly before a VMRUN
of L2, and sync'd back to vcpu->arch.cr2 shortly after. The value are
only out-of-sync in two cases: after save+restore, and after a #PF is
injected into L2. In either case, if a #VMEXIT to L1 is synthesized
before L2 runs, using the value in vmcb02 would be incorrect.

After save+restore, the value of CR2 is restored by KVM_SET_SREGS into
vcpu->arch.cr2. It is not reflect in vmcb02 until a VMRUN of L2. Before
that, it holds whatever was in vmcb02 before restore, which would be
zero on a new vCPU that never ran nested. If a #VMEXIT to L1 is
synthesized before L2 ever runs, using vcpu->arch.cr2 to update vmcb12
is the right thing to do.

The #PF injection case is more nuanced.  Although the APM is a bit
unclear about when CR2 is written during a #PF, the SDM is more clear:

	Processors update CR2 whenever a page fault is detected. If a
	second page fault occurs while an earlier page fault is being
	delivered, the faulting linear address of the second fault will
	overwrite the contents of CR2 (replacing the previous address).
	These updates to CR2 occur even if the page fault results in a
	double fault or occurs during the delivery of a double fault.

KVM injecting the exception surely counts as the #PF being "detected".
More importantly, when an exception is injected into L2 at the time of a
synthesized #VMEXIT, KVM updates exit_int_info in vmcb12 accordingly,
such that an L1 hypervisor can re-inject the exception. If CR2 is not
written at that point, the L1 hypervisor have no way of correctly
re-injecting the #PF. Hence, if a #VMEXIT to L1 is synthesized after
the #PF is injected into L2 but before it actually runs, using
vcpu->arch.cr2 to update vmcb12 is also the right thing to do.

Note that KVM does _not_ update vcpu->arch.cr2 when a #PF is pending for
L2, only when it is injected. The distinction is important, because only
injected (but not intercepted) exceptions are propagated to L1 through
exit_int_info. It would be incorrect to update CR2 in vmcb12 for a
pending #PF, as L1 would perceive an updated CR2 value with no #PF.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260203201010.1871056-1-yosry.ahmed@linux.dev
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1007,7 +1007,7 @@ int nested_svm_vmexit(struct vcpu_svm *s
 	vmcb12->save.efer   = svm->vcpu.arch.efer;
 	vmcb12->save.cr0    = kvm_read_cr0(vcpu);
 	vmcb12->save.cr3    = kvm_read_cr3(vcpu);
-	vmcb12->save.cr2    = vmcb02->save.cr2;
+	vmcb12->save.cr2    = vcpu->arch.cr2;
 	vmcb12->save.cr4    = svm->vcpu.arch.cr4;
 	vmcb12->save.rflags = kvm_get_rflags(vcpu);
 	vmcb12->save.rip    = kvm_rip_read(vcpu);


