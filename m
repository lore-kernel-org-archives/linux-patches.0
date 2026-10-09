Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899711A682B;
	Fri,  9 Oct 2026 14:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555992; cv=none; b=kyIqh9F2LuDy2XmGm9a5OGRF7imbiiurTz/OJ2kR3UlS2YaNjU4MoLzN8be+0Fi+l9axkdSzqiABZaau10ML2q6i0eEjLNsuWkHNMEMzrWugE08igjGFlYgWrkWlUJBZ+Neb9H8seEoCl5aE2K5yKBKN+znxLGqYMVtQPhNDfCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555992; c=relaxed/simple;
	bh=zQIkZUB9Zn7CiXc+LprqihRWAwRTkPHTcJw4osoIq6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4FG72SV7eROm93h9MEoaWTuXcecszzhDbAfar6gLm9TQq45KpZbnl6DBSw6kZGilZBBgy/cO+Ne9yPoHSbLSyxXe/d/rUSCXJcfZ7TTZMfXLQ3tz7ssLDVdp4hqT+KoidwlMmunkkOsTIvDlGmjKUxEEQ2hbfrzmdYJL1IFFGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8VoNKGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8VoNKGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2FE1F0089A;
	Fri,  9 Oct 2026 14:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555991;
	bh=Hrf2mcZMkxaxFIVU2ykqOT6XBo5BJ1JTvigJYbA43Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8VoNKGx5TaGAloEfFN3j8d+DiyeYjiKLa4oNK0FApw6HgbCyKOeN81dQ2itnUkAJ
	 dIiqR9Iy8sKbXLTPovlc/ibQdXt9347sfhn5DcbDb7hKvQK5S0WWjwGERCTR9YbXIi
	 SLeyGVt1hfX+kRQ6nG6Q0jbUD6mdB7xIx037GYPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 102/428] bpf: Fix overflow of jump offset in constant blinding
Date: Fri,  9 Oct 2026 16:07:19 +0200
Message-ID: <20261009140948.455710866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit ad139384ecddb6f3e7e3c3c12765aafae0e39670 ]

bpf_jit_blind_insn() rewrites 'if rX op imm goto off' into:

  AX = imm ^ rnd
  AX ^= rnd
  if rX op AX goto off

and subtracts 2 from off when the jump is backward. off is s16, so
-32767 and -32768 wrap and the jump goes 32767 insns forward, past the
end of the prog. The jump is inside the patch, hence bpf_adj_branches()
doesn't check it. The kernel crashes when such prog runs with
bpf_jit_harden=2.

Return -ERANGE in such case. bpf_jit_blind_constants() fails the same
way when blinding of other insns moves a jump out of range.

Fixes: 4f3446bb809f ("bpf: add generic constant blinding for use in jits")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20260924182353.277516-1-alexei.starovoitov@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 71ee96a77ae26..5ec94c370872a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1355,7 +1355,7 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 {
 	struct bpf_insn *to = to_buff;
 	u32 imm_rnd = get_random_u32();
-	s16 off;
+	int off;
 
 	BUILD_BUG_ON(BPF_REG_PARAMS + 2 != MAX_BPF_JIT_REG);
 	BUILD_BUG_ON(BPF_REG_AX + 1 != MAX_BPF_JIT_REG);
@@ -1431,6 +1431,8 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 		off = from->off;
 		if (off < 0)
 			off -= 2;
+		if (off < S16_MIN)
+			return -ERANGE;
 		*to++ = BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
 		*to++ = BPF_ALU64_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
 		*to++ = BPF_JMP_REG(from->code, from->dst_reg, BPF_REG_AX, off);
@@ -1451,6 +1453,8 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 		off = from->off;
 		if (off < 0)
 			off -= 2;
+		if (off < S16_MIN)
+			return -ERANGE;
 		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
 		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
 		*to++ = BPF_JMP32_REG(from->code, from->dst_reg, BPF_REG_AX,
@@ -1599,7 +1603,9 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_verifier_env *env, struct bp
 		if (!rewritten)
 			continue;
 
-		if (env)
+		if (rewritten < 0)
+			tmp = ERR_PTR(rewritten);
+		else if (env)
 			tmp = bpf_patch_insn_data(env, i, insn_buff, rewritten);
 		else
 			tmp = bpf_patch_insn_single(clone, i, insn_buff, rewritten);
-- 
2.53.0



