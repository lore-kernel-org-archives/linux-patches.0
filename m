Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06D735505C;
	Tue,  6 Jan 2026 17:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720390; cv=none; b=Y9MxNtEN6LqLhpapuI/zS5d+dlmnaWGLE5mbV//9SLWNxLvqNrXJG2/vsXIXH9fdJqLVBKnnAqokXez5k0OGV4m4ddUPkis9jWwrJ4p8vtfJ537X48S09XWy/rhkr87byC8sBJqbmOxKTMU2imDUCnffmHzUUNY8TdnC7v35W94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720390; c=relaxed/simple;
	bh=UGXdbx0VjL60votqyy6lEhkC1uHQ2zpK4n3G7tt0yXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ozZddfGd9uN71RyULTnDH13f7AYLdOqZqSl59HNqr7Zh/gVZN4sO3cPT4Ep3rJcLis6yjrO8W2voZfWeOkinNnZdX3OR0mgYEb4lYEZ7z2CS2m7dfRRIHiJ3WORACIx5skJwZ3gDOACZ+cQEA+vQI80hZGjyZNO7APFxDonSUs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v88OjVao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v88OjVao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C591C116C6;
	Tue,  6 Jan 2026 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720390;
	bh=UGXdbx0VjL60votqyy6lEhkC1uHQ2zpK4n3G7tt0yXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v88OjVaod2UrgOw6TAG8QY+cztypmI8bC1LfkDwHq2ws5pHG0vSxE7fCWFDpFbRHp
	 dm2HmyLmTw0ff8nHy1bL4n2saJbk0SGpaudL0XUVEpyVzNK1Pauq51wev2tggJH7An
	 MGiu+vQwKvy7cJY1De8WzzpwpjX+FMxU/JW88jxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 223/567] KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE
Date: Tue,  6 Jan 2026 18:00:05 +0100
Message-ID: <20260106170459.564306349@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4650,15 +4650,29 @@ static int svm_check_intercept(struct kv
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


