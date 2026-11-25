Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622451;
	b=487WnXUinqgQ60LsTWfK3sDy/bRHMc8p442ZDdf0iosVWgEuaxD4Tgw/Hjipcg7zF3am
	 XVaW8bPkDgeX25ELTGX+b+19JnvucrB8ZHMmvAod2SByrm5iY73O/FgPyOpeE8uy2aP6o
	 GCpjCF5AxUYJXBTHpYAxUnuR33bAx+P1/FWtHMI0Wnul7E1zVhI5pYLE5V6d49enx+UXa
	 BG/MeKlQc20UPRLbUbn3yG61bfIBuK7p2nPu58lEHVXQkYEzfyiOGx73fWxrrxqK3209J
	 apjfWFWwT9x4YVBzT6ObgHVU8ge4H2u3jjs4TJ1b/P0FjIzMRh056tAdLb0NwNp9RTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lqggNljsQBRwcpSe8HhGysSvYzFScyXynqgbub9WJ8o=;
	b=IwYVaydUzSA3qR4lHZPm1MiL+XW6ygc/jbkC8burnPERZMAuTQH8CrjPxXQT5a7cNgG0
	 KkUZnW0QWFs4YaHMntY+OmH1qY4Bf1CpSkHiftW3Qi2Rrk6zIfXeqsnCbHb5sB+Iqr0VC
	 7vBb6OGIjvr/VaxTrygm5flalKW1b7IDsXAxTR2SxW9H/Wkb9YkTU+4wxcvhEQCmsJRiJ
	 pKXzhIyOu8s794OkYWmNNAMAYUfkc3zLqC68g7ukmUAsrIDK219WDhpAj2ttIBFeEgqdj
	 sWTx6G1r2Z2VujZnbZp26K5KaGyz96IULBYOB6mFFVjP0PJhbNtOZsy8U6AvFpx9IPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UnyE1QMa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152FE606A31E;
	Wed, 25 Nov 2026 16:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UnyE1QMa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1215F1F000CF;
	Wed, 25 Nov 2026 16:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622450;
	bh=lqggNljsQBRwcpSe8HhGysSvYzFScyXynqgbub9WJ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnyE1QMail1ScMchwtsrUTJe3yXgZIXDzRTqkQQo3BKkIT8xEcvdKeQcziK476PI0
	 xmZC/oetSKfWVgW7mxgymagY25FGXLP5p+tbWHZF26FqchAQsNIcuCfR+x92TwexGe
	 0+HNOsXwrjxuv64qZ02XyF75a2O9LnvqaYooMdhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Hao Sun <sunhao.th@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 540/990] bpf: Fix uninit read for helper mem args on partially spilled slots
Date: Wed, 25 Nov 2026 15:31:47 +0100
Message-ID: <20261125143834.743734086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

[ sashal: Context lines differ because the target tree still uses is_spilled_reg() on state->stack[spi] where upstream uses bpf_is_spilled_reg(ss); the patch was applied by hand with identical added and removed lines. ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c8a72c96e227a..23c1401a97bdf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8318,7 +8318,12 @@ static int check_stack_range_initialized(
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



