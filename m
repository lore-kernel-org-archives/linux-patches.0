Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6510F1D55D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qmni5ohu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC835C433C9;
	Wed,  4 Oct 2023 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443373;
	bh=U4iseO2tHrScxBWHyCUihBZVNGdDc2lYcvkeaHVOvTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qmni5ohudxwPcz8y5Rrx1MAgkL3un4VkO7ITfqhYEHQ+QZt3D/BtZ84wNS8QsVJZD
	 4Z2VdA/OvXbtjguLnlUGGbezps/WQvMM+CJMqhnJ0FI8NxGGdNCxM3F8tW2kkNeW17
	 61fH1VP8EeJc9Noh2lA1DMhBMnh+P8AQEg3CgA0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/259] selftests/powerpc: Pass make context to children
Date: Wed,  4 Oct 2023 19:55:07 +0200
Message-ID: <20231004175223.509617717@linuxfoundation.org>
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

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit 4ecd0868c5138238dec8a1549bb6ff8e5b48208b ]

Make supports passing the 'jobserver' (parallel make support) to child
invocations of make when either
	1. The target command uses $(MAKE) directly
	2. The command starts with '+'

This context is not passed through expansions that result in $(MAKE), so
the macros used in several places fail to pass on the jobserver context.
Warnings are also raised by the child mentioning this.

Prepend macros lines that invoke $(MAKE) with '+' to allow passing the
jobserver context to these children.

Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230228000709.124727-3-bgray@linux.ibm.com
Stable-dep-of: 58b33e78a317 ("selftests/powerpc: Fix emit_tests to work with run_kselftest.sh")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/Makefile     |  8 +++----
 tools/testing/selftests/powerpc/pmu/Makefile | 24 ++++++++++----------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
index 6ba95cd19e423..ae2bfc0d822f2 100644
--- a/tools/testing/selftests/powerpc/Makefile
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -45,28 +45,28 @@ $(SUB_DIRS):
 include ../lib.mk
 
 override define RUN_TESTS
-	@for TARGET in $(SUB_DIRS); do \
+	+@for TARGET in $(SUB_DIRS); do \
 		BUILD_TARGET=$(OUTPUT)/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests;\
 	done;
 endef
 
 override define INSTALL_RULE
-	@for TARGET in $(SUB_DIRS); do \
+	+@for TARGET in $(SUB_DIRS); do \
 		BUILD_TARGET=$(OUTPUT)/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install;\
 	done;
 endef
 
 override define EMIT_TESTS
-	@for TARGET in $(SUB_DIRS); do \
+	+@for TARGET in $(SUB_DIRS); do \
 		BUILD_TARGET=$(OUTPUT)/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests;\
 	done;
 endef
 
 override define CLEAN
-	@for TARGET in $(SUB_DIRS); do \
+	+@for TARGET in $(SUB_DIRS); do \
 		BUILD_TARGET=$(OUTPUT)/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean; \
 	done;
diff --git a/tools/testing/selftests/powerpc/pmu/Makefile b/tools/testing/selftests/powerpc/pmu/Makefile
index d2c1accc2e69c..2b95e44d20ff9 100644
--- a/tools/testing/selftests/powerpc/pmu/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/Makefile
@@ -25,34 +25,34 @@ $(OUTPUT)/per_event_excludes: ../utils.c
 DEFAULT_RUN_TESTS := $(RUN_TESTS)
 override define RUN_TESTS
 	$(DEFAULT_RUN_TESTS)
-	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests
-	TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests
-	TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests
+	+TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests
+	+TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests
+	+TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests
 endef
 
 DEFAULT_EMIT_TESTS := $(EMIT_TESTS)
 override define EMIT_TESTS
 	$(DEFAULT_EMIT_TESTS)
-	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
-	TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
-	TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
+	+TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
+	+TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
+	+TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -s -C $$TARGET emit_tests
 endef
 
 DEFAULT_INSTALL_RULE := $(INSTALL_RULE)
 override define INSTALL_RULE
 	$(DEFAULT_INSTALL_RULE)
-	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install
-	TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install
-	TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install
+	+TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install
+	+TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install
+	+TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install
 endef
 
 DEFAULT_CLEAN := $(CLEAN)
 override define CLEAN
 	$(DEFAULT_CLEAN)
 	$(RM) $(TEST_GEN_PROGS) $(OUTPUT)/loop.o
-	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
-	TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
-	TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
+	+TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
+	+TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
+	+TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
 endef
 
 ebb:
-- 
2.40.1



