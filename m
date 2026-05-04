Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4AC3AA4F8;
	Mon,  4 May 2026 14:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904087; cv=none; b=LqjKVuGti3tbZsFekiKMVCdHfeWdS3RiTsvdlmZ+rGzAHOrqUK0fCGxKBg6LyXFOC2zA+vrZm61Fcxg2+86aQwLXUZX1WdiyQHI5AXTa+IC+x9Abc4Kz08arN7RS7gLQ+8fqwSK4cOF4pScTN0slwnerZhlsYwNztKFvrLMd7bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904087; c=relaxed/simple;
	bh=XKZ0HLHYzjeHR+A1AihbW1l3wRfsXoxk8A39HFTEfh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+53C+dFte6heNPvajvuL9F+cRHat+4DYfc5HGzwb5yWzpkoGXzLNyM/jUZ5uLFGgnqDJuTwUVaxbvkycn5HTFdeMofzKRCnVn4cKImRHuNbNL7mtGvS8Rj886KV1MV25dQc8G5Z+2a1bbht6uzuCJdHMb/RbXsQY/+zRZ0rkM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQJ6fSfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQJ6fSfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BD1C2BCB8;
	Mon,  4 May 2026 14:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904087;
	bh=XKZ0HLHYzjeHR+A1AihbW1l3wRfsXoxk8A39HFTEfh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQJ6fSfgmSWJixi5YbVGZRhtgS4i95ofe86MewF8ZJmQUMN7tRmjRKTnzBv3abG4N
	 QVlBmsKJcQ5BjTQOwcOfF/S74TP1Wtq3kUkfsSU/dSJ1RY+4qPbeNVYjlGmbI9ugbU
	 75nTP2hP5kFu2dYlrACWTgOLWYNhefMwhnGJxH7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 178/275] KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12
Date: Mon,  4 May 2026 15:51:58 +0200
Message-ID: <20260504135149.681918998@linuxfoundation.org>
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

commit b53ab5167a81537777ac780bbd93d32613aa3bda upstream.

svm_copy_lbrs() always marks VMCB_LBR dirty in the destination VMCB.
However, nested_svm_vmexit() uses it to copy LBRs to vmcb12, and
clearing clean bits in vmcb12 is not architecturally defined.

Move vmcb_mark_dirty() to callers and drop it for vmcb12.

This also facilitates incoming refactoring that does not pass the entire
VMCB to svm_copy_lbrs().

Fixes: d20c796ca370 ("KVM: x86: nSVM: implement nested LBR virtualization")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-2-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    7 +++++--
 arch/x86/kvm/svm/svm.c    |    2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -684,6 +684,7 @@ static void nested_vmcb02_prepare_save(s
 	} else {
 		svm_copy_lbrs(vmcb02, vmcb01);
 	}
+	vmcb_mark_dirty(vmcb02, VMCB_LBR);
 	svm_update_lbrv(&svm->vcpu);
 }
 
@@ -1188,10 +1189,12 @@ int nested_svm_vmexit(struct vcpu_svm *s
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK)))
+		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		svm_copy_lbrs(vmcb12, vmcb02);
-	else
+	} else {
 		svm_copy_lbrs(vmcb01, vmcb02);
+		vmcb_mark_dirty(vmcb01, VMCB_LBR);
+	}
 
 	svm_update_lbrv(vcpu);
 
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -811,8 +811,6 @@ void svm_copy_lbrs(struct vmcb *to_vmcb,
 	to_vmcb->save.br_to		= from_vmcb->save.br_to;
 	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
 	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
-
-	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
 }
 
 static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)


