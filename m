Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B131252904;
	Mon, 12 May 2025 17:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071926; cv=none; b=BvVGwZdDGT1hx5hyJAsxpaG7yJBYLVQ+mCSAyENxEZqqVpQxDlRHY0zVbFe61aAvW/4Pz0ueqpDQtG5hz+NQr6MeN03zOqvP+hD/rFlSM3rsJlaeA8mc1L5UnjdWNrt4ZZaoswkwHl7Fl0X3n94D9KIcuOzr37vUoa/akpmac98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071926; c=relaxed/simple;
	bh=BuPRXda+79L2yxGjdMB4eZajLlJHtJgzC6vxwZ9URyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOwnJnuDE4vGHsOtTzWMbE2VQh3J0QofanpNNl2HnsjXyfWjhTyPy3keN55oEsQxjObai9r3+pRr9ZrM3LOLkH/Z2uHbuu+u/01Q8FjcYxRJcEkNKs/nuoIRs6PGIk9DOQdqgehAw1CmihEfHQDLiQ46jS3/vlNdrb5jK/WpXlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1oNsQUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1oNsQUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4929AC4CEE7;
	Mon, 12 May 2025 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071925;
	bh=BuPRXda+79L2yxGjdMB4eZajLlJHtJgzC6vxwZ9URyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1oNsQUy21PSVOhRGDFvD+RXhs+tfDJL2t3lOL0IwzUzySBJklhEX4rRi2zlSzwoU
	 /b6Hug2VQWxjxm+8DFDdoSKVPrw1SeIH5/0eio6R6Soqa7Au2+9Be1cNbL5EkVf0S6
	 E9aoz/9YpEOQ9jh3NwAbKcvIqhbDicgSBNFTrCLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 080/197] selftests/mm: fix build break when compiling pkey_util.c
Date: Mon, 12 May 2025 19:38:50 +0200
Message-ID: <20250512172047.632292662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavan Srinivasan <maddy@linux.ibm.com>

commit 22adb528621ddc92f887882a658507fbf88a5214 upstream.

Commit 50910acd6f615 ("selftests/mm: use sys_pkey helpers consistently")
added a pkey_util.c to refactor some of the protection_keys functions
accessible by other tests.  But this broken the build in powerpc in two
ways,

pkey-powerpc.h: In function `arch_is_powervm':
pkey-powerpc.h:73:21: error: storage size of `buf' isn't known
   73 |         struct stat buf;
      |                     ^~~
pkey-powerpc.h:75:14: error: implicit declaration of function `stat'; did you mean `strcat'? [-Wimplicit-function-declaration]
   75 |         if ((stat("/sys/firmware/devicetree/base/ibm,partition-name", &buf) == 0) &&
      |              ^~~~
      |              strcat

Since pkey_util.c includes pkeys-helper.h, which in turn includes pkeys-powerpc.h,
stat.h including is missing for "struct stat". This is fixed by adding "sys/stat.h"
in pkeys-powerpc.h

Secondly,

pkey-powerpc.h:55:18: warning: format `%llx' expects argument of type `long long unsigned int', but argument 3 has type `u64' {aka `long unsigned int'} [-Wformat=]
   55 |         dprintf4("%s() changing %016llx to %016llx\n",
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   56 |                          __func__, __read_pkey_reg(), pkey_reg);
      |                                    ~~~~~~~~~~~~~~~~~
      |                                    |
      |                                    u64 {aka long unsigned int}
pkey-helpers.h:63:32: note: in definition of macro `dprintf_level'
   63 |                 sigsafe_printf(args);           \
      |                                ^~~~

These format specifier related warning are removed by adding
"__SANE_USERSPACE_TYPES__" to pkeys_utils.c.

Link: https://lkml.kernel.org/r/20250428131937.641989-1-nysal@linux.ibm.com
Fixes: 50910acd6f61 ("selftests/mm: use sys_pkey helpers consistently")
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Nysal Jan K.A. <nysal@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/pkey-powerpc.h |    2 ++
 tools/testing/selftests/mm/pkey_util.c    |    1 +
 2 files changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/pkey-powerpc.h
+++ b/tools/testing/selftests/mm/pkey-powerpc.h
@@ -3,6 +3,8 @@
 #ifndef _PKEYS_POWERPC_H
 #define _PKEYS_POWERPC_H
 
+#include <sys/stat.h>
+
 #ifndef SYS_pkey_alloc
 # define SYS_pkey_alloc		384
 # define SYS_pkey_free		385
--- a/tools/testing/selftests/mm/pkey_util.c
+++ b/tools/testing/selftests/mm/pkey_util.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#define __SANE_USERSPACE_TYPES__
 #include <sys/syscall.h>
 #include <unistd.h>
 


