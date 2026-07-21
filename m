Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C119939A815;
	Tue, 21 Jul 2026 15:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647786; cv=none; b=bHk9lOo/s5o0sRn5KMpdLHToCa3Ch4YReLlNhJOXN77B+ITQsonNglydur89JgugJL4E4OtmggaxcMEJlC16pGMRNaCyZyO8YxYSwSuum3RwwCpWzANNfFMZLfHkXEQPKzWrPdq5FuXkfBS1uWmY5qpo1QhaJoqYWi0Hs+KKgJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647786; c=relaxed/simple;
	bh=YZ3OXjdEyxd0Mig/dc+uI4LBcdwQ/44hXI7cGnu5Y50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VORNCKgpFgzAXVwNYptN5OACUU6rwDdpqMWWsGPc/UwzmNdbBZyFN2b7EHLJLjaH6cXz7fj1uUQKLZE6CKtBfQzoNLAtBUVy/bS08NVEopDq+hKNEuFwO8eKdHlz6pQLmsAZssucION7AYctzNMPWxMYPiDpoqwQe4pN24aEdfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7YaMO54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7YaMO54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBE11F00A3A;
	Tue, 21 Jul 2026 15:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647785;
	bh=BUB4BO6K3KsVNo+JYr4YG1fgs73LMgBJM3JYH48JKow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7YaMO54Gh0aaM5VzVErFsoBiUtq/JnyQKMI1w7PSB9pVY1zO2SFg3eQXHDeqovSx
	 hNkJxSW62wzPlCNu/KmkRiRwoe6LOZuyvcvgplfOd8+fqvYycgfO/hGz6eCV8z1qBm
	 P3GbxYgUR/7CszWl0MrUGwEEcreCvQXoNZcjc8I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0001/1266] bpf, arm64: Reject out-of-range B.cond targets
Date: Tue, 21 Jul 2026 17:07:18 +0200
Message-ID: <20260721152441.827265802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 48d83d94930eb4db4c93d2de44838b9455cff626 ]

aarch64_insn_gen_cond_branch_imm() calls label_imm_common() to
compute a 19-bit signed byte offset for a conditional branch,
but unlike its siblings aarch64_insn_gen_branch_imm() and
aarch64_insn_gen_comp_branch_imm(), it does not check whether
label_imm_common() returned its out-of-range sentinel (range)
before feeding the value to aarch64_insn_encode_immediate().

aarch64_insn_encode_immediate() unconditionally masks the value
with the 19-bit field mask, so an offset that was rejected by
label_imm_common() gets silently truncated. With the sentinel
value SZ_1M, the resulting field ends up with bit 18 (the sign
bit of the 19-bit signed displacement) set, and the CPU decodes
it as a ~1 MiB *backward* branch, producing an incorrectly
targeted B.cond instruction. For code-gen locations like the
emit_bpf_tail_call() this function is the only barrier between
an overflowing displacement and a silently miscompiled branch.

Fix it by returning AARCH64_BREAK_FAULT when the offset is out
of range, so callers see a loud failure instead of a silently
misencoded branch. validate_code() scans the generated image
for any AARCH64_BREAK_FAULT and then lets the JIT fail.

Fixes: 345e0d35ecdd ("arm64: introduce aarch64_insn_gen_cond_branch_imm()")
Fixes: c94ae4f7c5ec ("arm64: insn: remove BUG_ON from codegen")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20260415121403.639619-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/lib/insn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index 7232b1e70a125f..cb845b3649a188 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -338,6 +338,8 @@ u32 aarch64_insn_gen_cond_branch_imm(unsigned long pc, unsigned long addr,
 	long offset;
 
 	offset = label_imm_common(pc, addr, SZ_1M);
+	if (offset >= SZ_1M)
+		return AARCH64_BREAK_FAULT;
 
 	insn = aarch64_insn_get_bcond_value();
 
-- 
2.53.0



