Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22C4339BE;
	Fri, 24 Nov 2023 18:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMFmXf3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42769C433C8;
	Fri, 24 Nov 2023 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851989;
	bh=8weSAZh5bz7SEjptIHA1xYUqlBnyC7i0grRSsn+H6z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMFmXf3D+bZahHzNs4wlnRGrWeWanSlUFQJ9GGFzQsjtx6oH3SqzATRv1tZB8FC7s
	 xZxvUtDx8k3NKFnZL/IYDRl5PXAWLVly1jJhEjDmoRfJmcVlW2AE/2f8PROU03Tv12
	 u9bUyKf/nczPxfm4k2tm9qo4bPLhIaBZ7Tmlq6II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Su <tao1.su@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 176/372] KVM: x86: Clear bit12 of ICR after APIC-write VM-exit
Date: Fri, 24 Nov 2023 17:49:23 +0000
Message-ID: <20231124172016.330891436@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Tao Su <tao1.su@linux.intel.com>

commit 629d3698f6958ee6f8131ea324af794f973b12ac upstream.

When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.

Under the x2APIC section, regarding ICR, the SDM says:

  It remains readable only to aid in debugging; however, software should
  not assume the value returned by reading the ICR is the last written
  value.

I.e. the guest is allowed to set bit 12.  However, the SDM also gives KVM
free reign to do whatever it wants with the bit, so long as KVM's behavior
doesn't confuse userspace or break KVM's ABI.

Clear bit 12 so that it reads back as '0'. This approach is safer than
"do nothing" and is consistent with the case where IPI virtualization is
disabled or not supported, i.e.,

  handle_fastpath_set_x2apic_icr_irqoff() -> kvm_x2apic_icr_write()

Opportunistically replace the TODO with a comment calling out that eating
the write is likely faster than a conditional branch around the busy bit.

Link: https://lore.kernel.org/all/ZPj6iF0Q7iynn62p@google.com/
Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
Cc: stable@vger.kernel.org
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/r/20230914055504.151365-1-tao1.su@linux.intel.com
[sean: tweak changelog, replace TODO with comment, drop local "val"]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2294,22 +2294,22 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u64 val;
 
 	/*
-	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
-	 * xAPIC, ICR writes need to go down the common (slightly slower) path
-	 * to get the upper half from ICR2.
+	 * ICR is a single 64-bit register when x2APIC is enabled, all others
+	 * registers hold 32-bit values.  For legacy xAPIC, ICR writes need to
+	 * go down the common path to get the upper half from ICR2.
+	 *
+	 * Note, using the write helpers may incur an unnecessary write to the
+	 * virtual APIC state, but KVM needs to conditionally modify the value
+	 * in certain cases, e.g. to clear the ICR busy bit.  The cost of extra
+	 * conditional branches is likely a wash relative to the cost of the
+	 * maybe-unecessary write, and both are in the noise anyways.
 	 */
-	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
-		val = kvm_lapic_get_reg64(apic, APIC_ICR);
-		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
-		trace_kvm_apic_write(APIC_ICR, val);
-	} else {
-		/* TODO: optimize to just emulate side effect w/o one more write */
-		val = kvm_lapic_get_reg(apic, offset);
-		kvm_lapic_reg_write(apic, offset, (u32)val);
-	}
+	if (apic_x2apic_mode(apic) && offset == APIC_ICR)
+		kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR));
+	else
+		kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
 }
 EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
 


