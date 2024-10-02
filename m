Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCCE1D0BAA;
	Wed,  2 Oct 2024 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876706; cv=none; b=a7iCj0NWG0dQTy2OVqeUmpYcH5YAQ7//mi9D/4YrKtoceLr3oYv0qmZBE3yOYPQQOO41srlU9Y4XeZiwashA851H3O4viM7T4JkL+eBL8bDF7wGcqcUIy5biC7iAH94+2AOdqB+aprpmVkV3ExyyrhW/nYKAe0wUuZJAWBzMA7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876706; c=relaxed/simple;
	bh=UWGU9umq8yFz112rDmBd/OZH7TdKsJjcQ62ItS9bt7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9Kf2IRN7CYckkRIYz3P5m82tidaq04lXzPanvaPef/1ukQLaUq602VDE/kp67b8lD2V1Tkq57etK+LdrjzvAI2o8Vet6RysHW8c46cv4SvWj9ufdhdRRpZWVRI4d4lh+BaNGFHGomlPFuS/ErHZflcBnO3baOZ0rQTumEyuzak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwv6k4ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwv6k4ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152D3C4CEC5;
	Wed,  2 Oct 2024 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876706;
	bh=UWGU9umq8yFz112rDmBd/OZH7TdKsJjcQ62ItS9bt7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwv6k4ZKZD9COQZT0BSTJtoESEYGE4i5M9txtLLbLrHDy/+86k6AzN6CYeLU3rtDW
	 wOQejwrlzWGO0Z/5bcBPQ7IlcbA71+bjWVSM5YeCW21gVrpYiZ5sBLgFnQ0prpznuO
	 GKjD12ezYpBtr5+yz4+koXAhsrVpJYzOVZTeEOus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.11 536/695] KVM: x86: Move x2APIC ICR helper above kvm_apic_write_nodecode()
Date: Wed,  2 Oct 2024 14:58:54 +0200
Message-ID: <20241002125843.895426429@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit d33234342f8b468e719e05649fd26549fb37ef8a upstream.

Hoist kvm_x2apic_icr_write() above kvm_apic_write_nodecode() so that a
local helper to _read_ the x2APIC ICR can be added and used in the
nodecode path without needing a forward declaration.

No functional change intended.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240719235107.3023592-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2453,6 +2453,29 @@ void kvm_lapic_set_eoi(struct kvm_vcpu *
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
 
+#define X2APIC_ICR_RESERVED_BITS (GENMASK_ULL(31, 20) | GENMASK_ULL(17, 16) | BIT(13))
+
+int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
+{
+	if (data & X2APIC_ICR_RESERVED_BITS)
+		return 1;
+
+	/*
+	 * The BUSY bit is reserved on both Intel and AMD in x2APIC mode, but
+	 * only AMD requires it to be zero, Intel essentially just ignores the
+	 * bit.  And if IPI virtualization (Intel) or x2AVIC (AMD) is enabled,
+	 * the CPU performs the reserved bits checks, i.e. the underlying CPU
+	 * behavior will "win".  Arbitrarily clear the BUSY bit, as there is no
+	 * sane way to provide consistent behavior with respect to hardware.
+	 */
+	data &= ~APIC_ICR_BUSY;
+
+	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
+	kvm_lapic_set_reg64(apic, APIC_ICR, data);
+	trace_kvm_apic_write(APIC_ICR, data);
+	return 0;
+}
+
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
@@ -3194,29 +3217,6 @@ int kvm_lapic_set_vapic_addr(struct kvm_
 	return 0;
 }
 
-#define X2APIC_ICR_RESERVED_BITS (GENMASK_ULL(31, 20) | GENMASK_ULL(17, 16) | BIT(13))
-
-int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
-{
-	if (data & X2APIC_ICR_RESERVED_BITS)
-		return 1;
-
-	/*
-	 * The BUSY bit is reserved on both Intel and AMD in x2APIC mode, but
-	 * only AMD requires it to be zero, Intel essentially just ignores the
-	 * bit.  And if IPI virtualization (Intel) or x2AVIC (AMD) is enabled,
-	 * the CPU performs the reserved bits checks, i.e. the underlying CPU
-	 * behavior will "win".  Arbitrarily clear the BUSY bit, as there is no
-	 * sane way to provide consistent behavior with respect to hardware.
-	 */
-	data &= ~APIC_ICR_BUSY;
-
-	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
-	kvm_lapic_set_reg64(apic, APIC_ICR, data);
-	trace_kvm_apic_write(APIC_ICR, data);
-	return 0;
-}
-
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
 {
 	u32 low;


