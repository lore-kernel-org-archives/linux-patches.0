Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E27487A7;
	Mon, 14 Oct 2024 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918357; cv=none; b=KLkv3McV/quRJGhpFfy7U4ZlIctU5nacJgYrj0qArqkr+ohTgcikqstYyQt3S/9TSOsf2f7c74mJrRroFm83mdmL7Gy+R/I8po+WhmFmU5td5QhDtyyArnlstivdXbU8EBM+bFX1ziAypVqQHfrWZP9ROCuC6kbtacqgt9WhoYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918357; c=relaxed/simple;
	bh=Ec+Nh7rIBfp7PVszjgQrQ3FicGSxW2geZnX9rYQNkV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtXAJeXutEgy7GvIvNt7L8spOQ9pPBzZd69h/8dwnMZO4Y50+e/4WPvoOHdAm4/A/xPFSMnPsDjne9euEv+NwMW5Ef3YGNDcXoh1lnPHwD40G6mnFu/CaDVULzzxvltXCEh9SZiOMi4SrV64vRlLNTzzmcNGtnz7xBu9aUzMegE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyriphnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyriphnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46654C4CEC3;
	Mon, 14 Oct 2024 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918356;
	bh=Ec+Nh7rIBfp7PVszjgQrQ3FicGSxW2geZnX9rYQNkV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyriphncNlONSyfEuvJGKUWYnZ4wI0kVg5vAUKme8F5GBRarbOrphawaIxOt6qHxG
	 D7vEOneodn9zEewYW+pIc16u8okZq6skViFt6kD+UpPuBm55uarxcC4Su4VI02jE3r
	 76spDPCFnJbz2nL4CiTjo4HOduqERRvQQJAmk4gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 291/798] KVM: x86: Enforce x2APICs must-be-zero reserved ICR bits
Date: Mon, 14 Oct 2024 16:14:05 +0200
Message-ID: <20241014141229.376290512@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

commit 71bf395a276f0578d19e0ae137a7d1d816d08e0e upstream.

Inject a #GP on a WRMSR(ICR) that attempts to set any reserved bits that
are must-be-zero on both Intel and AMD, i.e. any reserved bits other than
the BUSY bit, which Intel ignores and basically says is undefined.

KVM's xapic_state_test selftest has been fudging the bug since commit
4b88b1a518b3 ("KVM: selftests: Enhance handling WRMSR ICR register in
x2APIC mode"), which essentially removed the testcase instead of fixing
the bug.

WARN if the nodecode path triggers a #GP, as the CPU is supposed to check
reserved bits for ICR when it's partially virtualized.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240719235107.3023592-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2314,7 +2314,7 @@ void kvm_apic_write_nodecode(struct kvm_
 	 * maybe-unecessary write, and both are in the noise anyways.
 	 */
 	if (apic_x2apic_mode(apic) && offset == APIC_ICR)
-		kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR));
+		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR)));
 	else
 		kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
 }
@@ -2936,8 +2936,21 @@ int kvm_lapic_set_vapic_addr(struct kvm_
 	return 0;
 }
 
+#define X2APIC_ICR_RESERVED_BITS (GENMASK_ULL(31, 20) | GENMASK_ULL(17, 16) | BIT(13))
+
 int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
 {
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
 	data &= ~APIC_ICR_BUSY;
 
 	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));


