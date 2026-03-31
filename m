Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B7629DB8F;
	Tue, 31 Mar 2026 16:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976248; cv=none; b=YAveTQcl3/OchLlfW6fohd/rI4paDyIqqYw8nAwOAb9LBKbfg0/JQ3aVlnDMXI0CUEY85L3tGSn4oy9xWkT//wapvabaT/P9XPCIJzlGRYbhwHDGYGhInQDi5+CQQjGJ1+G703XHKLl1qTPQvlO9z5mrtkoQHi7OZU4mXOO4HMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976248; c=relaxed/simple;
	bh=ARdb5eLY2bB2tu3sIhs3XLgHQK+7S0Q9PTT1EezfBl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uglI0WdSnqsxHflTKPAJwFwiR2HKQfvOt0vP+RC5yaR3znPV2KH27tvSS60zellMcyBxcugyGhzs43wEerHxEvyeAY3TiPerDLijVKNHD1kHjB7S9oHNKYF/+ZoSEBIRA+q4olRxJtlN3rBeh2atqOqbM82gRR8ZJ57IIN30mSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yW1ovmUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yW1ovmUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB15C19424;
	Tue, 31 Mar 2026 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976248;
	bh=ARdb5eLY2bB2tu3sIhs3XLgHQK+7S0Q9PTT1EezfBl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yW1ovmUjX3zJcxeJnUjPWDzehxzjEcB0hRNakf4+ByLguq8dVrOmOLQ2B8s6/5lrg
	 hkCekQ+d0PK3LDOlPHOac4LH74WAG6Ecig0UvPY/LBCJ5UkAM3L3H1wz2dRkBZNA+/
	 we5pe9fPKEKzvyN2hvyiVBFiGBMc1WXuzZsaV6VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Laporte <glapt.pro@outlook.com>,
	Tianci Cao <ziye@zju.edu.cn>,
	Shenghao Yuan <shenghaoyuan0928@163.com>,
	Yazhou Tang <tangyazhou518@outlook.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/309] bpf: Reset register ID for BPF_END value tracking
Date: Tue, 31 Mar 2026 18:18:25 +0200
Message-ID: <20260331161753.564387320@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazhou Tang <tangyazhou518@outlook.com>

[ Upstream commit a3125bc01884431d30d731461634c8295b6f0529 ]

When a register undergoes a BPF_END (byte swap) operation, its scalar
value is mutated in-place. If this register previously shared a scalar ID
with another register (e.g., after an `r1 = r0` assignment), this tie must
be broken.

Currently, the verifier misses resetting `dst_reg->id` to 0 for BPF_END.
Consequently, if a conditional jump checks the swapped register, the
verifier incorrectly propagates the learned bounds to the linked register,
leading to false confidence in the linked register's value and potentially
allowing out-of-bounds memory accesses.

Fix this by explicitly resetting `dst_reg->id` to 0 in the BPF_END case
to break the scalar tie, similar to how BPF_NEG handles it via
`__mark_reg_known`.

Fixes: 9d2119984224 ("bpf: Add bitwise tracking for BPF_END")
Closes: https://lore.kernel.org/bpf/AMBPR06MB108683CFEB1CB8D9E02FC95ECF17EA@AMBPR06MB10868.eurprd06.prod.outlook.com/
Link: https://lore.kernel.org/bpf/4be25f7442a52244d0dd1abb47bc6750e57984c9.camel@gmail.com/
Reported-by: Guillaume Laporte <glapt.pro@outlook.com>
Co-developed-by: Tianci Cao <ziye@zju.edu.cn>
Signed-off-by: Tianci Cao <ziye@zju.edu.cn>
Co-developed-by: Shenghao Yuan <shenghaoyuan0928@163.com>
Signed-off-by: Shenghao Yuan <shenghaoyuan0928@163.com>
Signed-off-by: Yazhou Tang <tangyazhou518@outlook.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260304083228.142016-2-tangyazhou@zju.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 648c4bd3e5a92..1280ee4c81c33 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15431,6 +15431,13 @@ static void scalar_byte_swap(struct bpf_reg_state *dst_reg, struct bpf_insn *ins
 	/* Apply bswap if alu64 or switch between big-endian and little-endian machines */
 	bool need_bswap = alu64 || (to_le == is_big_endian);
 
+	/*
+	 * If the register is mutated, manually reset its scalar ID to break
+	 * any existing ties and avoid incorrect bounds propagation.
+	 */
+	if (need_bswap || insn->imm == 16 || insn->imm == 32)
+		dst_reg->id = 0;
+
 	if (need_bswap) {
 		if (insn->imm == 16)
 			dst_reg->var_off = tnum_bswap16(dst_reg->var_off);
-- 
2.51.0



