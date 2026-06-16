Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BED2466B5E;
	Tue, 16 Jun 2026 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631870; cv=none; b=j58tjUZTVVmXdUtsASIrz8yaAFXLt3kWKEsDscxdfvT6UHKDGXnyieyJ2FnGcbEskisVtebTglmuBVliTbqujOmOqQNzGGhN+mAE3WRpdy5Q9oJ+TU4zfDoSfkwY392VmxmmrkgYxs5DJg3a9ZVQGYYwckc44t8JA0UVe4Y/81Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631870; c=relaxed/simple;
	bh=/UTEh6CSCiEWndhjWmJ4fvoOIHPqbwiL8a91FTzRl78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psy9IRz2TaKR3RQzk39+HK1uXj7MrF79BCZqIWmTP4h55Re46O3YmOn/TJJgQMZ9yLCopat8/O7573nplJVTVXJuIaokPHGTCeI1sHblJcW2E0Wd20WwxsLyAwDndRrKuwhzyd8q5UCEUDegb+eqa/LcM922B1JihU4GxJ+i04c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DokD1ATT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DokD1ATT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B3C1F000E9;
	Tue, 16 Jun 2026 17:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631869;
	bh=TNHm2Yk2LXjPk095r0B3m3KVMYY2JS+i6Mhhk02L8ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DokD1ATT/SvyASIuC2QdIJIbzR5O54ayl+ruJIfxWw0MdpUCg7spsWWm5H09xMKpg
	 Nd3YuXhht11nDvFTuCAOMtv3Tc0IB/0f/tNSdYchLoGUHdv5n/dMAHQ6fs3rbgd2W6
	 tMx08ZAtnt8yC6wciXlPRVYXEXwu4OfU/3tXvCi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.1 283/522] ARM: 9474/1: io: avoid KASAN instrumentation of raw halfword I/O
Date: Tue, 16 Jun 2026 20:27:10 +0530
Message-ID: <20260616145139.180191809@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit d59ed803715a71fb9582e139d648ece8d66dc743 upstream.

For CPUs before ARMv6, __raw_readw() and __raw_writew() are implemented
as C volatile halfword accesses so the compiler can generate an access
sequence that is safe for those machines. With KASAN enabled, those C
accesses are instrumented as normal memory accesses.

That is not valid for MMIO. On ARM926/VersatilePB with KASAN enabled,
PL011 probing traps in __asan_store2() while registering the UART, because
the instrumented writew() tries to check KASAN shadow for an MMIO address.

Keep the existing volatile halfword access, but move the ARMv5 definitions
into __no_kasan_or_inline functions so raw MMIO halfword accesses are not
instrumented by KASAN. The ARMv6-and-newer inline assembly path is
unchanged.

Fixes: 421015713b30 ("ARM: 9017/2: Enable KASan for ARM")
Cc: stable@vger.kernel.org # v5.11+
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/io.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -56,8 +56,19 @@ void __raw_readsl(const volatile void __
  * the bus. Rather than special-case the machine, just let the compiler
  * generate the access for CPUs prior to ARMv6.
  */
-#define __raw_readw(a)         (__chk_io_ptr(a), *(volatile unsigned short __force *)(a))
-#define __raw_writew(v,a)      ((void)(__chk_io_ptr(a), *(volatile unsigned short __force *)(a) = (v)))
+#define __raw_writew __raw_writew
+static __no_kasan_or_inline void __raw_writew(u16 val, volatile void __iomem *addr)
+{
+	__chk_io_ptr(addr);
+	*(volatile unsigned short __force *)addr = val;
+}
+
+#define __raw_readw __raw_readw
+static __no_kasan_or_inline u16 __raw_readw(const volatile void __iomem *addr)
+{
+	__chk_io_ptr(addr);
+	return *(const volatile unsigned short __force *)addr;
+}
 #else
 /*
  * When running under a hypervisor, we want to avoid I/O accesses with


