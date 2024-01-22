Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5363D74E09;
	Tue, 23 Jan 2024 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975465; cv=none; b=MXAdjdsNkxzuZotlEu1fxwvefg6xYP4SjjDpXV1jMZB5Iaiv4vqX3rCG1o0p+TuZZHlBjKdJWfJA5uVUkYOiVw3m63eWXdVxjFg/0d8ZE/opPTSvHdtHeBbk73Z8x/CQHl7UsWsLbh+/DmGprg8VpulFhyk+uitGRexEtYxHo+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975465; c=relaxed/simple;
	bh=0LuLjJindWeZlQoXofjB0fd/sgt2w7guMXvaI8Prigs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgAyJ5Mpw1Ep0Nex+VbqWtWaUm/mWa0ge5aLzrTbHryaMPq6tDBi88sD9zI5tcDwqH1ACOXLFHH5qA3kfA2xO+lbsbENXa6PUpXXyEJRUnUbIcaHoW0noIGOcA7E14LAGHuWau5y14VrERKNOQD/8ztgQ+il8fnnGQY47mBcJgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kr7Dl4qX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kr7Dl4qX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BC7C433C7;
	Tue, 23 Jan 2024 02:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975465;
	bh=0LuLjJindWeZlQoXofjB0fd/sgt2w7guMXvaI8Prigs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kr7Dl4qX/fsFS2+B0cV7ayeDJ1kvK+48eWNjQ3ODBXHzD07KhFoYq+D+e/H6VXNPF
	 qsnwxWdbjLwy5yKmpBwsnSnnC9UXGlMCdR3OCmm+afekHJSaKgUNbjfMayp59RjUMk
	 dw4foGwTwFJPqAHR4EEn36FEYBKar/xCUgxxPHS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Sterz <s.sterz@proxmox.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 421/583] Revert "nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"
Date: Mon, 22 Jan 2024 15:57:52 -0800
Message-ID: <20240122235824.852538722@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit a484755ab2526ebdbe042397cdd6e427eb4b1a68 upstream.

Revert KVM's made-up consistency check on SVM's TLB control.  The APM says
that unsupported encodings are reserved, but the APM doesn't state that
VMRUN checks for a supported encoding.  Unless something is called out
in "Canonicalization and Consistency Checks" or listed as MBZ (Must Be
Zero), AMD behavior is typically to let software shoot itself in the foot.

This reverts commit 174a921b6975ef959dd82ee9e8844067a62e3ec1.

Fixes: 174a921b6975 ("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB")
Reported-by: Stefan Sterz <s.sterz@proxmox.com>
Closes: https://lkml.kernel.org/r/b9915c9c-4cf6-051a-2d91-44cc6380f455%40proxmox.com
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20231018194104.1896415-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -247,18 +247,6 @@ static bool nested_svm_check_bitmap_pa(s
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
-static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu, u8 tlb_ctl)
-{
-	/* Nested FLUSHBYASID is not supported yet.  */
-	switch(tlb_ctl) {
-		case TLB_CONTROL_DO_NOTHING:
-		case TLB_CONTROL_FLUSH_ALL_ASID:
-			return true;
-		default:
-			return false;
-	}
-}
-
 static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 					 struct vmcb_ctrl_area_cached *control)
 {
@@ -278,9 +266,6 @@ static bool __nested_vmcb_check_controls
 					   IOPM_SIZE)))
 		return false;
 
-	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
-		return false;
-
 	if (CC((control->int_ctl & V_NMI_ENABLE_MASK) &&
 	       !vmcb12_is_intercept(control, INTERCEPT_NMI))) {
 		return false;


