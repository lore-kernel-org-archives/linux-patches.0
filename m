Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEBB30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A6AC433C8;
	Wed, 20 Sep 2023 12:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212649;
	bh=chuCTRH3AFQUxqH3oMh04k3wF36dPejNc//nPuIFoN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKOjST0a+126t/e4/4K/1T0cY1nEFn4T5mCSCOYhbKr4b0XKXF1hc3QGPVxbZr/iu
	 zyWGusSBTimjpMDIwXIR4jQaznubYI2kQu/WnqMncVPAEf6gnmfBMsVuOcJWBadhGS
	 s6rkr449UCIFl1bODeWODMYMc6DeT8mHOgR89N+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	tony garnock-jones <tonyg@leastfixedpoint.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/83] perf tools: Add an option to build without libbfd
Date: Wed, 20 Sep 2023 13:31:43 +0200
Message-ID: <20230920112828.753732764@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
References: <20230920112826.634178162@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 0d1c50ac488ebdaeeaea8ed5069f8d435fd485ed ]

Some distributions, like debian, don't link perf with libbfd. Add a
build flag to make this configuration buildable and testable.

This was inspired by:

  https://lore.kernel.org/linux-perf-users/20210910102307.2055484-1-tonyg@leastfixedpoint.com/T/#u

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: tony garnock-jones <tonyg@leastfixedpoint.com>
Link: http://lore.kernel.org/lkml/20210910225756.729087-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 7822a8913f4c ("perf build: Update build rule for generated files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 47 ++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 3e7706c251e9e..89905b4e93091 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -824,33 +824,36 @@ else
   endif
 endif
 
-ifeq ($(feature-libbfd), 1)
-  EXTLIBS += -lbfd -lopcodes
-else
-  # we are on a system that requires -liberty and (maybe) -lz
-  # to link against -lbfd; test each case individually here
-
-  # call all detections now so we get correct
-  # status in VF output
-  $(call feature_check,libbfd-liberty)
-  $(call feature_check,libbfd-liberty-z)
 
-  ifeq ($(feature-libbfd-liberty), 1)
-    EXTLIBS += -lbfd -lopcodes -liberty
-    FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -ldl
+ifndef NO_LIBBFD
+  ifeq ($(feature-libbfd), 1)
+    EXTLIBS += -lbfd -lopcodes
   else
-    ifeq ($(feature-libbfd-liberty-z), 1)
-      EXTLIBS += -lbfd -lopcodes -liberty -lz
-      FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -lz -ldl
+    # we are on a system that requires -liberty and (maybe) -lz
+    # to link against -lbfd; test each case individually here
+
+    # call all detections now so we get correct
+    # status in VF output
+    $(call feature_check,libbfd-liberty)
+    $(call feature_check,libbfd-liberty-z)
+
+    ifeq ($(feature-libbfd-liberty), 1)
+      EXTLIBS += -lbfd -lopcodes -liberty
+      FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -ldl
+    else
+      ifeq ($(feature-libbfd-liberty-z), 1)
+        EXTLIBS += -lbfd -lopcodes -liberty -lz
+        FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -lz -ldl
+      endif
     endif
+    $(call feature_check,disassembler-four-args)
   endif
-  $(call feature_check,disassembler-four-args)
-endif
 
-ifeq ($(feature-libbfd-buildid), 1)
-  CFLAGS += -DHAVE_LIBBFD_BUILDID_SUPPORT
-else
-  msg := $(warning Old version of libbfd/binutils things like PE executable profiling will not be available);
+  ifeq ($(feature-libbfd-buildid), 1)
+    CFLAGS += -DHAVE_LIBBFD_BUILDID_SUPPORT
+  else
+    msg := $(warning Old version of libbfd/binutils things like PE executable profiling will not be available);
+  endif
 endif
 
 ifdef NO_DEMANGLE
-- 
2.40.1



