Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EDD33064F;
	Mon, 29 Dec 2025 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025786; cv=none; b=PfOt7E8trvq8w19edLoshSTsjPuyPMF+UtAlXmE1tX3TfzY3T50wHeilnJRhyFyse87am0CQ522jvCqFdCVepPwEbBIMLUWEqaEKJMAitSl0EjitmDgAhEBjRYZOEUwWqBYD0J4CuH5U/r+t9YHcGfO+aRNSSWrN1E8Z6bV9Q1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025786; c=relaxed/simple;
	bh=htZiGLh9+DoL00/QU08F37/GkRQpKXFETjWKueDsdik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CU3/BD9A3a3RtyYa0qh+SsOTrG/ffZqCVVCuf9m1JAQY16RmNaFWnX1isnQG6zYa/MKmpvP0gttoFTlcKhSqEJZWGRFS6iYj+7DelJs5Lv7SDlgCKo13Qq6Ek/nBlZ2APGNLKOQdivxElI4oE7qZSunFbtkXqCavYNJ+KAe2JRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kY74+3m1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kY74+3m1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8402C4CEF7;
	Mon, 29 Dec 2025 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025786;
	bh=htZiGLh9+DoL00/QU08F37/GkRQpKXFETjWKueDsdik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kY74+3m1CWg16uZfYQizoBadEzn0oGE+MtNhMIsUu4/KTrXzDbUxs0RSDUGbsPbh9
	 kMrUjSwdlst2iWvEEMCUkI2CUm29psRq2BkvSeU97sRBnMHfITY5ET1poPadHHhSSE
	 rl/H3cgQBdbBNezJ++RBElGeVMfAvD93XtG2ggTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 336/430] lib/crypto: riscv/chacha: Avoid s0/fp register
Date: Mon, 29 Dec 2025 17:12:18 +0100
Message-ID: <20251229160736.692298872@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit 43169328c7b4623b54b7713ec68479cebda5465f upstream.

In chacha_zvkb, avoid using the s0 register, which is the frame pointer,
by reallocating KEY0 to t5. This makes stack traces available if e.g. a
crash happens in chacha_zvkb.

No frame pointer maintenance is otherwise required since this is a leaf
function.

Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Fixes: bb54668837a0 ("crypto: riscv - add vector crypto accelerated ChaCha20")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/riscv/chacha-riscv64-zvkb.S |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/crypto/riscv/chacha-riscv64-zvkb.S
+++ b/lib/crypto/riscv/chacha-riscv64-zvkb.S
@@ -60,7 +60,8 @@
 #define VL		t2
 #define STRIDE		t3
 #define ROUND_CTR	t4
-#define KEY0		s0
+#define KEY0		t5
+// Avoid s0/fp to allow for unwinding
 #define KEY1		s1
 #define KEY2		s2
 #define KEY3		s3
@@ -143,7 +144,6 @@
 // The updated 32-bit counter is written back to state->x[12] before returning.
 SYM_FUNC_START(chacha_zvkb)
 	addi		sp, sp, -96
-	sd		s0, 0(sp)
 	sd		s1, 8(sp)
 	sd		s2, 16(sp)
 	sd		s3, 24(sp)
@@ -280,7 +280,6 @@ SYM_FUNC_START(chacha_zvkb)
 	bnez		NBLOCKS, .Lblock_loop
 
 	sw		COUNTER, 48(STATEP)
-	ld		s0, 0(sp)
 	ld		s1, 8(sp)
 	ld		s2, 16(sp)
 	ld		s3, 24(sp)


