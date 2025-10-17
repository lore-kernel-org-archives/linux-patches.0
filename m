Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA474332ED8;
	Fri, 17 Oct 2025 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714195; cv=none; b=UqSJQZM6u1Qyf7NPJcfhS+R/z0OcwRvDxVTqdAWvKSGXSYOrRgExXj6uaMpYZJYSOvQUv1+kx+Xx563eAkpuf5vsT8ARdD7NClmMI/oRqiPtSunyzUpd27UWScChDk5J0DNs2QF86VNPSA1AsMJJvcTvOOb5ibgFDLV23Z1VY18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714195; c=relaxed/simple;
	bh=zB6NQKAjEfE6ojK2N7oLUveOdqM4KiUuJTG2WkOexVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfY/cc7zCVvWFJ6ehnWY1ExQ0Dpy8EcqFMuHb4J0wndoEW6CExJSN68UtVxSnDUgAFdrKHtWWrfow0meOJGH3/hd4+b/Y80x8fOrAwzPvQURAHTdTKpobWsiODO/AQiS8jzVGS4KwVTLph0mjCsqxaq3W9ZN5gDcpg41bnS37oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwqyoWRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwqyoWRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288B2C4CEF9;
	Fri, 17 Oct 2025 15:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714195;
	bh=zB6NQKAjEfE6ojK2N7oLUveOdqM4KiUuJTG2WkOexVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwqyoWRUMorT8ndxQ9T5UQLPX9mS25FifV2NDrMmc5f+wFxKC1nd+t+OV4ErMOEtY
	 umgmMR3Mi2jLuxxFqMq/Hagt/rP1leKHQZ0KkhrljGx+4Qhw+odXCPCS+o0/OUobYb
	 bqn6wlZV2GlJcfKFwG/HoSEPBzovfAuYaSBcdT8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Bill Wendling <morbo@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	James Clark <james.clark@linaro.org>,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev,
	Paul Walmsley <paul.walmsley@sifive.com>,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/277] perf python: split Clang options when invoking Popen
Date: Fri, 17 Oct 2025 16:51:06 +0200
Message-ID: <20251017145149.299711559@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit c6a43bc3e8f6102a47da0d2e53428d08f00172fb ]

When passing a list to subprocess.Popen, each element maps to one argv
token. Current code bundles multiple Clang flags into a single element,
something like:

  cmd = ['clang',
         '--target=x86_64-linux-gnu -fintegrated-as -Wno-cast-function-type-mismatch',
	 'test-hello.c']

So Clang only sees one long, invalid option instead of separate flags,
as a result, the script cannot capture any log via PIPE.

Fix this by using shlex.split() to separate the string so each option
becomes its own argv element. The fixed list will be:

  cmd = ['clang',
         '--target=x86_64-linux-gnu',
	 '-fintegrated-as',
	 '-Wno-cast-function-type-mismatch',
	 'test-hello.c']

Fixes: 09e6f9f98370 ("perf python: Fix splitting CC into compiler and options")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20251006-perf_build_android_ndk-v3-2-4305590795b2@arm.com
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: linux-riscv@lists.infradead.org
Cc: llvm@lists.linux.dev
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/setup.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 649550e9b7aa8..abb567de3e8a9 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -1,6 +1,7 @@
 from os import getenv, path
 from subprocess import Popen, PIPE
 from re import sub
+import shlex
 
 cc = getenv("CC")
 
@@ -16,7 +17,9 @@ cc_is_clang = b"clang version" in Popen([cc, "-v"], stderr=PIPE).stderr.readline
 src_feature_tests  = getenv('srctree') + '/tools/build/feature'
 
 def clang_has_option(option):
-    cc_output = Popen([cc, cc_options + option, path.join(src_feature_tests, "test-hello.c") ], stderr=PIPE).stderr.readlines()
+    cmd = shlex.split(f"{cc} {cc_options} {option}")
+    cmd.append(path.join(src_feature_tests, "test-hello.c"))
+    cc_output = Popen(cmd, stderr=PIPE).stderr.readlines()
     return [o for o in cc_output if ((b"unknown argument" in o) or (b"is not supported" in o) or (b"unknown warning option" in o))] == [ ]
 
 if cc_is_clang:
-- 
2.51.0



