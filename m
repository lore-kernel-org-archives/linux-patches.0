Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A9F32BF24;
	Sat, 30 May 2026 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160069; cv=none; b=rCIXyeTAAaU3RjygzGkFRdBcPFuy3nW2tfFrt6h9vQhhTkyHjuYNUPr5/BcxHOedMW3WCMfkSxj1eZyiChLzB1FRPHwh7Nzh1NeggVTuR0AQb9JHOsiaabfpeGLy/C0jMBcLL5Ycr3LaaRc5s4g+pJvW/6xQ3roaWIn4v8B5QOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160069; c=relaxed/simple;
	bh=fmpBmvTBQreQsHO9zyLcO3CpEvjNDxV0rXgh4OepCpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBiOmsiUALWa2d9eWyNdhpHw393l6aEY071DL/E/hJIXK8jEDqajr5KP+nRlaBPRuggz5trl5fQlD58G68Pn1dOXo9lUPQhL+mgoMKIm3s4Xb7PVu+aSW8hV2sk2ZDZ3BXacoZjzg3zZXcWb+ISHXqUtwp4ybCe638Z7+fXEt9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrND7k8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrND7k8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155221F00893;
	Sat, 30 May 2026 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160067;
	bh=jdDx4LaYPiBjFEvnX8XeuyknRFGcoz+LwVToiA6FWuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrND7k8cBFPiFJA0yzXrRaqrH1u7xkdvL1zMLfQnM0xhooJ4GNrwicozOvTzi4XCH
	 Z8TdPhE+PoUPLrynDFGlyW3Drhc3lHA1jmWbN8q98e29iG6+EncwF2ADttVG1tId2l
	 nqUCkAvlCjsRvxLLlX1i0yCFPxqf5x/NrZVsNs6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 237/969] KVM: nSVM: Ensure AVIC is inhibited when restoring a vCPU to guest mode
Date: Sat, 30 May 2026 17:56:01 +0200
Message-ID: <20260530160307.004138088@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1682,6 +1682,9 @@ static int svm_set_nested_state(struct k
 
 	svm->nested.force_msr_bitmap_recalc = true;
 
+	if (kvm_vcpu_apicv_active(vcpu))
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
 out_free:


