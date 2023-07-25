Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0031D301;
	Tue, 25 Jul 2023 11:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FCDC433C7;
	Tue, 25 Jul 2023 11:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283300;
	bh=SP7FcrL/n/JbIPYcqAj06Y4gPl8RVIcWqAmrAHKcOK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziffk8eSnj70mBYU/LCWvfRfENstpNg0MzUvqwzO+2O0DujaGhYJNu56ZCP4Cg9J0
	 r3eWxqXxIAwcTshJTyOczTpb5hViNK0tLbg6r6tb08ssJ2rVyICgdg3stXdYrWaEqD
	 SCbQf3BXiFeayuNug5cPtaas5NyBUQ5c9iAz2Dd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Georg=20M=C3=BCller?= <georgmueller@gmx.net>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	regressions@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 05/78] perf probe: Add test for regression introduced by switch to die_get_decl_file()
Date: Tue, 25 Jul 2023 12:45:56 +0200
Message-ID: <20230725104451.513695648@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Georg Müller <georgmueller@gmx.net>

commit 56cbeacf143530576905623ac72ae0964f3293a6 upstream.

This patch adds a test to validate that 'perf probe' works for binaries
where DWARF info is split into multiple CUs

Signed-off-by: Georg Müller <georgmueller@gmx.net>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: regressions@lists.linux.dev
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230628084551.1860532-5-georgmueller@gmx.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/shell/test_uprobe_from_different_cu.sh |   77 ++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100755 tools/perf/tests/shell/test_uprobe_from_different_cu.sh

--- /dev/null
+++ b/tools/perf/tests/shell/test_uprobe_from_different_cu.sh
@@ -0,0 +1,77 @@
+#!/bin/bash
+# test perf probe of function from different CU
+# SPDX-License-Identifier: GPL-2.0
+
+set -e
+
+temp_dir=$(mktemp -d /tmp/perf-uprobe-different-cu-sh.XXXXXXXXXX)
+
+cleanup()
+{
+	trap - EXIT TERM INT
+	if [[ "${temp_dir}" =~ ^/tmp/perf-uprobe-different-cu-sh.*$ ]]; then
+		echo "--- Cleaning up ---"
+		perf probe -x ${temp_dir}/testfile -d foo
+		rm -f "${temp_dir}/"*
+		rmdir "${temp_dir}"
+	fi
+}
+
+trap_cleanup()
+{
+        cleanup
+        exit 1
+}
+
+trap trap_cleanup EXIT TERM INT
+
+cat > ${temp_dir}/testfile-foo.h << EOF
+struct t
+{
+  int *p;
+  int c;
+};
+
+extern int foo (int i, struct t *t);
+EOF
+
+cat > ${temp_dir}/testfile-foo.c << EOF
+#include "testfile-foo.h"
+
+int
+foo (int i, struct t *t)
+{
+  int j, res = 0;
+  for (j = 0; j < i && j < t->c; j++)
+    res += t->p[j];
+
+  return res;
+}
+EOF
+
+cat > ${temp_dir}/testfile-main.c << EOF
+#include "testfile-foo.h"
+
+static struct t g;
+
+int
+main (int argc, char **argv)
+{
+  int i;
+  int j[argc];
+  g.c = argc;
+  g.p = j;
+  for (i = 0; i < argc; i++)
+    j[i] = (int) argv[i][0];
+  return foo (3, &g);
+}
+EOF
+
+gcc -g -Og -flto -c ${temp_dir}/testfile-foo.c -o ${temp_dir}/testfile-foo.o
+gcc -g -Og -c ${temp_dir}/testfile-main.c -o ${temp_dir}/testfile-main.o
+gcc -g -Og -o ${temp_dir}/testfile ${temp_dir}/testfile-foo.o ${temp_dir}/testfile-main.o
+
+perf probe -x ${temp_dir}/testfile --funcs foo
+perf probe -x ${temp_dir}/testfile foo
+
+cleanup


