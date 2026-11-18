Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046520;
	b=paQ3ixsDoprMDxm/X2T4qNcjJJuxWRyebWFxUbbCvurYAsMhiuX2w0KLLRyrBIHqHXKj
	 WoGtqo3xAj3WvjMmvQVKeto3Y8ht8jUmf3+d53FAiKHpJ6owzxJg/2ILiLWcUWR+ghMzl
	 oleJ2kaVH3iU63F5PROCpmeJi+91SsCYR5yV5ZCKpcZfKn+O1KDPGOCjs9UC2YzPm6gEV
	 JypzmcuggMg+087GyfE0GlOSq84C6fFdyyyPeymirVLuy2XGg6r4cWD6bWoF5CdxH2GAk
	 xGAPHXHeP8fDoo+uM3RLtv4dRp/L6TUNNySfVofBCANjTB/NGK8i42nk6fTTHAj3/dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AHOlY6lLO2NdMohxjKHpTrKCnax1adhgpJ6RQwXhKZs=;
	b=JzIIkQsY/9TAz0i0YKGRsJCdBNm1s+eE2MZusHT+B4FH46A+gO6/EgqwGw3QKNnRwqoi
	 eBP7Ux2ZNuERs+Q/2OJ+34uXLeRgIC1eQVVblNK7FcbsDqdMesxiIev6n14jDKnbkuKNX
	 zRzoaSg6KIztIgzuz/c66P2xVv++I70ocFz+YVrHgIGaCwNbLNmtRPZrFrPV4dNx4uNJe
	 CSHpvH3Se6t2at/Vc6vBs+5ftICMrMxEy1wNM3peD4GBg6jOCd9pxrsJtoIiIHwNcQr9b
	 rPVe13SzmGK04n47l0SpNcnveXtp1VFGOcmlb5tfBIY/ywciSWJ5BNE4jb8R4w1Jatw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f211VCpg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040E160A2621;
	Thu, 19 Nov 2026 00:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f211VCpg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E7A1F000C8;
	Thu, 19 Nov 2026 00:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046519;
	bh=AHOlY6lLO2NdMohxjKHpTrKCnax1adhgpJ6RQwXhKZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f211VCpgKrmpcfs+ZNnQOnPvsYDy6rTIPK55swn2PG5zmNKgp+zP0QanKsVi6k1P0
	 qWwYcv5F/zYPaX79lJNFy/AmvhCdgT7ey57rbobXijUpOZqy8uEl0ZJrhf07Fh/o5F
	 8DrKluS8byKvtLUKc3BSlHTapOSZ4gdBpOmLRtJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1310/2857] MIPS: mm: Fix the cache error vector jump for XKPHYS kernels
Date: Wed, 18 Nov 2026 15:39:04 +0100
Message-ID: <20261118150248.629375841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



