Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D2D6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F63C433D2;
	Tue, 10 Jan 2023 18:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375185;
	bh=sDwQr0Wn1l01rcLgMrwtjowdjVfEvBNikKRTBJ+29/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fs3M/jOyJyfi3SfAjEC9LUUUBTIWu4K1ncGy7Gms3HaXwGi50aUMKezJAuu57arU1
	 t3n0jB1Dngj/bK3+nujC+ZJOLRVhiJ4h3KorxIvieVCXW/ZVCnOignRiZwmg5DB0K3
	 Mlx9CVdyeR1veKebCxQ9UNdY0HJ0BC88QaboTOeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <ndesaulniers@google.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.15 107/290] ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod
Date: Tue, 10 Jan 2023 19:03:19 +0100
Message-Id: <20230110180035.467200525@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nick Desaulniers <ndesaulniers@google.com>

commit 3220022038b9a3845eea762af85f1c5694b9f861 upstream.

clang-15's ability to elide loops completely became more aggressive when
it can deduce how a variable is being updated in a loop. Counting down
one variable by an increment of another can be replaced by a modulo
operation.

For 64b variables on 32b ARM EABI targets, this can result in the
compiler generating calls to __aeabi_uldivmod, which it does for a do
while loop in float64_rem().

For the kernel, we'd generally prefer that developers not open code 64b
division via binary / operators and instead use the more explicit
helpers from div64.h. On arm-linux-gnuabi targets, failure to do so can
result in linkage failures due to undefined references to
__aeabi_uldivmod().

While developers can avoid open coding divisions on 64b variables, the
compiler doesn't know that the Linux kernel has a partial implementation
of a compiler runtime (--rtlib) to enforce this convention.

It's also undecidable for the compiler whether the code in question
would be faster to execute the loop vs elide it and do the 64b division.

While I actively avoid using the internal -mllvm command line flags, I
think we get better code than using barrier() here, which will force
reloads+spills in the loop for all toolchains.

Link: https://github.com/ClangBuiltLinux/linux/issues/1666

Reported-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/nwfpe/Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/nwfpe/Makefile
+++ b/arch/arm/nwfpe/Makefile
@@ -11,3 +11,9 @@ nwfpe-y				+= fpa11.o fpa11_cpdo.o fpa11
 				   entry.o
 
 nwfpe-$(CONFIG_FPE_NWFPE_XP)	+= extended_cpdo.o
+
+# Try really hard to avoid generating calls to __aeabi_uldivmod() from
+# float64_rem() due to loop elision.
+ifdef CONFIG_CC_IS_CLANG
+CFLAGS_softfloat.o	+= -mllvm -replexitval=never
+endif


