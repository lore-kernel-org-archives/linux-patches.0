Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B0C20316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWPKrqyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D882AC433C8;
	Mon,  6 Nov 2023 13:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276509;
	bh=pxT2UfW5zkgutyXYZ/THOyqobAfyZEMjZZJVmDOOAKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWPKrqyIO5+/E8+qdd3gOvpsvShWt1utYjTEWKRJUQiu2zdp7IYcmr4LXiZ2dV6Iz
	 JgO1xjnWDnCTKfZ80LZF6ZqPnSZ3opSHWanwHEjIAMRbQ0brjmGUCCquvrmB5GBfKi
	 Q1E3Z7DA35m3u/Z3aepqlee3UZRLvcHQrWHF/N8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 6.1 42/62] x86: KVM: SVM: always update the x2avic msr interception
Date: Mon,  6 Nov 2023 14:03:48 +0100
Message-ID: <20231106130303.319739065@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <mlevitsk@redhat.com>

commit b65235f6e102354ccafda601eaa1c5bef5284d21 upstream.

The following problem exists since x2avic was enabled in the KVM:

svm_set_x2apic_msr_interception is called to enable the interception of
the x2apic msrs.

In particular it is called at the moment the guest resets its apic.

Assuming that the guest's apic was in x2apic mode, the reset will bring
it back to the xapic mode.

The svm_set_x2apic_msr_interception however has an erroneous check for
'!apic_x2apic_mode()' which prevents it from doing anything in this case.

As a result of this, all x2apic msrs are left unintercepted, and that
exposes the bare metal x2apic (if enabled) to the guest.
Oops.

Remove the erroneous '!apic_x2apic_mode()' check to fix that.

This fixes CVE-2023-5090

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230928173354.217464-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -822,8 +822,7 @@ void svm_set_x2apic_msr_interception(str
 	if (intercept == svm->x2avic_msrs_intercepted)
 		return;
 
-	if (avic_mode != AVIC_MODE_X2 ||
-	    !apic_x2apic_mode(svm->vcpu.arch.apic))
+	if (avic_mode != AVIC_MODE_X2)
 		return;
 
 	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {


