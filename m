Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436DC158215;
	Tue, 23 Jul 2024 18:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759766; cv=none; b=p9dyVPtjlxTvenDjg5njNnAua/inG8IWKOG8Ns4uxLzUKr3dYlmJhIH3ibMhrkXRmUD+S0gxsEqw6Ag/LVZfF2UryU3B6+onytyJ6GJ6BEil4ezK5kK83MK4kg18bmZw2B2x64jz/QTDtdfp8xyBsY3vL+Vvp+h1DIO/Cm8OkIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759766; c=relaxed/simple;
	bh=XKMdenBcGs14TaNFKTy2CtecZgJ3MZYe4Mpye/WlVXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8PXRRjoMdx3ZHadLMN/1RUVtBZ8Z9QKxvAxbNz5Vw1h4aqPTxCzhqEV0dGQ2B7PTrh3Nn6lb6enJDBeX+EEwZQ4V8M6kGcCeyA/iRgBP+2j6xQi10TEd4mOGQxYtTeYOKIXGj0M6VkYrrAgANAi9zCdtLAu85zqGUoN4LHE6PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvtkUbQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvtkUbQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15BFC4AF0A;
	Tue, 23 Jul 2024 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759766;
	bh=XKMdenBcGs14TaNFKTy2CtecZgJ3MZYe4Mpye/WlVXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvtkUbQIhjs0LZGIfXCWA2rnr3cKjNHf5RCfItU9fwTJIAAftmhX5afZfwjCQ504p
	 2FTz4bIOpycH5XkXQjfzYMkQ55sjDHdrruFCp4jMoho5bFDQZHTzo7177MVsBA/eOt
	 CVcad4oJixu5Mbvhk2h3766JhLF/PZX0l5h9Nw+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 6.6 120/129] ARM: 9324/1: fix get_user() broken with veneer
Date: Tue, 23 Jul 2024 20:24:28 +0200
Message-ID: <20240723180409.426694227@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -109,16 +109,6 @@ extern int __get_user_64t_1(void *);
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
@@ -126,7 +116,7 @@ extern int __get_user_64t_4(void *);
 		"bl	__get_user_" #__s				\
 		: "=&r" (__e), "=r" (__r2)				\
 		: "0" (__p), "r" (__l)					\
-		: __GUP_CLOBBER_##__s)
+		: "ip", "lr", "cc")
 
 /* narrowing a double-word get into a single 32bit word register: */
 #ifdef __ARMEB__
@@ -148,7 +138,7 @@ extern int __get_user_64t_4(void *);
 		"bl	__get_user_64t_" #__s				\
 		: "=&r" (__e), "=r" (__r2)				\
 		: "0" (__p), "r" (__l)					\
-		: __GUP_CLOBBER_##__s)
+		: "ip", "lr", "cc")
 #else
 #define __get_user_x_64t __get_user_x
 #endif


