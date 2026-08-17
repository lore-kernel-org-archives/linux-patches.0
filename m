Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCB5175A99;
	Mon, 17 Aug 2026 14:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978614; cv=none; b=Bm2+RXQhV2KxLupbNktkvePw2hNKKA8ENsKHUMmU4c1E9aTUYC3Rb7FXbKJUDPEsuHZkXB0/RLTM+xcK+eDMW9TrwxHRESXfItcWm+oYm7EHnqIbfIs0Hn5T87YrAgJqfu0vDCQ7/A8fZh+Vtdv8hl2gYs/Dq3QQM1CaPBxvqG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978614; c=relaxed/simple;
	bh=ohuRpcwOCurFN/etlKNF90Mgke32iU8IMj2GMaqs33g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2cnDJdyw4ZrlI1zFb0BUBAR984RrEWqJZuPxussH3iMlP8juu/eLtxGsnkKoZR3cImkGMOz9uPCpbPmpaGmZg+2j6ugHGKq8kK9sol/tillSlNc1x90zAmr3JS2Av5kpy09ZxYqQ54ND6oVM3sbMtEC7aeMHpgaLmbcbvL4Rlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCmTK8ls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCmTK8ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D231F00A3D;
	Mon, 17 Aug 2026 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978613;
	bh=Q5qu3ID0n237dEvWOFN7qrqf2rcT8wWXCu68QrvDJ5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCmTK8ls3uodVyU7Pj1FjVNwjAGk2FQAMyYCRJIURWc6eiHhjrqZHQajbzznJyEuU
	 xfsgEnixcfRCvIF8ZA7w3YID0VUcX+L6oiiKvq6wHGKDkwGZAAWoKjAwvdrV9GU4Zx
	 dL24829dCmZI5hbFiAe63Btz31mm+L5+qnBqguE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/156] fortify: Disable -Wstringop-overread in tests
Date: Mon, 17 Aug 2026 15:33:51 +0200
Message-ID: <20260817132538.412975082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit c1f3e770eec26d6f96dd6d2ea30555ba7c09a244 upstream.

clang recently added support for -Wstringop-overread [1], which is on by
default like -Wfortify-source. This breaks the usage of -Werror in the
fortify tests, resulting in the following false positive warnings in the
kernel build:

  warning: unsafe memcmp() usage lacked '__read_overflow2' warning in lib/test_fortify/read_overflow2-memcmp.c
  warning: unsafe memcmp() usage lacked '__read_overflow' warning in lib/test_fortify/read_overflow-memcmp.c
  warning: unsafe memchr() usage lacked '__read_overflow' warning in lib/test_fortify/read_overflow-memchr.c

Examining the fortify test logs shows a warning like the following in
each of the failed logs:

  In file included from lib/test_fortify/read_overflow2-memcmp.c:5:
  lib/test_fortify/test_fortify.h:34:2: error: 'memcmp' reading 17 bytes from a region of size 16 [-Werror,-Wstringop-overread]
     34 |         TEST;
        |         ^
  lib/test_fortify/read_overflow2-memcmp.c:3:2: note: expanded from macro 'TEST'
      3 |         memcmp(large, small, sizeof(small) + 1)
        |         ^
  1 error generated.

Disable -Wstringop-overread for the fortify tests, as it defeats the
purpose of testing the Linux specific implementation of fortify, like
-Wfortify-source.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2168
Link: https://github.com/llvm/llvm-project/commit/86f2e71cb8d165b59ad31a442b2391e23826133e [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260623-fix-test_fortify-for-clang-stringop-overread-v1-1-15ee8342a953@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_fortify/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/test_fortify/Makefile b/lib/test_fortify/Makefile
index 7887e6126e79c..eba2ba0faeb6a 100644
--- a/lib/test_fortify/Makefile
+++ b/lib/test_fortify/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ccflags-y := $(call cc-disable-warning,fortify-source)
+ccflags-y += $(call cc-disable-warning,stringop-overread)
 
 quiet_cmd_test_fortify = TEST    $@
       cmd_test_fortify = $(CONFIG_SHELL) $(srctree)/scripts/test_fortify.sh \
-- 
2.53.0



