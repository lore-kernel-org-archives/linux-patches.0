Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC3C3314DE;
	Mon, 29 Dec 2025 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025806; cv=none; b=XZjGAKnalNxhcghGhBbWV/WrJZAbpO/mWWH4jvEsAM078K2ntaaF/rb1kQKuHK9btcL7Fv2MQH53SIxlgzX3lo+lWGqg2TkLLiB0mIPO92ZMWYWnMbBAhvyqtta7dg3qq4H6qOjF3hQqeFYx+HbTZBTPkHDSJX43uI5jktC3DnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025806; c=relaxed/simple;
	bh=eGYLzXwgRfjmKeGrZP4LL6d/Wgf3Owd4etLJcLWOOEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TTrb3t7eQBr/K2MpWoRBcKGKZn2GNg2691DbhIayBfdV4wqYJi9LydAj19z026i8iwgaN24BhH9GCk5ixg2kkfPq8LDa6aArx9UPRf2LfjCd1SfApx1yAIgv5y9Ow8Av+u/7jdEv/U3MR/g1Kpj/QkGVEKkPoienP4DJ6hJq9g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClgKVw0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClgKVw0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D33C4CEF7;
	Mon, 29 Dec 2025 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025805;
	bh=eGYLzXwgRfjmKeGrZP4LL6d/Wgf3Owd4etLJcLWOOEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClgKVw0PzmWao1O4Nkw30lxVCQSZmJ+6bg8OjWtt5ZQiAM7zdBCOYds/WQQ/FzI5V
	 eieZkaH6BPYzVaWBndLOLeY1BWG26+UhLGLM/Z6LkSPp0nX/McnM4wwYzPeqJ7sPZ8
	 Uz3pEo/3Z6XPqi2I7ET5QqJ4MD44ke8wMTvTkmpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 342/430] KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE
Date: Mon, 29 Dec 2025 17:12:24 +0100
Message-ID: <20251229160736.915087536@linuxfoundation.org>
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit 3d80f4c93d3d26d0f9a0dd2844961a632eeea634 upstream.

When emulating L2 instructions, svm_check_intercept() checks whether a
write to CR0 should trigger a synthesized #VMEXIT with
SVM_EXIT_CR0_SEL_WRITE. However, it does not check whether L1 enabled
the intercept for SVM_EXIT_WRITE_CR0, which has higher priority
according to the APM (24593—Rev.  3.42—March 2024, Table 15-7):

  When both selective and non-selective CR0-write intercepts are active at
  the same time, the non-selective intercept takes priority. With respect
  to exceptions, the priority of this intercept is the same as the generic
  CR0-write intercept.

Make sure L1 does NOT intercept SVM_EXIT_WRITE_CR0 before checking if
SVM_EXIT_CR0_SEL_WRITE needs to be injected.

Opportunistically tweak the "not CR0" logic to explicitly bail early so
that it's more obvious that only CR0 has a selective intercept, and that
modifying icpt_info.exit_code is functionally necessary so that the call
to nested_svm_exit_handled() checks the correct exit code.

Fixes: cfec82cb7d31 ("KVM: SVM: Add intercept check for emulated cr accesses")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251024192918.3191141-4-yosry.ahmed@linux.dev
[sean: isolate non-CR0 write logic, tweak comments accordingly]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4528,15 +4528,29 @@ static int svm_check_intercept(struct kv
 	case SVM_EXIT_WRITE_CR0: {
 		unsigned long cr0, val;
 
-		if (info->intercept == x86_intercept_cr_write)
+		/*
+		 * Adjust the exit code accordingly if a CR other than CR0 is
+		 * being written, and skip straight to the common handling as
+		 * only CR0 has an additional selective intercept.
+		 */
+		if (info->intercept == x86_intercept_cr_write && info->modrm_reg) {
 			icpt_info.exit_code += info->modrm_reg;
+			break;
+		}
 
-		if (icpt_info.exit_code != SVM_EXIT_WRITE_CR0 ||
-		    info->intercept == x86_intercept_clts)
+		/*
+		 * Convert the exit_code to SVM_EXIT_CR0_SEL_WRITE if a
+		 * selective CR0 intercept is triggered (the common logic will
+		 * treat the selective intercept as being enabled).  Note, the
+		 * unconditional intercept has higher priority, i.e. this is
+		 * only relevant if *only* the selective intercept is enabled.
+		 */
+		if (vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_CR0_WRITE) ||
+		    !(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0)))
 			break;
 
-		if (!(vmcb12_is_intercept(&svm->nested.ctl,
-					INTERCEPT_SELECTIVE_CR0)))
+		/* CLTS never triggers INTERCEPT_SELECTIVE_CR0 */
+		if (info->intercept == x86_intercept_clts)
 			break;
 
 		cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK;


