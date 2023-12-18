Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FAD1D144;
	Mon, 18 Dec 2023 14:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdxQDV6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11867C433C8;
	Mon, 18 Dec 2023 14:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908308;
	bh=Nd/Qcfb6t3n01FF75EhN+3C3omcOKjwbnQes0MmWABQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdxQDV6O81SSDLPMant6Kr0HdrpngGEhR5sWRUhBxSlFV3NgezvPK6UtQDfnRWM2j
	 f8K10tTWApwjnxdg9gyAOzh0L0q0ez33cPRZDaoFQCqDlr1TrNOfwu9GH7T6o3VQhd
	 tRJQW61VfM6IPIdlyZXSuP4DjM1XOzYmr6rgJ2Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 130/166] Revert "selftests: error out if kernel header files are not yet built"
Date: Mon, 18 Dec 2023 14:51:36 +0100
Message-ID: <20231218135110.903463130@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: John Hubbard <jhubbard@nvidia.com>

commit 43e8832fed08438e2a27afed9bac21acd0ceffe5 upstream.

This reverts commit 9fc96c7c19df ("selftests: error out if kernel header
files are not yet built").

It turns out that requiring the kernel headers to be built as a
prerequisite to building selftests, does not work in many cases. For
example, Peter Zijlstra writes:

"My biggest beef with the whole thing is that I simply do not want to use
'make headers', it doesn't work for me.

I have a ton of output directories and I don't care to build tools into
the output dirs, in fact some of them flat out refuse to work that way
(bpf comes to mind)." [1]

Therefore, stop erroring out on the selftests build. Additional patches
will be required in order to change over to not requiring the kernel
headers.

[1] https://lore.kernel.org/20231208221007.GO28727@noisy.programming.kicks-ass.net

Link: https://lkml.kernel.org/r/20231209020144.244759-1-jhubbard@nvidia.com
Fixes: 9fc96c7c19df ("selftests: error out if kernel header files are not yet built")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/Makefile |   21 --------------------
 tools/testing/selftests/lib.mk   |   40 ++-------------------------------------
 2 files changed, 4 insertions(+), 57 deletions(-)

--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -152,12 +152,10 @@ ifneq ($(KBUILD_OUTPUT),)
   abs_objtree := $(realpath $(abs_objtree))
   BUILD := $(abs_objtree)/kselftest
   KHDR_INCLUDES := -isystem ${abs_objtree}/usr/include
-  KHDR_DIR := ${abs_objtree}/usr/include
 else
   BUILD := $(CURDIR)
   abs_srctree := $(shell cd $(top_srcdir) && pwd)
   KHDR_INCLUDES := -isystem ${abs_srctree}/usr/include
-  KHDR_DIR := ${abs_srctree}/usr/include
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
@@ -171,7 +169,7 @@ export KHDR_INCLUDES
 # all isn't the first target in the file.
 .DEFAULT_GOAL := all
 
-all: kernel_header_files
+all:
 	@ret=1;							\
 	for TARGET in $(TARGETS); do				\
 		BUILD_TARGET=$$BUILD/$$TARGET;			\
@@ -182,23 +180,6 @@ all: kernel_header_files
 		ret=$$((ret * $$?));				\
 	done; exit $$ret;
 
-kernel_header_files:
-	@ls $(KHDR_DIR)/linux/*.h >/dev/null 2>/dev/null;                          \
-	if [ $$? -ne 0 ]; then                                                     \
-            RED='\033[1;31m';                                                  \
-            NOCOLOR='\033[0m';                                                 \
-            echo;                                                              \
-            echo -e "$${RED}error$${NOCOLOR}: missing kernel header files.";   \
-            echo "Please run this and try again:";                             \
-            echo;                                                              \
-            echo "    cd $(top_srcdir)";                                       \
-            echo "    make headers";                                           \
-            echo;                                                              \
-	    exit 1;                                                                \
-	fi
-
-.PHONY: kernel_header_files
-
 run_tests: all
 	@for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -44,26 +44,10 @@ endif
 selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
 top_srcdir = $(selfdir)/../../..
 
-ifeq ("$(origin O)", "command line")
-  KBUILD_OUTPUT := $(O)
+ifeq ($(KHDR_INCLUDES),)
+KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
 endif
 
-ifneq ($(KBUILD_OUTPUT),)
-  # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
-  # expand a shell special character '~'. We use a somewhat tedious way here.
-  abs_objtree := $(shell cd $(top_srcdir) && mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && pwd)
-  $(if $(abs_objtree),, \
-    $(error failed to create output directory "$(KBUILD_OUTPUT)"))
-  # $(realpath ...) resolves symlinks
-  abs_objtree := $(realpath $(abs_objtree))
-  KHDR_DIR := ${abs_objtree}/usr/include
-else
-  abs_srctree := $(shell cd $(top_srcdir) && pwd)
-  KHDR_DIR := ${abs_srctree}/usr/include
-endif
-
-KHDR_INCLUDES := -isystem $(KHDR_DIR)
-
 # The following are built by lib.mk common compile rules.
 # TEST_CUSTOM_PROGS should be used by tests that require
 # custom build rule and prevent common build rule use.
@@ -74,25 +58,7 @@ TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)
 TEST_GEN_PROGS_EXTENDED := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS_EXTENDED))
 TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
 
-all: kernel_header_files $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) \
-     $(TEST_GEN_FILES)
-
-kernel_header_files:
-	@ls $(KHDR_DIR)/linux/*.h >/dev/null 2>/dev/null;                      \
-	if [ $$? -ne 0 ]; then                                                 \
-            RED='\033[1;31m';                                                  \
-            NOCOLOR='\033[0m';                                                 \
-            echo;                                                              \
-            echo -e "$${RED}error$${NOCOLOR}: missing kernel header files.";   \
-            echo "Please run this and try again:";                             \
-            echo;                                                              \
-            echo "    cd $(top_srcdir)";                                       \
-            echo "    make headers";                                           \
-            echo;                                                              \
-	    exit 1; \
-	fi
-
-.PHONY: kernel_header_files
+all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
 
 define RUN_TESTS
 	BASE_DIR="$(selfdir)";			\


