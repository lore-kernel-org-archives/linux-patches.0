Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542C77BAEC;
	Wed,  5 Feb 2025 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766414; cv=none; b=SE9SY3/xVxiW+dgqa3iR9AzqND6r/jgCG/OTzCI5NE6l26SujWuOwSVPkws+TTj5oTs3CLN3RXkY/LTyxg5cL9XiC8u6H56Frr9A/oG+Wr6T41e1MJvyauo+qY+paNLQMDUdeOxz4ph3tDlO1BI/yp6LbdAC9fNaciypAfbhIK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766414; c=relaxed/simple;
	bh=kv3J1Zs5E4JmFQuqd3RqzS22BrSm0UOEtdQAG765u9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOMmHQhXHByxgLfpwumdRNANdfwMFCbDfyPjMRjbC3HDsVnCupXmEdSXRFsG5ZjC9adwvU8PFKzdoCvJSvXvYfVboPW6oXIcMnq6LO2lyo0AU5bfxA0C71npgt9OVmtH1yJ2S5f4SvtaZ/hZvCOoUXEGOak6mN/vaVpujSogrKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNaau1Is; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNaau1Is"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0269C4CED6;
	Wed,  5 Feb 2025 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766414;
	bh=kv3J1Zs5E4JmFQuqd3RqzS22BrSm0UOEtdQAG765u9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNaau1IsX88fe69QYexVKn7qLmYQeFkZdCFXGvdIyNW2jRUsREeLASZfHatRkQYli
	 Nb5FfjgTxIKH87XeBxAQHY5bkBZoz4JL0YALvEKiRO7N1ogzIbluzDL9uN3xWEL4fe
	 QYcK+Dgy6s7UaPeLV0H0fUnrXvUCzUKbpeZDpfMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 271/623] tools build: Remove the libunwind feature tests from the ones detected when test-all.o builds
Date: Wed,  5 Feb 2025 14:40:13 +0100
Message-ID: <20250205134506.596781164@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b40fbeb0b1cd72912c41fb18c8b5e4b73ed191c4 ]

We have a tools/build/feature/test-all.c that has the most common set of
features that perf uses and are expected to have its development files
available when building perf.

When we made libwunwind opt-in we forgot to remove them from the list of
features that are assumed to be available when test-all.c builds, remove
them.

Before this patch:

  $ rm -rf /tmp/b ; mkdir /tmp/b ; make -C tools/perf O=/tmp/b feature-dump ; grep feature-libunwind-aarch64= /tmp/b/FEATURE-DUMP
  feature-libunwind-aarch64=1
  $

Even tho this not being test built and those header files being
available:

  $ head -5 tools/build/feature/test-libunwind-aarch64.c
  // SPDX-License-Identifier: GPL-2.0
  #include <libunwind-aarch64.h>
  #include <stdlib.h>

  extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
  $

After this patch:

  $ grep feature-libunwind- /tmp/b/FEATURE-DUMP
  $

Now an audit on what is being enabled when test-all.c builds will be
performed.

Fixes: 176c9d1e6a06f2fa ("tools features: Don't check for libunwind devel files by default")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index bca47d136f058..8056315431860 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -89,13 +89,6 @@ FEATURE_TESTS_EXTRA :=                  \
          libbfd-liberty                 \
          libbfd-liberty-z               \
          libopencsd                     \
-         libunwind-x86                  \
-         libunwind-x86_64               \
-         libunwind-arm                  \
-         libunwind-aarch64              \
-         libunwind-debug-frame          \
-         libunwind-debug-frame-arm      \
-         libunwind-debug-frame-aarch64  \
          cxx                            \
          llvm                           \
          clang                          \
-- 
2.39.5



