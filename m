Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC7A11187;
	Tue, 26 Aug 2025 12:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212631; cv=none; b=nWjDjIKSuFHmok1/H8BCsKr5UshFOmCwO8HXyQaoFfoq2ba1TWjF3TuKEkQOwjdn7NihM2kcocPzd2ZPI7NVhxCyixVVR0KV3+NGDkb/BPnp208dPO60xDPNZxi+NdIc4JIJYZjiscR5/AqnLIyUIRTLcEpweQd103AnXGuB5yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212631; c=relaxed/simple;
	bh=Chiqb5bl5Pw5yYG0VknBSSUxgAXDitYY5PvCP1vtodQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCTypCDsu6dPRqyeIsfY4vDK6ilbAWvl395QrIuV08GcRyruoCAImM1p1dZ8xg6yGYXK0NFU7/h0+F1Dxu1W8ge1amCsKTeDej7IK/3H1PYhHVJsRk595sgWisBSgDNdEUBTYr7r66gJaSH8Cdj4oHpZL0lUyWevKMhKGndHdVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZ+XyN+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ+XyN+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C975C4CEF1;
	Tue, 26 Aug 2025 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212630;
	bh=Chiqb5bl5Pw5yYG0VknBSSUxgAXDitYY5PvCP1vtodQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZ+XyN+VUgAaZRel4miDVTeEBriMRyzckvG6tqBaeveHPfYzPAUJtuSDk1tZHvlpO
	 RXmM10efDeqjeKFszL0VD/XKvfbdJ1WmuPogyFCDfgYiQO3fupUcrBHwdYbuP51PDW
	 TMSTn/MDn7vjrwUGs6c81a2EmJH6/J5wFkxvrs20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/587] KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer exits
Date: Tue, 26 Aug 2025 13:03:11 +0200
Message-ID: <20250826110954.017565605@linuxfoundation.org>
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
index ee501871ddb0..32b792387271 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6019,8 +6019,15 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
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



