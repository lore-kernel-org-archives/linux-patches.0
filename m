Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981844EB872;
	Tue, 13 Oct 2026 12:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895715; cv=none; b=d+Id1CXveDaEcnT0JVaJSb1sTeqyeX4dv5/BKeVozkzgJffBD0ju8WIwWCeiNTx/X8Ecw/PIh65T88KOsi1FfnbGmsBK5duFiqUXIHztZHvE/h/XvuH8jfYQGMPWdoZ17b1cNa4qhouTByveCDmMX4A0mlcxEQfEFn9wZ+Tfzos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895715; c=relaxed/simple;
	bh=xSaxROWpPQGnHgNv8B7BWzfkBpR4/wY0Z0TJ2H1V9Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaxtm/IY7xuzhGheTMltS88qIIRyAyCU/FdbSu3V0lL/aHky6buVOjfB4gG5zdJepImtwjO6DdOrWF2HAGajRuy2L0zEOOtnSaC3JcM0Mjk0rdIQGCIl6TC0fRtZVUjzP048yhfBIcCg5fBvYvhzveE9Dpvxsq6v10NWiqlGOgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFV49T2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFV49T2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A191F000FF;
	Tue, 13 Oct 2026 12:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895714;
	bh=jiHjQt5f8Bye4aaQr1g5bSBzq//El/MvdICQhdoAvPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFV49T2k+nZ8zB5xFMxmc23hso0Szp1mkYMIXGo/N6r1lXNlnBNRjh+iiWXz1uDCE
	 0nqUJSMDhNhKKnnFRakWRGt+xBGOzCq39uc488Y3Z7iQ6VF1PeyBc9/1pC+hg0ko1E
	 6uI9Wbv2RRNsrQSMCSREqAYQ2h72Iyyg/wOIyiBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/497] KVM: SVM: Use the active VMCBs MSR bitmap when checking if MSR is intercepted
Date: Tue, 13 Oct 2026 13:38:11 +0200
Message-ID: <20261013112915.593871798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 9e06bbb9ade7cdf28d4a3b5b14e5812881c8df85 ]

Use the MSR permission bitmap of the active VMCB instead of assuming that
KVM is always using vmcb02's bitmap when L2 is active, as KVM uses msrpm02
if and only if L1 wants to intercept MSR accesses, i.e. if and only if KVM
needs to merge msprm01 with msrpm12.

Don't bother tracking the virtual address of the bitmap that's being used,
as __va() is cheap on x86, and caching the virtual address would introduce
yet another source of potentially stale information.

Fixes: b2ac58f90540 ("KVM/SVM: Allow direct access to MSR_IA32_SPEC_CTRL")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260826195833.844526-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ sashal: Adapted VMCB access to use to_svm(vcpu) with the existing struct kvm_vcpu parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c8883511d7b0..9408ab965aeaa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -812,17 +812,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	u32 offset;
 	u32 *msrpm;
 
-	/*
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 */
-	msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
-				      to_svm(vcpu)->msrpm;
+	msrpm = __va(__sme_clr(to_svm(vcpu)->vmcb->control.msrpm_base_pa));
 
 	offset    = svm_msrpm_offset(msr);
 	bit_write = 2 * (msr & 0x0f) + 1;
-- 
2.53.0



