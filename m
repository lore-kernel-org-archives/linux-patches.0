Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47B86FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D1CC433CA;
	Sun, 17 Sep 2023 19:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980673;
	bh=1UDDH/yEbRx/M/zZhmjrAlUsaSKBMsoGU+bJiGAJRBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNfrAB4Xm41KYBRNBEFqIhVxp8yX2uKGAEwXtDdcRRbIlwc2cjwoKCPSP3/wdGbY7
	 3ikGf6xe/AtDFjM84/Q/ss600jr3//Z/Pxr+1/jAdDkkulfkL+y+YdFeTegbS8nuYc
	 6uSB7t9Alsw96AKT7tX0FatLy7b9QugJ1IX24BpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Anup Sharma <anupnewsmail@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.5 233/285] perf build: Update build rule for generated files
Date: Sun, 17 Sep 2023 21:13:53 +0200
Message-ID: <20230917191059.490942929@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

commit 7822a8913f4c51c7d1aff793b525d60c3384fb5b upstream.

The bison and flex generate C files from the source (.y and .l)
files.  When O= option is used, they are saved in a separate directory
but the default build rule assumes the .C files are in the source
directory.  So it might read invalid file if there are generated files
from an old version.  The same is true for the pmu-events files.

For example, the following command would cause a build failure:

  $ git checkout v6.3
  $ make -C tools/perf  # build in the same directory

  $ git checkout v6.5-rc2
  $ mkdir build  # create a build directory
  $ make -C tools/perf O=build  # build in a different directory but it
                                # refers files in the source directory

Let's update the build rule to specify those cases explicitly to depend
on the files in the output directory.

Note that it's not a complete fix and it needs the next patch for the
include path too.

Fixes: 80eeb67fe577aa76 ("perf jevents: Program to convert JSON file")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anup Sharma <anupnewsmail@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230728022447.1323563-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/Makefile.build  |   10 ++++++++++
 tools/perf/pmu-events/Build |    6 ++++++
 2 files changed, 16 insertions(+)

--- a/tools/build/Makefile.build
+++ b/tools/build/Makefile.build
@@ -117,6 +117,16 @@ $(OUTPUT)%.s: %.c FORCE
 	$(call rule_mkdir)
 	$(call if_changed_dep,cc_s_c)
 
+# bison and flex files are generated in the OUTPUT directory
+# so it needs a separate rule to depend on them properly
+$(OUTPUT)%-bison.o: $(OUTPUT)%-bison.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,$(host)cc_o_c)
+
+$(OUTPUT)%-flex.o: $(OUTPUT)%-flex.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,$(host)cc_o_c)
+
 # Gather build data:
 #   obj-y        - list of build objects
 #   subdir-y     - list of directories to nest
--- a/tools/perf/pmu-events/Build
+++ b/tools/perf/pmu-events/Build
@@ -35,3 +35,9 @@ $(PMU_EVENTS_C): $(JSON) $(JSON_TEST) $(
 	$(call rule_mkdir)
 	$(Q)$(call echo-cmd,gen)$(PYTHON) $(JEVENTS_PY) $(JEVENTS_ARCH) $(JEVENTS_MODEL) pmu-events/arch $@
 endif
+
+# pmu-events.c file is generated in the OUTPUT directory so it needs a
+# separate rule to depend on it properly
+$(OUTPUT)pmu-events/pmu-events.o: $(PMU_EVENTS_C)
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)


