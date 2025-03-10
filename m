Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7EC2343C5;
	Mon, 10 Mar 2025 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629418; cv=none; b=qtBFDbRwmsZV6KYF6nFjRHqNd1H2oqwsxPA9YnSQYfUf9eX/QVIf7aBJyWc66luVGFkEA1aHL5qGEiivKwGbhhH7SgJbSSzc7/UDuaffnE5WyRLF4BWca/Xw+QbIByEuBF7ac3ieQCSsdjr3G3eePyTZDYz2/xBpCDxv7InXQpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629418; c=relaxed/simple;
	bh=o4VMXnq519CjqIqG89OXMde5CJxXEwUHZCN+t1HVsog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgLSIzp6BBZvKDnEmuZP/EjifPw2TyfX1SlRoaUd2tQmN3wROb7HFpS5aV+rzisLQrhcoPhzTYM9DgIu0qaGtiwizIS0c8EQd2xPzbTwXqQ0kKG7LY1508mft+UtytS/cE5OP8hTdNtOJnLFPybGXNxbUVD9qrCrcEuZO8Jjh0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cayqTM8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cayqTM8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38843C4CEE5;
	Mon, 10 Mar 2025 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629417;
	bh=o4VMXnq519CjqIqG89OXMde5CJxXEwUHZCN+t1HVsog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cayqTM8jJpCI5bhsuobzd6kngPTT7aqgVL42q+hMAjZ+HFkaufUxXXtITQkv/lyoP
	 7o1QWW66pqe/AfqmpWXKtknCAuPNDFC84NO2xXgVMMvCmrJBKD8sqNaayji9h1nHHU
	 PcNJGC2+9J4eG5qSc7nDtzvhlE+NXseFDtnTf1kQ=
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
Subject: [PATCH 5.15 256/620] m68k: vga: Fix I/O defines
Date: Mon, 10 Mar 2025 18:01:42 +0100
Message-ID: <20250310170555.729285702@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


