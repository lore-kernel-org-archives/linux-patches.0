Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE9B430BA3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300899; cv=none; b=Fmo0+74W5Fd+pdEe0XzPWNy5hAP+1dQxVGmyiOwdEO1j91zyAlxrsaPDl6prWNVoSsi25Y4yMD6te13D8tJKzWfzaXQuBhecWZuMwR9SkBcLzejM/EJI7Aitl1uZ3j3zQswmesnWeV2a4HqlHxm+PzqCXL2lO2m7alYMstCHNk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300899; c=relaxed/simple;
	bh=YS4ql6IaG0Yax69ihYE0M0rLl2ObJX9geCS7pWfRBR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIV0SFzVt+ZyZIPFhaeVONjIxM7VRwanvuiZ06Jd9KDspsuEy2zDZhyj4rgjlq0LJnzfn4FMcfotvewyYybr+KFsu6XVH4t/p1XA3n7MWykH4Jgw6qsp0ZW4QN2OaePn5adTvc7pus8g85fM/55ogfSilSYYv5k7QWYLHEGUxk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Idh7q2fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Idh7q2fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3A0C19424;
	Sat, 28 Feb 2026 17:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300899;
	bh=YS4ql6IaG0Yax69ihYE0M0rLl2ObJX9geCS7pWfRBR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Idh7q2fvZz+zpiA7FReArODJuXPft2DqqTLGiVWZuKDzMjlwe9tzo3zZTYEScizG7
	 K8o7q9CvphGTHFffyYYn51iPNXd/xirPTh1YvR/+46vcBhU13UuDUbx2n1VWs67yvw
	 iYsEswBlKsLGXGefYCNPGmjVt0DA8ncU3RBDRmw690QQwKXuM9SxnExcLXdSRTaGaU
	 Ep5aKc25y4oQcR9IEAIyHBspt5qq3bhz2RZ56ds8+HMAT2RJL35Gg5ohMRQjHTuDf7
	 ecPo+fPjo4o1tvHZ6+YFLqC/mwxSMpMfjjwIVhKgu78ansQ6JXUgN1M5o4cVzG4S7f
	 pzhInU4s50K0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/752] tools headers: Go back to include asm-generic/unistd.h for arm64
Date: Sat, 28 Feb 2026 12:35:26 -0500
Message-ID: <20260228174750.1542406-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 096b86ce08332fbcb0ec6ff6714c44899ec03970 ]

The header unistd.h is included under Arm64's uAPI folder (see
tools/arch/arm64/include/uapi/asm/), but it does not include its
dependent header unistd_64.h.

The intention is for unistd_64.h to be generated dynamically using
scripts/Makefile.asm-headers.

However, this dynamic approach causes problems because the header is not
available early enough, even though it is widely included throughout
tools.

Using the perf build as an example:

 1) Feature detection: Perf first runs feature tests.

    The BPF feature program test-bpf.c includes unistd.h.  Since
    unistd_64.h has not been generated yet, the program fails to build,
    and the BPF feature ends up being disabled.

 2) libperf build:

    The libperf Makefile later generates unistd_64.h on the fly, so
    libperf itself builds successfully.

 3) Final perf build:

    Although the perf binary can build successfully using the generated
    header, we never get a chance to build BPF skeleton programs,
    because BPF support was already disabled earlier.

Restore to include asm-generic/unistd.h for fixing the issue.  This
aligns with most architectures (x86 is a special case that keeps
unistd_32.h/unistd_64.h for its particular syscall numbers) and ensures
the header is available from the start.

Fixes: 22f72088ffe69a37 ("tools headers: Update the syscall table with the kernel sources")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/arch/arm64/include/uapi/asm/unistd.h | 24 +++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/arch/arm64/include/uapi/asm/unistd.h b/tools/arch/arm64/include/uapi/asm/unistd.h
index df36f23876e86..9306726337fe0 100644
--- a/tools/arch/arm64/include/uapi/asm/unistd.h
+++ b/tools/arch/arm64/include/uapi/asm/unistd.h
@@ -1,2 +1,24 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#include <asm/unistd_64.h>
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define __ARCH_WANT_RENAMEAT
+#define __ARCH_WANT_NEW_STAT
+#define __ARCH_WANT_SET_GET_RLIMIT
+#define __ARCH_WANT_TIME32_SYSCALLS
+#define __ARCH_WANT_MEMFD_SECRET
+
+#include <asm-generic/unistd.h>
-- 
2.51.0

