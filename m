Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591279;
	b=khw+C/iriOm33cIFoEFlq0wl16aIr+GDDWBXT5ayMWacGzS8SL2CaatNjKvvxi4o1FVv
	 jz9RP7r4OS/QdRS1sCj7A7lHSeonGM5vqSB0EWfBRmW+izpxsq6qfl8iYyP/ASeraNsHO
	 fDsgiHhRNvhzTN0z4uMzPDDGmBTcHda5VMvP/RzC1J0B6/ikJJSJLb5ptZwPFrszH0WI0
	 srm8zxPGEFmijgeMZU65cs7VUYbWu7eEHswRHa0uvmG6DylosDi6HXduZzHimTnuLjNse
	 FE1krqGBgCyeX0wIpLrM0NkXeBVT9NTjanYWnPIiR1vIg8T1AknNuV3EsgJgMgTU41w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=96EiIVkinBxXEx+WYC1nh25jh6AXZJDtm+tLBe1ikTc=;
	b=dYumckrl0ZjbK3dofeecsTdggOG4BvmkcCvcZQ6V2vKCbgE3/SKCQKmyfgm3Lqv1LPh0
	 OMvIiFsLIyekAaMZfkN5lJrv1GLuuvpd6c7w/65YUuEc1T0FgzmtZAYkZNaYZ6HEMYT1P
	 ui140wfCdq9URoZsdWcyrUuZx6Ibijs011g8bXppEaQJbfLIKIh345vEhsRpXuH+E7Bwl
	 uEjdUivM6FrwwKO5yaZ/F5LK8BSP4ZuUASB3kzgYkCYODEKNZsu6qNJxih5HlwOnlMlQY
	 /0VTWIx07HZ9NTRxp45z4NoX3Hufohh7BvoQvj16oSmqZrNq61gcT0yUaaWcGkVzXEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4aedLtA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BAA6076FB4;
	Fri, 13 Nov 2026 17:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4aedLtA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63531F000C4;
	Fri, 13 Nov 2026 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591278;
	bh=96EiIVkinBxXEx+WYC1nh25jh6AXZJDtm+tLBe1ikTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4aedLtA2Lv0Dwfk2XZHNrc6TeGny6IKIK2Jvo+v7S9C4Fbxrb+9F21xUHaIP5h/G
	 vOCqsicBCIuFaE/dS5erh2Qtpib524M/S1M5uW4N8fWTKItUGkUBoh60E+QqQiDb6E
	 rhj0ZIf0DKFLdG4e1UqJvAVozSDSvQOu9wxGBGKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 382/670] MIPS: mm: Fix the cache error vector jump for XKPHYS kernels
Date: Fri, 13 Nov 2026 10:49:06 -0500
Message-ID: <20261113153824.717423160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



