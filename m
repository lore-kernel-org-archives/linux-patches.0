Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66243F166E;
	Wed, 20 May 2026 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297116; cv=none; b=rwkpgIOagCi06mx2yegBVB93LCdvffNC60Ezgr4kkhashDW+FG10SH600FP3pUDV3iz6mUEOfmIkE+HV2wuvMuk/85Nq/G/QUgLy7O6OHYm1KHJ6+6G1QoQ81VJoQ2EgJtNCmNUqH3dDH2WxQazwl0Ugd4sPgnfwzp6lXAn5QvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297116; c=relaxed/simple;
	bh=YMdWdGkSAcaFj9yXfnqEZ3DV1xrQ7K1qlGaxJhSm5is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUzNTwYerLCo2IOwt06wIWeQcZKbKSpIUTi5JoOfvMlPQ3kZyaiJ1eQWTUTLBNFd1LL8gSSBA44StlbfSQ19tXkJCYVvTxnyhVZbGPpeII4r6n1GvDUONNPp+rseBoEqp02pHP6SisKWnjjoA5Ce02movXIa4eYpBi8HgI6231E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUyDBBv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUyDBBv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571CF1F000E9;
	Wed, 20 May 2026 17:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297114;
	bh=AZ1MvCsjOwL0gcVRFfYrZUdnn2MTKlb5/cZ5YU9KsZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUyDBBv5r3Zt+1UCGcZmx6z6ovSlrG+iTKs4PIoL7wKZ/GE1RCxt11Wfv2n57uBP1
	 LhGPHuOWU73flTZkdXEalbAGSznySrJAbz9HRKzVY8bIVSzkie1LbXjAGkSA6NglaH
	 S7GZOTcDyySVNhuiWDB7d0xeDeb8l+ora3fJY9aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Eads <josheads@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.0 1057/1146] KVM: x86: Swap the dst and src operand for MOVNTDQA
Date: Wed, 20 May 2026 18:21:47 +0200
Message-ID: <20260520162212.154664663@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 3098c076c83ea2913245cb915cdcba98eb24214c upstream.

Swap the MOVNTDQA operands, as MOVNTDQA does NOT in fact have "the same
characteristics as 0F E7 (MOVNTDQ)"; MOVNTDQA loads from memory and stores
to registers, while MOVNTDQ loads from registers and stores to memory.

Per the SDM:

 MOVNTDQ - Move packed integer values in xmm1 to m128 using non-temporal
           hint.

 MOVNTDQA - Move double quadword from m128 to xmm1 using non-temporal hint
            if WC memory type.

Reported-by: Josh Eads <josheads@google.com>
Fixes: c57d9bafbd0b ("KVM: x86: Add support for emulating MOVNTDQA")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260506213514.2781948-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4469,7 +4469,7 @@ static const struct opcode opcode_map_0f
 	X16(N), X16(N),
 	/* 0x20 - 0x2f */
 	X8(N),
-	X2(N), GP(SrcReg | DstMem | ModRM | Mov | Aligned, &pfx_0f_e7_0f_38_2a), N, N, N, N, N,
+	X2(N), GP(SrcMem | DstReg | ModRM | Mov | Aligned, &pfx_0f_e7_0f_38_2a), N, N, N, N, N,
 	/* 0x30 - 0x7f */
 	X16(N), X16(N), X16(N), X16(N), X16(N),
 	/* 0x80 - 0xef */


