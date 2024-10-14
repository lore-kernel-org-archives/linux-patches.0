Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2AC1ABEAD;
	Mon, 14 Oct 2024 14:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917355; cv=none; b=GIdcIwYAZSPNZmdtBC7QWVKHYpZM+4MB4ekHB6XCQKRQQB4T9xFtVnbL6HOiuNPmweSNFK5ks5P1FjqqyhV1zaTIBjaZ+dk2UOK3UNdyC6pUg/kKbTp27B0pDs+N7PK8AVOcGMiiIp3uYsgGjYmkxAEDt0xCtmozIImvC8FU1/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917355; c=relaxed/simple;
	bh=sELjz1y6ZbTFeCWaMdgnBkyJqo9zTFirLjj6IxbmRrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCKDJBNJk4mZzvwxy/HHJcpRCp6B+9c/+Abye0NWGGtAMjaOxzMqgJ1ykN7RVTRNwf2uXjG1Bryb/E1p/4QiCORNOwz5VcRRtwzsB+uIFlV+veFRBsErY2VSNC/ZSviPJBx9NoqeEVTzv4WEbfXk7pgCScTp2hxZx25vxLwCqUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lcks2Djc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lcks2Djc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F522C4CEC3;
	Mon, 14 Oct 2024 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917354;
	bh=sELjz1y6ZbTFeCWaMdgnBkyJqo9zTFirLjj6IxbmRrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lcks2DjcQs0Oa33zWLjkL04wOQhj8JfZDW1KBQmwsabFUoE5aVbEHD68SNwP1Se6A
	 T5lFvcFxAUT92ylpKvNVjrDylEF41pXvINyZhUUknEFdPT1Dy8uWhIKSEqz9xicA0A
	 Sxl4QMFi+UbjKOyvSJZiNkpSwIN0cNOpgL/XvuB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/798] kselftest/arm64: Dont pass headers to the compiler as source
Date: Mon, 14 Oct 2024 16:09:27 +0200
Message-ID: <20241014141218.471880124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit a884f7970e57aef78c6011561e29d238e46b3a9f ]

The signal Makefile rules pass all the dependencies for each executable,
including headers, to the compiler which GCC is happy enough with but
clang rejects:

   clang --target=aarch64-none-linux-gnu -fintegrated-as -Wall -O2 -g -I/home/broonie/git/linux/tools/testing/selftests/ -isystem /home/broonie/git/linux/usr/include -D_GNU_SOURCE -std=gnu99 -I.  test_signals.c test_signals_utils.c testcases/testcases.c signals.S testcases/fake_sigreturn_bad_magic.c test_signals.h test_signals_utils.h testcases/testcases.h -o testcases/fake_sigreturn_bad_magic
  clang: error: cannot specify -o when generating multiple output files

This happens because clang gets confused about what to do with the
header files, failing to identify them as source.  This is not amazing
behaviour on clang's part and should ideally be fixed but even if that
happens we'd still need a new clang release so let's instead rework the
Makefile so we use variables for the lists of header and source files,
allowing us to only pass the source files to the compiler and keep clang
happy.

As a bonus the resulting Makefile is a bit easier to read.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20230111-arm64-kselftest-clang-v1-3-89c69d377727@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 5225b6562b9a ("kselftest/arm64: signal: fix/refactor SVE vector length enumeration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/signal/Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/Makefile b/tools/testing/selftests/arm64/signal/Makefile
index be7520a863b03..8f5febaf1a9a2 100644
--- a/tools/testing/selftests/arm64/signal/Makefile
+++ b/tools/testing/selftests/arm64/signal/Makefile
@@ -22,6 +22,10 @@ $(TEST_GEN_PROGS): $(PROGS)
 
 # Common test-unit targets to build common-layout test-cases executables
 # Needs secondary expansion to properly include the testcase c-file in pre-reqs
+COMMON_SOURCES := test_signals.c test_signals_utils.c testcases/testcases.c \
+	signals.S
+COMMON_HEADERS := test_signals.h test_signals_utils.h testcases/testcases.h
+
 .SECONDEXPANSION:
-$(PROGS): test_signals.c test_signals_utils.c testcases/testcases.c signals.S $$@.c test_signals.h test_signals_utils.h testcases/testcases.h
-	$(CC) $(CFLAGS) $^ -o $@
+$(PROGS): $$@.c ${COMMON_SOURCES} ${COMMON_HEADERS}
+	$(CC) $(CFLAGS) ${@}.c ${COMMON_SOURCES} -o $@
-- 
2.43.0



