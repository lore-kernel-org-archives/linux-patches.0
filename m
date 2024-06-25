Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA86112EBEA;
	Tue, 25 Jun 2024 09:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308653; cv=none; b=rl9njfeSf869OL+lBZkOoltrnEFo6BFKnqhArk33qjUPFmcjRM0g5Gb5cPtuNe4zc++xHtwRGyfscUAlGCOhzmYIbHW7YxCWhboJbHsRQK/bSvd/XNw+7RvZAOpz6cqPKTtNlv3anFOLicQTZ06Q/34wxIw+APgfcOljWkKP0bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308653; c=relaxed/simple;
	bh=goAM+7IBuvr4p8KQ4I7T2Tbi0GdOMLSgMA5QkLb4t8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1bIuQ0kB/0ofuExSwEfS7AeFSeWuViNZau4QhAJ0W+EXiqOGAR8D+NYYT2GgUbyKyebrDyi0jZF1OG5k6LsEpiUzjzDfH2Yw6fqpPD5cqzb4peDL9Zel1fmCAdM/93CflxRAcJK6TGSZxuIttBz/Y/Uwzd5BxepB56PEH4lAn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGd3Jdia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGd3Jdia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D39C32781;
	Tue, 25 Jun 2024 09:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308653;
	bh=goAM+7IBuvr4p8KQ4I7T2Tbi0GdOMLSgMA5QkLb4t8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGd3JdialRQszMLg60gCvF9ZfCjtdQyQFmYIYjuD1Lfb9+DKfODu0QycLDKwE8Oxk
	 mvdGo+A/ndgurR+UFamX4Wlevot9yNd++ZyUEckxVOx+Y2URFT2vxCnTd7fe4FpUzD
	 cWt+fTMmAJc8KCPZ48F4D5lFfQG/9PLcOQOeYN7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adamos Ttofari <attofari@amazon.de>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.9 193/250] KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes
Date: Tue, 25 Jun 2024 11:32:31 +0200
Message-ID: <20240625085555.459148134@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10677,13 +10677,12 @@ static void vcpu_scan_ioapic(struct kvm_
 
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


