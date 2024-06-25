Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF4313C90B;
	Tue, 25 Jun 2024 10:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309712; cv=none; b=OTPf6z7m0cMSBPDaNMBALksVq5eNS1o6ra2/9xVgabcYfsOry2vnG7y6pyoeQ3NSJk8tA8vGcPfL9UZ6IFZL/CBHZimv+0C8BIMtW4z/E2jZZiRfQmgQ7/Q9uTW+W+v6dpGV+6tqEPJvWfXO6ZORGOOOMlPWJhjqGnCQFKm2jrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309712; c=relaxed/simple;
	bh=LKcEuvH9HKigBSJH9jEYCMS7cj+IOcoFt1sdpDsigSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uc4zcLwqShKeWeuZyVRrRxwDwgBDOc/pSOYStHClwKIQfuRZnuyeT/j8HFdBRlM6H2EyW44b5ILIsiHdzSBDWSbSDcrOw2OaF5t4xJj8HUdHUMZ6p+In9FHy+y5D3bVUZkJktWuJ/KEw9TtDsraQzdBH+KmpNmbrWDb4qrFifzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J75XF75+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J75XF75+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42380C32781;
	Tue, 25 Jun 2024 10:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309712;
	bh=LKcEuvH9HKigBSJH9jEYCMS7cj+IOcoFt1sdpDsigSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J75XF75+Yny0xWE1jM8pEKv/Gj4+3XooPK+8k/Zttqs9GQL134QMPO4acxYrgmPe9
	 /vap9c34eD9uyhXc1/pU02DFfwpIwp9Ab46pKPuM59UUo8r6P0GVRMVsKXBFayEiZL
	 XB+oc0Txr6rjC33xyYayFSoEBAG9Aq4Lw6s0kqI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adamos Ttofari <attofari@amazon.de>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 101/131] KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes
Date: Tue, 25 Jun 2024 11:34:16 +0200
Message-ID: <20240625085529.776669179@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10523,13 +10523,12 @@ static void vcpu_scan_ioapic(struct kvm_
 
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


