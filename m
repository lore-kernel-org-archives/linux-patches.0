Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E923547ACF5;
	Thu, 20 Aug 2026 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244474; cv=none; b=Ut1MXqPItod+R5SDVogv3Mc9VdhnRoXeVCO2YMSe3BZlW6JAcaZs2HTFJYnvIFoh+6Rey8Ahm5Clw7DLS51v0zPysEIr9r8hGUDQrS1eoc/x9sLuoxtL5dchCm7DN9M7aCJLK2WtkjC27v9EsLZVLsCyo9gVm0054kVqZQnJNVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244474; c=relaxed/simple;
	bh=rP615kU+qCHARBmtqJ4TQR7Gy1v99mlov8eXcXMZLVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HchYGk5h7bKxZ2WIp9ys+cLLhghNDo7COVBNcjMYgpWs5VQ6sR9kiph5IAe08bY/P2Qit5KGBfwiJCN6uf/ZH/V8Ts19J/PkH0/ArX3/Hoyfp46YJBWAW9bHbx0wMHk2G6JKOi7PYD7+KajGVjdXxrJBhLM17/NDbKwHgZ6pbuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkIRl6GT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkIRl6GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA971F000E9;
	Thu, 20 Aug 2026 16:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244472;
	bh=Ro2lDmhE2SfDsGcEND8YCOAyrFzHJOh6VfKosVAsoMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkIRl6GT/0ClKizMI+8m2+Se0lwQn6FcA6uiMEYue5N362zRdzxELsK8+C0+b2oje
	 hvIZLf46PFIz7aUoeieZUXAVThsDvXjUn1URI0sXDGfhaZfzwlihIUPtb6W43rbP1h
	 hBr39CGE/5V0TPx2UEggPgZkHoobJ/P7M+DxE5gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/235] KVM: x86: Check for in-kernel xAPIC when querying APICv for directed yield
Date: Thu, 20 Aug 2026 16:56:18 +0200
Message-ID: <20260820145220.747625962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit ae801e1303e939ad5ebd9f390bdcc57275ada33b ]

Use kvm_vcpu_apicv_active() to check if APICv is active when seeing if a
vCPU is a candidate for directed yield due to a pending ACPIv interrupt.
This will allow moving apicv_active into kvm_lapic without introducing a
potential NULL pointer deref (kvm_vcpu_apicv_active() effectively adds a
pre-check on the vCPU having an in-kernel APIC).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220614230548.3852141-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e800decd9c0a ("KVM: x86: Only reset TSC Deadline Timer in apic_timer_expired on KVM_RUN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11122,7 +11122,8 @@ bool kvm_arch_dy_runnable(struct kvm_vcp
 		 kvm_test_request(KVM_REQ_EVENT, vcpu))
 		return true;
 
-	if (vcpu->arch.apicv_active && kvm_x86_ops.dy_apicv_has_pending_interrupt(vcpu))
+	if (kvm_vcpu_apicv_active(vcpu) &&
+	    kvm_x86_ops.dy_apicv_has_pending_interrupt(vcpu))
 		return true;
 
 	return false;


