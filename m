Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CF88837;
	Mon, 28 Oct 2024 06:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098269; cv=none; b=hFV6zxGBmVw9AMS8qQsGVHqs67NVIhL5bOg4nwKwX6IC6AUlGU1jZ6FsqglR7w0YcEazrKMK4qaPlycoUcQ5HwumnkJZnJKkQPoshiUOCRoV4F+kxmbV21N+SZKwylE416Wp40Ge/MRJnvDChdAIICBsOZFoRB7iHebLUDbZC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098269; c=relaxed/simple;
	bh=vJ2rnsl1LVD4596WGAEIZaq3uaJQnogEmr0CZAs/Xp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgBKShra7lRajmWRa5MEBPdM7gHZicdRbK2AnCMel1ER8ftd9K/lwVIkc0FQM/XPwWJ+EX+15LfRhhpUMPgQvoBSomXlmGgqjezJBC8HDNDjdMBxYXC04euLx+lPI27snhh1B72323XKVAvLEsbsjUuqF9U2dRWNZYzSoS8CwRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4LeuHbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4LeuHbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7099EC4CEC3;
	Mon, 28 Oct 2024 06:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098269;
	bh=vJ2rnsl1LVD4596WGAEIZaq3uaJQnogEmr0CZAs/Xp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4LeuHbH4tplHVlFqNl2jrnV/ffYO1fw8rWiwFLqRuNd0AWBsry9yXDCxYdmRJRqj
	 2+XjxXzufXCbPupoYsrf9bpixPxn6CDo0n1Ijts7kkjSR37CDRZEaZph5ee1D4gkCR
	 P8c1i5dM545tFzjQHMlJWvjWwU7Rn3GmbIjqtDp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Xu Kuohai <xukuohai@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 153/261] bpf, arm64: Fix address emission with tag-based KASAN enabled
Date: Mon, 28 Oct 2024 07:24:55 +0100
Message-ID: <20241028062315.863869162@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Collingbourne <pcc@google.com>

[ Upstream commit a552e2ef5fd1a6c78267cd4ec5a9b49aa11bbb1c ]

When BPF_TRAMP_F_CALL_ORIG is enabled, the address of a bpf_tramp_image
struct on the stack is passed during the size calculation pass and
an address on the heap is passed during code generation. This may
cause a heap buffer overflow if the heap address is tagged because
emit_a64_mov_i64() will emit longer code than it did during the size
calculation pass. The same problem could occur without tag-based
KASAN if one of the 16-bit words of the stack address happened to
be all-ones during the size calculation pass. Fix the problem by
assuming the worst case (4 instructions) when calculating the size
of the bpf_tramp_image address emission.

Fixes: 19d3c179a377 ("bpf, arm64: Fix trampoline for BPF_TRAMP_F_CALL_ORIG")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://linux-review.googlesource.com/id/I1496f2bc24fba7a1d492e16e2b94cf43714f2d3c
Link: https://lore.kernel.org/bpf/20241018221644.3240898-1-pcc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 59e05a7aea56a..6e5a934ee2f55 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2172,7 +2172,11 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 	emit(A64_STR64I(A64_R(20), A64_SP, regs_off + 8), ctx);
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
-		emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
+		/* for the first pass, assume the worst case */
+		if (!ctx->image)
+			ctx->idx += 4;
+		else
+			emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
 		emit_call((const u64)__bpf_tramp_enter, ctx);
 	}
 
@@ -2216,7 +2220,11 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		im->ip_epilogue = ctx->ro_image + ctx->idx;
-		emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
+		/* for the first pass, assume the worst case */
+		if (!ctx->image)
+			ctx->idx += 4;
+		else
+			emit_a64_mov_i64(A64_R(0), (const u64)im, ctx);
 		emit_call((const u64)__bpf_tramp_exit, ctx);
 	}
 
-- 
2.43.0



