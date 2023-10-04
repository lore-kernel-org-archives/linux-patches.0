Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263A61D55D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/PJxouO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE4CC433C8;
	Wed,  4 Oct 2023 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443376;
	bh=S8625Jfh+whD7EHW/llD7JLIZosvzs2Ju86wJiC34IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/PJxouOGuLNH5Qp4tquGvMxreADL2JQyb7IXR1yij5Zvpw5iYroeaEAU+raqjIUu
	 W79ArF7RFpWSIFOS86npGQbLJrFvPOeA9YV7tzCzevEIzx0vbcfcoBKiJ20kBkEJVc
	 qEDyNw7aWJhxjjuqQygNA5z4ZELKnpkh3Zw4GMAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/259] selftests/powerpc: Fix emit_tests to work with run_kselftest.sh
Date: Wed,  4 Oct 2023 19:55:08 +0200
Message-ID: <20231004175223.546065118@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 58b33e78a31782ffe25d404d5eba9a45fe636e27 ]

In order to use run_kselftest.sh the list of tests must be emitted to
populate kselftest-list.txt.

The powerpc Makefile is written to use EMIT_TESTS. But support for
EMIT_TESTS was dropped in commit d4e59a536f50 ("selftests: Use runner.sh
for emit targets"). Although prior to that commit a548de0fe8e1
("selftests: lib.mk: add test execute bit check to EMIT_TESTS") had
already broken run_kselftest.sh for powerpc due to the executable check
using the wrong path.

It can be fixed by replacing the EMIT_TESTS definitions with actual
emit_tests rules in the powerpc Makefiles. This makes run_kselftest.sh
able to run powerpc tests:

  $ cd linux
  $ export ARCH=powerpc
  $ export CROSS_COMPILE=powerpc64le-linux-gnu-
  $ make headers
  $ make -j -C tools/testing/selftests install
  $ grep -c "^powerpc" tools/testing/selftests/kselftest_install/kselftest-list.txt
  182

Fixes: d4e59a536f50 ("selftests: Use runner.sh for emit targets")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230921072623.828772-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/Makefile     |  7 +++----
 tools/testing/selftests/powerpc/pmu/Makefile | 11 ++++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
index ae2bfc0d822f2..c8c085fa05b05 100644
--- a/tools/testing/selftests/powerpc/Makefile
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -58,12 +58,11 @@ override define INSTALL_RULE
 	done;
 endef
 
-override define EMIT_TESTS
+emit_tests:
 	+@for TARGET in $(SUB_DIRS); do \
 		BUILD_TARGET=$(OUTPUT)/$$TARGET;	\
-		$(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests;\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET $@;\
 	done;
-endef
 
 override define CLEAN
 	+@for TARGET in $(SUB_DIRS); do \
@@ -76,4 +75,4 @@ endef
 tags:
 	find . -name '*.c' -o -name '*.h' | xargs ctags
 
-.PHONY: tags $(SUB_DIRS)
+.PHONY: tags $(SUB_DIRS) emit_tests
diff --git a/tools/testing/selftests/powerpc/pmu/Makefile b/tools/testing/selftests/powerpc/pmu/Makefile
index 2b95e44d20ff9..a284fa874a9f1 100644
--- a/tools/testing/selftests/powerpc/pmu/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/Makefile
@@ -30,13 +30,14 @@ override define RUN_TESTS
 	+TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests
 endef
 
-DEFAULT_EMIT_TESTS := $(EMIT_TESTS)
-override define EMIT_TESTS
-	$(DEFAULT_EMIT_TESTS)
+emit_tests:
+	for TEST in $(TEST_GEN_PROGS); do \
+		BASENAME_TEST=`basename $$TEST`;	\
+		echo "$(COLLECTION):$$BASENAME_TEST";	\
+	done
 	+TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
 	+TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
 	+TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
-endef
 
 DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
 override define INSTALL_RULE
@@ -64,4 +65,4 @@ sampling_tests:
 event_code_tests:
 	TARGET=$@; BUILD_TARGET=$$OUTPUT/$$TARGET; mkdir -p $$BUILD_TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -k -C $$TARGET all
 
-.PHONY: all run_tests ebb sampling_tests event_code_tests
+.PHONY: all run_tests ebb sampling_tests event_code_tests emit_tests
-- 
2.40.1



