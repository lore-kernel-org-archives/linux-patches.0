Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41553D300A;
	Mon,  4 May 2026 14:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904075; cv=none; b=MSxaK8fb7OcZnay9PZBzOAX6Qqvp4GQU0vYssd2s1lbs+F2JUbmafht9HWvxl2vTS9iiQRC5Z2HI7Ey88YILoweYa4CLOz/yazQVql2xeyX11JwXYAMttnxTlu/aoWG5sCS4aNcFDGLzfw7h1zWIkDlpu/YSBlEOPDjZsZloumE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904075; c=relaxed/simple;
	bh=MsxmGeAh/P6nXPUq1/Zjkfdt9iT3ENz3cyI68W60nU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQkgCnZhr+BbwMKrNNtTr+kAiTUMIm9NFU9PFR966y0ZgkyZrITE/ikybspj6pB0OQ9DNt6znLhRBF+PANsvvGnNUVaWAS/zfnUdOEVacS6/1uoTodnBPaSfsfxDH12WN9xkYJzz6Z/GYVi1mc3U3yzJ2pnSFRUi/a56W+t1F6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stCr2uux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stCr2uux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816B2C2BCB8;
	Mon,  4 May 2026 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904074;
	bh=MsxmGeAh/P6nXPUq1/Zjkfdt9iT3ENz3cyI68W60nU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stCr2uuxf2udGjuchIu0slZHgdmd/eNdUgGN1ukQXN3IhWy5G8leqMe3Q2t130m7D
	 0MXJJfCfLqYleMU4pQGDljOXhsVoQifYpzs5/HL6thFtU90ywdK132vj1YJykNqe9a
	 dXKgYk9qIojqdN/Vtg8upcjY57eU7IqNI9iNXJz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 174/275] KVM: nSVM: Ensure AVIC is inhibited when restoring a vCPU to guest mode
Date: Mon,  4 May 2026 15:51:54 +0200
Message-ID: <20260504135149.531813449@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 24f7d36b824b65cf1a2db3db478059187b2a37b0 upstream.

On nested VMRUN, KVM ensures AVIC is inhibited by requesting
KVM_REQ_APICV_UPDATE, triggering a check of inhibit reasons, finding
APICV_INHIBIT_REASON_NESTED, and disabling AVIC.

However, when KVM_SET_NESTED_STATE is performed on a vCPU not in guest
mode with AVIC enabled, KVM_REQ_APICV_UPDATE is not requested, and AVIC
is not inhibited.

Request KVM_REQ_APICV_UPDATE in the KVM_SET_NESTED_STATE path if AVIC is
active, similar to the nested VMRUN path.

Fixes: f44509f849fe ("KVM: x86: SVM: allow AVIC to co-exist with a nested guest running")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260224225017.3303870-1-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1896,6 +1896,9 @@ static int svm_set_nested_state(struct k
 
 	svm->nested.force_msr_bitmap_recalc = true;
 
+	if (kvm_vcpu_apicv_active(vcpu))
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
 out_free:


