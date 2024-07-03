Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5A01822D2;
	Wed,  3 Jul 2024 10:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003487; cv=none; b=pxjenF9BWptcV4yO+HX3wmrAFyWolEj1APgnedw3zjh6IdhmNANlEPcnAdAIphxNe0AjbdibvfiQhncZL2Kxsgz2c3VANp87PfulG90nHoq0JKQlCuYixW3gbPTjC0jgS1S+qdi7FdtScUM0V6q/NGvhcdvCjHSmKmLTS+wiCR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003487; c=relaxed/simple;
	bh=V/LwmnUVOiKrVp6ibdOWq5tItlVSOlsrqo0GcbB7DII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHwbOl7byzfI45abyKrgvldzXIpJvNQ5FpdjGDReTJUqYBMPSzjRgcz+Fz+iPHu9Hr4Gs2upEsOyIlUbtA0h6UOljn/bzybw0xg6VcurqvsJiDyBs9CaIHZqb1Fn9gNOvpE9xEK5vMRlrshVN8RaZCNhzdKaIjOaO0LP6AJ99+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cw3fy5To; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cw3fy5To"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F694C2BD10;
	Wed,  3 Jul 2024 10:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003487;
	bh=V/LwmnUVOiKrVp6ibdOWq5tItlVSOlsrqo0GcbB7DII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cw3fy5TogS7kStvc31eLDdS3oqPHp0ux0rJ8kZQfQkx6m4UqvoW4UTi6c2oBytu1K
	 TNbt438oAwMmA+8JFCk1XLTufuE/EqMRUhRF/5vUtKQUyJlTn64yxqUp6132YriXip
	 cVfaaLG3mrLwq4Uae4LHt6lPlzh30DEZ67WQqgOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/139] powerpc/io: Avoid clang null pointer arithmetic warnings
Date: Wed,  3 Jul 2024 12:39:22 +0200
Message-ID: <20240703102832.897463347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 03c0f2c2b2220fc9cf8785cd7b61d3e71e24a366 ]

With -Wextra clang warns about pointer arithmetic using a null pointer.
When building with CONFIG_PCI=n, that triggers a warning in the IO
accessors, eg:

  In file included from linux/arch/powerpc/include/asm/io.h:672:
  linux/arch/powerpc/include/asm/io-defs.h:23:1: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     23 | DEF_PCI_AC_RET(inb, u8, (unsigned long port), (port), pio, port)
        | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ...
  linux/arch/powerpc/include/asm/io.h:591:53: note: expanded from macro '__do_inb'
    591 | #define __do_inb(port)          readb((PCI_IO_ADDR)_IO_BASE + port);
        |                                       ~~~~~~~~~~~~~~~~~~~~~ ^

That is because when CONFIG_PCI=n, _IO_BASE is defined as 0.

Although _IO_BASE is defined as plain 0, the cast (PCI_IO_ADDR) converts
it to void * before the addition with port happens.

Instead the addition can be done first, and then the cast. The resulting
value will be the same, but avoids the warning, and also avoids void
pointer arithmetic which is apparently non-standard.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Closes: https://lore.kernel.org/all/CA+G9fYtEh8zmq8k8wE-8RZwW-Qr927RLTn+KqGnq1F=ptaaNsA@mail.gmail.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240503075619.394467-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/io.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 4681d4c50567e..5ff8ab12f56c7 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -569,12 +569,12 @@ __do_out_asm(_rec_outl, "stwbrx")
 #define __do_inw(port)		_rec_inw(port)
 #define __do_inl(port)		_rec_inl(port)
 #else /* CONFIG_PPC32 */
-#define __do_outb(val, port)	writeb(val,(PCI_IO_ADDR)_IO_BASE+port);
-#define __do_outw(val, port)	writew(val,(PCI_IO_ADDR)_IO_BASE+port);
-#define __do_outl(val, port)	writel(val,(PCI_IO_ADDR)_IO_BASE+port);
-#define __do_inb(port)		readb((PCI_IO_ADDR)_IO_BASE + port);
-#define __do_inw(port)		readw((PCI_IO_ADDR)_IO_BASE + port);
-#define __do_inl(port)		readl((PCI_IO_ADDR)_IO_BASE + port);
+#define __do_outb(val, port)	writeb(val,(PCI_IO_ADDR)(_IO_BASE+port));
+#define __do_outw(val, port)	writew(val,(PCI_IO_ADDR)(_IO_BASE+port));
+#define __do_outl(val, port)	writel(val,(PCI_IO_ADDR)(_IO_BASE+port));
+#define __do_inb(port)		readb((PCI_IO_ADDR)(_IO_BASE + port));
+#define __do_inw(port)		readw((PCI_IO_ADDR)(_IO_BASE + port));
+#define __do_inl(port)		readl((PCI_IO_ADDR)(_IO_BASE + port));
 #endif /* !CONFIG_PPC32 */
 
 #ifdef CONFIG_EEH
@@ -590,12 +590,12 @@ __do_out_asm(_rec_outl, "stwbrx")
 #define __do_writesw(a, b, n)	_outsw(PCI_FIX_ADDR(a),(b),(n))
 #define __do_writesl(a, b, n)	_outsl(PCI_FIX_ADDR(a),(b),(n))
 
-#define __do_insb(p, b, n)	readsb((PCI_IO_ADDR)_IO_BASE+(p), (b), (n))
-#define __do_insw(p, b, n)	readsw((PCI_IO_ADDR)_IO_BASE+(p), (b), (n))
-#define __do_insl(p, b, n)	readsl((PCI_IO_ADDR)_IO_BASE+(p), (b), (n))
-#define __do_outsb(p, b, n)	writesb((PCI_IO_ADDR)_IO_BASE+(p),(b),(n))
-#define __do_outsw(p, b, n)	writesw((PCI_IO_ADDR)_IO_BASE+(p),(b),(n))
-#define __do_outsl(p, b, n)	writesl((PCI_IO_ADDR)_IO_BASE+(p),(b),(n))
+#define __do_insb(p, b, n)	readsb((PCI_IO_ADDR)(_IO_BASE+(p)), (b), (n))
+#define __do_insw(p, b, n)	readsw((PCI_IO_ADDR)(_IO_BASE+(p)), (b), (n))
+#define __do_insl(p, b, n)	readsl((PCI_IO_ADDR)(_IO_BASE+(p)), (b), (n))
+#define __do_outsb(p, b, n)	writesb((PCI_IO_ADDR)(_IO_BASE+(p)),(b),(n))
+#define __do_outsw(p, b, n)	writesw((PCI_IO_ADDR)(_IO_BASE+(p)),(b),(n))
+#define __do_outsl(p, b, n)	writesl((PCI_IO_ADDR)(_IO_BASE+(p)),(b),(n))
 
 #define __do_memset_io(addr, c, n)	\
 				_memset_io(PCI_FIX_ADDR(addr), c, n)
-- 
2.43.0



