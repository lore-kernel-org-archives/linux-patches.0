Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E2B36493F;
	Thu, 30 Jul 2026 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422956; cv=none; b=sNYFL4kfgL9kRzRORMyixDwsjoPujWi0oauB4x5MRP1DuS3NmkzDJu+bqfXxrOzSkvlbjJIt5WPeQso8JnD1foqWRZ/S/dsaPYx2a7k/+ZwJihgbsbGih1jvFsKVINfXc5ntILNwmnQ5VNFpuJ8q4edTMUPc/APNTOj/SFX4kqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422956; c=relaxed/simple;
	bh=VqxnwdHpiRtido35EsnNUEi0wbDjW5F3FKyvOOHUA3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QhCjpR0+7vAk4YtkRVeThxLY/8DNBGbL8VwzUkN+PAsrECcaUbsWfl+ibqnkelWD9/Z2eKm6/ttTaR0In1iPavGSxjBjzpc+UiE3/HtetMjUAxmsBUDDp3CIEraoFp4TX8hsoML5R90RgY2t0U1oKSkcV3xPl+v9E+ksWlTBiT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNGL91lD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNGL91lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CA81F000E9;
	Thu, 30 Jul 2026 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422955;
	bh=5akkgauxPwKzUPhUv4gXKTQz0qrHkCcZlwF+PnuIkgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNGL91lD8JQhVaGfLhP6mG0+TQV6YoTVIki56m3N1DcoF+yS53Wbq6BjCFRFzeUS7
	 CbvSNRMi33JCZkcuA67+G+gPgxKaMGdZ2ZLO3ZqLPhgKJ4MykaBuGskN2b26YWZBcC
	 u50WsZJzb4yxp8RuJwGelOaP1vkGBmhfdVpQrHi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andreas Schwab <schwab@linux-m68k.org>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 616/744] m68k: avoid -Wunused-but-set-parameter in clear_user_page()
Date: Thu, 30 Jul 2026 16:14:49 +0200
Message-ID: <20260730141457.367452213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 955b67c3ddf9912a670ed80eae7769745b4f405e upstream.

The loop in clear_user_pages() iterates over all pages and calls
clear_user_page() for each of them.  During the loop "vaddr" is modified.
However on m68k clear_user() is a macro which does not use "vaddr".  The
compiler sees a variable which is modified but never used and emits a
warning for that:

include/linux/highmem.h: In function 'clear_user_pages':
include/linux/highmem.h:234:63: warning: parameter 'vaddr' set but not used [-Wunused-but-set-parameter=]
    static inline void clear_user_pages(void *addr, unsigned long vaddr,

Other architectures use an inline function for clear_user_page() which
avoids the warning.  This is not possible on m68k, as dlush_dcache_page()
is another macro which is not yet defined where clear_user_page() is
defined.  Including cacheflush_mm.h will trigger recursive and lots of
other issues.

So hide the warning with a cast to (void) instead.

While we are here, do the same for copy_user_page().

Link: https://lore.kernel.org/20260525-m68k-clear_user_page-v2-1-0c8981c6eca1@weissschuh.net
Fixes: 62a9f5a85b98 ("mm: introduce clear_pages() and clear_user_pages()")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/include/asm/page_mm.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/m68k/include/asm/page_mm.h
+++ b/arch/m68k/include/asm/page_mm.h
@@ -55,10 +55,12 @@ static inline void clear_page(void *page
 #define clear_user_page(addr, vaddr, page)	\
 	do {	clear_page(addr);		\
 		flush_dcache_page(page);	\
+		(void)(vaddr);			\
 	} while (0)
 #define copy_user_page(to, from, vaddr, page)	\
 	do {	copy_page(to, from);		\
 		flush_dcache_page(page);	\
+		(void)(vaddr);			\
 	} while (0)
 
 extern unsigned long m68k_memoffset;


