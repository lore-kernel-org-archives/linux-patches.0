Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF760355049;
	Fri, 15 May 2026 16:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860851; cv=none; b=i4Q69hEF+KPsiu6RN7sHbIcF9arwJOFBot4UdqkYa8SvixcIrMyhFuZMy8wcmssKKV0FJSM5eDpj+MC+5t/BD6/Osg8he7/oGrv6T/vU7ZGWvQxYSX3oUG1QdTmc24Gx/xjjWsCsIdPw5peLB8LTMlRwPKNczZ7WYb6Pr6yUUkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860851; c=relaxed/simple;
	bh=DZiKf/ZxjolGWhdfdhqeLJ4FFrlUzJwFs2Go/8JiGv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2IugEqWi2xJqEi3ZoQbiCVriN/MPlJx1jAL5MrfFayjBvgcXP042p/+6JHTx3ckZoldDzybMEWPquGxY8xQoNNv9knWEy9S6xSbFnyDoep9xnUJFaT1+sJ2ATx1kTmPF+hiK/Tnd9ywOqyqLF+mmV55kU9KavC3IK7xteZ4TzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0Qq6ocj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0Qq6ocj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365ECC2BCB0;
	Fri, 15 May 2026 16:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860851;
	bh=DZiKf/ZxjolGWhdfdhqeLJ4FFrlUzJwFs2Go/8JiGv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0Qq6ocjTqcsb8auHJj0Jd0VVxBedkM0jCv1aYMCmLeRSDRx0pDfvb3duQ0bBi473
	 FbIoyqxqrNgWJCJBxwuoq52IDA891rrZ76SUVLSvY8v+/NbYSyUHnjGUBUoDH+2Rj8
	 4rAU4rcd2ExWnI8tPuA0iQWM4WGLck3zy4EQSLBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 102/474] KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
Date: Fri, 15 May 2026 17:43:31 +0200
Message-ID: <20260515154717.244901965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -863,12 +863,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
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


