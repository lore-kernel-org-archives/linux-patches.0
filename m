Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A727A402434;
	Thu, 12 Mar 2026 20:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346420; cv=none; b=uHVlVfCxcKirfk+7cn1Cxsp7xuOghn4qoc3HXcKK5as54f9yC5F5Xl9446ps9vn35K+4amFrz5ad6IQ6Q2bPq49h8k08Tapfjo1bvR3ejK+jR8lzzRLmNLp3ebkOMzbFCL/ioK3lqaX+GOlRypu3QAMxMdGsdmqE4VnISX/gAzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346420; c=relaxed/simple;
	bh=/0tQTpSTObsUW+WDS0uRTmV2ydNMJlNtwv6QY5z0VZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrjys1+6S3FF4iroMvkokJoMV3ts1fArXEYSIP/jJPxs/UGpbA1nJdnpUvQT2U2VF6YGJCuPyydQ0fOQgG+fVf/lhFAcEnf9ypbdGLPr9iIrDib0hIlI5SnYd+VOR6g74MG7YDuQHBeJEe6U4v0tGRg+GJPgbXD8StJHAtrkKok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQ8yL3zI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQ8yL3zI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B156DC19425;
	Thu, 12 Mar 2026 20:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346420;
	bh=/0tQTpSTObsUW+WDS0uRTmV2ydNMJlNtwv6QY5z0VZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQ8yL3zI9iSPYmUTHpGg+t7zs1/zNX6hc7+a6VJWUSvqa44Bx6wRUnYOjVXAayjp2
	 wCP97WPtyhHGSzWXlaA+nhPCvXtEww9+8nMPDXQylnHz3q1TMzfpeztke1rrj9731d
	 My2MyYkk3J6Vq1Sr7hJpW8vmi8/3RQyhCipavoR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/265] bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic tearing
Date: Thu, 12 Mar 2026 21:07:05 +0100
Message-ID: <20260312201019.570238335@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 82b57436f2f10..9310196e0a09e 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1880,7 +1880,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
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



