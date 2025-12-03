Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1644C31A077;
	Wed,  3 Dec 2025 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779976; cv=none; b=Kvfql1v8s3LBvLyFFpSt6Q0NdZjvlNF+cl/AldVesZRKPjbMj7ZHkVim2SJq0uHdCTG6I8JCsg0bUo8TXdZ4KzjIyevsejtjUXvInb0gzzTlnj5XTEbuMmrqhVSnlbr9VCSCYy5hoBf4qYT9gTJBKuPr1Qdfef9GxYakV5ke+X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779976; c=relaxed/simple;
	bh=M0dvR6WmuFRPqCtcxsST9z9oLau2zmj0a7Ut+OVWBBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7ISileT+XOMUOpAak9t1O67Gt8NflhNsgEOs3o3SPr/xd3zs04ToB92qTPqEzPTbBsVjHKaXs7nYE245ma9u7XeF0lhaSxowCcqof8P3SZjmFqV6K9bmm8Wj6BDqCHIhPkgm+1Q0IS7qfPengKXbRO2K7VdeLfIknU6VD730bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKDXVObA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKDXVObA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DD1C4CEF5;
	Wed,  3 Dec 2025 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779976;
	bh=M0dvR6WmuFRPqCtcxsST9z9oLau2zmj0a7Ut+OVWBBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKDXVObANcYdSLBzgEFP78KESShX2p9g94dbss9m25zAdtvbFEWbjrv9gs/fGWV8G
	 JqkjPxU3vJqY6ADN4BlSvi+rDzPEkvXidcG3t0tXdAA97hxYC6tfP/yG8XnAQap8jn
	 YIt+xBHGFy3+L0whv0pFip7Yyk2RNtev9tr3QJqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Rizzo <matteorizzo@google.com>,
	evn@google.com,
	Jim Mattson <jmattson@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 417/568] KVM: SVM: Mark VMCB_LBR dirty when MSR_IA32_DEBUGCTLMSR is updated
Date: Wed,  3 Dec 2025 16:26:59 +0100
Message-ID: <20251203152455.968090987@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

[ Upstream commit dc55b3c3f61246e483e50c85d8d5366f9567e188 ]

The APM lists the DbgCtlMsr field as being tracked by the VMCB_LBR clean
bit.  Always clear the bit when MSR_IA32_DEBUGCTLMSR is updated.

The history is complicated, it was correctly cleared for L1 before
commit 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when
L2 is running").  At that point svm_set_msr() started to rely on
svm_update_lbrv() to clear the bit, but when nested virtualization
is enabled the latter does not always clear it even if MSR_IA32_DEBUGCTLMSR
changed. Go back to clearing it directly in svm_set_msr().

Fixes: 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
Reported-by: Matteo Rizzo <matteorizzo@google.com>
Reported-by: evn@google.com
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251108004524.1600006-2-yosry.ahmed@linux.dev
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ Open coded svm_get_lbr_vmcb() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3053,11 +3053,17 @@ static int svm_set_msr(struct kvm_vcpu *
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
-		if (svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK)
+		if (svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) {
+			if (svm->vmcb->save.dbgctl == data)
+				break;
 			svm->vmcb->save.dbgctl = data;
-		else
+		} else {
+			if (svm->vmcb01.ptr->save.dbgctl == data)
+				break;
 			svm->vmcb01.ptr->save.dbgctl = data;
+		}
 
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		svm_update_lbrv(vcpu);
 
 		break;


