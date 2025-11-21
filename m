Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC6D1F09AC;
	Fri, 21 Nov 2025 13:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731216; cv=none; b=bt7LyVU+ZqY0aNyZ38AI8aYkzeb5g5f07dv4JInEgHhQeA0Ov1OzPZ67LDbIwkBNQKgQ8ynoTCs6+nKXGKhAGDWQ095V3ZXFnIoweGniAF60NJjyhfS1YtZoowiOaSD1IMEY+3lGLq/Bk3HLquFBMk46C0BEvlotX8jxWNn/gRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731216; c=relaxed/simple;
	bh=1fJD62HOoQS0NPtUOWpPOWnybksdVzzCx6eUY5M7aIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAMqnoYPulk+jEbH+Bz4dbTuVMaok/GhOIMJeJl3aO2rQHZEDykXsNJIY4cDcgxYIBlS7CA7yHxyysxYrDQ5p1BwFsajlsf9f1Whkk/oYC8ajPuuBoaaGzUGqcRXj/3msXa7agLY0jrATDJe48e4JFPb6Z0c52PyJWMObZzQS7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFG/lD16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFG/lD16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8946CC4CEF1;
	Fri, 21 Nov 2025 13:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731215;
	bh=1fJD62HOoQS0NPtUOWpPOWnybksdVzzCx6eUY5M7aIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFG/lD16DalLxyfkBrerSZrJZm5xWU0BFZBt/n3tU5VmBr7qSMOjMKIXtA76DiOZX
	 1z7zhVt+z6jS4R5u7i3Sq51f6EKVeDHr1w6MMcfvfKyYsgw2fsOAfhCyn8KAjWMP98
	 fMSfSTT5OdUBtaCKXLRHaDwLz1ZN7G03+Ice/ato=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 131/247] perf build: Dont fail fast path feature detection when binutils-devel is not available
Date: Fri, 21 Nov 2025 14:11:18 +0100
Message-ID: <20251121130159.428934865@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@kernel.org>

[ Upstream commit a09e5967ad6819379fd31894634d7aed29c18409 ]

This is one more remnant of the BUILD_NONDISTRO series to make building
with binutils-devel opt-in due to license incompatibility.

In this case just the references at link time were still in place, which
make building the test-all.bin file fail, which wasn't detected before
probably because the last test was done with binutils-devel available,
doh.

Now:

  $ rpm -q binutils-devel
  package binutils-devel is not installed
  $ file /tmp/build/perf-tools/feature/test-all.bin
  /tmp/build/perf-tools/feature/test-all.bin: ELF 64-bit LSB executable, x86-64, version 1 (SYSV),
  dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2,
  BuildID[sha1]=4b5388a346b51f1b993f0b0dbd49f4570769b03c, for GNU/Linux 3.2.0, not stripped
  $

Fixes: 970ae86307718c34 ("perf build: The bfd features are opt-in, stop testing for them by default")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/Makefile | 4 ++--
 tools/perf/Makefile.config   | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index bd615a708a0aa..049d5d2b36468 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -110,7 +110,7 @@ all: $(FILES)
 __BUILD = $(CC) $(CFLAGS) -MD -Wall -Werror -o $@ $(patsubst %.bin,%.c,$(@F)) $(LDFLAGS)
   BUILD = $(__BUILD) > $(@:.bin=.make.output) 2>&1
   BUILD_BFD = $(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
-  BUILD_ALL = $(BUILD) -fstack-protector-all -O2 -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -lslang $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz -llzma -lzstd
+  BUILD_ALL = $(BUILD) -fstack-protector-all -O2 -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -lslang $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -ldl -lz -llzma -lzstd
 
 __BUILDXX = $(CXX) $(CXXFLAGS) -MD -Wall -Werror -o $@ $(patsubst %.bin,%.cpp,$(@F)) $(LDFLAGS)
   BUILDXX = $(__BUILDXX) > $(@:.bin=.make.output) 2>&1
@@ -118,7 +118,7 @@ __BUILDXX = $(CXX) $(CXXFLAGS) -MD -Wall -Werror -o $@ $(patsubst %.bin,%.cpp,$(
 ###############################
 
 $(OUTPUT)test-all.bin:
-	$(BUILD_ALL) || $(BUILD_ALL) -lopcodes -liberty
+	$(BUILD_ALL)
 
 $(OUTPUT)test-hello.bin:
 	$(BUILD)
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 5a5832ee7b53c..5a3026bba31c6 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -323,9 +323,6 @@ FEATURE_CHECK_LDFLAGS-libpython := $(PYTHON_EMBED_LDOPTS)
 
 FEATURE_CHECK_LDFLAGS-libaio = -lrt
 
-FEATURE_CHECK_LDFLAGS-disassembler-four-args = -lbfd -lopcodes -ldl
-FEATURE_CHECK_LDFLAGS-disassembler-init-styled = -lbfd -lopcodes -ldl
-
 CORE_CFLAGS += -fno-omit-frame-pointer
 CORE_CFLAGS += -Wall
 CORE_CFLAGS += -Wextra
@@ -921,6 +918,8 @@ ifdef BUILD_NONDISTRO
 
   ifeq ($(feature-libbfd), 1)
     EXTLIBS += -lbfd -lopcodes
+    FEATURE_CHECK_LDFLAGS-disassembler-four-args = -lbfd -lopcodes -ldl
+    FEATURE_CHECK_LDFLAGS-disassembler-init-styled = -lbfd -lopcodes -ldl
   else
     # we are on a system that requires -liberty and (maybe) -lz
     # to link against -lbfd; test each case individually here
-- 
2.51.0



