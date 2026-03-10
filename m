Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E583803CD;
	Tue, 10 Mar 2026 11:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141985; cv=none; b=EDbwp+F3tlcTL6C/S/S1rPbAZpr3HbxXPwXuhbt3hKFvKQ11iQ9ZMf0DzOqMbnw7M4bHe5MLXpbmxnzaxbZmDjBORWwRYyiHlZCsW5ONLlhBps/ofv0FadXTtK2jDScEOuWI17gosAd9GcPcL0woeWvET6i5eNbHjmIqlfQ9gKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141985; c=relaxed/simple;
	bh=DFcVptJHE90BO3dqT9p9dM65RX0wG6rDmsWvG1CjIWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr25pWHMz45i3ff8l653tgKKI5rt1ny1eIZybgyB1xaYaHiJZV9bIKmrzZGZPjUsl79gZXr/KRuC0O2Zwbg1Pe6DXLLMFF/Ik3zW4EJkKyQdONT9tKFlwT/vvUWf1Nmd21Rte5aUZJaKkzNVuz2IxndeG0TV+vEZqDnzfe4/fr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cgk5QvmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cgk5QvmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB038C2BC86;
	Tue, 10 Mar 2026 11:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141985;
	bh=DFcVptJHE90BO3dqT9p9dM65RX0wG6rDmsWvG1CjIWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cgk5QvmBvunkmYNUosQvpbef4HV2UansCuSRk6+28cydNDZwTGP6oG1MvH3lK8hL5
	 RyRXxEPaJr7YpGtOfAvD7kc4KnvebbNMoS9Ae1P4OGoYGcgFfBRybKjb2N4yjKaI3w
	 nLBaffNvvEmMaGMI1V4KWoRHy9XyABi6qGVlkjKYmBY3T8hfcPsayBTuajvbGCztSy
	 +oNu+GOQ8Is82IoWANESdJSVP3fyZT/L89yjssBFV9gSSubWSl6vhqxXn665HjpsWl
	 /VcMAqXUX8VB6DYR9V6sN7LXwi4aoZHoReT6klmBiCx05VK6rJ7Wo5c/WA3nfo6+c0
	 UruFjsoHu7gfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nathan Chancellor <nathan@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/314] ACPI: APEI: GHES: Disable KASAN instrumentation when compile testing with clang < 18
Date: Tue, 10 Mar 2026 07:16:09 -0400
Message-ID: <f50ea2b10b038d4cae7a530f6714155a5a305e29.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit b584bfbd7ec417f257f651cc00a90c66e31dfbf1 ]

After a recent innocuous change to drivers/acpi/apei/ghes.c, building
ARCH=arm64 allmodconfig with clang-17 or older (which has both
CONFIG_KASAN=y and CONFIG_WERROR=y) fails with:

  drivers/acpi/apei/ghes.c:902:13: error: stack frame size (2768) exceeds limit (2048) in 'ghes_do_proc' [-Werror,-Wframe-larger-than]
    902 | static void ghes_do_proc(struct ghes *ghes,
        |             ^

A KASAN pass that removes unneeded stack instrumentation, enabled by
default in clang-18 [1], drastically improves stack usage in this case.

To avoid the warning in the common allmodconfig case when it can break
the build, disable KASAN for ghes.o when compile testing with clang-17
and older. Disabling KASAN outright may hide legitimate runtime issues,
so live with the warning in that case; the user can either increase the
frame warning limit or disable -Werror, which they should probably do
when debugging with KASAN anyways.

Closes: https://github.com/ClangBuiltLinux/linux/issues/2148
Link: https://github.com/llvm/llvm-project/commit/51fbab134560ece663517bf1e8c2a30300d08f1a [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260114-ghes-avoid-wflt-clang-older-than-18-v1-1-9c8248bfe4f4@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
index 5db61dfb46915..1a0b85923cd42 100644
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -1,6 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ACPI_APEI)		+= apei.o
 obj-$(CONFIG_ACPI_APEI_GHES)	+= ghes.o
+# clang versions prior to 18 may blow out the stack with KASAN
+ifeq ($(CONFIG_COMPILE_TEST)_$(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_y_)
+KASAN_SANITIZE_ghes.o := n
+endif
 obj-$(CONFIG_ACPI_APEI_PCIEAER)	+= ghes_helpers.o
 obj-$(CONFIG_ACPI_APEI_EINJ)	+= einj.o
 einj-y				:= einj-core.o
-- 
2.51.0

