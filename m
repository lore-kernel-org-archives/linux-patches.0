Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDEC23ED5B;
	Fri,  9 Jan 2026 12:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960711; cv=none; b=BWwigR0WFtG4bzBA6K3kHZcc/N/NBsAeWsAkHmul0Z9hBjcTH5ZtOAgz6OrYIKb+S7Noa63AcnX15/xNQW355FCyCzsu4W3/kRtRXhIKmhXTmGjiKYrFed6lgMMLzpjEWIgVqTDgtxWhWSIrDsmIIdZwZIxA/vhsOtE8vRLia2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960711; c=relaxed/simple;
	bh=xG2aK7NRNsMK5xPZ/IZAYe33mlAR7xY/u+hGhGV3eFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=txPFu3lqCgFjJVXpz2lxWUzkGLSsQ/HdAh+DnkdLhrODKhmaEVarRSX1pV+JeEZZWAW1vQljjPM/RwiReXP9TxK5amEG/Ds1ZzvTgqJdDP5U0qdLhEylgQP1+INqOAMm0gd5ynIDKZyndXcjhdCvMIYf36Rt5nijY8re8ciGhE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3RxoiHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3RxoiHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E8BC4CEF1;
	Fri,  9 Jan 2026 12:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960711;
	bh=xG2aK7NRNsMK5xPZ/IZAYe33mlAR7xY/u+hGhGV3eFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3RxoiHLsxyS7Ob7Q5GcsgS+lO3VB+6tFHuOr7nnKTBLVKcz/iemkWkJRa9PwrAB+
	 b2OC+ROearI2vMsRX8Eqxmq8OXCXCa7Ky0F1zQeUNEGZW0Iq3xbzTUtwHw368z+Orr
	 RSf+cEbZF7PzwoTBjbHu8KQwwooyyXgt2VtkByx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 465/737] KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE
Date: Fri,  9 Jan 2026 12:40:04 +0100
Message-ID: <20260109112151.481272890@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4548,15 +4548,29 @@ static int svm_check_intercept(struct kv
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


