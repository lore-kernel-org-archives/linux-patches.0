Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E470149C4F;
	Tue, 25 Jun 2024 09:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309248; cv=none; b=kq32zs3wEIECtkcThKu2+YCif4i/vly7qeDxxsifW38ThJWOaK7/zDAMYX3PNl64jyXYAr3PLSxLBFfmfBrmdErZf41gvlqR0dIc6mOgW6CJ62GaxBJE9GSCF0041gpe+M47qwK3AHM6ajHHiwOqCL8V5SsZxuixMsDOQIXzUNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309248; c=relaxed/simple;
	bh=a+STfXBiYxr4A2OZoON39K4P+CrqNJ02Ft7YLMkCqoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUyLFahvHIJl6X2rlOMW1sQw37zQ3glRZaFPFYXpGQimmD2tC9npPKDvzAJX4P128ouCC4I/nnlH8aGB8kQoqjgQgr0sgOkABXxch4r2gOsNTPmPpSF4SDr1JLUQo8xgYu+7HOUs2SC/ENoOOgMaJtRAElINYDHVZJBUan9iawc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0R5E9sGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0R5E9sGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972DDC32781;
	Tue, 25 Jun 2024 09:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309248;
	bh=a+STfXBiYxr4A2OZoON39K4P+CrqNJ02Ft7YLMkCqoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0R5E9sGi5VIH6xOW684COmt1mhbnzlK0ZIbwolk7RcvbPfOnGEE62mlMYstYrRJ32
	 Bn19yIiDjaPw2Rqo+/ZIJs46ZN6h+vc4nd0W+OOIE3O4x+dwa3xKGCBL0vEd9YM9Hv
	 GExKWKdogrJwIIvk0TnFA/SNisddvQvtNU/IYRqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adamos Ttofari <attofari@amazon.de>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 144/192] KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes
Date: Tue, 25 Jun 2024 11:33:36 +0200
Message-ID: <20240625085542.685896071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit f3ced000a2df53f4b12849e121769045a81a3b22 upstream.

Sync pending posted interrupts to the IRR prior to re-scanning I/O APIC
routes, irrespective of whether the I/O APIC is emulated by userspace or
by KVM.  If a level-triggered interrupt routed through the I/O APIC is
pending or in-service for a vCPU, KVM needs to intercept EOIs on said
vCPU even if the vCPU isn't the destination for the new routing, e.g. if
servicing an interrupt using the old routing races with I/O APIC
reconfiguration.

Commit fceb3a36c29a ("KVM: x86: ioapic: Fix level-triggered EOI and
userspace I/OAPIC reconfigure race") fixed the common cases, but
kvm_apic_pending_eoi() only checks if an interrupt is in the local
APIC's IRR or ISR, i.e. misses the uncommon case where an interrupt is
pending in the PIR.

Failure to intercept EOI can manifest as guest hangs with Windows 11 if
the guest uses the RTC as its timekeeping source, e.g. if the VMM doesn't
expose a more modern form of time to the guest.

Cc: stable@vger.kernel.org
Cc: Adamos Ttofari <attofari@amazon.de>
Cc: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240611014845.82795-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10456,13 +10456,12 @@ static void vcpu_scan_ioapic(struct kvm_
 
 	bitmap_zero(vcpu->arch.ioapic_handled_vectors, 256);
 
+	static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
+
 	if (irqchip_split(vcpu->kvm))
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
-	else {
-		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
-		if (ioapic_in_kernel(vcpu->kvm))
-			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
-	}
+	else if (ioapic_in_kernel(vcpu->kvm))
+		kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
 
 	if (is_guest_mode(vcpu))
 		vcpu->arch.load_eoi_exitmap_pending = true;


