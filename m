Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044676;
	b=tBbq3otsLPhLVZMZ8pFSGQX7Swe/Wi+P//R4f57SutiZ14J3Qs1AFH/AQ+uOsGgMgPFk
	 J+7MZTi27DZdpVRXL5FHDCdWXz1e1WqRxu53TT3rNJ1BBCclbbkX079IZuvJP2px86vZl
	 pq605f+TzJnF4+61SRl/EKHOM6wF7q5IoxsYsiDBs1V8B8Tun7EN2jfnTbiEsLiHOmXn6
	 9G5kuMwHlO2rK5+0Kk+gnge4Db/Xtvfn+6gcpzeRSszyn/MPIG/xkwcwNHJ10aXSaOdt/
	 HBEs6VO2wacXeZZAbVAxX7+Z06xu6NRkznImijOMQVbvyFGG8odOzx6jF152J5CHFOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AjjBrN2pf0rxDIjIiP8uisL2OPlmidtR9j8BcL7Wo7k=;
	b=2ODwsSHlrWQznKRgQNTRvjCbyjZaQROYgjDCS8epyDwQKJItqzHOrkvS5bCzusWZEwpl
	 ebBIO52MeKm/qvxf+YWtTn4gbWGYHW1vMsxnPFtAzVVuPth/b/z8yYT0QuG0s/S8OrWxf
	 U49P6jmJKD73ETms0M29lC2WkQSNqSQskO00r0+0Q6ldV6FGHwkR1yPNGDK5Yzk8VnmCZ
	 //4OZFpfZCUaJdxtUgj2cO67UjET+832at04r1B4F0I76AQEyw28OGEKd447xuLJGwHjC
	 zQyFLeuxJ2PCg6S1iQVI0DszgNUD2x5zjWIk5QYRYFNsOAq/UxgnO9rJ1uZIxg0xnVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2jHN1i3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F897606A333;
	Wed, 18 Nov 2026 23:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2jHN1i3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6AA1F000C4;
	Wed, 18 Nov 2026 23:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044676;
	bh=AjjBrN2pf0rxDIjIiP8uisL2OPlmidtR9j8BcL7Wo7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2jHN1i37kNVAdXdblNSEzhcwEUxxD7e4f1tO/FvTlZIH2xAWvZeryyosQf9sN2HT
	 PHLng6KhewYjf6+4488DWVSEDIbjfpvdXTHc0mlMlcp6xsn1fnOqVcB2BmdZc+xNUr
	 Ayv2bmjhhBKuWv+8mQgzZYOnIo9VldudM+toRRds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 0625/2857] KVM: x86: Preserve DR6.BLD (Bus Lock Detect) when delivering #DB payload
Date: Wed, 18 Nov 2026 15:27:39 +0100
Message-ID: <20261118150224.000257565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 719a1d58bf43edd03b271df90b67c58c1e9a7da4 upstream.

Preserve Bus Lock Detect if it isn't present in the payload.  Unlike RTM,
which is explicitly modified on every #DB,  DR6.BLD is modified if and only
if the #DB is due to a (coincident) Bus Lock Detect.

Per Intel's SDM:

  Other debug exceptions do not modify this bit.

And AMD's APM

  All other #DB exceptions leave DR6[BLD] unmodified,

Restore the explicit RTM handling that was clobbered by commit
9a3ecd5e2aa1 ("KVM: X86: Rename DR6_INIT to DR6_ACTIVE_LOW"), as the
semantics of any given bit are feature specific, i.e. are obviously not
consistent for active-high versus active-low.  In other words, while the
bug was technically introduced when support for Bus Lock Detect was added,
it's really that attempt to genericize handling of active-low bits that set
KVM up to fail.

Fixes: e8ea85fb280e ("KVM: X86: Add support for the emulation of DR6_BUS_LOCK bit")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930193634.3415089-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   52 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -574,30 +574,37 @@ void kvm_deliver_exception_payload(struc
 	switch (ex->vector) {
 	case DB_VECTOR:
 		/*
-		 * "Certain debug exceptions may clear bit 0-3.  The
-		 * remaining contents of the DR6 register are never
-		 * cleared by the processor".
-		 */
-		vcpu->arch.dr6 &= ~DR_TRAP_BITS;
-		/*
-		 * In order to reflect the #DB exception payload in guest
-		 * dr6, three components need to be considered: active low
-		 * bit, FIXED_1 bits and active high bits (e.g. DR6_BD,
-		 * DR6_BS and DR6_BT)
-		 * DR6_ACTIVE_LOW contains the FIXED_1 and active low bits.
-		 * In the target guest dr6:
-		 * FIXED_1 bits should always be set.
-		 * Active low bits should be cleared if 1-setting in payload.
-		 * Active high bits should be set if 1-setting in payload.
+		 * DR6 is a mess.  Reserved/unused bits are fixed-to-1, and so
+		 * to maintain backwards compatibility with existing software,
+		 * features that use previously-reserved bits have active-low
+		 * semantics, i.e. clear the bit when the feature is present in
+		 * the payload.
+		 *
+		 * Further complicating matters, some DR6 bits are preserved by
+		 * hardware, while others are explicitly modified on every #DB.
+		 * The trap bits are always set based on the payload, as is the
+		 * RTM flag (but it's active low).  All other bits are modified
+		 * if and only if a relevant debug exception occurs, e.g. BD,
+		 * BS, and BT are never cleared by hardware, and BLD is never
+		 * set by hardware (when supported, excepting RESET).
 		 *
-		 * Note, the payload is compatible with the pending debug
-		 * exceptions/exit qualification under VMX, that active_low bits
-		 * are active high in payload.
-		 * So they need to be flipped for DR6.
+		 * Lastly, the payload does NOT have active-low semantics, e.g.
+		 * so that it's compatible VMX's pending debug exceptions and
+		 * qualification fields, and to avoid bleeding the DR6 madness
+		 * into other KVM code.
+		 *
+		 * To compute DR6:
+		 *
+		 *  1. "Reset" the bits that are modified on all #DBs
+		 *  2. Clear active-low bits that are present in the payload.
+		 *  3. Set active-high bits that are present in the payload.
+		 *  4. Clear fixed-0 bits.
+		 *  5. Set fixed-1 bits.
 		 */
-		vcpu->arch.dr6 |= DR6_ACTIVE_LOW;
-		vcpu->arch.dr6 |= ex->payload;
-		vcpu->arch.dr6 ^= ex->payload & DR6_ACTIVE_LOW;
+		vcpu->arch.dr6 &= ~DR_TRAP_BITS;
+		vcpu->arch.dr6 |= DR6_RTM;
+		vcpu->arch.dr6 &= ~(ex->payload & DR6_ACTIVE_LOW);
+		vcpu->arch.dr6 |= (ex->payload & ~DR6_ACTIVE_LOW);
 
 		/*
 		 * The #DB payload is defined as compatible with the 'pending
@@ -606,6 +613,7 @@ void kvm_deliver_exception_payload(struc
 		 * breakpoint), it is reserved and must be zero in DR6.
 		 */
 		vcpu->arch.dr6 &= ~BIT(12);
+		vcpu->arch.dr6 |= DR6_FIXED_1;
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = ex->payload;


