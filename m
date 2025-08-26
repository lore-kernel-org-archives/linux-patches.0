Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACD31ADFFE;
	Tue, 26 Aug 2025 13:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214166; cv=none; b=OkfXvwYEGa0g3G2+KuflbsK4lDKZP2UszRFFpoNIfKcl80OJvPAb+YjpAtGp9bVLHUsDRnAnbztbdXoR7k/TbqeZB3VfeM+Mj7BjFUATdHTsCvS9UC42mH/5OEh4i2bmz74LzQoO/t7SNaMdTA/uwk3dTwl3iGAFX/vBDsiJ8Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214166; c=relaxed/simple;
	bh=x56nIxocI8jLM295R6ixCQ0yzYkFjoi3yDZr12czo0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNnR00j9R3SUatngYmPsmT+keoP+oCTtkzrvjTW8oOZNdfSp/p+xzypHJW0rmtl16q1q1UnCuGaiIoo0ghxf5PqjlWJMnwOX/8CbzPtUJjG6wcbra4Xstz13iHGMk/BgWkeYBvUmsVHi6s9ou913xgPuBPpER7npDSodZdbAg0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1AzH2oP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1AzH2oP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EECDC4CEF1;
	Tue, 26 Aug 2025 13:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214166;
	bh=x56nIxocI8jLM295R6ixCQ0yzYkFjoi3yDZr12czo0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1AzH2oPGrq0QQy2Zy6i7wKBj0IH5FdJUPqU+7QU2n5Hc1WRsv36Ev7c1hRYFfSvD
	 5owGCXXc+ZdeAC6DmbK7Yko5/98Cf1VJmf12dM51RNnZgFP0YWinnTNH2drZC6fA3S
	 uPm8mybewIJhG3X5ma0y1fRgHfsF94/dUMWFWpM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/482] KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer exits
Date: Tue, 26 Aug 2025 13:04:48 +0200
Message-ID: <20250826110931.673691378@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit e6b5d16bbd2d4c8259ad76aa33de80d561aba5f9 ]

Re-enter the guest in the fast path if VMX preeemption timer VM-Exit was
"spurious", i.e. if KVM "soft disabled" the timer by writing -1u and by
some miracle the timer expired before any other VM-Exit occurred.  This is
just an intermediate step to cleaning up the preemption timer handling,
optimizing these types of spurious VM-Exits is not interesting as they are
extremely rare/infrequent.

Link: https://lore.kernel.org/r/20240110012705.506918-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0b495979a02b..96bbccd9477c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5933,8 +5933,15 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!vmx->req_immediate_exit &&
-	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
+	/*
+	 * In the *extremely* unlikely scenario that this is a spurious VM-Exit
+	 * due to the timer expiring while it was "soft" disabled, just eat the
+	 * exit and re-enter the guest.
+	 */
+	if (unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
+		return EXIT_FASTPATH_REENTER_GUEST;
+
+	if (!vmx->req_immediate_exit) {
 		kvm_lapic_expired_hv_timer(vcpu);
 		return EXIT_FASTPATH_REENTER_GUEST;
 	}
-- 
2.50.1



