Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC0A20B7EE;
	Tue, 26 Aug 2025 11:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207025; cv=none; b=S4P0wpkaJZJVyLXWUaZUIdE6Wj3y9oVXRZMsd/DoW+gB36iK6IPqIoxafPd3aVwGfoGlmFsAZ8Ng+u2vkGP9fNyBv1UIh2Dxtllf9pvGzStXNIpy1vazWJIRky7QVrucyzoWK363Wm58DcOPNl6oS4vufsyYIXmtWg81LUCD2Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207025; c=relaxed/simple;
	bh=6Dsu5ZXvhA77KSqqrU9G4x48OcyUofydbqn2Ho0YiLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJmxR5QgHSu/oQ2iyuhTBVxpX0RKnrUFIVMa+Y3H+P2Sbz2MacLWExzvzDb3LSC4TWnRDD1QWMOGwExvr6VYq8GVCFahdLbzLhQFLsSfY45Qx4nxzoO6/BDPXx2F65BsTbGK5Ws5njL0p7eEpHOhpsit/yaZo5mCl1h8LMn+Sjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPQyS8nF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPQyS8nF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45641C4CEF1;
	Tue, 26 Aug 2025 11:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207024;
	bh=6Dsu5ZXvhA77KSqqrU9G4x48OcyUofydbqn2Ho0YiLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPQyS8nF4TmbQFkKnLktA5oDvObAP3XJrKIiEWysnBR94a5VtW6as2pkwkqMGFVwG
	 U+uOUnLkIIrm3OgD+7T7Ui3QodU0nHAy/zdNLUTYHSP5FEEYqDoy1852flkqAOuemv
	 7fV1Tv0b5zK4BwakEOCq+FG0tyJPsOJaXLEbA8Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.16 022/457] lib/crypto: arm64/poly1305: Fix register corruption in no-SIMD contexts
Date: Tue, 26 Aug 2025 13:05:06 +0200
Message-ID: <20250826110937.880487652@linuxfoundation.org>
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

commit eec76ea5a7213c48529a46eed1b343e5cee3aaab upstream.

Restore the SIMD usability check that was removed by commit a59e5468a921
("crypto: arm64/poly1305 - Add block-only interface").

This safety check is cheap and is well worth eliminating a footgun.
While the Poly1305 functions should not be called when SIMD registers
are unusable, if they are anyway, they should just do the right thing
instead of corrupting random tasks' registers and/or computing incorrect
MACs.  Fixing this is also needed for poly1305_kunit to pass.

Just use may_use_simd() instead of the original crypto_simd_usable(),
since poly1305_kunit won't rely on crypto_simd_disabled_for_test.

Fixes: a59e5468a921 ("crypto: arm64/poly1305 - Add block-only interface")
Cc: stable@vger.kernel.org
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20250706231100.176113-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/lib/crypto/poly1305-glue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/lib/crypto/poly1305-glue.c
+++ b/arch/arm64/lib/crypto/poly1305-glue.c
@@ -7,6 +7,7 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/internal/poly1305.h>
 #include <linux/cpufeature.h>
 #include <linux/jump_label.h>
@@ -33,7 +34,7 @@ void poly1305_blocks_arch(struct poly130
 			  unsigned int len, u32 padbit)
 {
 	len = round_down(len, POLY1305_BLOCK_SIZE);
-	if (static_branch_likely(&have_neon)) {
+	if (static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		do {
 			unsigned int todo = min_t(unsigned int, len, SZ_4K);
 


