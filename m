Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56FF3314C4;
	Mon, 29 Dec 2025 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025914; cv=none; b=NCqKc82a3t0KT7bmPhveJFNsMrEk/85ipCutU00Ej2QtLCLlJFqkc7yD1yLgGgjgdbG2FpSpQtTF1CqqFSdykRahNBqSmI/b/y1bvTxA8L5LQVhaC/7VIXRSL2OxP6rH/nWrVBCuzm2qIfdhOHad0Q0xxkGeFvEMitdzcx5fvNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025914; c=relaxed/simple;
	bh=cZjqvaVctoT41lNYXFA8y8e/oOb4mb8Gl7OcXUaHuvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CnvP4tCob8eVTlxs/Fi+qn0kt7ve4LtzjgjhfEDnyTZRLJwUSkhwvP3nGmA6ehAcbvMZKZ+8svBnNC9IcQzF1qYVRrwn/DtdbHclSUEseontT+XX/dTQCuXYuwsxA62cwPBK/zTZjkBqHdD+17ddIAaSfK2OGnEkGmof6tPA0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHh4DxEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHh4DxEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373F8C4CEF7;
	Mon, 29 Dec 2025 16:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025913;
	bh=cZjqvaVctoT41lNYXFA8y8e/oOb4mb8Gl7OcXUaHuvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHh4DxExj4Z0pXLGznTBrafIx8Qjhetxz8KxPmTaVSqhKJxg7RVKVNqyDpnN9i2J4
	 N2q6gLyxDawpJoNsLRL0+GDMNw4K/OQ9FxaYFL8xZffgTgKjuw7J+/pExzD+papkjZ
	 KhhK0y2QyPuLl9nzhH8A3SsucX+UL1OtrFP/9bCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 350/430] KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)
Date: Mon, 29 Dec 2025 17:12:32 +0100
Message-ID: <20251229160737.206186972@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -985,7 +985,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 	if (!nested_vmcb_check_save(vcpu) ||
 	    !nested_vmcb_check_controls(vcpu)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
-		vmcb12->control.exit_code_hi = 0;
+		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
 		goto out;
@@ -1018,7 +1018,7 @@ out_exit_err:
 	svm->soft_int_injected = false;
 
 	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-	svm->vmcb->control.exit_code_hi = 0;
+	svm->vmcb->control.exit_code_hi = -1u;
 	svm->vmcb->control.exit_info_1  = 0;
 	svm->vmcb->control.exit_info_2  = 0;
 


