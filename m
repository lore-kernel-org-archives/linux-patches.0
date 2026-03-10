Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6946637B413;
	Tue, 10 Mar 2026 11:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141938; cv=none; b=Jd4loH/OnCcHyuHLYZoshQsthUTi+8FeYvaPkMCmqH/ZSZcnVRK4/vUEVlcFzvqMPqxLgv4yBWAcnvZ738AWm+6SGumvWBSI9ewWKYbxxuQAeHqvrE462Q9EA2aiqW9fNazRZkwMFrq1ICyL0c8ypvTfOigH67RKyyxYtjlF23c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141938; c=relaxed/simple;
	bh=KCK2QXcqwxK2NLtb5LLjpz0due6cBPoyTonpyWJV6Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKccTJWa4Ces/RzItLy/Z3l7KnURgXEu2y/FnMtHMHy9pYN+O7x9OH/L+yqojpnodqCUG54NXkFA7QlJ1NZPHe0bBa5dlWPWtHa4KkGYi8A1Cz3K067Cdch+1N/BXgB0j7MLR8EaNVAQyEAsstNZ7oJpyAWp2QG461He2dJRJPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COayF3xb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COayF3xb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997DBC2BC86;
	Tue, 10 Mar 2026 11:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141938;
	bh=KCK2QXcqwxK2NLtb5LLjpz0due6cBPoyTonpyWJV6Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COayF3xbShPvuT1cRbHqlbKUO+NuBI8askTdzg8utJDT4cXha78fHd6EVXtBBac0v
	 WeGPcLuGDqrlYiSj/ssb1dwGyQ7OphJ9hNWn7dtsyQNZHhhOHN2b65cts97TYOCdiD
	 4yqC0eLD11EVBfUuJadFdHwdlfCoszSahD/9uJhAr5PyMlceIKV/6twCA0/LOQ3hW2
	 CJne0ryPl1kuRW+vCZXj9Zfpv+TWPmJrG8mbOz4Bj5/cOHtyA/LRiVXuQIGBEK7/oD
	 sx91B4j5UahnJTr5IVqTAGaw7mRa8t3ErxB3izdlh+P6fPWsygskhXwK9MyKgdEbYt
	 P/hKMq8FKYRMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/314] bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic tearing
Date: Tue, 10 Mar 2026 07:15:21 -0400
Message-ID: <ee5154faf55c44f72dfdc18d7c54282412febf32.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 83a6ca613f9c2..107eb71b533a0 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2122,7 +2122,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
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

