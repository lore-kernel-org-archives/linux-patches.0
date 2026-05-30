Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD84320CAD;
	Sat, 30 May 2026 17:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163466; cv=none; b=iCkuU+waXntcXA7isIHlqwoT3WMkhvf9a/KTMHrSP50+ZAQzIAhodKF/pzhYFTXpHeN+vSny3Ucg18mQM4HRxw16v5I6ibNPJJcTUNVF4QlDmxJibOMpW6ZljdkhMcAeyzTxv+IH8/p71cbUNgtdO5UCGFTzJxzy4g2CEe2FkUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163466; c=relaxed/simple;
	bh=79/WEzE9x6pOSK644VC1ir0b2WyjPjRM0pEiPp6OBgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5KUgO3VE7mMbLEXItUS5PViSo+/VtMFKokIm7q8WFtYZ6Dc1Lea8NcLck23roN5OEEoQOX0cBty2V8femGW8tZEbD3sY5ZshFJgKgTLi70WXzMlgMl6Kjbibye094Sne3H6GpuhuSIvbQrHsbwQ+Rr6pFNj+SQS4Xr273TnEok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeeOAaK5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeeOAaK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931101F00893;
	Sat, 30 May 2026 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163465;
	bh=v/Sv5jwmCHKxVREV9AU6ca06wLVI8Mct0E3Ff3bMhpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DeeOAaK52RxQy3Z5xTzCjOp4abXDhVcnKaWC5MCRsRCCjA+MobJC4W+2bmdsCjJVR
	 QIzzn9Ei6l9DBNbFisZaiRDmqIZOFu+3kU9aK8F8zNDgDIjpsczBvvv6n0GRK4JkTj
	 IsuNXrNZUhvOmHQPwDdHqNtM3IKVLPcH+Bk8g1X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 237/776] KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
Date: Sat, 30 May 2026 17:59:11 +0200
Message-ID: <20260530160246.654666430@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 01ddcdc55e097ca38c28ae656711b8e6d1df71f8 upstream.

nested_svm_vmrun() currently only injects a #GP if kvm_vcpu_map() fails
with -EINVAL. But it could also fail with -EFAULT if creating a host
mapping failed. Inject a #GP in all cases, no reason to treat failure
modes differently.

Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest memory")
CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-6-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -651,12 +651,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 	}
 
 	vmcb12_gpa = svm->vmcb->save.rax;
-	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
-	if (ret == -EINVAL) {
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
-	} else if (ret) {
-		return kvm_skip_emulated_instruction(vcpu);
 	}
 
 	ret = kvm_skip_emulated_instruction(vcpu);


