Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053207;
	b=UNzIDcDwHztc96YHLVoRfNIQCTnIrVRB2Dfl6p724sZqt61KFeuM6FnDhDL6CcdOGQ7g
	 dmLffRUkpR/SE8cBiADmnWIgX2QwCdjji32UEBWoSSOi27zoF76IKw1RH21ods5GsDUvX
	 A6B/5A65yUixP+328R9rOargevsPdEY4pMl6//7CiH04PEJC9y5/QxrQ7GGfeDE7PC1SV
	 0ja2k7xQVgdKoefExlyQIG9S970Us3n5UOYhmRkwnYsnlFPF9dWxh2UhzEJ71zJuWGXHF
	 1SNxgWA3UtfLiNziY6HAVOA+eLvB1A8sr8awb58VasMZoKPRoAzgfXJpSeV1J9Op6Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hLuN0cHl51ejlxRaHdDZlhPT38jMsd5IR+l01BnAae4=;
	b=xxH4A8HGAvuVS3o3Z4BMr5gArWX4AoXOWNxs+xcwlR7J4t/dmttBM5aKPU6wyjMScOQa
	 sq6eokmnY5leG8um6seIzXM/Ay3b8uc80tU1Ip5fD3Na2Z9DasIW+TBnsbKj2Y6LNbaPb
	 4bxMId9Mk3NIPYbblOC1nEYrThRUIM4y7Tqy0mm7FPHySVi43zuH8AkH7z8+HnpMB7ynK
	 RDkwMfhydfAsdu67R4z3dmNm/2PZoz8SV+tJ6bnaZfXG0cpVeJAekMBWgR0oQsG5KIYqm
	 HjTmhKWGFDNxy7/4rsyh6gEgmhYrUEqjyL+A70ncQzDlZwpebm1nISlmdxnwGbyGdPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yupY4AVJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2484E606A31C;
	Thu, 19 Nov 2026 01:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yupY4AVJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EE11F000C4;
	Thu, 19 Nov 2026 01:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053207;
	bh=hLuN0cHl51ejlxRaHdDZlhPT38jMsd5IR+l01BnAae4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yupY4AVJIrO+8aBAYtRBfTGZgs9FZNXO4J3cOIgKu8danlmLrskMUsk8pDT3KT7jx
	 GU2wRd+vNjQkCZmP7+EeZI4+EFdwQrdixDNVV+Th+XUh3OH9IRSdTj9UWpM5tjSKqi
	 ZVS7CuagkLj7L86zbyqDRNh2OiG1vl7jX2GP2MAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0790/2214] KVM: x86: Preserve DR6.BLD (Bus Lock Detect) when delivering #DB payload
Date: Wed, 18 Nov 2026 15:41:06 +0100
Message-ID: <20261118150043.170851036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 719a1d58bf43edd03b271df90b67c58c1e9a7da4 ]

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
[ sashal: Replaced ex->payload references with the local payload variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 52 ++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99f58a57280a4..ccbd27f496488 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -569,30 +569,37 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 	switch (nr) {
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
-		vcpu->arch.dr6 |= payload;
-		vcpu->arch.dr6 ^= payload & DR6_ACTIVE_LOW;
+		vcpu->arch.dr6 &= ~DR_TRAP_BITS;
+		vcpu->arch.dr6 |= DR6_RTM;
+		vcpu->arch.dr6 &= ~(payload & DR6_ACTIVE_LOW);
+		vcpu->arch.dr6 |= (payload & ~DR6_ACTIVE_LOW);
 
 		/*
 		 * The #DB payload is defined as compatible with the 'pending
@@ -601,6 +608,7 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 		 * breakpoint), it is reserved and must be zero in DR6.
 		 */
 		vcpu->arch.dr6 &= ~BIT(12);
+		vcpu->arch.dr6 |= DR6_FIXED_1;
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = payload;
-- 
2.53.0



