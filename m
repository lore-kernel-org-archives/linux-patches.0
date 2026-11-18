Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017405;
	b=yklhBiKKFKXPjO++cWQjjSQ1CX71sWxu3BLyBKnIzes0brGP8MZ5IROP0oSkHnCt2u+v
	 9vmwmHHLbIQ74XAmzac2JFgaVAFjESCyJTh49uGszBunKtiuieybgHRngwFNu7wOg90yL
	 bTySZHT8Es3cRhgSlf97wGIo1DkLVPCfH9sjK0VQCKx7Iy6AnbZsIZ3ZqLy7NzWF7+yc1
	 Vl6jjzgeEMKUzVG0cxpeaeBPBafGr76v2rI8I6EOuntkNlIWdVvMf1OXsmS/upGSiQjnq
	 LN5Xc9lhozleB4Lu6zZA5rDbQRpjZL0HyJlHCrUblRl3d+lKA7jcVMNEfTWceIwvv2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F5dX42bi2J8tgIDWKVzEzO0DPyt6nXmUoDC7s1gv0Jo=;
	b=fSZYfLQhp4BW+QCjZSr+IWb1WTt9mn2YCR7sGwLRrYC4bWD4l/a488F6ytcu80SjFdh6
	 Xy/MSws7cfYp98DXmTovZXvED8zLC72oxN+nx0Q9u2+CHqqbhyl0jhn3UteX5yQllPyPS
	 kSLMVeUCtsbxUMJRKhrD1puqwnglpap/qooKRL9jm77J5blV5BzQrZdhCMjh5o/R9fLam
	 wTKwA5k7iOdCWMpUrSDLs5MGe6kyD4faKqn3FvpSKKQEYpeAoLUFm9YlxQL1eF5edgAIh
	 2GGBdolFSWA+O6N6Ne1BgWigU6r6lx/1U86c8/UgFNPwhgzTmdmsIjEV+cVreuuBEUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2VW+WD5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F0B606A320;
	Wed, 18 Nov 2026 15:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2VW+WD5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB181F000CB;
	Wed, 18 Nov 2026 15:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017405;
	bh=F5dX42bi2J8tgIDWKVzEzO0DPyt6nXmUoDC7s1gv0Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2VW+WD58rnm9/Vc9ShQhiT1oVhzw3EslPjVD7d+3JrodK0ANpXxHeK4zPhCt2bXQ
	 Ve3Ub+cJ0IYhIT8m5FbF5lhVN3LLblIEmfGfMuFxSSGpirHhboq5O8cVuA0WSf1fiK
	 qXK7wM+HraXF7p1DstSVzboGAb6SVMksuQi5QTqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Hao Sun <sunhao.th@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0823/2651] bpf: Fix uninit read for helper mem args on partially spilled slots
Date: Wed, 18 Nov 2026 15:34:23 +0100
Message-ID: <20261118150317.518578751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 04c763aa40094..0c7562f007a80 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7026,7 +7026,12 @@ static int check_stack_range_initialized(
 			goto mark;
 		}
 
-		if (bpf_is_spilled_reg(ss) &&
+		/*
+		 * Only the bytes marked STACK_SPILL hold the spilled register.
+		 * The rest of a narrowly spilled slot keeps its previous type
+		 * and must be initialized on its own.
+		 */
+		if (*stype == STACK_SPILL &&
 		    (ss->spilled_ptr.type == SCALAR_VALUE ||
 		     env->allow_ptr_leaks)) {
 			if (clobber) {
-- 
2.53.0



