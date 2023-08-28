Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB1811C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2975C433C9;
	Mon, 28 Aug 2023 10:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217817;
	bh=zMstjQ9X/zORgAzjsW2yzYM2K+lzmumhTJbVftqCLhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkgeKep/+zcVKGiO92xjBVENipwDGSB4U7esE3LV/Y2L1JfHrMPGYfIY8TZoynyly
	 nBxRA9K2SvAwSKfApHLVneeuvo7rcNUAH/qcH2QW/NqGoc+ZqIJJ+vdb153zRsLRBC
	 7oC12gPadrBbzk9JbWW4aqqALesSexpOcPNOQjrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Chanho Min <chanho.min@lge.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 51/57] lib/clz_ctz.c: Fix __clzdi2() and __ctzdi2() for 32-bit kernels
Date: Mon, 28 Aug 2023 12:13:11 +0200
Message-ID: <20230828101146.148941596@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>
References: <20230828101144.231099710@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 382d4cd1847517ffcb1800fd462b625db7b2ebea upstream.

The gcc compiler translates on some architectures the 64-bit
__builtin_clzll() function to a call to the libgcc function __clzdi2(),
which should take a 64-bit parameter on 32- and 64-bit platforms.

But in the current kernel code, the built-in __clzdi2() function is
defined to operate (wrongly) on 32-bit parameters if BITS_PER_LONG ==
32, thus the return values on 32-bit kernels are in the range from
[0..31] instead of the expected [0..63] range.

This patch fixes the in-kernel functions __clzdi2() and __ctzdi2() to
take a 64-bit parameter on 32-bit kernels as well, thus it makes the
functions identical for 32- and 64-bit kernels.

This bug went unnoticed since kernel 3.11 for over 10 years, and here
are some possible reasons for that:

 a) Some architectures have assembly instructions to count the bits and
    which are used instead of calling __clzdi2(), e.g. on x86 the bsr
    instruction and on ppc cntlz is used. On such architectures the
    wrong __clzdi2() implementation isn't used and as such the bug has
    no effect and won't be noticed.

 b) Some architectures link to libgcc.a, and the in-kernel weak
    functions get replaced by the correct 64-bit variants from libgcc.a.

 c) __builtin_clzll() and __clzdi2() doesn't seem to be used in many
    places in the kernel, and most likely only in uncritical functions,
    e.g. when printing hex values via seq_put_hex_ll(). The wrong return
    value will still print the correct number, but just in a wrong
    formatting (e.g. with too many leading zeroes).

 d) 32-bit kernels aren't used that much any longer, so they are less
    tested.

A trivial testcase to verify if the currently running 32-bit kernel is
affected by the bug is to look at the output of /proc/self/maps:

Here the kernel uses a correct implementation of __clzdi2():

  root@debian:~# cat /proc/self/maps
  00010000-00019000 r-xp 00000000 08:05 787324     /usr/bin/cat
  00019000-0001a000 rwxp 00009000 08:05 787324     /usr/bin/cat
  0001a000-0003b000 rwxp 00000000 00:00 0          [heap]
  f7551000-f770d000 r-xp 00000000 08:05 794765     /usr/lib/hppa-linux-gnu/libc.so.6
  ...

and this kernel uses the broken implementation of __clzdi2():

  root@debian:~# cat /proc/self/maps
  0000000010000-0000000019000 r-xp 00000000 000000008:000000005 787324  /usr/bin/cat
  0000000019000-000000001a000 rwxp 000000009000 000000008:000000005 787324  /usr/bin/cat
  000000001a000-000000003b000 rwxp 00000000 00:00 0  [heap]
  00000000f73d1000-00000000f758d000 r-xp 00000000 000000008:000000005 794765  /usr/lib/hppa-linux-gnu/libc.so.6
  ...

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: 4df87bb7b6a22 ("lib: add weak clz/ctz functions")
Cc: Chanho Min <chanho.min@lge.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org # v3.11+
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/clz_ctz.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

--- a/lib/clz_ctz.c
+++ b/lib/clz_ctz.c
@@ -30,36 +30,16 @@ int __weak __clzsi2(int val)
 }
 EXPORT_SYMBOL(__clzsi2);
 
-int __weak __clzdi2(long val);
-int __weak __ctzdi2(long val);
-#if BITS_PER_LONG == 32
-
-int __weak __clzdi2(long val)
+int __weak __clzdi2(u64 val);
+int __weak __clzdi2(u64 val)
 {
-	return 32 - fls((int)val);
+	return 64 - fls64(val);
 }
 EXPORT_SYMBOL(__clzdi2);
 
-int __weak __ctzdi2(long val)
+int __weak __ctzdi2(u64 val);
+int __weak __ctzdi2(u64 val)
 {
-	return __ffs((u32)val);
+	return __ffs64(val);
 }
 EXPORT_SYMBOL(__ctzdi2);
-
-#elif BITS_PER_LONG == 64
-
-int __weak __clzdi2(long val)
-{
-	return 64 - fls64((u64)val);
-}
-EXPORT_SYMBOL(__clzdi2);
-
-int __weak __ctzdi2(long val)
-{
-	return __ffs64((u64)val);
-}
-EXPORT_SYMBOL(__ctzdi2);
-
-#else
-#error BITS_PER_LONG not 32 or 64
-#endif


