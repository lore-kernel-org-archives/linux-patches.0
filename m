Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6753426B083;
	Thu, 13 Feb 2025 15:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459054; cv=none; b=PpF7Lixi4+J0nedbYSXOp6qiNf2CutX8dkTb3GomrQt8Db/azlzypD2j3O4e4NWjCcGtPPeRHgh4J6KCc8jT5fUqTGAK/BjtHKBHAQHJb/XTFa9MRaB+1FNg6gfNn2Gfe1BQ4r3FdoKggWJrIDxJkEqqGyXh1BzAqVh9dsUl0iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459054; c=relaxed/simple;
	bh=DtMz6W33X9WUVWNCV3071HieI0ykPZkbSQM1NRNvx98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJTcCDqA3/2HehoXquGOU4xzvQyBx4f6AtcLHMabVXgjqwxjulazhXLb8G1+bDmiIMkLi5gea+CUAGFtWkhYxC9D53q2ahrUONJ8vGQ5UFff4mlKrYtQUQS/DcGbaC1PQJnKQDvGtvVK2hmViQzhdH1rH6qO9tedjbv3mlqFK/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0egEo0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0egEo0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65124C4CED1;
	Thu, 13 Feb 2025 15:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459053;
	bh=DtMz6W33X9WUVWNCV3071HieI0ykPZkbSQM1NRNvx98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0egEo0PhLlSMTCMTmBYBQfRy6ajOfw/le+OwWti5lL3fhb1tDqL3rbdSolM6IjUn
	 kKqv0RXh1wrKue713HLDV5QG2QYK3QvlM4VDRXJW+yEVXbvUXJlHlPGpSzYSus9i9m
	 /Pf1Coij2mC+m0KraRuq2sX+rqAtMGhxn9EJvbfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.13 154/443] m68k: vga: Fix I/O defines
Date: Thu, 13 Feb 2025 15:25:19 +0100
Message-ID: <20250213142446.540207561@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 53036937a101b5faeaf98e7438555fa854a1a844 upstream.

Including m68k's <asm/raw_io.h> in vga.h on nommu platforms results
in conflicting defines with io_no.h for various I/O macros from the
__raw_read and __raw_write families. An example error is

   In file included from arch/m68k/include/asm/vga.h:12,
                 from include/video/vga.h:22,
                 from include/linux/vgaarb.h:34,
		 from drivers/video/aperture.c:12:
>> arch/m68k/include/asm/raw_io.h:39: warning: "__raw_readb" redefined
      39 | #define __raw_readb in_8
	 |
   In file included from arch/m68k/include/asm/io.h:6,
		    from include/linux/io.h:13,
		    from include/linux/irq.h:20,
		    from include/asm-generic/hardirq.h:17,
		    from ./arch/m68k/include/generated/asm/hardirq.h:1,
		    from include/linux/hardirq.h:11,
		    from include/linux/interrupt.h:11,
                    from include/linux/trace_recursion.h:5,
		    from include/linux/ftrace.h:10,
		    from include/linux/kprobes.h:28,
		    from include/linux/kgdb.h:19,
		    from include/linux/fb.h:6,
		    from drivers/video/aperture.c:5:
   arch/m68k/include/asm/io_no.h:16: note: this is the location of the previous definition
      16 | #define __raw_readb(addr) \
	 |

Include <asm/io.h>, which avoids raw_io.h on nommu platforms.
Also change the defined values of some of the read/write symbols in
vga.h to __raw_read/__raw_write as the raw_in/raw_out symbols are not
generally available.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501071629.DNEswlm8-lkp@intel.com/
Fixes: 5c3f968712ce ("m68k/video: Create <asm/vga.h>")
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v3.5+
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/20250107095912.130530-1-tzimmermann@suse.de
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/include/asm/vga.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/m68k/include/asm/vga.h
+++ b/arch/m68k/include/asm/vga.h
@@ -9,7 +9,7 @@
  */
 #ifndef CONFIG_PCI
 
-#include <asm/raw_io.h>
+#include <asm/io.h>
 #include <asm/kmap.h>
 
 /*
@@ -29,9 +29,9 @@
 #define inw_p(port)		0
 #define outb_p(port, val)	do { } while (0)
 #define outw(port, val)		do { } while (0)
-#define readb			raw_inb
-#define writeb			raw_outb
-#define writew			raw_outw
+#define readb			__raw_readb
+#define writeb			__raw_writeb
+#define writew			__raw_writew
 
 #endif /* CONFIG_PCI */
 #endif /* _ASM_M68K_VGA_H */


