Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D272E1624D5;
	Tue, 31 Mar 2026 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974718; cv=none; b=QfzAwi+LvGAQIe4OuLdB85gkAVMGuEIfB5za0h0b+1lgNYChamzU72cOgfgaXmx4kfJ0VbapqTp5fHHconTJPAENI8PsyWElFRoFHxnWggagVwxi3NGFqeJY1B8bXtcMsv7FIAor4n/ISTXuRYC78I0jRrpp2YP2tA8mvfFvO2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974718; c=relaxed/simple;
	bh=LwIfEMW4pcQZua0sZjtHefSjW+4iXdNFbF4gUkTO9Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XShw+d2cKpcX7Eh+/eWCoipy7PgZaBwKksw1Jz/lyr4sv0KbXuhMGdATybYcSwM1+/DeiqVznVz1K6/+DflDIJrn9sPqu9+VksPAIHwS1Be0av6tEO/YgoB9Vsb4+znuS4tUn8RKYC1hvRE3TFKVIC48ZTptST3MAPxn1teTTYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVhvgpLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVhvgpLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DCFC19423;
	Tue, 31 Mar 2026 16:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974718;
	bh=LwIfEMW4pcQZua0sZjtHefSjW+4iXdNFbF4gUkTO9Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVhvgpLkNnehIICyUF8el1c6C4qMJaPkIOACEp+foizgPfm5znah5GUb707ypKjbX
	 axIsJYC0XHVo08BEmm1e0JxZlt3k1D2JEoEh3a9Ueuaumz83+Kbx+HRDKINZ/XU7p9
	 tHcJ2+gfMP9zIXH7QRAZ/71KQTJG8v/HlsEWtF+Q=
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
Subject: [PATCH 6.19 003/342] bpf: Reset register ID for BPF_END value tracking
Date: Tue, 31 Mar 2026 18:17:16 +0200
Message-ID: <20260331161759.038670992@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9c4723cdac700..bf721a1274799 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15512,6 +15512,13 @@ static void scalar_byte_swap(struct bpf_reg_state *dst_reg, struct bpf_insn *ins
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



