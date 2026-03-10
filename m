Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADF4381AE3;
	Tue, 10 Mar 2026 11:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141082; cv=none; b=HYVsv7RqeFjkFbaIUkj9TJdxQD+LBkSMYfpxRu+v9tZbVBMAe93W6jLbkl52L6ovZv/3ZF/oiUgYd+ag3Qd6b3IY5LbjMdIBQ4EfsCAciCpw0NKo3t9+84CxsblxJuBG63caTZf5UgaZPxa4UBN2gCA4/sOTWr8FphJV+7o2tUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141082; c=relaxed/simple;
	bh=sOaZ5DRUv/0aiuDSVbI4qMZnIT6MuoYpvBpM4aLAQ3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnlQUGWfKMhES/fg79bmouiJnYHWT7cyCbcapF/ascmpPWmh6w0rKhzTV+nGlKJoE30+FfT70VyNAeQ+i8JOlbDQTzHa5Ce3Gowh4Z0VJyffOacVScLm9F2uG5N9BRelsSO3lJewvhDPQbLZOU7t5bVtum919ptfmoDORzVq3BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tdM/ssRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tdM/ssRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63499C19423;
	Tue, 10 Mar 2026 11:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141082;
	bh=sOaZ5DRUv/0aiuDSVbI4qMZnIT6MuoYpvBpM4aLAQ3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdM/ssRW8tskWbUD8NI4f60K+6PF8j47n/9G71cgACdMXUEwyH7D46ouCHBTZDM0c
	 zhyfVoQxKcsdgNGJqj74lpz8aL9fOX3fV9uYq9tD4n316VimMduNzSVsmlDDbjM1yv
	 nbpB7yXa82yvYCdMdJ++LgsZNEoVdNDSk1r3Utpc9d3pOeNMNu5BlM2eSEevwQh65M
	 oYhHF7/QDjxPXqGS4rzYsJNvA+6oyWbrA24s1JDvmK+juhX8BzDQEbA9IdxqTrv9GS
	 J6uFMpeTcumDMKGGYy55X6v6zuI3dXlvQHTyQj+8cbHUAIvksbSPwFSeAMGX2NfP9L
	 C3EMSenxvHDSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 082/311] bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic tearing
Date: Tue, 10 Mar 2026 07:02:09 -0400
Message-ID: <caca78872482ae12491ea35efe7d7e118d395390.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fuad Tabba <tabba@google.com>

[ Upstream commit ef06fd16d48704eac868441d98d4ef083d8f3d07 ]

struct bpf_plt contains a u64 target field. Currently, the BPF JIT
allocator requests an alignment of 4 bytes (sizeof(u32)) for the JIT
buffer.

Because the base address of the JIT buffer can be 4-byte aligned (e.g.,
ending in 0x4 or 0xc), the relative padding logic in build_plt() fails
to ensure that target lands on an 8-byte boundary.

This leads to two issues:
1. UBSAN reports misaligned-access warnings when dereferencing the
   structure.
2. More critically, target is updated concurrently via WRITE_ONCE() in
   bpf_arch_text_poke() while the JIT'd code executes ldr. On arm64,
   64-bit loads/stores are only guaranteed to be single-copy atomic if
   they are 64-bit aligned. A misaligned target risks a torn read,
   causing the JIT to jump to a corrupted address.

Fix this by increasing the allocation alignment requirement to 8 bytes
(sizeof(u64)) in bpf_jit_binary_pack_alloc(). This anchors the base of
the JIT buffer to an 8-byte boundary, allowing the relative padding math
in build_plt() to correctly align the target field.

Fixes: b2ad54e1533e ("bpf, arm64: Implement bpf_arch_text_poke() for arm64")
Signed-off-by: Fuad Tabba <tabba@google.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20260226075525.233321-1-tabba@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 1d657bd3ce655..f9fcd699f2e94 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2126,7 +2126,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	extable_offset = round_up(prog_size + PLT_TARGET_SIZE, extable_align);
 	image_size = extable_offset + extable_size;
 	ro_header = bpf_jit_binary_pack_alloc(image_size, &ro_image_ptr,
-					      sizeof(u32), &header, &image_ptr,
+					      sizeof(u64), &header, &image_ptr,
 					      jit_fill_hole);
 	if (!ro_header) {
 		prog = orig_prog;
-- 
2.51.0

