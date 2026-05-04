Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1445347BA9;
	Mon,  4 May 2026 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903400; cv=none; b=ULEcuGoQ6UWTvL9qQa+P82Ap61WVauGywKVa0QzkuITHNgxS/CNXwgLjLxGOhRKBNcEFKFwpqIXgIDweW756UnIRtRKUIGFG+4soJusgk8580NTpYr/KDgux6iab9LZ+34NfumVVHt/hGNbNzve1DlDR5tdiprRg0rk1KjxFffQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903400; c=relaxed/simple;
	bh=Ao7FzFJuAoS3UGG3MjivonX7hPzKFCgb0oeUebOeUKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKc3KiashW5d5mZtwKaf2FrWIsv/jvoFmT4AN7DdcIVM32+e4Zb+J/JmL8Y0MGwCxRmA0ZQ+H7qNcCFG+/vKOVMHlMKz0gvLJa3zzGW+I+ogA9IBwnj/0pQ+bgdlxuxI82BW+5xW8tDZ7/i+6K44cc4fXdH0vgkh5kIu33qSWVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZShG35bH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZShG35bH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57636C2BCB8;
	Mon,  4 May 2026 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903400;
	bh=Ao7FzFJuAoS3UGG3MjivonX7hPzKFCgb0oeUebOeUKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZShG35bHdroeaVP3gXx00izBgNPSD3UWX1ZY14RgOJCK9UJxvbcwQenhPFUwR1Nko
	 RQW9YB21P3+lkQRPLeSuoLBJDxN67EysKukpORKyIh8lLfigUbnUxWZN+BuX88W1dc
	 G+Ekyi0ZEWn9JPbH0FJydm52noNj5flwmwEPMWyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 220/307] KVM: nSVM: Triple fault if mapping VMCB12 fails on nested #VMEXIT
Date: Mon,  4 May 2026 15:51:45 +0200
Message-ID: <20260504135151.141183506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 1b30e7551767cb95b3e49bb169c72bbd76b56e05 upstream.

KVM currently injects a #GP and hopes for the best if mapping VMCB12
fails on nested #VMEXIT, and only if the failure mode is -EINVAL.
Mapping the VMCB12 could also fail if creating host mappings fails.

After the #GP is injected, nested_svm_vmexit() bails early, without
cleaning up (e.g. KVM_REQ_GET_NESTED_STATE_PAGES is set, is_guest_mode()
is true, etc).

Instead of optionally injecting a #GP, triple fault the guest if mapping
VMCB12 fails since KVM cannot make a sane recovery. The APM states that
a #VMEXIT will triple fault if host state is illegal or an exception
occurs while loading host state, so the behavior is not entirely made
up.

Do not return early from nested_svm_vmexit(), continue cleaning up the
vCPU state (e.g. switch back to vmcb01), to handle the failure as
gracefully as possible.

Fixes: cf74a78b229d ("KVM: SVM: Add VMEXIT handler and intercepts")
CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-9-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1208,12 +1208,8 @@ void nested_svm_vmexit(struct vcpu_svm *
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 
-	rc = nested_svm_vmexit_update_vmcb12(vcpu);
-	if (rc) {
-		if (rc == -EINVAL)
-			kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
+	if (nested_svm_vmexit_update_vmcb12(vcpu))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 
 	/* Exit Guest-Mode */
 	leave_guest_mode(vcpu);


