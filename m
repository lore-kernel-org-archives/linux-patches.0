Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164B33F58C4;
	Fri,  7 Aug 2026 14:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114070; cv=none; b=X0NlPDpIvPrcAG123wPUJDy1DtPggJFiWjnhjvmORVipkGDTCaxhmqeBNLQ/WRq9ItcDKvhU0G+0xZP31oCdMhuWfY4M70Uh9zOl6vnhAADtwHU43cDvfIedsoxblamMXIzaWwL95g0YJwoX5BY5915s/aswfFeI8JF7JrXw2Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114070; c=relaxed/simple;
	bh=4iR8hIMcCA754yXZt0ev4IgJ3QGRNT2XLh2jVoRz59c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1NzF8De2VSn8vZ/cwsq2eLD5IbCiqbts1OFNbTV5TYQN1l7vo0+YqeakOJIcS0mT4QMtK1bdp1YeDq319sIhfSaVIhiOPbyuyi5b6/Yj0Tr3uPqjHgRTfOqrLUx1q0nlgeHZ+cqpQkGkJ4b6UcA06T1L5UuCwwzw+81zoMeRHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7Lyct6Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7Lyct6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A9B1F00A3A;
	Fri,  7 Aug 2026 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114065;
	bh=HLCBAylvVEyup9kR1DNf9/snZNyIFuDT7aS2M+cmeKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7Lyct6Zt89bjF7HftqHdI688CrDFxh8QiVTuwuWjxZKaVdr+AKP9NlJtNNV2v5st
	 3vX/LlRWKSEFkLGl/dSNc8SKi1yA1HbCWEUUB9yleP4x7K8sAxjMG1EHbczaw/zK49
	 Xi9TJcU92pAsro8A80o6/0bS1b0uQVdqZ9xXqLRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.12 133/337] fortify: Disable -Wstringop-overread in tests
Date: Fri,  7 Aug 2026 16:35:36 +0200
Message-ID: <20260807143421.417594372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_fortify/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_fortify/Makefile
+++ b/lib/test_fortify/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ccflags-y := $(call cc-disable-warning,fortify-source)
+ccflags-y += $(call cc-disable-warning,stringop-overread)
 
 quiet_cmd_test_fortify = TEST    $@
       cmd_test_fortify = $(CONFIG_SHELL) $(src)/test_fortify.sh \


