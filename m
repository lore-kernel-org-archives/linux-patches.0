Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848E733C53A;
	Fri,  9 Jan 2026 12:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962442; cv=none; b=bFo2xcoLI101PYOxNTOwW4x2JzoTn0d9BxDkVcefnW/KB/c9wDaCNqmUkseMjOHhLWw2M6w8zaykILMOOv9ZdLWKa7o0LtNeghR/CLdZsIxxfRiXi3mnpnfvDeR7lWBE3mqCW4yk90lVzCx4dcPB9jc/F9JuYCWIwIBwxdRdGY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962442; c=relaxed/simple;
	bh=EM3bU+LwpaloGnCotfU0Na+HjPGrrFTt730LdaYnjqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dyhtwx9BbZgFaHxZDH+P2vsnZ9d0C2zD7F2l2OhSuNxAlEjoCpz8Yap0FFKSNT91oBHJRqzLNT6CkNDDTMMh/wGVb/bHGh85ht6oCGs5NBiIpxtjngqHoYZZ1CqDS/SOYu5G9zaRkyeYx2u6J+kbmB7HsiwgpWOGm8gLLAZALTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckx9ISEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckx9ISEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC082C4CEF1;
	Fri,  9 Jan 2026 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962442;
	bh=EM3bU+LwpaloGnCotfU0Na+HjPGrrFTt730LdaYnjqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckx9ISEvwKFdGnkXdjlgMMnkW1UfwRupHqXGkPHmB9R6iUysmEBoDUj9l0HObL0L4
	 0fUNV6gSSsVAmYlSmP6dMLd9zUGutlmvFJbTMPSY5ln2qVio1sgqb+N2L9ChAIf25h
	 kJXUkbmOJY7i9cP1+kAyqCHQNhlz2W1Hsbyxs9S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 366/634] KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)
Date: Fri,  9 Jan 2026 12:40:44 +0100
Message-ID: <20260109112131.295626305@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit f402ecd7a8b6446547076f4bd24bd5d4dcc94481 upstream.

Set exit_code_hi to -1u as a temporary band-aid to fix a long-standing
(effectively since KVM's inception) bug where KVM treats the exit code as
a 32-bit value, when in reality it's a 64-bit value.  Per the APM, offset
0x70 is a single 64-bit value:

  070h 63:0 EXITCODE

And a sane reading of the error values defined in "Table C-1. SVM Intercept
Codes" is that negative values use the full 64 bits:

  –1 VMEXIT_INVALID Invalid guest state in VMCB.
  –2 VMEXIT_BUSYBUSY bit was set in the VMSA
  –3 VMEXIT_IDLE_REQUIREDThe sibling thread is not in an idle state
  -4 VMEXIT_INVALID_PMC Invalid PMC state

And that interpretation is confirmed by testing on Milan and Turin (by
setting bits in CR0[63:32] to generate VMEXIT_INVALID on VMRUN).

Furthermore, Xen has treated exitcode as a 64-bit value since HVM support
was adding in 2006 (see Xen commit d1bd157fbc ("Big merge the HVM
full-virtualisation abstractions.")).

Cc: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: stable@vger.kernel.org
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251113225621.1688428-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -834,7 +834,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 	if (!nested_vmcb_check_save(vcpu) ||
 	    !nested_vmcb_check_controls(vcpu)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
-		vmcb12->control.exit_code_hi = 0;
+		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
 		goto out;
@@ -867,7 +867,7 @@ out_exit_err:
 	svm->soft_int_injected = false;
 
 	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-	svm->vmcb->control.exit_code_hi = 0;
+	svm->vmcb->control.exit_code_hi = -1u;
 	svm->vmcb->control.exit_info_1  = 0;
 	svm->vmcb->control.exit_info_2  = 0;
 


