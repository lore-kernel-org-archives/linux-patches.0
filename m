Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C8817CA12;
	Mon, 10 Mar 2025 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627046; cv=none; b=sttcloOTYIg3eWpd9wOj3bwNBniJgD2MpZGCowiOLnKviYpKEoc5ZPakuFWmte1qxCX198kshoxiCyq50A3WvfeRIqvgtfAbF37CMF0bIkqLhbo2oocXNophZFAnt07/2h+dAyHP9BWMMizsgtmCCnaXflC43GH23sb0av977jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627046; c=relaxed/simple;
	bh=iSKEaGdx9LV2qbAaChBdDZXqhcwp/b+fxzrHEx2UByw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/jwSGthetLJKR/BbHB78PEhhKkA9pBiOzkwQgnJqP3t1VStmOMBusMP577ReqUN1ZdqDBIZw70TFQL1S0Jshube3Dit9nH3/XXzg+q1RI8Z3pNEM2Bd1vjb43+pbyoJ1awRG6EEzxifB0CWOB9Hcrf4JNbJSRc1bHJPQfgTIbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJVDayw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJVDayw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40271C4CEE5;
	Mon, 10 Mar 2025 17:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627046;
	bh=iSKEaGdx9LV2qbAaChBdDZXqhcwp/b+fxzrHEx2UByw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJVDayw0Mw9etDgbxPu4GymNPxfbfjoed6eWsPwnsMirDUhy3LawQ3J11VeVVtCyz
	 C8sno8mxB+haW3tARbUVj9M1w8o8/i0XEiGvxrQVWQmUpazeKZzQyro23AJBhG7Eb1
	 L+sMTwXO3tEigR3QOdP7sKAEFqO0pBpHqrrrnSRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.13 175/207] KVM: SVM: Suppress DEBUGCTL.BTF on AMD
Date: Mon, 10 Mar 2025 18:06:08 +0100
Message-ID: <20250310170454.748139322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit d0eac42f5cecce009d315655bee341304fbe075e upstream.

Mark BTF as reserved in DEBUGCTL on AMD, as KVM doesn't actually support
BTF, and fully enabling BTF virtualization is non-trivial due to
interactions with the emulator, guest_debug, #DB interception, nested SVM,
etc.

Don't inject #GP if the guest attempts to set BTF, as there's no way to
communicate lack of support to the guest, and instead suppress the flag
and treat the WRMSR as (partially) unsupported.

In short, make KVM behave the same on AMD and Intel (VMX already squashes
BTF).

Note, due to other bugs in KVM's handling of DEBUGCTL, the only way BTF
has "worked" in any capacity is if the guest simultaneously enables LBRs.

Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    9 +++++++++
 arch/x86/kvm/svm/svm.h |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3181,6 +3181,15 @@ static int svm_set_msr(struct kvm_vcpu *
 		 */
 		data &= ~GENMASK(5, 2);
 
+		/*
+		 * Suppress BTF as KVM doesn't virtualize BTF, but there's no
+		 * way to communicate lack of support to the guest.
+		 */
+		if (data & DEBUGCTLMSR_BTF) {
+			kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
+			data &= ~DEBUGCTLMSR_BTF;
+		}
+
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -591,7 +591,7 @@ static inline bool is_vnmi_enabled(struc
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-#define DEBUGCTL_RESERVED_BITS (~(DEBUGCTLMSR_BTF | DEBUGCTLMSR_LBR))
+#define DEBUGCTL_RESERVED_BITS (~DEBUGCTLMSR_LBR)
 
 extern bool dump_invalid_vmcb;
 


