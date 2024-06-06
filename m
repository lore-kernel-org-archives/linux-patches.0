Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECA919A2A2;
	Thu,  6 Jun 2024 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683277; cv=none; b=RJRMCQ35yXJ6tTaFpwzInHyXlcsnRdE9boAlG0Magj2dQZ0wBJwE3B3xSZrD8pzfeXcSsElZPWvbBisxWoKh4J2BJc71JDIWveaoa7XmmMGuBMmxWo+BhAVNbjYDnrDhE9kEwuUHAQzZ4Tui7ER1JTc1rvRbeRA16n7JU35RYMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683277; c=relaxed/simple;
	bh=P+tUMIex25pmTvaY+udiIYQ++yG+po/q/crqYlQVBpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6p0QgMaQUJgd6YZGI6uaT0mtWEZbu4T73J9MgT8sq0A9aBwRLSz8ENhHJpSBxDnqdhwIS0JGM1ry9y3oXaAYgYc9d9v5oXPymWRmF0r3JCnA+R7RMOcqbB6WwDR9PsxC06gb3RZnnHVDKniptRmf4O0GeACvCS0AHNJUGBWUaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UbgdtjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UbgdtjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF09C2BD10;
	Thu,  6 Jun 2024 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683276;
	bh=P+tUMIex25pmTvaY+udiIYQ++yG+po/q/crqYlQVBpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UbgdtjIgbNoZ3XcXy8yLXwOo6/MosIF145LKsPfyQ2qweHP/t95EeB+NvV8g8O7m
	 dMQEKPsO3ywK9x07x6a9ynaoQuqlQK+hrUwz6DvuJfEeUfEuhKuePo7Awq1b1Eq4Hi
	 HZU6GbQEtmv0RDNDkU/TehaIqfq1LrxyyxRCOPiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Valentin Obst <kernel@valentinobst.de>,
	John Hubbard <jhubbard@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/473] selftests: default to host arch for LLVM builds
Date: Thu,  6 Jun 2024 16:01:23 +0200
Message-ID: <20240606131705.052262073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Valentin Obst <kernel@valentinobst.de>

[ Upstream commit d4e6fbd245c48b272cc591d1c5e7c07aedd7f071 ]

Align the behavior for gcc and clang builds by interpreting unset
`ARCH` and `CROSS_COMPILE` variables in `LLVM` builds as a sign that the
user wants to build for the host architecture.

This patch preserves the properties that setting the `ARCH` variable to an
unknown value will trigger an error that complains about insufficient
information, and that a set `CROSS_COMPILE` variable will override the
target triple that is determined based on presence/absence of `ARCH`.

When compiling with clang, i.e., `LLVM` is set, an unset `ARCH` variable in
combination with an unset `CROSS_COMPILE` variable, i.e., compiling for
the host architecture, leads to compilation failures since `lib.mk` can
not determine the clang target triple. In this case, the following error
message is displayed for each subsystem that does not set `ARCH` in its
own Makefile before including `lib.mk` (lines wrapped at 75 chrs):

  make[1]: Entering directory '/mnt/build/linux/tools/testing/selftests/
   sysctl'
  ../lib.mk:33: *** Specify CROSS_COMPILE or add '--target=' option to
   lib.mk.  Stop.
  make[1]: Leaving directory '/mnt/build/linux/tools/testing/selftests/
   sysctl'

In the same scenario a gcc build would default to the host architecture,
i.e., it would use plain `gcc`.

Fixes: 795285ef2425 ("selftests: Fix clang cross compilation")
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Valentin Obst <kernel@valentinobst.de>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index aa646e0661f36..a8f0442a36bca 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -7,6 +7,8 @@ else ifneq ($(filter -%,$(LLVM)),)
 LLVM_SUFFIX := $(LLVM)
 endif
 
+CLANG := $(LLVM_PREFIX)clang$(LLVM_SUFFIX)
+
 CLANG_TARGET_FLAGS_arm          := arm-linux-gnueabi
 CLANG_TARGET_FLAGS_arm64        := aarch64-linux-gnu
 CLANG_TARGET_FLAGS_hexagon      := hexagon-linux-musl
@@ -18,7 +20,13 @@ CLANG_TARGET_FLAGS_riscv        := riscv64-linux-gnu
 CLANG_TARGET_FLAGS_s390         := s390x-linux-gnu
 CLANG_TARGET_FLAGS_x86          := x86_64-linux-gnu
 CLANG_TARGET_FLAGS_x86_64       := x86_64-linux-gnu
-CLANG_TARGET_FLAGS              := $(CLANG_TARGET_FLAGS_$(ARCH))
+
+# Default to host architecture if ARCH is not explicitly given.
+ifeq ($(ARCH),)
+CLANG_TARGET_FLAGS := $(shell $(CLANG) -print-target-triple)
+else
+CLANG_TARGET_FLAGS := $(CLANG_TARGET_FLAGS_$(ARCH))
+endif
 
 ifeq ($(CROSS_COMPILE),)
 ifeq ($(CLANG_TARGET_FLAGS),)
@@ -30,7 +38,7 @@ else
 CLANG_FLAGS     += --target=$(notdir $(CROSS_COMPILE:%-=%))
 endif # CROSS_COMPILE
 
-CC := $(LLVM_PREFIX)clang$(LLVM_SUFFIX) $(CLANG_FLAGS) -fintegrated-as
+CC := $(CLANG) $(CLANG_FLAGS) -fintegrated-as
 else
 CC := $(CROSS_COMPILE)gcc
 endif # LLVM
-- 
2.43.0



