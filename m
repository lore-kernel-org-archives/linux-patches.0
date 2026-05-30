Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DDE32BF24;
	Sat, 30 May 2026 16:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160205; cv=none; b=XMAOFHtgVvLlROPpJiDfUlDmM9tJfKvFYKPUmmQrfEw9KngZ6hGelhF0mRzhgldvDmEvoIKCfvSwJX+RvixFWo92Fz+SRDUXDTkfxI4+Aj9EmKAZcpIpgRD0sGzClz/kzcJG1sLMGXf7Smxu+lbgFyxA5CyeNW1BUbdBSIVieh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160205; c=relaxed/simple;
	bh=8liFkPs7MHsQxOeOSs6e/8zLlZCJ5kkgCUrv3rhuGP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUqM7rFUKalAQCokcM0eXSkp6wqdZ0JBs1xmKpiooqyXntjNaK1GxW+fNqjWnAHQJ8sRkSfnzGM4OQox8k4lRriQcgEoCSGfcYAX6e/QZHJ6/p8Gnzz5xvLswFanXVrsxgCBHRUxiKxmXnmpqDKwu1dXSu1oXyd3jK0ywuaL6XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INJNH/py; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INJNH/py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFE51F00893;
	Sat, 30 May 2026 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160204;
	bh=dncTRQhfdAEja++bXuEaXkmWnB1eXEGqEGU3Blk2c9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INJNH/pyWte5Qz/XEAA48jgKNk5JZXLsDLLRxXc7jmOH5oQ2c9zRNTyFkyAMYKntv
	 STm27/3Z/yJa2jyIWnOFuHUnulmWzHk3fzYjLe/1s8EVvethchNvrWkJmBE5M4naj1
	 JsBcSsiEY9ACEEJxoxSTi7emdhcv48Ty7XKxq/TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 236/969] KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts
Date: Sat, 30 May 2026 17:56:00 +0200
Message-ID: <20260530160306.978131429@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit d5bde6113aed8315a2bfe708730b721be9c2f48b upstream.

When reacting to an intercept update, explicitly mark vmcb01's intercepts
dirty, as KVM always initially operates on vmcb01, and nested_svm_vmexit()
isn't guaranteed to mark VMCB_INTERCEPTS as dirty.  I.e. if L2 is active,
KVM will modify the intercepts for L1, but might not mark them as dirty
before the next VMRUN of L1.

Fixes: 116a0a23676e ("KVM: SVM: Add clean-bit for intercetps, tsc-offset and pause filter count")
Cc: stable@vger.kernel.org
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260218230958.2877682-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -128,11 +128,13 @@ void recalc_intercepts(struct vcpu_svm *
 	struct vmcb_ctrl_area_cached *g;
 	unsigned int i;
 
-	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+	vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_INTERCEPTS);
 
 	if (!is_guest_mode(&svm->vcpu))
 		return;
 
+	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+
 	c = &svm->vmcb->control;
 	h = &svm->vmcb01.ptr->control;
 	g = &svm->nested.ctl;


