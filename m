Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBB4157054;
	Mon, 29 Jan 2024 17:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548186; cv=none; b=lmTLQsJUcihe2SbAoc1a06eN9GXdjSfbBKDudV5D8Zt+XJr42zcpOkUrpJCPLQjsHwIy9MAA6mxJBrUyoiv24rhJPjQv+YeQJylO5ckilYdGTuZYOisumJSEAjSdwtJL2dGUAToYib7H9kI+/Ky/WjG59xRDTrKdtrUTP3bozvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548186; c=relaxed/simple;
	bh=+4sy0+1+Sd6OkJJ1LTjwxAFbbHHykwc5yzw3KUNoFDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9oXUhS7Xj/XjkD2OAGsqvtQj2ArLKu9nc5ZEzJzlqHyiCUHcWf4OLyDdbAIJe1iE4EuOR5LVbij/ao9njLIuuUvxgk5n8efx4vcXNQbWBW6YIkyndaJxPnxwVWFuyQ3BQ8+BNkDRSHrwDCQj2WQK2EONIMjz8ZB0WbdaI4ML8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lW+QbCFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lW+QbCFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE85C43390;
	Mon, 29 Jan 2024 17:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548186;
	bh=+4sy0+1+Sd6OkJJ1LTjwxAFbbHHykwc5yzw3KUNoFDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lW+QbCFxZ7jb8OY02f/ecH/H56ZjIv62T+z9evcoggMbp8rHisocQBfAu47L//UaJ
	 batF8iuL8Cm/LeT+pvEM55/LHvZQlcpzYvQ4nodRQGsu82kb6KIpuFMcFxDPfdIsLV
	 Q1PwHAV1MZ6zegtNbug79u+hk1mfE8zDY+9g4WpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Sterz <s.sterz@proxmox.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/185] Revert "nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"
Date: Mon, 29 Jan 2024 09:03:24 -0800
Message-ID: <20240129165958.738514951@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit a484755ab2526ebdbe042397cdd6e427eb4b1a68 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bc288e6bde64..5d4d78c9a787 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -239,18 +239,6 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
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
@@ -270,8 +258,6 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 					   IOPM_SIZE)))
 		return false;
 
-	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
-		return false;
 
 	return true;
 }
-- 
2.43.0



