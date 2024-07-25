Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C568468;
	Thu, 25 Jul 2024 14:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918972; cv=none; b=Efhd6yWSfqhbid2v1XhZtricnOQoSVNTiM/nEx+FZjR2KjiVJVFVpngG54VlF0NykfRd3DVmIESfdE6pPlpb2FhnDFsZGAWdcizt+wU2PCru//rrWF2yejpFaG/eq+I1D0YRQwP6f5xm5h0dNj9uWhkY9uo+r9qSkztxbxcKKhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918972; c=relaxed/simple;
	bh=d2v3qkLuJVby0m4z6Z8UhisrLCBQ2IVj8o9e4RGG6Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNS2UUYe6R4NzuBayAkJHP4TesH0XnubIvBDvRR0NC2nZg38MQ9/wGt22bB66CSo1SMeYWoy2Li2dYWZxseSgauyS5K4Wx27bf4XdzjKR/oDZ1UIt1AUIwu9W8zkGhpAJ/9csjqwXCBKlL7Wq2Wm3ynPolcIF3OKdlo5hQ/GFMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtUkZv33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtUkZv33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F6EC116B1;
	Thu, 25 Jul 2024 14:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918972;
	bh=d2v3qkLuJVby0m4z6Z8UhisrLCBQ2IVj8o9e4RGG6Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtUkZv3303Gho4XB/At71HwUhuJKb8r1ZYQ8b/MwVqtqXZ7PMVBYRjjGG7HyS5Ev9
	 BOgcSsitB/BEy0S9opgu2tXupYQtZE6ayiWVJJiqpv0/zhNhnkTFaOBYi63OvmQdYo
	 xfj+iSKDA7Oxtt8Lk3LnoT8az3cOFti8RINj7fzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 5.10 44/59] ARM: 9324/1: fix get_user() broken with veneer
Date: Thu, 25 Jul 2024 16:37:34 +0200
Message-ID: <20240725142734.926686214@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -147,16 +147,6 @@ extern int __get_user_64t_1(void *);
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
@@ -164,7 +154,7 @@ extern int __get_user_64t_4(void *);
 		"bl	__get_user_" #__s				\
 		: "=&r" (__e), "=r" (__r2)				\
 		: "0" (__p), "r" (__l)					\
-		: __GUP_CLOBBER_##__s)
+		: "ip", "lr", "cc")
 
 /* narrowing a double-word get into a single 32bit word register: */
 #ifdef __ARMEB__
@@ -186,7 +176,7 @@ extern int __get_user_64t_4(void *);
 		"bl	__get_user_64t_" #__s				\
 		: "=&r" (__e), "=r" (__r2)				\
 		: "0" (__p), "r" (__l)					\
-		: __GUP_CLOBBER_##__s)
+		: "ip", "lr", "cc")
 #else
 #define __get_user_x_64t __get_user_x
 #endif


