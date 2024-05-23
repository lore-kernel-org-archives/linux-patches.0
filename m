Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A899814AD24;
	Thu, 23 May 2024 13:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470205; cv=none; b=KYSR+BUKa7mP06OjOP+nIXRAClyB9zWJ5UuKmnAu8FA8S0doeEhQH1sVWs0gNkvpdaV/sLWkfwDPwY3m+/ZzDZ/mXgHYXC+tL6lm/35S86rsAnEUD5qOfV7F0kudNlHDZJrlKiCERSRKsHHlzBWDe26Nh6+gun6wsvq/h3gPZt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470205; c=relaxed/simple;
	bh=gjNLKs2i/J087k6JIbelAOmFEYskeQecvnB1RDvTIdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDi7UzJ5VOZgMGAEbc9ehdy3biAfvBuFzT+9dDwcgUzwx6HoLRm753egNu6RUqEr42OtipPXilfNJqofBYYUJ4wGOTNfs78kCfx8Lp+aPS9bI4R4mDWwHM2HVDEjOr+yx+yc9QkyPug8vTzghPWgG5oSciE17LYP86fqUUuhecE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJ/ohsSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJ/ohsSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30049C2BD10;
	Thu, 23 May 2024 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470205;
	bh=gjNLKs2i/J087k6JIbelAOmFEYskeQecvnB1RDvTIdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJ/ohsSGtRRhZYjhypXFZVUczVhOxF3Ks7Jw39NXXPUf0zzsxkBGCnDRli/msVpV7
	 NApkJK5q/8j6E8PzEbo2BqEuxSNpY0RJwVn8XzOcJtjGnt+txrTSjx/IZmh+FwSe6p
	 y1hvqjhOT5093bsB81pGWVTupGREJ6ovCczrQs1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [PATCH 5.10 08/15] KVM: x86: Clear "has_error_code", not "error_code", for RM exception injection
Date: Thu, 23 May 2024 15:12:50 +0200
Message-ID: <20240523130326.770547257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
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
[nsaenz: backport to 5.10.y]
Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8501,13 +8501,20 @@ static void update_cr8_intercept(struct
 
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
 	kvm_x86_ops.queue_exception(vcpu);
 }
 


