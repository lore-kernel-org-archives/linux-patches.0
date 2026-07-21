Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC65B38757B;
	Tue, 21 Jul 2026 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657398; cv=none; b=jkYXJKbIlmyh7tthJmu8MBByt0thpXMV5eAWxYP1DWBWdo9QVuCVHSgWF0Vk8c25V2BDNAREjXtBleYVxbbq9iICVQckwJavCaqpGV1Z6+OJsiyiTJCK7gIz7NhWTr0Gu2biP8c1p2j2TePSAoiQ5Ym63LNUrfO6B4guLjzUYG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657398; c=relaxed/simple;
	bh=FiPjXK+Matdj+jruLNLc2RMDZtPsPcAK/Kj8aONsBuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r49vtaDG3Gpc9s9/yyo2mxtDEmedzzgzpU1Ajsv/0yneSxONoovSygvYtmdEL0al7DYj8EiEolhUrjbZv917f23Ve7At7kmjjsm/lFOcsW5fpzcTsU0HHQYwCSVoUqb0qbnnI7+1m5ua4IQNPultHC6xrpv41hOiX/2tJmHDNOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDB3136q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDB3136q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD0B1F000E9;
	Tue, 21 Jul 2026 18:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657393;
	bh=VlKNgWWAThZ+zIxYcwlRz/hmn1n3rr53iLlxzEe+HDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDB3136qGRVio/ySGpnroFrzgYYbMEWbDh9iEjuIjj9A/JTzwzwlEIX4BboDhhx70
	 VYhGjLCBwIPj8RANZlGBJjUL7PkIu7BgNmhTgPjdN76F8n37Wikh/ZlkNB9bFDt+JA
	 wJ3QOZCHVpVzCOrRElp3RIxyQIQKw9of0tcuEARY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jens Remus <jremus@linux.ibm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Justin Stitt <justinstitt@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0705/1611] perf s390: Fix TEXTREL in Python extension by compiling as PIC
Date: Tue, 21 Jul 2026 17:13:41 +0200
Message-ID: <20260721152531.238048475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit 49f5f6ae67dec54014584bb3126a5a94f14e2a5c ]

On s390 the Python extension build fails as follows when using a linker
that is configured to treat text relocations (TEXTREL) in shared
libraries as error by default:

  GEN     python/perf.cpython-314-s390x-linux-gnu.so
/usr/bin/ld.bfd: error: read-only segment has dynamic relocations

This occurrs because util/llvm-c-helpers.o is erroneously built from
util/llvm-c-helpers.cpp without compiler option -fPIC but linked into
the shared library (via libperf-util.a(perf-util-in.o)).

On s390, object files must be compiled as position-indepedent code (PIC)
in order to be linked into shared libraries.  Commit a9a3f1d18a6c ("perf
s390: Always build with -fPIC") added compiler option -fPIC to CFLAGS
for s390, which is used in C compiles.  Add -fPIC to CXXFLAGS for s390
as well, so that it is also used in C++ compiles.

Fixes: a9a3f1d18a6c9ccf ("perf s390: Always build with -fPIC")
Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 2dd5f5a60568d0..8ae13809f68b2e 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -110,6 +110,7 @@ endif
 
 ifeq ($(ARCH),s390)
   CFLAGS += -fPIC
+  CXXFLAGS += -fPIC
 endif
 
 ifeq ($(ARCH),mips)
-- 
2.53.0



