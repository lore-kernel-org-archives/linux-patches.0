Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66F036998C;
	Wed, 17 Sep 2025 12:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113671; cv=none; b=M2Z1GDK4aCPwIO/KP6fIQSzjxuxPP/r94IExFhW6ZUAR1oRZoyrO2bneZidbAA+TRbKAC6O8w1hCOEJsnNEi3SILHGRP1qH4O6LBIVk5UZn0QHyg5Nrarq0TjcZ8rPlxUXy1bRr4QQIpEGzi9P5hNjjKnb1coqbFWdE77cQ1MmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113671; c=relaxed/simple;
	bh=xVDT9CzLPZOkIW0rkgm3sEOB4IR+loHfRQ3RrBUU4ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0xZXYawZ2Y8rpQAsWDmFVR3/Dx1gDNAptNEexqnC8T/rnhBBtg1j9kFw7+/OTYJnfXlHVuk/49M3uePmzo93hcwfG9hyMvumcR8kUgsY/OSbDi2COxIlm2qmvCs8N5Nahds9tXKvv0/DOKnlbbxH0zZIALXp9esbUUKZ+wFga4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsFxuYXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsFxuYXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15097C4CEF5;
	Wed, 17 Sep 2025 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113671;
	bh=xVDT9CzLPZOkIW0rkgm3sEOB4IR+loHfRQ3RrBUU4ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsFxuYXhDRgXj5Yejrfnf3o9XufT7eZLVCn3P1R76Sib6mxSuIYXmf/hzw72tBz7d
	 fQzbuc85LqjD+z5DRrosGWnH7kVjYjvEZtm5uVlqlauLvlMVUmk94UE7sVVK/Yh7+8
	 DdnOcji5W4j1kjdcKbjGkiOr54s/04btFIz3+3C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Marc Rutland <mark.rutland@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/101] kasan: fix GCC mem-intrinsic prefix with sw tags
Date: Wed, 17 Sep 2025 14:33:46 +0200
Message-ID: <20250917123336.949214209@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ada Couprie Diaz <ada.coupriediaz@arm.com>

[ Upstream commit 51337a9a3a404fde0f5337662ffc7699793dfeb5 ]

GCC doesn't support "hwasan-kernel-mem-intrinsic-prefix", only
"asan-kernel-mem-intrinsic-prefix"[0], while LLVM supports both.  This is
already taken into account when checking
"CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX", but not in the KASAN Makefile
adding those parameters when "CONFIG_KASAN_SW_TAGS" is enabled.

Replace the version check with "CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX",
which already validates that mem-intrinsic prefix parameter can be used,
and choose the correct name depending on compiler.

GCC 13 and above trigger "CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX" which
prevents `mem{cpy,move,set}()` being redefined in "mm/kasan/shadow.c"
since commit 36be5cba99f6 ("kasan: treat meminstrinsic as builtins in
uninstrumented files"), as we expect the compiler to prefix those calls
with `__(hw)asan_` instead.  But as the option passed to GCC has been
incorrect, the compiler has not been emitting those prefixes, effectively
never calling the instrumented versions of `mem{cpy,move,set}()` with
"CONFIG_KASAN_SW_TAGS" enabled.

If "CONFIG_FORTIFY_SOURCES" is enabled, this issue would be mitigated as
it redefines `mem{cpy,move,set}()` and properly aliases the
`__underlying_mem*()` that will be called to the instrumented versions.

Link: https://lkml.kernel.org/r/20250821120735.156244-1-ada.coupriediaz@arm.com
Link: https://gcc.gnu.org/onlinedocs/gcc-13.4.0/gcc/Optimize-Options.html [0]
Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Fixes: 36be5cba99f6 ("kasan: treat meminstrinsic as builtins in uninstrumented files")
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ kasan_params => CFLAGS_KASAN ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.kasan |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -68,10 +68,14 @@ CFLAGS_KASAN := -fsanitize=kernel-hwaddr
 		$(call cc-param,hwasan-inline-all-checks=0) \
 		$(instrumentation_flags)
 
-# Instrument memcpy/memset/memmove calls by using instrumented __hwasan_mem*().
-ifeq ($(call clang-min-version, 150000)$(call gcc-min-version, 130000),y)
-CFLAGS_KASAN += $(call cc-param,hwasan-kernel-mem-intrinsic-prefix=1)
-endif
+# Instrument memcpy/memset/memmove calls by using instrumented __(hw)asan_mem*().
+ifdef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
+	ifdef CONFIG_CC_IS_GCC
+		CFLAGS_KASAN += $(call cc-param,asan-kernel-mem-intrinsic-prefix=1)
+	else
+		CFLAGS_KASAN += $(call cc-param,hwasan-kernel-mem-intrinsic-prefix=1)
+	endif
+endif # CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
 
 endif # CONFIG_KASAN_SW_TAGS
 


