Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A87128816;
	Tue, 26 Aug 2025 12:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212634; cv=none; b=X8MoIR2ILMBM+Pg311noQyFjlQ4dJjgPgMDaHTjKODkLE4BvdINlbFwvmt29SPgtDZp3StTqV3auvDD2rdE3WLxibzITmxloj/Eer/82BGAc9cebfY7/ApbPvZkKlNlZSSKvZSvzmmZmQzXtHXApVTSH1BORLKat1WWvUWY8NCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212634; c=relaxed/simple;
	bh=gvjdZeAJJJ7roW5d+n3CDirjm4D668JPKa79rJiCEqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZkuO27BdWQNRr4Ga+NsKkJyj2/vj2qOm08BVpTpGw0hDGHfzf/9WiNU3w3XejYWUhbmJhfgu0leyvmEX/tONvg7ZDk1A2BbdsbPvKM6neAgHL3QtlZFBfVcLKvsCrVa3rHF6ttflcauvbxg0iCuoepr2yUOfYlb82QmSMSm8dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlSfwxYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlSfwxYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C96C4CEF1;
	Tue, 26 Aug 2025 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212633;
	bh=gvjdZeAJJJ7roW5d+n3CDirjm4D668JPKa79rJiCEqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlSfwxYF8uIqhj8YhjNLKQgs2AM3K4oe2cF0d1bohXxM784AGkmD0f83xwv5r5TUa
	 zrI7abgYuDw0j05ahEzI9TVr+duJByseEpTFz+Kcc5gRZ0lL3DhPVRobqYODSE1Hee
	 twJQmrQKjuFWK0qR/yb7FfBPQCFzA43mYYMnl4QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/587] KVM: VMX: Handle forced exit due to preemption timer in fastpath
Date: Tue, 26 Aug 2025 13:03:12 +0200
Message-ID: <20250826110954.041839157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 11776aa0cfa7d007ad1799b1553bdcbd830e5010 ]

Handle VMX preemption timer VM-Exits due to KVM forcing an exit in the
exit fastpath, i.e. avoid calling back into handle_preemption_timer() for
the same exit.  There is no work to be done for forced exits, as the name
suggests the goal is purely to get control back in KVM.

In addition to shaving a few cycles, this will allow cleanly separating
handle_fastpath_preemption_timer() from handle_preemption_timer(), e.g.
it's not immediately obvious why _apparently_ calling
handle_fastpath_preemption_timer() twice on a "slow" exit is necessary:
the "slow" call is necessary to handle exits from L2, which are excluded
from the fastpath by vmx_vcpu_run().

Link: https://lore.kernel.org/r/20240110012705.506918-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32b792387271..631fdd4a575a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6027,12 +6027,15 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 	if (unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
 		return EXIT_FASTPATH_REENTER_GUEST;
 
-	if (!vmx->req_immediate_exit) {
-		kvm_lapic_expired_hv_timer(vcpu);
-		return EXIT_FASTPATH_REENTER_GUEST;
-	}
+	/*
+	 * If the timer expired because KVM used it to force an immediate exit,
+	 * then mission accomplished.
+	 */
+	if (vmx->req_immediate_exit)
+		return EXIT_FASTPATH_EXIT_HANDLED;
 
-	return EXIT_FASTPATH_NONE;
+	kvm_lapic_expired_hv_timer(vcpu);
+	return EXIT_FASTPATH_REENTER_GUEST;
 }
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
-- 
2.50.1



