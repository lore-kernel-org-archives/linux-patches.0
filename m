Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A609F13247D;
	Wed,  3 Jul 2024 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005859; cv=none; b=btLiBgXKr2Wax4bBQCNZaNoeEE3I63KGGDSJ9O+vdrw2AkdTZ0xO02Ou1A/edBRVpOr4RPL8bd87MHFZaGe2MkRW6SYZvTxqefGg5YPuKBMUF8D8azhBkMTgXFRbttTqOj9gVqTaTNthxBtnxY5USL9PSsKbVWFzAVFMVmZTNEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005859; c=relaxed/simple;
	bh=nAvLPGrTlLRqcfLx/eCxRoeb4+dDrEPA9SQ1y8Nlunk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkvIkEtX42etnzHtG0oKY8G4RAJNeqi+XU1yyn0ncJVtsMjFigiuRjlG+SNPXVa7PzRuCdpRXBNYHEIlxd5XOWTkXndWG2X8NopuKlMJS1VbQiS3SBhExLUxzDKncExZ0Cv/uZeHgTkml1vGl/frDYbBUvf6WS2obJpKhXxAJrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMlir9ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMlir9ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B488C2BD10;
	Wed,  3 Jul 2024 11:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005859;
	bh=nAvLPGrTlLRqcfLx/eCxRoeb4+dDrEPA9SQ1y8Nlunk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMlir9ZK1kH20WKnI6F8Z1ZdHA4j0uGL5/2fSCofYsZJo5ja69lTelBCyEjZPHZ94
	 /0GGDem6zyGD1dBkIr0jGQUttGZGcXrUVkXvQud+My/XJpx/u8lnjfG5LjMza1K1J/
	 Skvuo1vtPMW8no+FUTl7KqPhU0tQhEIUX75/AbVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adamos Ttofari <attofari@amazon.de>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 221/356] KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes
Date: Wed,  3 Jul 2024 12:39:17 +0200
Message-ID: <20240703102921.473101020@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9654,13 +9654,12 @@ static void vcpu_scan_ioapic(struct kvm_
 
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


