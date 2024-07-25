Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1331319D06D;
	Thu, 25 Jul 2024 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918467; cv=none; b=T7gdGBQE3C5nknHD40c/jTPUJ326MIhWgvu9+zEs/cjNcXh7chZD3aM6mRMydsStOPiPCft5OprPvaaNdQUXI+PynoNk/mE3jkEYQiXpYeKnwI0waHOc7YIftzsfk37rliee8gqbJ2nWTf7bMM7uMGtcBajCVH8UUh1cfexehjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918467; c=relaxed/simple;
	bh=eWW3Qq77Xz1JDT5u+4QLE18B/Z/+J/rGCcshiQTPOHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUvLvm2OmMCyynlk0GFPQVWuOg0p5d0RfJAsQYEDcg3hl8d+DTt2+jUBdQMmzaQj4xU6Kn6Cp6yIEbabIDQnmyfeQK/JPUfp9V1Gxp5/SQfIu3AZ8IBMBP9Fn26Lf6KvuC3eGkGsVfC9GCPMLVSj+ZOBWfyyW8vPRx/5ZpTokbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvws5Mn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvws5Mn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDA2C116B1;
	Thu, 25 Jul 2024 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918467;
	bh=eWW3Qq77Xz1JDT5u+4QLE18B/Z/+J/rGCcshiQTPOHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvws5Mn0p7VacfVtb9JVCb0SeDedlBrRcvviKXt86DrTdgxjsJFaIex4J3E0KWOhq
	 0yewxG+YX8gwCtwHmTlbBYEzEr2nreg6/3h7r6uXQWlRXmHywHfm6iEiURUTN0MEZW
	 piATlO8MvMHPST+noLCP6XMWgoKPFaFP3iQUdJ/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 4.19 28/33] ARM: 9324/1: fix get_user() broken with veneer
Date: Thu, 25 Jul 2024 16:36:51 +0200
Message-ID: <20240725142729.571727472@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit 24d3ba0a7b44c1617c27f5045eecc4f34752ab03 upstream.

The 32-bit ARM kernel stops working if the kernel grows to the point
where veneers for __get_user_* are created.

AAPCS32 [1] states, "Register r12 (IP) may be used by a linker as a
scratch register between a routine and any subroutine it calls. It
can also be used within a routine to hold intermediate values between
subroutine calls."

However, bl instructions buried within the inline asm are unpredictable
for compilers; hence, "ip" must be added to the clobber list.

This becomes critical when veneers for __get_user_* are created because
veneers use the ip register since commit 02e541db0540 ("ARM: 8323/1:
force linker to use PIC veneers").

[1]: https://github.com/ARM-software/abi-aa/blob/2023Q1/aapcs32/aapcs32.rst

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: John Stultz <jstultz@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/uaccess.h |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -145,16 +145,6 @@ extern int __get_user_64t_1(void *);
 extern int __get_user_64t_2(void *);
 extern int __get_user_64t_4(void *);
 
-#define __GUP_CLOBBER_1	"lr", "cc"
-#ifdef CONFIG_CPU_USE_DOMAINS
-#define __GUP_CLOBBER_2	"ip", "lr", "cc"
-#else
-#define __GUP_CLOBBER_2 "lr", "cc"
-#endif
-#define __GUP_CLOBBER_4	"lr", "cc"
-#define __GUP_CLOBBER_32t_8 "lr", "cc"
-#define __GUP_CLOBBER_8	"lr", "cc"
-
 #define __get_user_x(__r2, __p, __e, __l, __s)				\
 	   __asm__ __volatile__ (					\
 		__asmeq("%0", "r0") __asmeq("%1", "r2")			\
@@ -162,7 +152,7 @@ extern int __get_user_64t_4(void *);
 		"bl	__get_user_" #__s				\
 		: "=&r" (__e), "=r" (__r2)				\
 		: "0" (__p), "r" (__l)					\
-		: __GUP_CLOBBER_##__s)
+		: "ip", "lr", "cc")
 
 /* narrowing a double-word get into a single 32bit word register: */
 #ifdef __ARMEB__
@@ -184,7 +174,7 @@ extern int __get_user_64t_4(void *);
 		"bl	__get_user_64t_" #__s				\
 		: "=&r" (__e), "=r" (__r2)				\
 		: "0" (__p), "r" (__l)					\
-		: __GUP_CLOBBER_##__s)
+		: "ip", "lr", "cc")
 #else
 #define __get_user_x_64t __get_user_x
 #endif


