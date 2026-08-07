Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457FB34BA24;
	Fri,  7 Aug 2026 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115131; cv=none; b=Ex2TkPixP8udUr8Hd5Gdv1LKTuZjPGyEweu12VvqHIX66Zn+KsOOWIc+e7DGCXmuPRLVjT/bAo1wzro/YmMy0YOo2Nuv4BwDXxu5RHeKmCQgy4LVcBVId6v8cbuPz1PSWpMAiaGbfuRFRxNq5S62UPp4PjwiO6Ctt8rNtbArh+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115131; c=relaxed/simple;
	bh=y2fjKR+aRa2oisCTWyT5lUFI5KtacS9ZDN1dts7n9j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qd2Obp7FnzSYsYhsokD0O5yknJfr6dcwE3aJF3WYum8xmscAVELNnRUxL/k1kmfrje+G6E09Gi8vtZNNR1uzie+r1RqmrAnEyt6RvlBCqaafgspMRAufwWWdwCdz5z7MoRhIVE0bNQu98UgCGEhkkl69jUo2bd9c+3e3oTnRI8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHtrx5Cd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHtrx5Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C2B1F000E9;
	Fri,  7 Aug 2026 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115130;
	bh=XEq/Fnuqtk+zDkfOPRh/uHOCIXSgPwsv3aht0hJZ1Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHtrx5CdqPPfC/uFOwUSGfPuQ/ygYycarZR9okRcyGm7sm0TcaD7+CaoK5e76TKFE
	 oZbCWdt7ZBG0fpz8FS66gSGb9cVeKSKKbxqMg4sWeKlxcFQ73ZxThbA4RDJGFEG+a/
	 A2vnWZFUDCqxQRhCjK5ZJdG6FD3GJe+jIdMDrNdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.18 168/396] fortify: Disable -Wstringop-overread in tests
Date: Fri,  7 Aug 2026 16:35:28 +0200
Message-ID: <20260807143427.926128918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


