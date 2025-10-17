Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1690336EC9;
	Fri, 17 Oct 2025 15:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714204; cv=none; b=X30fx+P4gxDPT3WLC1kAx8+Y3BH8vmDJRPomzGO3cJS6YqZwROTERTvIWiMB6aRoib9ZYySVx5Ypffum+RRbIKMUaMtjnECrBbHf9c9mUISuljDnpPW5BCvTOOpi+FQIN/x3bx8P6ZMYgfGXAkl1dEjP5emeMoN902DTSBeTE2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714204; c=relaxed/simple;
	bh=aSPhKdG/ToVZJ5+8kusvPngAyPgxFlWXvpGemVX22Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krhNfTNAJcCiVNMU6j1IBl6Rl8qDyYwMGYYpg9P6W3gNHIatSjlV8I7Ttm9OTLf5+0WYTL717F67WdeXRzrK97+rOEcGV/9zMQglvarFS9loc5jLkcAXk1qXphObZGd5nSS30vG2BxD1+DIUBfSLexrFmXbyewUOq9VBdBARZUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0MlxUnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0MlxUnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE63CC4CEE7;
	Fri, 17 Oct 2025 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714204;
	bh=aSPhKdG/ToVZJ5+8kusvPngAyPgxFlWXvpGemVX22Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0MlxUnID93NFGJpRzPgr4RYfL6biZA5+XSk21KgZiWUcfAaZWdocGpmqxAeq+4Py
	 +57y3prS+YUoZ0NSeeOEPTOXdUNenjvu1Jn7dC3fOz/IZtUTLc+8VTo6tYRVjBmG63
	 4OKACN2ZBD0X5UzE/Y+MDJTV0b/3o1YfiwK1yYCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	James Clark <james.clark@linaro.org>,
	Yang Jihong <yangjihong@bytedance.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Colin Ian King <colin.i.king@gmail.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ze Gao <zegao2021@gmail.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Leo Yan <leo.yan@linux.dev>,
	ak@linux.intel.com,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	linux-arm-kernel@lists.infradead.org,
	Yanteng Si <siyanteng@loongson.cn>,
	Sun Haiyong <sunhaiyong@loongson.cn>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/277] perf test: Add a test for default perf stat command
Date: Fri, 17 Oct 2025 16:50:38 +0200
Message-ID: <20251017145148.283904974@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 65d11821910bd910a2b4b5b005360d036c76ecef ]

Test that one cycles event is opened for each core PMU when "perf stat"
is run without arguments.

The event line can either be output as "pmu/cycles/" or just "cycles" if
there is only one PMU. Include 2 spaces for padding in the one PMU case
to avoid matching when the word cycles is included in metric
descriptions.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Cc: Yang Jihong <yangjihong@bytedance.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ze Gao <zegao2021@gmail.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Weilin Wang <weilin.wang@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Jing Zhang <renyu.zj@linux.alibaba.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: ak@linux.intel.com
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Yanteng Si <siyanteng@loongson.cn>
Cc: Sun Haiyong <sunhaiyong@loongson.cn>
Cc: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20240926144851.245903-8-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 24937ee839e4 ("perf evsel: Ensure the fallback message is always written to")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat.sh | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/perf/tests/shell/stat.sh b/tools/perf/tests/shell/stat.sh
index 3f1e67795490a..c6df7eec96b98 100755
--- a/tools/perf/tests/shell/stat.sh
+++ b/tools/perf/tests/shell/stat.sh
@@ -146,6 +146,30 @@ test_cputype() {
   echo "cputype test [Success]"
 }
 
+test_hybrid() {
+  # Test the default stat command on hybrid devices opens one cycles event for
+  # each CPU type.
+  echo "hybrid test"
+
+  # Count the number of core PMUs, assume minimum of 1
+  pmus=$(ls /sys/bus/event_source/devices/*/cpus 2>/dev/null | wc -l)
+  if [ "$pmus" -lt 1 ]
+  then
+    pmus=1
+  fi
+
+  # Run default Perf stat
+  cycles_events=$(perf stat -- true 2>&1 | grep -E "/cycles/|  cycles  " | wc -l)
+
+  if [ "$pmus" -ne "$cycles_events" ]
+  then
+    echo "hybrid test [Found $pmus PMUs but $cycles_events cycles events. Failed]"
+    err=1
+    return
+  fi
+  echo "hybrid test [Success]"
+}
+
 test_default_stat
 test_stat_record_report
 test_stat_record_script
@@ -153,4 +177,5 @@ test_stat_repeat_weak_groups
 test_topdown_groups
 test_topdown_weak_groups
 test_cputype
+test_hybrid
 exit $err
-- 
2.51.0



