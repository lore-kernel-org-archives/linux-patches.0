Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEF521D00E;
	Tue, 26 Aug 2025 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207022; cv=none; b=o78SaxvI/lfv+c8glQmMh33bNYQjTFHcYPOp11TZw062WpB7S2QLkAxyQVvO9OhMi5jSRhtysQFkN2y4SVq078dQuybIHKjPOX1nZQfC70GFrYXsyYVB44Iff0L1qddcQT7NWfLxKCar4u5srwNbfsXJ3YcfIdVLOy0yNmTOsv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207022; c=relaxed/simple;
	bh=zUNTarj+BI9ZrqyT/VKzKwtTtmEdEj+FwWy4C10ER6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDPp7MJ3TDRM9xw2MkjYrc3STeSiUJei2ryuq8E5QLPE0xPKLcoX274cxmDbD1Gfr9h4xgQoo/pCdu/MwCs0Yxj6i9xIqdoISATHbnPycrg7SF5+PPc6iNQfJh6G4/TuIij8urxM3yvuzL/sIwNJmboRg1D7SL8eNuZm5ZZg0HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGT7G/op; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGT7G/op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4542C4CEF1;
	Tue, 26 Aug 2025 11:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207022;
	bh=zUNTarj+BI9ZrqyT/VKzKwtTtmEdEj+FwWy4C10ER6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGT7G/op65p4aGTNWysC6YhvScpBFJ+dJweVWk8ogkzocN0LABgzB0vqcJ0SC6lXB
	 gtRdj2mXLMsQ+/2WKy/Os4Opb8uVmnXJhb69tNaiDg34TTVw0HXIzWp93yvrTkXa4y
	 Yb8hVtTOmjRkOY5FRnXexMErldZWg+Fhv1U+3uLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.16 021/457] lib/crypto: arm/poly1305: Fix register corruption in no-SIMD contexts
Date: Tue, 26 Aug 2025 13:05:05 +0200
Message-ID: <20250826110937.856305868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

commit 52c3e242f4d0043186b70d65460ba1767f27494a upstream.

Restore the SIMD usability check that was removed by commit 773426f4771b
("crypto: arm/poly1305 - Add block-only interface").

This safety check is cheap and is well worth eliminating a footgun.
While the Poly1305 functions should not be called when SIMD registers
are unusable, if they are anyway, they should just do the right thing
instead of corrupting random tasks' registers and/or computing incorrect
MACs.  Fixing this is also needed for poly1305_kunit to pass.

Just use may_use_simd() instead of the original crypto_simd_usable(),
since poly1305_kunit won't rely on crypto_simd_disabled_for_test.

Fixes: 773426f4771b ("crypto: arm/poly1305 - Add block-only interface")
Cc: stable@vger.kernel.org
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20250706231100.176113-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/lib/crypto/poly1305-glue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/lib/crypto/poly1305-glue.c
+++ b/arch/arm/lib/crypto/poly1305-glue.c
@@ -7,6 +7,7 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/internal/poly1305.h>
 #include <linux/cpufeature.h>
 #include <linux/jump_label.h>
@@ -39,7 +40,7 @@ void poly1305_blocks_arch(struct poly130
 {
 	len = round_down(len, POLY1305_BLOCK_SIZE);
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon)) {
+	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		do {
 			unsigned int todo = min_t(unsigned int, len, SZ_4K);
 


