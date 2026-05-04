Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4533E1CE5;
	Mon,  4 May 2026 14:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904656; cv=none; b=ttBKtOeTDP/xWl5UumtEuvUUiTA6RU4UhwN0EtK6/9x8AvJmFERhRsWll711g/RHGGWyVFlmBf8EcQXege6UpW0QLm04u3dHhoIKHgZ3SkydeaHxGFP1mSRu7xUaB7dRtsvYnsMaKdA8UMeerWLBgHjKGG9bHd4OhssyewfaYpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904656; c=relaxed/simple;
	bh=vX1+2Bd5le4vWov91gYHrhZYgwmvupHsmP4hzIr57/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWqZNM6YnvliID7CsrSX/boe8guHwSWgN45zdkF96dWIVJeg2Xae2xKoQfjTz7hWZajvO91+JsatgtxcuF1Nk1Lt9sEGKE2M85UKyRdmxWS1ThSyqxSJ/eWtB0y06CvHz0pYIqysoJKOTy8ugL8aAaniRSysCVFyarvWid5FqW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeNxSJC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeNxSJC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39696C2BCF7;
	Mon,  4 May 2026 14:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904656;
	bh=vX1+2Bd5le4vWov91gYHrhZYgwmvupHsmP4hzIr57/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeNxSJC9aE3ah1q9Zj37LpHZISFozNetoFR/9SNF3WpQyCQ+DUiXhtQtLowzmjWN3
	 wEnVJCCcgeVK2gkp0PLt3zeDTv/yt8bBwP2LGl1qtvLSH2IK024A/wRfe1oUhn72KD
	 6ml68a1YMR2rqRSh3rOI2UHa1M4fU4W/kCdkjkLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 123/215] KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts
Date: Mon,  4 May 2026 15:52:22 +0200
Message-ID: <20260504135134.644504597@linuxfoundation.org>
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
@@ -129,11 +129,13 @@ void recalc_intercepts(struct vcpu_svm *
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


