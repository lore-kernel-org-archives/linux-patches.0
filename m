Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FAC3DDDD2;
	Mon,  4 May 2026 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903064; cv=none; b=CP7qMGTMG6faipPGcgbCPzGeBQO1pdDZqH5uoh4nqngZvYvfpph49nZgDTjtrVJ6AuS9hxoUqDJcRZsIgGlitbGp/PT06saJ3Jk12z7AvwFBAqkAmhlnvae3ZPrhzyDLL3kUHfywGAq4xJZanCWt8QMvoYh8sUqY95HEXofckaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903064; c=relaxed/simple;
	bh=Qp1QQLg3WZm4C2BMqoS/mZKG+ddqvs6Lwp3zodzXGII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBaVx5OuSQW451Td2Fj7hmHIr1ore8GeK2QDWCNbgrsSHsshh/euC3ETxQ8LkpBXy3whKeoOfBAhZ/HBChqvQfn17NJ4V9CdAW4fGe1vQtsMz0bp0U777j9MOViV13WG0DwjPDuZEzHsXjMCow+FLUziqTAbXTyP6ULWNgfpXgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZkQVCUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZkQVCUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A289DC2BCC4;
	Mon,  4 May 2026 13:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903064;
	bh=Qp1QQLg3WZm4C2BMqoS/mZKG+ddqvs6Lwp3zodzXGII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZkQVCUULtaqqLaqr403VyjMkU+qsRhFKXLEefB0V/tZDltTSP77v7k9Ze4QziAWW
	 pI4Q+BU3aQGbMPmNSiCeDjxQkhpoeGBw2IQQ3WMaYxsZ9V28aVDLA253MzAu1uHR10
	 ONXRT8E+pth75sPCmGJ5hkMyT4u7Weze4CivplMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.0 089/307] parisc: Drop ip_fast_csum() inline assembly implementation
Date: Mon,  4 May 2026 15:49:34 +0200
Message-ID: <20260504135146.163754726@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 3dd31a370c1dccb580f729af7c580ccb1ae3c0c9 upstream.

The assembly code of ip_fast_csum() triggers unaligned access warnings
if the IP header isn't correctly aligned:

 Kernel: unaligned access to 0x173d22e76 in inet_gro_receive+0xbc/0x2e8 (iir 0x0e8810b6)
 Kernel: unaligned access to 0x173d22e7e in inet_gro_receive+0xc4/0x2e8 (iir 0x0e88109a)
 Kernel: unaligned access to 0x173d22e82 in inet_gro_receive+0xc8/0x2e8 (iir 0x0e90109d)
 Kernel: unaligned access to 0x173d22e7a in inet_gro_receive+0xd0/0x2e8 (iir 0x0e9810b8)
 Kernel: unaligned access to 0x173d22e86 in inet_gro_receive+0xdc/0x2e8 (iir 0x0e8810b8)

We have the option to a) ignore the warnings, b) work around it by
adding more code to check for alignment, or c) to switch to the generic
implementation and rely on the compiler to optimize the code.

Let's go with c), because a) isn't nice, and b) would effectively lead
to an implementation which is basically equal to c).

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v7.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig                |    3 +
 arch/parisc/include/asm/checksum.h |   89 ---------------------------------
 arch/parisc/lib/Makefile           |    2 
 arch/parisc/lib/checksum.c         |   99 -------------------------------------
 4 files changed, 6 insertions(+), 187 deletions(-)
 delete mode 100644 arch/parisc/lib/checksum.c

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -130,6 +130,9 @@ config GENERIC_BUG
 config GENERIC_BUG_RELATIVE_POINTERS
 	bool
 
+config GENERIC_CSUM
+	def_bool y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
--- a/arch/parisc/include/asm/checksum.h
+++ b/arch/parisc/include/asm/checksum.h
@@ -4,73 +4,7 @@
 
 #include <linux/in6.h>
 
-/*
- * computes the checksum of a memory block at buff, length len,
- * and adds in "sum" (32-bit)
- *
- * returns a 32-bit number suitable for feeding into itself
- * or csum_tcpudp_magic
- *
- * this function must be called with even lengths, except
- * for the last fragment, which may be odd
- *
- * it's best to have buff aligned on a 32-bit boundary
- */
-extern __wsum csum_partial(const void *, int, __wsum);
-
-/*
- *	Optimized for IP headers, which always checksum on 4 octet boundaries.
- *
- *	Written by Randolph Chung <tausq@debian.org>, and then mucked with by
- *	LaMont Jones <lamont@debian.org>
- */
-static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
-{
-	unsigned int sum;
-	unsigned long t0, t1, t2;
-
-	__asm__ __volatile__ (
-"	ldws,ma		4(%1), %0\n"
-"	addib,<=	-4, %2, 2f\n"
-"\n"
-"	ldws		4(%1), %4\n"
-"	ldws		8(%1), %5\n"
-"	add		%0, %4, %0\n"
-"	ldws,ma		12(%1), %3\n"
-"	addc		%0, %5, %0\n"
-"	addc		%0, %3, %0\n"
-"1:	ldws,ma		4(%1), %3\n"
-"	addib,>		-1, %2, 1b\n"
-"	addc		%0, %3, %0\n"
-"\n"
-"	extru		%0, 31, 16, %4\n"
-"	extru		%0, 15, 16, %5\n"
-"	addc		%4, %5, %0\n"
-"	extru		%0, 15, 16, %5\n"
-"	add		%0, %5, %0\n"
-"	subi		-1, %0, %0\n"
-"2:\n"
-	: "=r" (sum), "=r" (iph), "=r" (ihl), "=r" (t0), "=r" (t1), "=r" (t2)
-	: "1" (iph), "2" (ihl)
-	: "memory");
-
-	return (__force __sum16)sum;
-}
-
-/*
- *	Fold a partial checksum
- */
-static inline __sum16 csum_fold(__wsum csum)
-{
-	u32 sum = (__force u32)csum;
-	/* add the swapped two 16-bit halves of sum,
-	   a possible carry from adding the two 16-bit halves,
-	   will carry from the lower half into the upper half,
-	   giving us the correct sum in the upper half. */
-	sum += (sum << 16) + (sum >> 16);
-	return (__force __sum16)(~sum >> 16);
-}
- 
+#define csum_tcpudp_nofold csum_tcpudp_nofold
 static inline __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 					__u32 len, __u8 proto,
 					__wsum sum)
@@ -85,26 +19,7 @@ static inline __wsum csum_tcpudp_nofold(
 	return sum;
 }
 
-/*
- * computes the checksum of the TCP/UDP pseudo-header
- * returns a 16-bit checksum, already complemented
- */
-static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
-					__u32 len, __u8 proto,
-					__wsum sum)
-{
-	return csum_fold(csum_tcpudp_nofold(saddr,daddr,len,proto,sum));
-}
-
-/*
- * this routine is used for miscellaneous IP-like checksums, mainly
- * in icmp.c
- */
-static inline __sum16 ip_compute_csum(const void *buf, int len)
-{
-	 return csum_fold (csum_partial(buf, len, 0));
-}
-
+#include <asm-generic/checksum.h>
 
 #define _HAVE_ARCH_IPV6_CSUM
 static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
--- a/arch/parisc/lib/Makefile
+++ b/arch/parisc/lib/Makefile
@@ -3,7 +3,7 @@
 # Makefile for parisc-specific library files
 #
 
-lib-y	:= lusercopy.o bitops.o checksum.o io.o memset.o memcpy.o \
+lib-y	:= lusercopy.o bitops.o io.o memset.o memcpy.o \
 	   ucmpdi2.o delay.o
 
 obj-y	:= iomap.o
--- a/arch/parisc/lib/checksum.c
+++ /dev/null
@@ -1,99 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * INET		An implementation of the TCP/IP protocol suite for the LINUX
- *		operating system.  INET is implemented using the  BSD Socket
- *		interface as the means of communication with the user level.
- *
- *		MIPS specific IP/TCP/UDP checksumming routines
- *
- * Authors:	Ralf Baechle, <ralf@waldorf-gmbh.de>
- *		Lots of code moved from tcp.c and ip.c; see those files
- *		for more names.
- */
-#include <linux/module.h>
-#include <linux/types.h>
-
-#include <net/checksum.h>
-#include <asm/byteorder.h>
-#include <asm/string.h>
-#include <linux/uaccess.h>
-
-#define addc(_t,_r)                     \
-	__asm__ __volatile__ (          \
-"       add             %0, %1, %0\n"   \
-"       addc            %0, %%r0, %0\n" \
-	: "=r"(_t)                      \
-	: "r"(_r), "0"(_t));
-
-static inline unsigned int do_csum(const unsigned char * buff, int len)
-{
-	int odd, count;
-	unsigned int result = 0;
-
-	if (len <= 0)
-		goto out;
-	odd = 1 & (unsigned long) buff;
-	if (odd) {
-		result = be16_to_cpu(*buff);
-		len--;
-		buff++;
-	}
-	count = len >> 1;		/* nr of 16-bit words.. */
-	if (count) {
-		if (2 & (unsigned long) buff) {
-			result += *(unsigned short *) buff;
-			count--;
-			len -= 2;
-			buff += 2;
-		}
-		count >>= 1;		/* nr of 32-bit words.. */
-		if (count) {
-			while (count >= 4) {
-				unsigned int r1, r2, r3, r4;
-				r1 = *(unsigned int *)(buff + 0);
-				r2 = *(unsigned int *)(buff + 4);
-				r3 = *(unsigned int *)(buff + 8);
-				r4 = *(unsigned int *)(buff + 12);
-				addc(result, r1);
-				addc(result, r2);
-				addc(result, r3);
-				addc(result, r4);
-				count -= 4;
-				buff += 16;
-			}
-			while (count) {
-				unsigned int w = *(unsigned int *) buff;
-				count--;
-				buff += 4;
-				addc(result, w);
-			}
-			result = (result & 0xffff) + (result >> 16);
-		}
-		if (len & 2) {
-			result += *(unsigned short *) buff;
-			buff += 2;
-		}
-	}
-	if (len & 1)
-		result += le16_to_cpu(*buff);
-	result = csum_from32to16(result);
-	if (odd)
-		result = swab16(result);
-out:
-	return result;
-}
-
-/*
- * computes a partial checksum, e.g. for TCP/UDP fragments
- */
-/*
- * why bother folding?
- */
-__wsum csum_partial(const void *buff, int len, __wsum sum)
-{
-	unsigned int result = do_csum(buff, len);
-	addc(result, sum);
-	return (__force __wsum)csum_from32to16(result);
-}
-
-EXPORT_SYMBOL(csum_partial);


