Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625164;
	b=v79ZdA5KtA/khlpx1wnNGVd1mIXaXWD5Ubs+DA26Zl1UZPizM4PZL8ef0jtmZLBc69Lh
	 AYz5RvavPPMh9igi36FjjpqHNa3cJpk8eAAGDhDTh9MQqPsFeFC3FjdMW1ISW69a6JPRt
	 lT5XQ0SgqXKXHl2maJm/yNj1cwVqvpclLKOpp0OXCFa28Ujjtz1H260A0VTsp+QM40CLB
	 1q5qw1MGRxlXfTbT4So2Nw/ko2ogbaRUgvmX8YhTA+VfTxILr4/CWg5yJyPrw5KbTWDtv
	 aVC7IWBuokt28SL4A8aAjiVtSCqoSTRBtxWglGHeToKSIZNXcT7lPk5TAazntnp+92w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MtTsc/ey/CqXFVUGITNeSta7clININdKBZxNWxFltyk=;
	b=v5zVUuPLLp9Lwe2oYIWzlhWLmD53dJ2VK15gcLBMv/lo0QxC3HiVp+UyzDqtsX1CiyY0
	 erOsYLXE3czw6KI0gEVwmIHvpuryMZJDsWocUy7ZUkPVkkO/WFdm7oSY6uBe+FEBIX/Sn
	 4DDfRK/xysLO86FCV1eTUKQqdf4HanfKTSBODvH3Zm8tKQsYKYltMx59vMLwt8DDpfUu2
	 1VPbwW0KWGUlZCC+jT8hmYTJor0AJCa95ephnox/riW5P8F166dF5Lg74SNbl4O8tgKcC
	 hqJQVMVgG1EFK9SBSd/J6yAsbETUwa2NS5ylEODP3OfiZn16lG7gQPgeeFyNCtN2u3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asWkUfeZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2B4606A321;
	Wed, 25 Nov 2026 16:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=asWkUfeZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E00A1F000EC;
	Wed, 25 Nov 2026 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625163;
	bh=MtTsc/ey/CqXFVUGITNeSta7clININdKBZxNWxFltyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asWkUfeZlJOO0+gNhn8CShBuHrwZdOoCqlKA327F7zs751FbFgMIkka+nqmrCIQRx
	 7kPfrMzVBycMLGygWBNgUHLOygwb+k3M5wkp1wa3n6h4md67S4wZtRxf2b6p+3XzCZ
	 QUjZtZ4JtJ+hpUnfxoaHDjBMzfBZ1rfeMi3xKIhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Hao Sun <sunhao.th@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 428/816] bpf: Fix uninit read for helper mem args on partially spilled slots
Date: Wed, 25 Nov 2026 15:32:56 +0100
Message-ID: <20261125143859.100764049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Sun <sunhao.th@gmail.com>

[ Upstream commit b3861495d2b2f7459cddf49e63fa0758ba430583 ]

check_stack_range_initialized() takes the spilled register path when
bpf_is_spilled_reg(ss) holds, which, however, only looks at the last
byte of the slot. Hence, a partially spilled scalar (on the lower part)
bypasses the check and the following loads:

0: (b7) r1 = 1                        ; R1=1
1: (63) *(u32 *)(r10 -8) = r1         ; R1=1 R10=fp0 fp-8=????1
2: (18) r1 = 0x0                      ; R1=map_ptr(map=rb,ks=0,vs=0)
4: (bf) r2 = r10                      ; R2=fp0 R10=fp0
5: (07) r2 += -8                      ; R2=fp-8
6: (b7) r3 = 8                        ; R3=8
7: (b7) r4 = 0                        ; R4=0
8: (85) call bpf_ringbuf_output#130
...

When executed, it dumps the uninit four bytes:
	RINGBUF: 01 00 00 00 ff ff ff ff

This is the same root cause as the non-fetch atomic case fixed in
commit 5a84b4424db8 ("bpf: Fix uninit read for non-fetch atomics on
partially spilled slots").

Fix by only taking the spilled register path for the bytes marked
STACK_SPILL, so the rest of the slot goes through the usual checks.

Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Link: https://lore.kernel.org/bpf/20260925082814.1554771-1-sunhao.th@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 63bb703e0a64d..8666fb0ea3b75 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7812,7 +7812,12 @@ static int check_stack_range_initialized(
 			goto mark;
 		}
 
-		if (is_spilled_reg(&state->stack[spi]) &&
+		/*
+		 * Only the bytes marked STACK_SPILL hold the spilled register.
+		 * The rest of a narrowly spilled slot keeps its previous type
+		 * and must be initialized on its own.
+		 */
+		if (*stype == STACK_SPILL &&
 		    (state->stack[spi].spilled_ptr.type == SCALAR_VALUE ||
 		     env->allow_ptr_leaks)) {
 			if (clobber) {
-- 
2.53.0



