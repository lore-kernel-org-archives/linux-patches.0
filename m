Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590500;
	b=FmlKGQyzDsk5binOF+Ynl6odm/XaRsO1Gp2sM/4adcxupAhrx/YAblLNpJtelzK8b7s6
	 D9iWsUSSEBXGNDr8PVnljgEktAlTVixOvN7/8HHr/BSUmL4to4XKPNP+cLMqiaJeyWKmk
	 H2pP2oZi3yrWznGf7/lnNNXA02f7cVfGkvKWBi4p94FKMIalaKQeb5ppS85MwuzKAAD7a
	 VqxtREwyv8ToU4EIVJWDH/mcwZddbP8oenNyTPxRm5VBQWweSDY5jvZIQd1lmNibx04Z8
	 tHa4o/BSUdlE9OxaAb9unvjhqRWxzA7+SWcjr7DjWZeyIY1oW+WKPHom5e4TNzNU37A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M+BycPrczLyt9Fb/1Pb6KMQ5KYXQKVBw18LeAvRtvrM=;
	b=hc+IWBQLm8HfGJgwrV/Z1Tvu8zjq6pJGOyzymFt8mlN+92hLfrHqgqAwso6ikFvZUaxS
	 kodcMkt7BLcnJLE7LOoVidu4a4rgh6Fm6z/ovgNL6MsRpQfbmzySBJ/mSAj1/fVKIf4xX
	 Gz6e/9cQJTIkEder0MeJEcpv27ZN1KYORadvPtg/wnN+ltv4Z58JTi/yKu743x8xWi/vG
	 y0QgJLG1RY5f9bIg9hfripib+3Tq+Tad+LnYSTADu8MvW+bgVBJeWuAxpyBrmozNuAPeS
	 yQvzPU0nr0rit/MW1JaualC9Pgqf3L/uo5MufK6YdXkaLykVcXa3dLAZSpNV9v1EdcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HpD4N7ux;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8DD6071437;
	Fri, 13 Nov 2026 17:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HpD4N7ux
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEFE1F000C6;
	Fri, 13 Nov 2026 17:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590500;
	bh=M+BycPrczLyt9Fb/1Pb6KMQ5KYXQKVBw18LeAvRtvrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpD4N7ux6VKyRfhO1sfPzMm/uhkL5nWUwtG6ev77WGd2Wpekdvtll7bo5MUOs45aR
	 F/MOMYj2WwW2laTHdZ3N0WDIgW++PXoqUfLyARTLPU12i/FEy1ooe10izC/WUeqhej
	 4t6TB0Nhe4iw+kVCGabuPPDNs3/w+XhPpJAxQ1n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 447/686] MIPS: mm: Fix the cache error vector jump for XKPHYS kernels
Date: Fri, 13 Nov 2026 10:49:40 -0500
Message-ID: <20261113153836.027465150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e528583d13311..6989fe274aab8 100644
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



