Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2894442B32;
	Mon, 17 Aug 2026 15:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980406; cv=none; b=theHkzaEpkcWVgHplffQNxCi1/8vNKYTJy7vEyrJ8C1rEHzAZcsVd34Ok8PysewpgjIEwrNI+gvsTOODMA/q7pPd62Aun719Wy58hxlbw43w2p6bsV1VP0Oo/ChIRArm3g2wv0kTAggINXSIyFIy/adhEDSr1JfIZlz7ewbbrgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980406; c=relaxed/simple;
	bh=mEFUbkEDAZXQ85O86LQuxmfQSzxpGRAwAWzXPYB0oo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XE5jD9WIt8cvabPBNgvvJsOkMbiQSItYpQu5DrakhkAn2hJ54MGD8zzNzXrE1Kt45j9fg9/2GxXwMRy38qFU4cdXSTPDah0goUbx82yyBV2q5UzuJr+z1XRFhDZMGpw+fHfxM13wrus6TdAyATQzAzvb/6NMcGdw6ExSKUl4Dk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeZa0DKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeZa0DKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C341F000E9;
	Mon, 17 Aug 2026 15:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980405;
	bh=ExvH9Ca60zsln/2zArypg1FhOz7Kz3drjlMcyrQzebI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LeZa0DKqU+JCK1xSIuP/jomaWUI7RJRtJwdRd6R3IfXjDjbMPtcbhep70HgLLlLAf
	 DOgj+Gh4i5Kod6SIPHJKcaY8xFmYTpZDdpFsRiCuJmL5O0ioFJp6RamO37YrD48+u0
	 /m0SmwSUifmTHzJEMyu40dYMivnIidQGxFnU4Feg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 561/609] fortify: Disable -Wstringop-overread in tests
Date: Mon, 17 Aug 2026 15:34:17 +0200
Message-ID: <20260817132602.497832293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



