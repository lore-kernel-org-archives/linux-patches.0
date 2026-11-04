Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831829;
	b=Jm/ES4g8i6+T3KLBGV8xdNCVgYXVu5dKA8CexO5Ilpszoy8O/Sr0tU+G1+q9qhn1AsbB
	 IAJ1r4n5v5MNik+jgRD2BSz9SOLgrGsxrdKdkr+nA7W3Q4ZFTF+Y8XoXJ8Ut7kOE4cn7Z
	 +S0SIUqf06eAg7a8UYCIHO8MWvmSyxfnv1iTaJH0QYWO+OMWZY/LAP5zI8ubhybpNPx/1
	 0BCQ38qQgMY11hFZHgi+alj+jVpghrMKVBDkzn1sbFLg1TG9YFhILZ2M1gUHig9GP57VV
	 BwoGThKTYfLy/Vy55z8q9ZMkROpEuoE/7LXcKX/k3lTk0oBWGccRRnduL9XXmUaQdcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K95J88q/3lAL2Sl/1SguCjUF1nR53eY7iD1afPMltMM=;
	b=2dHb9JmOxdlgd408yFue3BJrmhArSHbJJGvIi1fPMHax6mO52js/qbuP5YCsp40gr2lu
	 m+mahBVG7vOKW1K3pHo9N/JSD12EMV40MeO7hGw10T3Ge6KZ4xAhJW6qw8wljHTBPN7ak
	 1c+0sYCKORgEOKoozC5Te2kNjwAIb5ZAi/EGbjJgrNDnLF0z0htKPgLLAwxNdPpqY2boK
	 kfwvXQnMJjHVSQvLR4rEcu+kI8wdRRuhrJKXDC441t/sZAgp9DDC6Ju2leMc4coM8dATa
	 okLlL3nQvoTJPimODWhMLmwQfJlticp0EjfSk+SikVhy/KLqxT7Bg3yjnW7/9uqFZkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MNgfMsHN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C86F606A878;
	Wed,  4 Nov 2026 22:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MNgfMsHN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2081F000C1;
	Wed,  4 Nov 2026 22:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831829;
	bh=K95J88q/3lAL2Sl/1SguCjUF1nR53eY7iD1afPMltMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNgfMsHNu/B6MvqDnBCRGPbNeM9yaMt/STrgxxivtQkDzE0EyJg5ZdmXj05QuVzYD
	 uXyDPmKEn+RNW5uB44z5ZumI6DW1NRmAKStvfyHayYT1iZA0IxPB15K762jEX/RSrl
	 vhzsoY542J7lBSqlGGan0r4pWE8CAVe0y0DxaY6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0936/1005] KVM: x86: Preserve DR6.BLD (Bus Lock Detect) when delivering #DB payload
Date: Wed,  4 Nov 2026 16:11:09 -0500
Message-ID: <20261104211109.350187693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -770,30 +770,37 @@ void kvm_deliver_exception_payload(struc
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
@@ -802,6 +809,7 @@ void kvm_deliver_exception_payload(struc
 		 * breakpoint), it is reserved and must be zero in DR6.
 		 */
 		vcpu->arch.dr6 &= ~BIT(12);
+		vcpu->arch.dr6 |= DR6_FIXED_1;
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = ex->payload;


