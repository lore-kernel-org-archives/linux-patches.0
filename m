Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E14321F27;
	Mon, 18 Aug 2025 13:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524736; cv=none; b=er1TfHzQ/gMA8GyyV+1xx2hOLasUz1sT4Q3ai/XVvgPYYNKwNJlwLdXYVop2VgUAp406E5qwCVxdOWv/JsveAKbRxPETB8seuSXfL9Nd/iuUubrMlxVEB/mXwY7oi8Ub6MzKcjoR1JuWroKbi3TUV2508hK7dNSZdEhyctd+54k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524736; c=relaxed/simple;
	bh=vHpEhGjxsBWsqpOSOyEebFtvpLnvmIT/evEO2vDhp6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlvjM2CwKQZlglS7NdSm+gvkJwfOrXnEnaZ0CqMHXMKW/8oRJrXdsh64sU+tKUAw5NBf7bIIYfeMLX7/V7NkjBvHvMFJkRHLhDGE8WaWrjqKegSSokoTdArXdsmemEd1r3lmXUiRrkkFzkjpgN+3AYH/0LxXOOJw0jhJQGZLmxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZspcqX4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZspcqX4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9BDC4CEEB;
	Mon, 18 Aug 2025 13:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524736;
	bh=vHpEhGjxsBWsqpOSOyEebFtvpLnvmIT/evEO2vDhp6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZspcqX4/XfY07kjfCasqlCRU1zNV+tMmZL9WXV4sACalfrgSDXl5J1HTg6b8rJZVK
	 yjEzQiDcQAr/63587EAPN1TWjxVcHCzmHyDfn0rU0PN8FuxH5r3I90LeN7SWxl7ARw
	 ws3jafKZrQ4wb9SwQhb3ZT38eNXUvX6NMSdN19hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.16 046/570] lib/crypto: x86/poly1305: Fix register corruption in no-SIMD contexts
Date: Mon, 18 Aug 2025 14:40:33 +0200
Message-ID: <20250818124507.592009359@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 16f2c30e290e04135b70ad374fb7e1d1ed9ff5e7 upstream.

Restore the SIMD usability check and base conversion that were removed
by commit 318c53ae02f2 ("crypto: x86/poly1305 - Add block-only
interface").

This safety check is cheap and is well worth eliminating a footgun.
While the Poly1305 functions should not be called when SIMD registers
are unusable, if they are anyway, they should just do the right thing
instead of corrupting random tasks' registers and/or computing incorrect
MACs.  Fixing this is also needed for poly1305_kunit to pass.

Just use irq_fpu_usable() instead of the original crypto_simd_usable(),
since poly1305_kunit won't rely on crypto_simd_disabled_for_test.

Fixes: 318c53ae02f2 ("crypto: x86/poly1305 - Add block-only interface")
Cc: stable@vger.kernel.org
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20250706231100.176113-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/crypto/poly1305_glue.c |   40 +++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/arch/x86/lib/crypto/poly1305_glue.c
+++ b/arch/x86/lib/crypto/poly1305_glue.c
@@ -25,6 +25,42 @@ struct poly1305_arch_internal {
 	struct { u32 r2, r1, r4, r3; } rn[9];
 };
 
+/*
+ * The AVX code uses base 2^26, while the scalar code uses base 2^64. If we hit
+ * the unfortunate situation of using AVX and then having to go back to scalar
+ * -- because the user is silly and has called the update function from two
+ * separate contexts -- then we need to convert back to the original base before
+ * proceeding. It is possible to reason that the initial reduction below is
+ * sufficient given the implementation invariants. However, for an avoidance of
+ * doubt and because this is not performance critical, we do the full reduction
+ * anyway. Z3 proof of below function: https://xn--4db.cc/ltPtHCKN/py
+ */
+static void convert_to_base2_64(void *ctx)
+{
+	struct poly1305_arch_internal *state = ctx;
+	u32 cy;
+
+	if (!state->is_base2_26)
+		return;
+
+	cy = state->h[0] >> 26; state->h[0] &= 0x3ffffff; state->h[1] += cy;
+	cy = state->h[1] >> 26; state->h[1] &= 0x3ffffff; state->h[2] += cy;
+	cy = state->h[2] >> 26; state->h[2] &= 0x3ffffff; state->h[3] += cy;
+	cy = state->h[3] >> 26; state->h[3] &= 0x3ffffff; state->h[4] += cy;
+	state->hs[0] = ((u64)state->h[2] << 52) | ((u64)state->h[1] << 26) | state->h[0];
+	state->hs[1] = ((u64)state->h[4] << 40) | ((u64)state->h[3] << 14) | (state->h[2] >> 12);
+	state->hs[2] = state->h[4] >> 24;
+	/* Unsigned Less Than: branchlessly produces 1 if a < b, else 0. */
+#define ULT(a, b) ((a ^ ((a ^ b) | ((a - b) ^ b))) >> (sizeof(a) * 8 - 1))
+	cy = (state->hs[2] >> 2) + (state->hs[2] & ~3ULL);
+	state->hs[2] &= 3;
+	state->hs[0] += cy;
+	state->hs[1] += (cy = ULT(state->hs[0], cy));
+	state->hs[2] += ULT(state->hs[1], cy);
+#undef ULT
+	state->is_base2_26 = 0;
+}
+
 asmlinkage void poly1305_block_init_arch(
 	struct poly1305_block_state *state,
 	const u8 raw_key[POLY1305_BLOCK_SIZE]);
@@ -62,7 +98,9 @@ void poly1305_blocks_arch(struct poly130
 	BUILD_BUG_ON(SZ_4K < POLY1305_BLOCK_SIZE ||
 		     SZ_4K % POLY1305_BLOCK_SIZE);
 
-	if (!static_branch_likely(&poly1305_use_avx)) {
+	if (!static_branch_likely(&poly1305_use_avx) ||
+	    unlikely(!irq_fpu_usable())) {
+		convert_to_base2_64(ctx);
 		poly1305_blocks_x86_64(ctx, inp, len, padbit);
 		return;
 	}


