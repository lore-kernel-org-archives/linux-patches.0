Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1050334C24;
	Fri,  9 Jan 2026 12:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960714; cv=none; b=qf/aJbuw/2DBbrTJ9ZoioFGBgu8wtUV2YXiTFN3YX4/tF5PrKiSLw3z6niBh0yVoctfn1PhMi/0gePprc/u3lbvEFP1FHksuz8FPVIemjUsOtgmTr2nixduFShMietUIumFsGMr8NYcH/EL3jWE1WOZZ5IMqWMjOLQQUzHNsGew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960714; c=relaxed/simple;
	bh=Fgcci3pZkKWN+jB34cWehG5/VlT/Fd5J81GO4eba2Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSIrERmZhrn+cXSBO2Cv6aTd3vSFmsTbpa16cR3OuaTvd46S59Bh2BJ3PdFQeMrdGwvBjLc6VHGi5kuBf0RW23w6rA5RD4e021MomWzxtkANgHEkwK51URww++n3/3eEmwNmmYyDQBnpiCOqYvqLlaE72w9nzY4+0jN99w3XXKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrPRhiOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrPRhiOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D83AC4CEF1;
	Fri,  9 Jan 2026 12:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960714;
	bh=Fgcci3pZkKWN+jB34cWehG5/VlT/Fd5J81GO4eba2Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrPRhiOoE29gjaHWG+nCIHoqT6dCVpyr5g7F23OPsmVO67mcyKHpMHMlavWj0it6/
	 E1UkjVDBIkHOj9usqE6Oq3Qnj+cgOIK4zBtU1bVLS33ItLDuU0yps7f5v88krurHBu
	 aEgYFHS6xwVm0iL1F1wXQiqw3w0ihkWriFERHhQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 466/737] KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN
Date: Fri,  9 Jan 2026 12:40:05 +0100
Message-ID: <20260109112151.518279782@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Mattson <jmattson@google.com>

commit 7c8b465a1c91f674655ea9cec5083744ec5f796a upstream.

Mark the VMCB_NPT bit as dirty in nested_vmcb02_prepare_save()
on every nested VMRUN.

If L1 changes the PAT MSR between two VMRUN instructions on the same
L1 vCPU, the g_pat field in the associated vmcb02 will change, and the
VMCB_NPT clean bit should be cleared.

Fixes: 4bb170a5430b ("KVM: nSVM: do not mark all VMCB02 fields dirty on nested vmexit")
Cc: stable@vger.kernel.org
Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250922162935.621409-3-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -544,6 +544,7 @@ static void nested_vmcb02_prepare_save(s
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	nested_vmcb02_compute_g_pat(svm);
+	vmcb_mark_dirty(vmcb02, VMCB_NPT);
 
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {


