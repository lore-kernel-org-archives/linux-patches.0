Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDF83E3C50;
	Mon,  4 May 2026 14:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904664; cv=none; b=Xs7XlU2Jst02zbTPpo1b76av28x8+9kNOMcWpdJ5zLrI+yOF1qjWluY+2tpX6UZoj/tI9mpoiyHFmDVW5HM/KUdFo+JWdN7jPxKT4B/enYtA/8DXzMVdvshyVFAYG0b49fNjc1Q3oqul/uB+xmqJ/CmUA/sL1NNyxtZJb1JopIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904664; c=relaxed/simple;
	bh=+/tDT/f/XWJe3uteUCbfG+91K3+Blr0eZTm3WIc8lvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmQvMAwFJT/B7XD76sBg5VAt7tCF3tRRhxHGQUPVQhk7qCrHrfdABNlJ94su34/gp58FlymUPnAlRmZop0z8djJA9lIKn5LrsfIUrj2fCsqbhGjpOSAC1EVjVDJ2ILqA10cvebccgH+Wo2nmPkQ+Fr4c+4W3M8lm1HILQ82Al6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKSX3tQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKSX3tQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CA6C2BCB8;
	Mon,  4 May 2026 14:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904664;
	bh=+/tDT/f/XWJe3uteUCbfG+91K3+Blr0eZTm3WIc8lvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKSX3tQwOzYhf71n1i8cZ79cIJAJGj6m6DbLlUMiKKr8M9yqQFCf921sVtngFmJEo
	 RjpSEDiF9Wf9qNu319hmdA61wTdfQvdr2RoymTMTCZ6LEGIXBFwIFoV9QoZ4O5vXwi
	 vrab/DYAteroyXCR3KRNUaQtZU0Mr/ESEyrmlR10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 126/215] KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
Date: Mon,  4 May 2026 15:52:25 +0200
Message-ID: <20260504135134.753090093@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -865,12 +865,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
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


