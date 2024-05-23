Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E531E497;
	Thu, 23 May 2024 13:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470306; cv=none; b=ZdafoHr8N7Knv/xwRxxmiiTALHXIg9+kDWnpW0yPXuTZIg+AKuNOrAnLs737Z9k7chPkYyt1FuddQj9fkUrPl29+7drYX1xlPI9+33IxqQf8FiSGiGcln9eqTisLtlTboTqYWQd646So1UbmeLHdyLiQI/08HDCSVikO3hM6GBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470306; c=relaxed/simple;
	bh=H/oTNvUOuTom9PqPFlMT+xn9MeTCP1pIQF7mJOX9WIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si7HdPf61PPZB1NoilWmfs3h9hRJ7XFsHPDpxggbBN85+kSAu5PtmRhVhk4+bzi4DW5QZ84iZg+/9WPTYnxjQApB4C9CCHOMav9Enoq6tYVwPjUFdF8mNKDlkilnwhl5sSE7CDbIVMppPlXRK+yl3maTHuKeJKRsHF9P8u3gcd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMhNmfj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMhNmfj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB60C3277B;
	Thu, 23 May 2024 13:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470305;
	bh=H/oTNvUOuTom9PqPFlMT+xn9MeTCP1pIQF7mJOX9WIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMhNmfj3ziXEcXHLJO1ewiMpTST3jCpxx0RG9lOCFbG+UiT7m5gNtqOqUmveZNZa8
	 Dto+h28tRsFi+TOkfqbErpnwGGKTi7JyqoHKHWrVMCQhp0RmfCdqTV+hsusABojr8/
	 L+Kk1+eFDPMfJtia9C6WMQ+kui63IQ47nWzL/Rec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [PATCH 5.15 15/23] KVM: x86: Clear "has_error_code", not "error_code", for RM exception injection
Date: Thu, 23 May 2024 15:13:11 +0200
Message-ID: <20240523130328.529955317@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 6c41468c7c12d74843bb414fc00307ea8a6318c3 upstream.

When injecting an exception into a vCPU in Real Mode, suppress the error
code by clearing the flag that tracks whether the error code is valid, not
by clearing the error code itself.  The "typo" was introduced by recent
fix for SVM's funky Paged Real Mode.

Opportunistically hoist the logic above the tracepoint so that the trace
is coherent with respect to what is actually injected (this was also the
behavior prior to the buggy commit).

Fixes: b97f07458373 ("KVM: x86: determine if an exception has an error code only when injecting it.")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230322143300.2209476-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[nsaenz: backport to 5.15.y]
Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9134,13 +9134,20 @@ int kvm_check_nested_events(struct kvm_v
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Suppress the error code if the vCPU is in Real Mode, as Real Mode
+	 * exceptions don't report error codes.  The presence of an error code
+	 * is carried with the exception and only stripped when the exception
+	 * is injected as intercepted #PF VM-Exits for AMD's Paged Real Mode do
+	 * report an error code despite the CPU being in Real Mode.
+	 */
+	vcpu->arch.exception.has_error_code &= is_protmode(vcpu);
+
 	trace_kvm_inj_exception(vcpu->arch.exception.nr,
 				vcpu->arch.exception.has_error_code,
 				vcpu->arch.exception.error_code,
 				vcpu->arch.exception.injected);
 
-	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
-		vcpu->arch.exception.error_code = false;
 	static_call(kvm_x86_queue_exception)(vcpu);
 }
 


