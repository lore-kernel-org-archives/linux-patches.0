Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06B943E4BC;
	Tue, 16 Jun 2026 17:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629573; cv=none; b=m5xlcol1n/TlYdzbiiw1vpJhWd3V04N+k4NG5vdxWQBwG755lrg0a0L84uJSiBz/uW3xAhhdMkomWtv+xuHBD2Ezx6SI262BTd8Awyw+7DVCRIq6Inl2wUD+tNry5OMsbY8f1ZJcJ7bxGFnbvyLtkkmEIvJCR+zUFsolK5jnrDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629573; c=relaxed/simple;
	bh=0IgELGJr0llH9mF5v6PqI2JMbTiU9IeRha9AWjSR/a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOseU74H5TbdIdFNzk1lQt6LPOpGqnS4E2hoF4Xg0dXgYPEisciN4KA8XbVchytkrzdEc1j8gJah6DV1x2FfL3JVsNZHjwu/ut55qgFe5/StmTqCwYmroKlT++hAyxuEKJY56WJrSNyf+cH9QeXr2eUY7eJOqWyOzk3PFGg1d7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vpq1ROPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vpq1ROPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B911B1F000E9;
	Tue, 16 Jun 2026 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629572;
	bh=STrRJT5DKGizQh/M4YsOzWCp1gI/asSyf+4CP4F6ar8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vpq1ROPfy+2WNzu+XKCmrmcGtQ1AsByS5kdZql2CVu21ZURFd+2tWg3vf9Txcn+y3
	 k5omm3phSheB19WTyaZmvJcgpEylKR4gv6YB455AWArCrCsR8u6qa2HBr0gpSsvwd5
	 OcRV8TYMZucI1JDH9OmD91qbxvU+f//PRxpnQ6WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.6 312/452] ARM: 9474/1: io: avoid KASAN instrumentation of raw halfword I/O
Date: Tue, 16 Jun 2026 20:28:59 +0530
Message-ID: <20260616145133.905083800@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


