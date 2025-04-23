Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D9225F7AD;
	Wed, 23 Apr 2025 15:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420500; cv=none; b=VvSM5Vf+rThuUtnvW8S7ihEGBdSmHOqgu2MeE9hulR/8hx9wekFLCJbuASyfRlkXetOO+OvKCHDCi/PL3W7YKDFMfUzGz8JL8xoNSzcPZeAlj/Hmahne73d0Y62l2YmzDEByy70m8sD4jNhtWqUHhGZLyZos89zKC0lEY1WTPJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420500; c=relaxed/simple;
	bh=SYle0wbFSFI9tw1WMgtXWQqKyjyiy6DUHNnLSe7ne4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mP6ivwUqGObc/O6cK4vnRHwCB4xux3AIgDP3neePFK4+yLDoC6OWZXTxvDrYb3Wj/f3NqexxHWsLdjKLlvw6v/pOczLhppxW2aDQxNvBl5wKvA/jMv5f3ROwI/w29AuQEbADfoL7jbum/UTtKJUSi5WMpSroUp9tgHTc1XWLWhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bt8wJedg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bt8wJedg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CD3C4CEE2;
	Wed, 23 Apr 2025 15:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420500;
	bh=SYle0wbFSFI9tw1WMgtXWQqKyjyiy6DUHNnLSe7ne4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bt8wJedgrW1BV7GnVwc75BKZtm0bxybivncATUZk30NFdRms6K7U6Yp9CT3tpoAR1
	 p3HO1toC8U21qTv3a91NChoFMnbiW3CgSWHuZiONdgmrGSN3PlObsuLQg5f2pztAHA
	 3h1Q8142YMS0uv6dsXOqDlShB4h9t+rJygYCCVgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 097/241] rust: helpers: Remove volatile qualifier from io helpers
Date: Wed, 23 Apr 2025 16:42:41 +0200
Message-ID: <20250423142624.543281070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit 584e61452f75bfeac2cdd83730b4059526ec60c7 upstream.

Remove the `volatile` qualifier used with __iomem in helper functions
in io.c. These helper functions are just wrappers around the
corresponding accessors so they are unnecessary.

This fixes the following UML build error with CONFIG_RUST enabled:

In file included from rust/helpers/helpers.c:19:
rust/helpers/io.c:12:10: error: passing 'volatile void *' to parameter of type 'void *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
   12 |         iounmap(addr);
      |                 ^~~~
arch/um/include/asm/io.h:19:42: note: passing argument to parameter 'addr' here
   19 | static inline void iounmap(void __iomem *addr)
      |                                          ^
1 error generated.

[ Arnd explains [1] that removing the qualifier is the way forward
  (thanks!):

    Rihgt, I tried this last week when it came up first, removing the
    'volatile' annotations in the asm-generic/io.h header and then
    all the ones that caused build regressions on arm/arm64/x86
    randconfig and allmodconfig builds.  This patch is a little
    longer than my original version as I did run into a few
    regressions later.

    As far as I can tell, none of these volatile annotations have
    any actual effect, and most of them date back to ancient kernels
    where this may have been required.

    Leaving it out of the rust interface is clearly the right way,
    and it shouldn't be too hard to upstream the changes below
    when we need to, but I also don't see any priority to send these.
    If anyone wants to help out, I can send them the whole patch.

  I created an issue [2] in case someone wants to help. - Miguel ]

Fixes: ce30d94e6855 ("rust: add `io::{Io, IoRaw}` base types")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/rust-for-linux/0c844b70-19c7-4b14-ba29-fc99ae0d69f0@app.fastmail.com/ [1]
Link: https://github.com/Rust-for-Linux/linux/issues/1156 [2]
Link: https://lore.kernel.org/r/20250412005341.157150-1-fujita.tomonori@gmail.com
[ Reworded for relative paths. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/helpers/io.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/rust/helpers/io.c b/rust/helpers/io.c
index 4c2401ccd720..15ea187c5466 100644
--- a/rust/helpers/io.c
+++ b/rust/helpers/io.c
@@ -7,94 +7,94 @@ void __iomem *rust_helper_ioremap(phys_addr_t offset, size_t size)
 	return ioremap(offset, size);
 }
 
-void rust_helper_iounmap(volatile void __iomem *addr)
+void rust_helper_iounmap(void __iomem *addr)
 {
 	iounmap(addr);
 }
 
-u8 rust_helper_readb(const volatile void __iomem *addr)
+u8 rust_helper_readb(const void __iomem *addr)
 {
 	return readb(addr);
 }
 
-u16 rust_helper_readw(const volatile void __iomem *addr)
+u16 rust_helper_readw(const void __iomem *addr)
 {
 	return readw(addr);
 }
 
-u32 rust_helper_readl(const volatile void __iomem *addr)
+u32 rust_helper_readl(const void __iomem *addr)
 {
 	return readl(addr);
 }
 
 #ifdef CONFIG_64BIT
-u64 rust_helper_readq(const volatile void __iomem *addr)
+u64 rust_helper_readq(const void __iomem *addr)
 {
 	return readq(addr);
 }
 #endif
 
-void rust_helper_writeb(u8 value, volatile void __iomem *addr)
+void rust_helper_writeb(u8 value, void __iomem *addr)
 {
 	writeb(value, addr);
 }
 
-void rust_helper_writew(u16 value, volatile void __iomem *addr)
+void rust_helper_writew(u16 value, void __iomem *addr)
 {
 	writew(value, addr);
 }
 
-void rust_helper_writel(u32 value, volatile void __iomem *addr)
+void rust_helper_writel(u32 value, void __iomem *addr)
 {
 	writel(value, addr);
 }
 
 #ifdef CONFIG_64BIT
-void rust_helper_writeq(u64 value, volatile void __iomem *addr)
+void rust_helper_writeq(u64 value, void __iomem *addr)
 {
 	writeq(value, addr);
 }
 #endif
 
-u8 rust_helper_readb_relaxed(const volatile void __iomem *addr)
+u8 rust_helper_readb_relaxed(const void __iomem *addr)
 {
 	return readb_relaxed(addr);
 }
 
-u16 rust_helper_readw_relaxed(const volatile void __iomem *addr)
+u16 rust_helper_readw_relaxed(const void __iomem *addr)
 {
 	return readw_relaxed(addr);
 }
 
-u32 rust_helper_readl_relaxed(const volatile void __iomem *addr)
+u32 rust_helper_readl_relaxed(const void __iomem *addr)
 {
 	return readl_relaxed(addr);
 }
 
 #ifdef CONFIG_64BIT
-u64 rust_helper_readq_relaxed(const volatile void __iomem *addr)
+u64 rust_helper_readq_relaxed(const void __iomem *addr)
 {
 	return readq_relaxed(addr);
 }
 #endif
 
-void rust_helper_writeb_relaxed(u8 value, volatile void __iomem *addr)
+void rust_helper_writeb_relaxed(u8 value, void __iomem *addr)
 {
 	writeb_relaxed(value, addr);
 }
 
-void rust_helper_writew_relaxed(u16 value, volatile void __iomem *addr)
+void rust_helper_writew_relaxed(u16 value, void __iomem *addr)
 {
 	writew_relaxed(value, addr);
 }
 
-void rust_helper_writel_relaxed(u32 value, volatile void __iomem *addr)
+void rust_helper_writel_relaxed(u32 value, void __iomem *addr)
 {
 	writel_relaxed(value, addr);
 }
 
 #ifdef CONFIG_64BIT
-void rust_helper_writeq_relaxed(u64 value, volatile void __iomem *addr)
+void rust_helper_writeq_relaxed(u64 value, void __iomem *addr)
 {
 	writeq_relaxed(value, addr);
 }
-- 
2.49.0



