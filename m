Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907849446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147F3C433C7;
	Sun, 13 Aug 2023 21:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962855;
	bh=kXBFi4hfIk+Q14JW8uzgsf+WK2BtG/zSp8omQa2vUck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtAg1R+kzMyZqZfk2AicWn1mYe8MCGYXZtkze13fj/TLoVrKlCf9G6pxinsvIrhl0
	 05D3192ysDQVT2dz74Aua/acjAPJrGHck5ssKVtn27ozcx7R6hfvxJHi+T4XwOTB0S
	 kPqfDfASKATjugB9By99DGYQhZJl1Wc6r7k7mlbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 32/68] selftests/rseq: Fix build with undefined __weak
Date: Sun, 13 Aug 2023 23:19:33 +0200
Message-ID: <20230813211709.133936691@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

commit d5ad9aae13dcced333c1a7816ff0a4fbbb052466 upstream.

Commit 3bcbc20942db ("selftests/rseq: Play nice with binaries statically
linked against glibc 2.35+") which is now in Linus' tree introduced uses
of __weak but did nothing to ensure that a definition is provided for it
resulting in build failures for the rseq tests:

rseq.c:41:1: error: unknown type name '__weak'
__weak ptrdiff_t __rseq_offset;
^
rseq.c:41:17: error: expected ';' after top level declarator
__weak ptrdiff_t __rseq_offset;
                ^
                ;
rseq.c:42:1: error: unknown type name '__weak'
__weak unsigned int __rseq_size;
^
rseq.c:43:1: error: unknown type name '__weak'
__weak unsigned int __rseq_flags;

Fix this by using the definition from tools/include compiler.h.

Fixes: 3bcbc20942db ("selftests/rseq: Play nice with binaries statically linked against glibc 2.35+")
Signed-off-by: Mark Brown <broonie@kernel.org>
Message-Id: <20230804-kselftest-rseq-build-v1-1-015830b66aa9@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/Makefile |    4 +++-
 tools/testing/selftests/rseq/rseq.c   |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -4,8 +4,10 @@ ifneq ($(shell $(CC) --version 2>&1 | he
 CLANG_FLAGS += -no-integrated-as
 endif
 
+top_srcdir = ../../../..
+
 CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/ -L$(OUTPUT) -Wl,-rpath=./ \
-	  $(CLANG_FLAGS)
+	  $(CLANG_FLAGS) -I$(top_srcdir)/tools/include
 LDLIBS += -lpthread -ldl
 
 # Own dependencies because we only want to build against 1st prerequisite, but
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -29,6 +29,8 @@
 #include <dlfcn.h>
 #include <stddef.h>
 
+#include <linux/compiler.h>
+
 #include "../kselftest.h"
 #include "rseq.h"
 


