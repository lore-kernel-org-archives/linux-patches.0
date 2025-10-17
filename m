Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF18219A7A;
	Fri, 17 Oct 2025 15:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714987; cv=none; b=UTzzJLAZM1vJbDkS/koT9LFnyl6xNZp/Al66vndBSF4v4lAIxGbQGGFCD7dHlHSahXu6pF3kvBPG9MtQ7HQnGVxCRsU5OhIlwt7zTP47fFExnkKiKvw9yhWDxpZ5+IluLslscXRVSEbkGIMQKm/k3BMwtAKuV4RGh7ZBBsj/1dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714987; c=relaxed/simple;
	bh=OoPorNaBWe0ft3U7g1YxUiXcG+hyx2E5OnmVK6+PK3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQNU4esoJhabtg1YEJlLnDGhk8EnVW6OUI27+dQU37Rqg3K5zshgkwcS6nCSHHJuGtMIs7MFvHVmq/p7E398ceSmZETO3nS4axbYy+sgmNYPrpYBf1j62zNsZEhnoE9dXPFUbCYLk1w9Dhs7SMzfZ1up5LQBE5lgn9wV85iEKBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiJxBQVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiJxBQVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08CBC4CEE7;
	Fri, 17 Oct 2025 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714987;
	bh=OoPorNaBWe0ft3U7g1YxUiXcG+hyx2E5OnmVK6+PK3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiJxBQVi0KBdcq/eZkdsLN0Yl5BcMcQGO0BMsGG1x95YfMRN3SNYhyV+4vHLCTXIR
	 eXj5XqbPoYc51MTImlq/JGdQIE3LoQ1PBZuWcvDOJXh7Zjfg4cMQDPrLWVvPYeyuDF
	 GulA8/grr220RF7d0bLkJj5HF9mzzzFGSHKFHeKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Blake Jones <blakejones@google.com>,
	Chun-Tse Shao <ctshao@google.com>,
	Collin Funk <collin.funk1@gmail.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Li Huafei <lihuafei1@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nam Cao <namcao@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 026/371] perf test trace_btf_enum: Skip if permissions are insufficient
Date: Fri, 17 Oct 2025 16:50:01 +0200
Message-ID: <20251017145202.745147933@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 4bd5bd8dbd41a208fb73afb65bda6f38e2b5a637 ]

Modify test behavior to skip if BPF calls fail with "Operation not
permitted".

Fixes: d66763fed30f0bd8 ("perf test trace_btf_enum: Add regression test for the BTF augmentation of enums in 'perf trace'")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Blake Jones <blakejones@google.com>
Cc: Chun-Tse Shao <ctshao@google.com>
Cc: Collin Funk <collin.funk1@gmail.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250821163820.1132977-3-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/trace_btf_enum.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/tests/shell/trace_btf_enum.sh b/tools/perf/tests/shell/trace_btf_enum.sh
index 572001d75d781..03e9f680a4a69 100755
--- a/tools/perf/tests/shell/trace_btf_enum.sh
+++ b/tools/perf/tests/shell/trace_btf_enum.sh
@@ -23,6 +23,14 @@ check_vmlinux() {
   fi
 }
 
+check_permissions() {
+  if perf trace -e $syscall $TESTPROG 2>&1 | grep -q "Operation not permitted"
+  then
+    echo "trace+enum test [Skipped permissions]"
+    err=2
+  fi
+}
+
 trace_landlock() {
   echo "Tracing syscall ${syscall}"
 
@@ -56,6 +64,9 @@ trace_non_syscall() {
 }
 
 check_vmlinux
+if [ $err = 0 ]; then
+  check_permissions
+fi
 
 if [ $err = 0 ]; then
   trace_landlock
-- 
2.51.0



