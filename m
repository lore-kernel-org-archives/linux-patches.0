Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAC146D544;
	Tue, 21 Jul 2026 19:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660499; cv=none; b=RrpKUvk/XisXZroUO3pmkY1qgSkleAw7VJyVtcIuahbaWlck/h0Mcmmb5Qbk8/Tup8Sw5YSB3CC/JxAkjbLvXUA4Ga/u1QNu0phGa6pBjskLN8fUBR2FOMo/6/4ODd1nbT6B5tUvqagVrFtm+syVrvPja2WDd83rDRtRQd9ztn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660499; c=relaxed/simple;
	bh=mh3w9Mczk2yfK1Ltte5/HYnqvrMbnguhLcKvw5ZAe9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7KAtvcXpegIcOtDJJXhvsOZ4KhEEMSedP5nwKkVc2oI9mj+7TZiocAFiD6ApIqOEZuSzqpq6rnEy//w+SpzXzHW6B01EA/j12ycp/w6YPzOXP1fFHhRsto0AoeIb0fonl9WDgXI7UmYUmKOYI+zJcOVA4rE9WJKt1YVipxUVqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYpmiQbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYpmiQbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAE71F00A3D;
	Tue, 21 Jul 2026 19:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660496;
	bh=xWZpHCEsuEf8yaVOF/o8+pTPZB5YtpKyW/qv6jZ7IR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYpmiQbokbOlpS0wDq4rhnsDsqpB7H0mcL92coH8gzOTXMI1KmknYG8qUB3j2RIF2
	 NQxwyXBL/6q8K5qVhKkmUylpplh25NbojANxxgWwdars7E909PA1VQdyHu3N8BejUK
	 H0RkvwEld1iRBV2tLuny+9Q6iT1iPlZ/nn/DZC7A=
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
Subject: [PATCH 7.1 1001/2077] perf s390: Fix TEXTREL in Python extension by compiling as PIC
Date: Tue, 21 Jul 2026 17:11:14 +0200
Message-ID: <20260721152616.426266379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 333ddd0e4bd814..33f90968c8a95a 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -109,6 +109,7 @@ endif
 
 ifeq ($(ARCH),s390)
   CFLAGS += -fPIC
+  CXXFLAGS += -fPIC
 endif
 
 ifeq ($(ARCH),mips)
-- 
2.53.0



