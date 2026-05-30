Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E3E32D42B;
	Sat, 30 May 2026 16:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160076; cv=none; b=nDJqfObBiuL2b1XAXNF/ko8OYbdxtrikA4h9b2sY+soyfNTCfY4+2H8qLqPN/4WBRwmbjV/xQttib5um2cwm2+pIELd2Fkd1XbnSDzrdOzJ7lHwWD0EIsQnjMlqo19J+WUbZRRDtVzJ8LE96VyURCEEx2DW+hx8/wQ4QT6hHy04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160076; c=relaxed/simple;
	bh=ocoLX8pmsfUfSF9qdJx52FJjWb0ZwPcq6bbQUzRl+F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZZkFQvZzj7xA4H0a/KR7Eq3Me4nEZPxtVXFpNcbjFEGHGeeS8djrh9DPl9PfMxFkwwQGmMCdxeE10NP+qdxs1zjad9Gpl4CRtjWLDe+3yGcW32w8c6t5wU8jidb1GFIwtH3JgstuY/14vM2/GDr3MtreOI6tlfHJ8B3S5g9N3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCd23z5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCd23z5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFF31F00898;
	Sat, 30 May 2026 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160075;
	bh=PxvP0DtIS9BzK5Ar1bVmLr4zkRuguBeoQT/O40wtZMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCd23z5Xs5YeJQ4DWiPauJfL99TYjLU3P4wo8RGQX+ZfEVPfUqqaen82tgZQhBu1f
	 g6OX9OQd+cX1DbspNV/zTi8rn4w9RrR3l4n2skLJwhfKk9FI1gpj5/Fnsm3DVuAcpT
	 KD6Sb2HaIxvEhRf2NnQOz+vTGmn7oRxhuf6Ro0Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 239/969] KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
Date: Sat, 30 May 2026 17:56:03 +0200
Message-ID: <20260530160307.056178716@linuxfoundation.org>
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
@@ -816,12 +816,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
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


