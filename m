Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52F514A4F0;
	Fri,  6 Dec 2024 14:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496151; cv=none; b=KRDCp6DpPPgHqAzisoWIX8R/6FVeisr33UAoZpRJEO3VOrJ8kFWPY/3g3Vu2Xwhvzlo6oIwjPr4YDk7AKHKHHhygfhthiztBfImSLSeq8h/DTozee8CCampIUk5Pg4K9q/VWz2BBvCP1ASsZW6mlYegUSUTvLKTygVqp26XxcWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496151; c=relaxed/simple;
	bh=wSKSMzY8clOou1UTyR6gm5NyWmK0v9YfZdT8Yh6+g7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldDtEabgfgbdBEbb+YrxvwxvvIiAcb5a8I3hg8cKvWMBSERGN2F7H22w74zy061syY3Jlys2H57i1fxe7oQoEbWedxoXfItSkQnNBDL0MtUmKPWHTyGz3mt4bKfyS6biLO8twFJLvX6BJI+ud61JKJHrWQ3gaj69p8GjhyEqkSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgFr5gCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgFr5gCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0CCC4CED1;
	Fri,  6 Dec 2024 14:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496151;
	bh=wSKSMzY8clOou1UTyR6gm5NyWmK0v9YfZdT8Yh6+g7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgFr5gCRcA69qGtCcS8MDC4Q+JcKMTpT4o5EL3XTdBTHV7aQXHOpxaz2Khx01EnzV
	 O2IpQBIMNIidQeyUqFFA9Xd+VWd045Sq9DjXjezFuZCXZyNIlykTAZKOZRSFcX9kH6
	 ZAfXcoYhwp/1a5fcgb/XfBH5C+zhvr6Y9btiDTRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Benjamin Gray <bgray@linux.ibm.com>,
	Ben Zong-You Xie <ben717@andestech.com>,
	Bibo Mao <maobibo@loongson.cn>,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	Dima Kogan <dima@secretsauce.net>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.12 066/146] perf jevents: fix breakage when do perf stat on system metric
Date: Fri,  6 Dec 2024 15:36:37 +0100
Message-ID: <20241206143530.207302746@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 4a159e6049f319bef6f9e6d2ccdd322f57d24830 upstream.

When do perf stat on sys metric, perf tool output nothing now:

  $ perf stat -a -M imx95_ddr_read.all -I 1000
  $

This command runs on an arm64 machine and the Soc has one DDR hw pmu
except one armv8_cortex_a55 pmu. Their maps show as follows:

const struct pmu_events_map pmu_events_map[] = {
{
	.arch = "arm64",
	.cpuid = "0x00000000410fd050",
	.event_table = {
		.pmus = pmu_events__arm_cortex_a55,
		.num_pmus = ARRAY_SIZE(pmu_events__arm_cortex_a55)
	},
	.metric_table = {
		.pmus = NULL,
		.num_pmus = 0
	}
},

static const struct pmu_sys_events pmu_sys_event_tables[] = {
{
	.event_table = {
		.pmus = pmu_events__freescale_imx95_sys,
		.num_pmus = ARRAY_SIZE(pmu_events__freescale_imx95_sys)
	},
	.metric_table = {
		.pmus = pmu_metrics__freescale_imx95_sys,
		.num_pmus = ARRAY_SIZE(pmu_metrics__freescale_imx95_sys)
	},
	.name = "pmu_events__freescale_imx95_sys",
},

Currently, pmu_metrics_table__find() will return NULL when only do perf
stat on sys metric. Then parse_groups() will never be called to parse
sys metric_name, finally perf tool will exit directly. This should be a
common problem.

To fix the issue, this will keep the logic before commit f20c15d13f01
("perf pmu-events: Remember the perf_events_map for a PMU") to return a
empty metric table rather than a NULL pointer.

This should be fine since the removed part just check if the table match
provided metric_name.  Without these code, the code in parse_groups()
will also check the validity of metrci_name too.

Fixes: f20c15d13f017d4b ("perf pmu-events: Remember the perf_events_map for a PMU")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Benjamin Gray <bgray@linux.ibm.com>
Cc: Ben Zong-You Xie <ben717@andestech.com>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Clément Le Goffic <clement.legoffic@foss.st.com>
Cc: Dima Kogan <dima@secretsauce.net>
Cc: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-riscv@lists.infradead.org
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241107162035.52206-2-irogers@google.com
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/pmu-events/empty-pmu-events.c |   12 +-----------
 tools/perf/pmu-events/jevents.py         |   12 +-----------
 2 files changed, 2 insertions(+), 22 deletions(-)

--- a/tools/perf/pmu-events/empty-pmu-events.c
+++ b/tools/perf/pmu-events/empty-pmu-events.c
@@ -539,17 +539,7 @@ const struct pmu_metrics_table *perf_pmu
         if (!map)
                 return NULL;
 
-        if (!pmu)
-                return &map->metric_table;
-
-        for (size_t i = 0; i < map->metric_table.num_pmus; i++) {
-                const struct pmu_table_entry *table_pmu = &map->metric_table.pmus[i];
-                const char *pmu_name = &big_c_string[table_pmu->pmu_name.offset];
-
-                if (pmu__name_match(pmu, pmu_name))
-                           return &map->metric_table;
-        }
-        return NULL;
+	return &map->metric_table;
 }
 
 const struct pmu_events_table *find_core_events_table(const char *arch, const char *cpuid)
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -1089,17 +1089,7 @@ const struct pmu_metrics_table *perf_pmu
         if (!map)
                 return NULL;
 
-        if (!pmu)
-                return &map->metric_table;
-
-        for (size_t i = 0; i < map->metric_table.num_pmus; i++) {
-                const struct pmu_table_entry *table_pmu = &map->metric_table.pmus[i];
-                const char *pmu_name = &big_c_string[table_pmu->pmu_name.offset];
-
-                if (pmu__name_match(pmu, pmu_name))
-                           return &map->metric_table;
-        }
-        return NULL;
+	return &map->metric_table;
 }
 
 const struct pmu_events_table *find_core_events_table(const char *arch, const char *cpuid)


