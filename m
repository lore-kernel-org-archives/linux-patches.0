Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A11F3DE422;
	Mon,  4 May 2026 14:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904072; cv=none; b=IDgr6R3tm/3UbDNxqNqO9+5/K3vAIpXayDaHaLoH51qagooDzp7xW4HnoRf7thgEd85A1cuePFFks8kVOypwIqgHQJNs+8pWaPXp/BLVzIcVPJ1gWo76y2B5ZNlA2I2ETH+1d6+pzOkhV5w6VgYcZdpNjXpgx7APQ/u+nQISP+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904072; c=relaxed/simple;
	bh=rDGpX6gvBf69RUIu/6z2yfgJwuUs1WF/t/sLVoylmNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxqtG1fMRZKZj3mSnGymFxSndlh8/KxOSXtACkpZ86dYNOHqZEFBKyXvb3QV2Vn2PALBgp+Po2FpTXx8rHLjbd3YHBir2IYAdJSJ37Mw28Sp76XqN+DRw5ffX0N3S0EkFPboTUAoIhp/V0Z9YHspvo2OMbaGFqdvGEioCtEALC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cf2oFMIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cf2oFMIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A05C2BCB8;
	Mon,  4 May 2026 14:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904072;
	bh=rDGpX6gvBf69RUIu/6z2yfgJwuUs1WF/t/sLVoylmNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cf2oFMIHG0ae3GfqDOJ3og7veZeuDRDDzwbcvVNxpDgD+jxJlrGMQMpGbq9TxxGm3
	 N0W8Xo6IOVpJjVcSSySKoN7kropAanGEGrKtzBiuemMYCdMoaoFfeIaer3yLa0kgEx
	 6K+VUUBuuQnJfTfYEkPsvYMH/IWUVQH4M5+1IXko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 173/275] KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts
Date: Mon,  4 May 2026 15:51:53 +0200
Message-ID: <20260504135149.487609742@linuxfoundation.org>
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


