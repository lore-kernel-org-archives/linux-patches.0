Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2B83D9DDB;
	Fri,  9 Oct 2026 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557185; cv=none; b=ofsTs6wfEB9dF9JcnEbGgG/SIS2NylfKVn0kUl7l40tOx36c3kB2XOmE8Hf+H9Grv/aeD2cv+FH0NqsrCXD79Gxb5FWlkirfRPrqMZxE5Kmiuh1lRTUgm4yccAEMq2nEvdDmFG8exIDiR0svZDr8LuedmGvh9/UsOnkPm0aGvFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557185; c=relaxed/simple;
	bh=MDw6t+3TnC95Q2rSra6higeBB5TzJSoFOQlA/eGDW1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAzkXR1nCs60rapmgWtuCy8pN0XGfBtB3qVX7uHZ4psv54rlwV1KxRr47A8EdS4KtuaQTPuJ+pmNFy01Iv4qUB8Mg8JduL8KTdAm8FaJMxp99Rt+9nEUvlMZ7+Vr5wmJMXSkj0VzO9ucm3ivG2wfH1qGJthS9gJ7yDERXwmO4F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RW9K7q8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RW9K7q8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A6D1F000FF;
	Fri,  9 Oct 2026 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557184;
	bh=Y17L0/cb8Oe9FvtbKwPCMQQb0xaAvREPArq8LAv5nEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RW9K7q8rh7E88f3VxkngOi4Y90mBkM9jLx02y8LHCulPng721PFY/2E2G/tK7+YPQ
	 2fsby4mPqhjcgiQ8yWpzj65s0zgIcTHVa4izTKc7/I3MY1ptyEfskuAbRRKFLxJuWc
	 QLzueRsV2lQoaGf4ww39V5qmjG7iLZhS8ho5UXVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 315/428] KVM: SVM: Use the active VMCBs MSR bitmap when checking if MSR is intercepted
Date: Fri,  9 Oct 2026 16:10:52 +0200
Message-ID: <20261009140953.043954577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 9e06bbb9ade7cdf28d4a3b5b14e5812881c8df85 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -673,16 +673,7 @@ static void clr_dr_intercepts(struct vcp
 
 static bool msr_write_intercepted(struct vcpu_svm *svm, u32 msr)
 {
-	/*
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 */
-	void *msrpm = is_guest_mode(&svm->vcpu) ? svm->nested.msrpm : svm->msrpm;
+	void *msrpm = __va(__sme_clr(svm->vmcb->control.msrpm_base_pa));
 
 	return svm_test_msr_bitmap_write(msrpm, msr);
 }


