Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36B42EB5D7;
	Tue, 15 Jul 2025 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587596; cv=none; b=I/ZDBWVIC8CXxZLcnh5jMyII5kL1TFbnOnE6mDbmzm/iZm+y1EEWIRgdvLg3Mcf90/HIOubgfSApun7pG4ER/XowJJqj8V8Jgse5N5RJh1JEPkGI2ANXzMijzbxB5wYejJ1L9ci0Ly1jTEpoqSDmrt8kvqjSFhTm+XONh+M2ClA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587596; c=relaxed/simple;
	bh=Fper4bd/vzpZaT1N7zNuPW1fYlrxmxpB78e2um1ZERU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCvFvn4yJck2taASgULkSnDYYbGjWdSSxI+DKArO+e2he5pHRrr5wnTwKh1gQWvN8qGwRPelk2YnXGdGs0sm0V80vMvOY13yIqEPOojAn13vglGRoNgH/K43OXIxtD1mfZLu+CBnmBQYWToIK9VURQo2bctk2dGRqFORrCMQEwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ru9nqh8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ru9nqh8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E2AC4CEE3;
	Tue, 15 Jul 2025 13:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587596;
	bh=Fper4bd/vzpZaT1N7zNuPW1fYlrxmxpB78e2um1ZERU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ru9nqh8xNlzIC2kkdaUbiYJIj9eBlZEiIzBGlUrWVk7dQVP6lpAxZhJSoI1dFbDFC
	 rppE0PCyHL0q9Tjgc2707blpTgHOQVN0SHAg5hMsDjjjipMMV61DP9Q0Xy4KZEZgC0
	 jHKC88gaeD+Wqeexw6bNvZnrl9u70GEMBBCHIRRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.10 072/208] s390: Add -std=gnu11 to decompressor and purgatory CFLAGS
Date: Tue, 15 Jul 2025 15:13:01 +0200
Message-ID: <20250715130813.835307963@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 3b8b80e993766dc96d1a1c01c62f5d15fafc79b9 upstream.

GCC changed the default C standard dialect from gnu17 to gnu23,
which should not have impacted the kernel because it explicitly requests
the gnu11 standard in the main Makefile. However, there are certain
places in the s390 code that use their own CFLAGS without a '-std='
value, which break with this dialect change because of the kernel's own
definitions of bool, false, and true conflicting with the C23 reserved
keywords.

  include/linux/stddef.h:11:9: error: cannot use keyword 'false' as enumeration constant
     11 |         false   = 0,
        |         ^~~~~
  include/linux/stddef.h:11:9: note: 'false' is a keyword with '-std=c23' onwards
  include/linux/types.h:35:33: error: 'bool' cannot be defined via 'typedef'
     35 | typedef _Bool                   bool;
        |                                 ^~~~
  include/linux/types.h:35:33: note: 'bool' is a keyword with '-std=c23' onwards

Add '-std=gnu11' to the decompressor and purgatory CFLAGS to eliminate
these errors and make the C standard version of these areas match the
rest of the kernel.

Cc: stable@vger.kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20250122-s390-fix-std-for-gcc-15-v1-1-8b00cadee083@kernel.org
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Makefile           |    2 +-
 arch/s390/purgatory/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -23,7 +23,7 @@ endif
 aflags_dwarf	:= -Wa,-gdwarf-2
 KBUILD_AFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -D__ASSEMBLY__
 KBUILD_AFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),$(aflags_dwarf))
-KBUILD_CFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -O2
+KBUILD_CFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -O2 -std=gnu11
 KBUILD_CFLAGS_DECOMPRESSOR += -DDISABLE_BRANCH_PROFILING -D__NO_FORTIFY
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-delete-null-pointer-checks -msoft-float
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-asynchronous-unwind-tables
--- a/arch/s390/purgatory/Makefile
+++ b/arch/s390/purgatory/Makefile
@@ -20,7 +20,7 @@ GCOV_PROFILE := n
 UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 
-KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes
+KBUILD_CFLAGS := -std=gnu11 -fno-strict-aliasing -Wall -Wstrict-prototypes
 KBUILD_CFLAGS += -Wno-pointer-sign -Wno-sign-compare
 KBUILD_CFLAGS += -fno-zero-initialized-in-bss -fno-builtin -ffreestanding
 KBUILD_CFLAGS += -c -MD -Os -m64 -msoft-float -fno-common


