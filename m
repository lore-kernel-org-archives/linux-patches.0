Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6611F3C0601;
	Sat, 17 Oct 2026 17:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258384; cv=none; b=soSK+U6Yac7qN7eqhM9QouB5ccsCnhIrSkK9aaagRx2ZVFRTLEiXCaSJ4eCmPWii+wDS8xzWjFCyXRP4sv3rI0tEOamLMdftmaTurjebqa1uj9lPbBbCIJ+5Jg6FdQj5hK+G4vl+Gic2PYj2HMNQCDH8aMZFzHgC8GdcXWmy9sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258384; c=relaxed/simple;
	bh=vYry0dLdfOLjFvD0+cYFp5psKo2QAGgdDZutKOiOkaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hqg7FHF10/2ENwky/u//7Zorw+8blO8qylJ7tKriqPIShGzazq86VlUrwLhrBiaIvBHhrd5LIzhKryfUfcsB5KSk+aiZSJ195L9ZQ5vt6clZN+BDujE/63b4Sc1pnEQhw3THA6mK1EcktZ8ITw8+HZmhcEqCkRQoF1vaI/dqlyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yo/eRVNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yo/eRVNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A895D1F000C6;
	Sat, 17 Oct 2026 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258383;
	bh=LxrkoEi1aDJbfP90aOEjh46LzBUyWnhTUIrlcAr0C5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yo/eRVNPKdVp8PGNuRdWnj68pZcvPwLaUmNio2Pc4cgYopiibae8mRRSLCAOlQ0qi
	 YqksqGUam6VvQcgiOuq8E+/1g6VoERazm4m9h57KcYko4wsQEhEcmrsga1EjMsQRUC
	 p3t2C1EJUtr9leGlTRngINYAXicGRbqIPOhR9XYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0866/1674] bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic tearing
Date: Sat, 17 Oct 2026 17:52:18 +0200
Message-ID: <20261017160453.343123376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 1fcdb129ada8a..f562060a50c4e 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1648,7 +1648,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	extable_offset = round_up(prog_size + PLT_TARGET_SIZE, extable_align);
 	image_size = extable_offset + extable_size;
 	header = bpf_jit_binary_alloc(image_size, &image_ptr,
-				      sizeof(u32), jit_fill_hole);
+				      sizeof(u64), jit_fill_hole);
 	if (header == NULL) {
 		prog = orig_prog;
 		goto out_off;
-- 
2.53.0



