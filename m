Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9863B3368B6;
	Wed, 20 May 2026 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300984; cv=none; b=QILVxc2gvgieqJoi6Ayus87N48SpXMD52aG49B7glpn8gfjBwM/C5N/Vv3dYGe8U+hr5bvOCIGYS3HeBsqeH0Cj2R8rhPhWWRY7V7p4ELXQiNqNQuOW7vVjqUydksAql0ISnEvuyO/lqMRycMNtvnPd1/mSEnTN7EfylGRiPQKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300984; c=relaxed/simple;
	bh=lz89CanfFajLvbMfMNJT7eUY9WojD3LXu+PvZWHwSfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lmj9LkV0ZqinN2v11muVyHU/mVDE4c75IC6WmwK+F2l8vbkKAvgZAhPqkfsEt3iD5gat+shFqTFk4gYqUyKzLvjPwSm11/Y+o6mlbKmWomqktt2jW2pbo9PWtewA7sPf4WK8oLD+sB7k+UqOHB9e5c1szRlHMGyxhrKpU23sMAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bV4jFR7P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bV4jFR7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4021F00893;
	Wed, 20 May 2026 18:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300983;
	bh=r9i+8HR70KnhYQ5tJaY2TPFr+BDpsYlKMmdJMzZ1hjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bV4jFR7Pbd2zg4Ns7VyKEiVwkcDvX5nhwDNEyAAhUPrJPyIb97RALH+Vz0vvm98Rr
	 jt9vpivbEv+EYTuR2E1x6YNKZ3AuKFIciDxI3hLX00CRT0sJrDtYP9s05DA2XD9UtB
	 BnU2r7smclEe5tHrZDWsP6FF4OrTz2GyWcY3olhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 345/666] bpf, arm64: Fix off-by-one in check_imm signed range check
Date: Wed, 20 May 2026 18:19:16 +0200
Message-ID: <20260520162118.709133571@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 1dd8be4ec722ce54e4cace59f3a4ba658111b3ec ]

check_imm(bits, imm) is used in the arm64 BPF JIT to verify that
a branch displacement (in arm64 instruction units) fits into the
signed N-bit immediate field of a B, B.cond or CBZ/CBNZ encoding
before it is handed to the encoder. The macro currently tests for
(imm > 0 && imm >> bits) || (imm < 0 && ~imm >> bits) which admits
values in [-2^N, 2^N) — effectively a signed (N+1)-bit range. A
signed N-bit field only holds [-2^(N-1), 2^(N-1)), so the check
admits one extra bit of range on each side.

In particular, for check_imm19(), values in [2^18, 2^19) slip past
the check but do not fit into the 19-bit signed imm19 field of
B.cond. aarch64_insn_encode_immediate() then masks the raw value
into the 19-bit field, setting bit 18 (the sign bit) and flipping
a forward branch into a backward one. Same class of issue exists
for check_imm26() and the B/BL encoding. Shift by (bits - 1)
instead of bits so the actual signed N-bit range is enforced.

Fixes: e54bcde3d69d ("arm64: eBPF JIT compiler")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20260415121403.639619-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 9310196e0a09e..c852749405e0c 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -33,8 +33,8 @@
 #define ARENA_VM_START (MAX_BPF_JIT_REG + 5)
 
 #define check_imm(bits, imm) do {				\
-	if ((((imm) > 0) && ((imm) >> (bits))) ||		\
-	    (((imm) < 0) && (~(imm) >> (bits)))) {		\
+	if ((((imm) > 0) && ((imm) >> ((bits) - 1))) ||		\
+	    (((imm) < 0) && (~(imm) >> ((bits) - 1)))) {	\
 		pr_info("[%2d] imm=%d(0x%x) out of range\n",	\
 			i, imm, imm);				\
 		return -EINVAL;					\
-- 
2.53.0



