Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585892;
	b=LcSSTvqKTXuQzkLugpi6zU5N7IqVDAelzXcigs9kz75DkQiEuijWKolNyLlYIbMYbE0B
	 +RbxNwkNuMnkIiCl+KCkeKW+6njxb9DcDugPsNWAuMx/pShFhys3X1W5l30nXgb83wtdh
	 L6Ve5IEV2MrzI9/xOZlz7Ua7d6zVZzGBdWToeuAnkNlZFnkM0WLQp2PaMT1qGJwdoJEOz
	 plh2BlYFBohP0dyHsWtJ2422LlRciCchCQc6JB1A7jk1WiIbsK6MBrqdKiUcb9dJKmTYW
	 +XvyRD89Yw+ptH2tz2s69m3CsRLlld0yPQhb2FV5lSkluB4anMxIvzKocWj2l+zQ7gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+KDvlflUF9bgK0V4kfVdiL8mieikO+v6BSt5cIZwdNM=;
	b=hwvUfv/fcULhmYA5FwDPnQ+tp87QmKlVHkp8gEiXgqrMOwUseTrg7UihZCvQf20X0Jbf
	 4T8dGRDW0Ebbeb/VI06M5Xg98cEFQVleTNtd3K3E197HfUNoz2lMdozKjn/b9diUaSX4p
	 wQhviFihUjpzTySAGuc1OHnATgFSyiLJzsZbcPHu8k3ImIpae29UKcS1A4/m6y2zP1LtX
	 RI2qTcCU8RQe9mY8CuV/NA238NDD7YcBmpVKrTi+/FhJEi72uA8tLACTnXKzGEwSzDImk
	 /E4X6uwTBTWyPWrw+RRItuBjbjeovpAqVA4F/kLfmpDDeQDe1oAgrtHkiKxYx8S1DXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbmQ2GB6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BA6606EABB;
	Fri, 13 Nov 2026 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbmQ2GB6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141E61F000C4;
	Fri, 13 Nov 2026 16:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585892;
	bh=+KDvlflUF9bgK0V4kfVdiL8mieikO+v6BSt5cIZwdNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbmQ2GB6Kdn2XIj1gZ1KDb3xb85fNRRug2yS/vwPoD9+reoRBeYOzTFK/jsUAlMfQ
	 d60aUpBQ9BoNHCxikzfrsfeFhepn7Nbs1GS07I1KG64sjfIR/5iIhHXeJrth+6t2aj
	 sM/ExLJACrE7UAufMdsTSZnUcnXDfIBle4BLlypU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 416/507] MIPS: mm: Fix the cache error vector jump for XKPHYS kernels
Date: Fri, 13 Nov 2026 10:52:00 -0500
Message-ID: <20261113153810.828229686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



