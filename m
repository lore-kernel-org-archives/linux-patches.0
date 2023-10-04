Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914E21D55D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5eHLMhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DA1C433C7;
	Wed,  4 Oct 2023 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443370;
	bh=BOlXeeQUPbbpE8AA4LAzi83cYGui+cbvR/SKjpGHclM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5eHLMhniTyHaLthyyoFuNfHuYGY7rtCVHQobS6Xp8mrpZ4vsRNhz0K1Gdb09sn13
	 CsmfePQBynewD9tyZbPUnvqXoY6EsGlZOUsxvVNynKgI+5kxXhjEt1w9ieTUIyEU3B
	 XJtvkRbn5YhHyBkFcw6LYKG9Pji5GnWpbHhXwOTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/259] selftests/powerpc: Use CLEAN macro to fix make warning
Date: Wed,  4 Oct 2023 19:55:06 +0200
Message-ID: <20231004175223.469082323@linuxfoundation.org>
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

[ Upstream commit 69608683a65be5322ef44091eaeb9890472b2eea ]

The CLEAN macro was added in 337f1e36 to prevent the

    Makefile:50: warning: overriding recipe for target 'clean'
    ../../lib.mk:124: warning: ignoring old recipe for target 'clean'

style warnings. Expand it's use to fix another case of redefining a
target directly.

Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230228000709.124727-2-bgray@linux.ibm.com
Stable-dep-of: 58b33e78a317 ("selftests/powerpc: Fix emit_tests to work with run_kselftest.sh")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/pmu/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/powerpc/pmu/Makefile b/tools/testing/selftests/powerpc/pmu/Makefile
index 30803353bd7cc..d2c1accc2e69c 100644
--- a/tools/testing/selftests/powerpc/pmu/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/Makefile
@@ -46,11 +46,14 @@ override define INSTALL_RULE
 	TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET install
 endef
 
-clean:
+DEFAULT_CLEAN := $(CLEAN)
+override define CLEAN
+	$(DEFAULT_CLEAN)
 	$(RM) $(TEST_GEN_PROGS) $(OUTPUT)/loop.o
 	TARGET=ebb; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
 	TARGET=sampling_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
 	TARGET=event_code_tests; BUILD_TARGET=$$OUTPUT/$$TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean
+endef
 
 ebb:
 	TARGET=$@; BUILD_TARGET=$$OUTPUT/$$TARGET; mkdir -p $$BUILD_TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -k -C $$TARGET all
@@ -61,4 +64,4 @@ sampling_tests:
 event_code_tests:
 	TARGET=$@; BUILD_TARGET=$$OUTPUT/$$TARGET; mkdir -p $$BUILD_TARGET; $(MAKE) OUTPUT=$$BUILD_TARGET -k -C $$TARGET all
 
-.PHONY: all run_tests clean ebb sampling_tests event_code_tests
+.PHONY: all run_tests ebb sampling_tests event_code_tests
-- 
2.40.1



