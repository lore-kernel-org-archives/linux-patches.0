Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9768019E802;
	Mon, 14 Oct 2024 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915831; cv=none; b=WNIN5ONumySKxzxgRRbTvmswqgjgWZW5RoezKS2z87nAkhsdEApkb2wuFOHwaPI23WKg6jT7+wV9AdPYLx4z30dFf4IkZdcD8t5dIHl5RU0xIMCt4bIs+OjvaE7sEOrA1XznOS/deglsoowDd2/agc2HzNzIC75V87kbG1YmKkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915831; c=relaxed/simple;
	bh=1a67unXAoZdZSR5obh/iDhEmG3RdcEpOOS0XhOrGMs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwEuQkzSzKTejqdm+CEqZgtZupORD6Ac6aQMsyY8p2QsaD7tkk2hC8DaoHKMIH+gSAN8pPay1pA9DWlie+3FwLD+PaerFSz62zyFedjBh7gj+Gkz7M6+ieMstCjQmP3nfbn3E96sUtvPSMw7ydoEEK098C18sSkBO2Kw3f+TdXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4UobNai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4UobNai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B18C4CEC3;
	Mon, 14 Oct 2024 14:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915831;
	bh=1a67unXAoZdZSR5obh/iDhEmG3RdcEpOOS0XhOrGMs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4UobNai1i0aKvNB5zVsxvcIcCrp3dU50vvb0RwQcyl2BKzXbhu+/rl5J49/9IVkl
	 LcdthbIT90D4j88i+zDx+lRfFRIf77/DPW9MQZSHRvUnHlv2tLxZg6t60taFL+kTrC
	 OAuXjtvK/6GwFqRDaEKiPJI/RK+FRs6XjNVGu2zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yang Jihong <yangjihong@bytedance.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 012/214] perf build: Fix static compilation error when libdw is not installed
Date: Mon, 14 Oct 2024 16:17:55 +0200
Message-ID: <20241014141045.474284090@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Jihong <yangjihong@bytedance.com>

[ Upstream commit 43f6564f18bf5b27e1675ef6f4baf68e786396b2 ]

If libdw is not installed in build environment, the output of
'pkg-config --modversion libdw' is empty, causing LIBDW_VERSION_2 to be
empty and the shell test will have the following error:

  /bin/sh: 1: test: -lt: unexpected operator

Before:

  $ pkg-config --modversion libdw
  Package libdw was not found in the pkg-config search path.
  Perhaps you should add the directory containing `libdw.pc'
  to the PKG_CONFIG_PATH environment variable
  No package 'libdw' found
  $ make LDFLAGS=-static -j16
    BUILD:   Doing 'make -j20' parallel build
  <SNIP>
  Package libdw was not found in the pkg-config search path.
  Perhaps you should add the directory containing `libdw.pc'
  to the PKG_CONFIG_PATH environment variable
  No package 'libdw' found
  /bin/sh: 1: test: -lt: unexpected operator

After:

  1. libdw is not installed:

  $ pkg-config --modversion libdw
  Package libdw was not found in the pkg-config search path.
  Perhaps you should add the directory containing `libdw.pc'
  to the PKG_CONFIG_PATH environment variable
  No package 'libdw' found
  $ make LDFLAGS=-static -j16
    BUILD:   Doing 'make -j20' parallel build
  <SNIP>
  Package libdw was not found in the pkg-config search path.
  Perhaps you should add the directory containing `libdw.pc'
  to the PKG_CONFIG_PATH environment variable
  No package 'libdw' found
  Makefile.config:473: No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR

  2. libdw version is lower than 0.177

  $ pkg-config --modversion libdw
  0.176
  $ make LDFLAGS=-static -j16
    BUILD:   Doing 'make -j20' parallel build
  <SNIP>

  Auto-detecting system features:
  ...                                   dwarf: [ on  ]
  <SNIP>
    INSTALL libsubcmd_headers
    INSTALL libapi_headers
    INSTALL libperf_headers
    INSTALL libsymbol_headers
    INSTALL libbpf_headers
    LINK    perf

  3. libdw version is higher than 0.177

  $ pkg-config --modversion libdw
  0.186
  $ make LDFLAGS=-static -j16
    BUILD:   Doing 'make -j20' parallel build
  <SNIP>

  Auto-detecting system features:
  ...                                   dwarf: [ on  ]
  <SNIP>
    CC      util/bpf-utils.o
    CC      util/pfm.o
    LD      util/perf-util-in.o
    LD      perf-util-in.o
    AR      libperf-util.a
    LINK    perf

Fixes: 536661da6ea18fe6 ("perf: build: Only link libebl.a for old libdw")
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yang Jihong <yangjihong@bytedance.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240919013513.118527-2-yangjihong@bytedance.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/Makefile | 2 +-
 tools/perf/Makefile.config   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 12796808f07a8..a0167244b2f7f 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -172,7 +172,7 @@ DWARFLIBS := -ldw
 ifeq ($(findstring -static,${LDFLAGS}),-static)
   DWARFLIBS += -lelf -lz -llzma -lbz2 -lzstd
 
-  LIBDW_VERSION := $(shell $(PKG_CONFIG) --modversion libdw)
+  LIBDW_VERSION := $(shell $(PKG_CONFIG) --modversion libdw).0.0
   LIBDW_VERSION_1 := $(word 1, $(subst ., ,$(LIBDW_VERSION)))
   LIBDW_VERSION_2 := $(word 2, $(subst ., ,$(LIBDW_VERSION)))
 
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index fa679db61f622..b452794c763ad 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -154,7 +154,7 @@ DWARFLIBS := -ldw
 ifeq ($(findstring -static,${LDFLAGS}),-static)
   DWARFLIBS += -lelf -ldl -lz -llzma -lbz2 -lzstd
 
-  LIBDW_VERSION := $(shell $(PKG_CONFIG) --modversion libdw)
+  LIBDW_VERSION := $(shell $(PKG_CONFIG) --modversion libdw).0.0
   LIBDW_VERSION_1 := $(word 1, $(subst ., ,$(LIBDW_VERSION)))
   LIBDW_VERSION_2 := $(word 2, $(subst ., ,$(LIBDW_VERSION)))
 
-- 
2.43.0



