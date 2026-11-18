Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037923;
	b=IyRvRKy9w0m3BEYzWGpXm+OlQE7pGECZsQ3rTkXvPhpSo7zyIwjCzO+GuinE1g0OwJ2t
	 k4E7450rVmQT4rxveGpaHNEGH9FEL7tMk2lzoYC1dj+4GcIcgpmV6SV32U0Z509li2Wga
	 ZGkdGCcSyCuczoGubTrnZrHKTTTEKjRDlperm1WDkKWwNGMm0ujCX3rr1gFLXW/v9vOjs
	 p9XYb9480vLOCpyQNRyh25al7IPi8ZaSLtxsT6+EiJ+9izjajcLPx3T30FffsaoLGgPC4
	 1dX2DQsSj708bTNPkD2Gr1o2rW2jJj4HCXDQyDkouAG4/vFRAZ7OSwJDzmW6J7QQ3lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGsiHJW236qmeuQz4yikX7KqVeXbL+xxcy0votZQh0k=;
	b=WPiO+vX6VIy0HnTPggqzI88Saq4mOdd4u/3f7KgFe6NFsMco73PC2bD4hE6i4hPkvuno
	 7f6PwhRHrvj4wIh0CeAur7+h2HGacW6Kc3zR1PScSm2+wfOqo5YV11WYTn/EctU708K1O
	 xUI1QGg0d3hSLj1xkGlwk8yn2KhUz7uN/kpXg1QtUgDwIjOi460+uuu41IBS9qRLHbiKA
	 bxzdrulunBRCJXXMdQ1fsUmIDf/w3LDOZ1o/nBpdlZPgnr0KfyA0rDcjFSvXck6CTjM8o
	 AhFaYEl0EL2hVQEwLZUJXCLPNsEIf75X946yHS4NZ2Wur1TgXU6YSXeo/NCOCxCGzCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y4NqTexJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C3D606A320;
	Wed, 18 Nov 2026 21:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y4NqTexJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4DA1F000C4;
	Wed, 18 Nov 2026 21:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037923;
	bh=qGsiHJW236qmeuQz4yikX7KqVeXbL+xxcy0votZQh0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4NqTexJ8jydfmReTQ3qBabUiS3mBTqHE3hEd7+3XRxEPKUWPxs/fSop8DGF5EZWV
	 3vZRGKX1dwEKL18pgxndsxik1pCLvEGS5DDfoSLlWFx8jkWa714BEFib6ZqjntOsEj
	 FdrFpjFHqaY9+MXV6c7GfFkiJm9d3ZT7hZSzMOqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1558/3318] MIPS: mm: Fix the cache error vector jump for XKPHYS kernels
Date: Wed, 18 Nov 2026 15:36:20 +0100
Message-ID: <20261118150407.767094598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 30b76362f80d39d80f1197c88b284d9fa7952356 ]

except_vec2_generic jumps to cache_parity_error with a j, which cannot
leave the vector's 256MB region. An XKPHYS kernel such as IP30's, linked
at 512MB, is outside it, so the j targets an unbacked address and its
speculative fetch raises bus errors on unrelated fetches. Jump to the
handler's uncached XKPHYS address instead.

Fixes: 7505576d1c1a ("MIPS: add support for SGI Octane (IP30)")
Cc: stable@vger.kernel.org
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/cex-gen.S | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/mips/mm/cex-gen.S b/arch/mips/mm/cex-gen.S
index 45dff5cd4b8e7..b4c027b0421dc 100644
--- a/arch/mips/mm/cex-gen.S
+++ b/arch/mips/mm/cex-gen.S
@@ -8,6 +8,7 @@
  *
  * Cache error handler
  */
+#include <asm/addrspace.h>
 #include <asm/asm.h>
 #include <asm/regdef.h>
 #include <asm/mipsregs.h>
@@ -37,6 +38,21 @@
 	nop
 	nop
 
+#if defined(CONFIG_64BIT) && VMLINUX_LOAD_ADDRESS >= XKPHYS && \
+    VMLINUX_LOAD_ADDRESS < XKSEG
+	/*
+	 * An XKPHYS kernel may lie outside the 256MB region a j from the
+	 * vector reaches, so jump to the handler's uncached XKPHYS address.
+	 */
+	PTR_LA	k0, cache_parity_error
+	PTR_LI	k1, TO_PHYS_MASK
+	and	k0, k0, k1
+	PTR_LI	k1, UNCAC_BASE
+	or	k0, k0, k1
+	jr	k0
+	nop
+#else
 	j	cache_parity_error
 	nop
+#endif
 	END(except_vec2_generic)
-- 
2.53.0



