Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F16466B5E;
	Tue, 16 Jun 2026 18:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634217; cv=none; b=YTmKg+iFl6qUNcA0TE1YHxWDjQrV7cye8FpQbJPPUp5CCGFM7649pfawjevMOuYAiHNluekx/W9rGooNY4ZWHw/w6wxFvVPade56g/KPoqOgLJkMxtoSNZ5Kf5hQ7J4WYCr1/BR6OevxrFRfYCTjmIh+5gxjjwuxyWgCfee1Qws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634217; c=relaxed/simple;
	bh=PbJA6BCok+aMdtTzVz79FGxbpJliO4y+yAgP8OLm8EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeH7/rQcPjO593WqqGq3XLH1FWYndWn2Nnd3LBmNUUpbSY7StdCjdKj5oALwPVWcwRw2nhNKaEwHbamcefq6M1ECfvC2yWPSIjZnMZvgC+++bObsolKb2ych7T4njzOy4IxvXn0Z1BhH21wQncYRrikqGus29jPqpzQmw7hP/uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1mn5W2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1mn5W2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DFD1F000E9;
	Tue, 16 Jun 2026 18:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634216;
	bh=oxu70sP3hr4FmM9717ALC8oJi9rIsRl4gA802yXweIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1mn5W2OhnX4OG/Ocd5Na/kDEtx0WIFa3l8EgDTfUTfZ3B5PSQdzihqz2MnvCR6l+
	 n1QtPtXlaHjYkJaT83PKeMe1HARwJphnFmjANmlQMCieg6SCJ8JISJ5m9JAAt8h/wi
	 NY+iMPDUHZ/KZov3t4H1cmSgJs1+rLF/lrSpKzHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.15 213/411] ARM: 9474/1: io: avoid KASAN instrumentation of raw halfword I/O
Date: Tue, 16 Jun 2026 20:27:31 +0530
Message-ID: <20260616145112.087601064@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


