Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C151974EB;
	Thu,  6 Jun 2024 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683458; cv=none; b=U4ui9w9FNV+safXmOLj4wuLbmR8uODVrfdpUM0/RHogmnEUnijApbUz1Wwg+hBGXeMp3yAnzDzLRak7EjCHXAlckngcPVldbKzKKIBfdzLu3oMrZhNGnXWl/4tdCQRr/jZ/itMuu8vgi1BgFAuQfjYquuaxj55NVaelbBIIa61U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683458; c=relaxed/simple;
	bh=6xB3DNP7jtvfvK5gavU5NKl5q+oZW9hE8BEAl6z40yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7oYlmJtDnJ3c1fdE+tege4MvJOz6xhQXCYwLKIbu4h2Q2c+XaFNUDccl5+oxZntmYOdLLyO+zixFuWkfBYBrBmLO+K3gUHx26o+psY2mm0IvU+WU0lml+JMudo8c/ZnYvzDzoUcpnv1XAIsHw+wudpOXPPPb+wE2M5i+LxbLx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+ycC7Fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+ycC7Fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EEFC32781;
	Thu,  6 Jun 2024 14:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683458;
	bh=6xB3DNP7jtvfvK5gavU5NKl5q+oZW9hE8BEAl6z40yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+ycC7FpsXH2jDo0gXaj2eWiaxnTvcV1jeKwsC1G15npnQE9GmKbWM63qZFNjY2yq
	 X6R+jgwHwOCw0pSKfTgafFdQ2J3r3kFe5ReovmNspDKrI/loZJGAgT6Wf7cfOVZUjy
	 krWweWqz7BLiT1A4cMsfZ+CiZu7lZ1R84rN/8Eoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 403/744] perf stat: Do not fail on metrics on s390 z/VM systems
Date: Thu,  6 Jun 2024 16:01:15 +0200
Message-ID: <20240606131745.380727392@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit c2f3d7dfc7373d53286f2a5c882d3397a5070adc ]

On s390 z/VM virtual machines command 'perf list' also displays metrics:

  # perf list | grep -A 20 'Metric Groups:'
  Metric Groups:

  No_group:
   cpi
        [Cycles per Instruction]
   est_cpi
        [Estimated Instruction Complexity CPI infinite Level 1]
   finite_cpi
        [Cycles per Instructions from Finite cache/memory]
   l1mp
        [Level One Miss per 100 Instructions]
   l2p
        [Percentage sourced from Level 2 cache]
   l3p
        [Percentage sourced from Level 3 on same chip cache]
   l4lp
        [Percentage sourced from Level 4 Local cache on same book]
   l4rp
        [Percentage sourced from Level 4 Remote cache on different book]
   memp
        [Percentage sourced from memory]
   ....
  #

The command

  # perf stat -M cpi -- true
  event syntax error: '{CPU_CYCLES/metric-id=CPU_CYCLES/.....'
                        \___ Bad event or PMU

  Unable to find PMU or event on a PMU of 'CPU_CYCLES'

   event syntax error: '{CPU_CYCLES/metric-id=CPU_CYCLES/...'
                        \___ Cannot find PMU `CPU_CYCLES'.
                             Missing kernel support?
 #

fails. 'perf stat' should not fail on metrics when the referenced CPU
Counter Measurement PMU is not available.

Output after:

  # perf stat -M est_cpi -- sleep 1

  Performance counter stats for 'sleep 1':

     1,000,887,494 ns   duration_time   #     0.00 est_cpi

       1.000887494 seconds time elapsed

       0.000143000 seconds user
       0.000662000 seconds sys

 #

Fixes: 7f76b31130680fb3 ("perf list: Add IBM z16 event description for s390")
Suggested-by: Ian Rogers <irogers@google.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20240404064806.1362876-2-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arch/s390/cf_z16/transaction.json         | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/perf/pmu-events/arch/s390/cf_z16/transaction.json b/tools/perf/pmu-events/arch/s390/cf_z16/transaction.json
index ec2ff78e2b5f2..3ab1d3a6638c4 100644
--- a/tools/perf/pmu-events/arch/s390/cf_z16/transaction.json
+++ b/tools/perf/pmu-events/arch/s390/cf_z16/transaction.json
@@ -2,71 +2,71 @@
   {
     "BriefDescription": "Transaction count",
     "MetricName": "transaction",
-    "MetricExpr": "TX_C_TEND + TX_NC_TEND + TX_NC_TABORT + TX_C_TABORT_SPECIAL + TX_C_TABORT_NO_SPECIAL"
+    "MetricExpr": "TX_C_TEND + TX_NC_TEND + TX_NC_TABORT + TX_C_TABORT_SPECIAL + TX_C_TABORT_NO_SPECIAL if has_event(TX_C_TEND) else 0"
   },
   {
     "BriefDescription": "Cycles per Instruction",
     "MetricName": "cpi",
-    "MetricExpr": "CPU_CYCLES / INSTRUCTIONS"
+    "MetricExpr": "CPU_CYCLES / INSTRUCTIONS if has_event(INSTRUCTIONS) else 0"
   },
   {
     "BriefDescription": "Problem State Instruction Ratio",
     "MetricName": "prbstate",
-    "MetricExpr": "(PROBLEM_STATE_INSTRUCTIONS / INSTRUCTIONS) * 100"
+    "MetricExpr": "(PROBLEM_STATE_INSTRUCTIONS / INSTRUCTIONS) * 100 if has_event(INSTRUCTIONS) else 0"
   },
   {
     "BriefDescription": "Level One Miss per 100 Instructions",
     "MetricName": "l1mp",
-    "MetricExpr": "((L1I_DIR_WRITES + L1D_DIR_WRITES) / INSTRUCTIONS) * 100"
+    "MetricExpr": "((L1I_DIR_WRITES + L1D_DIR_WRITES) / INSTRUCTIONS) * 100 if has_event(INSTRUCTIONS) else 0"
   },
   {
     "BriefDescription": "Percentage sourced from Level 2 cache",
     "MetricName": "l2p",
-    "MetricExpr": "((DCW_REQ + DCW_REQ_IV + ICW_REQ + ICW_REQ_IV) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100"
+    "MetricExpr": "((DCW_REQ + DCW_REQ_IV + ICW_REQ + ICW_REQ_IV) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100 if has_event(DCW_REQ) else 0"
   },
   {
     "BriefDescription": "Percentage sourced from Level 3 on same chip cache",
     "MetricName": "l3p",
-    "MetricExpr": "((DCW_REQ_CHIP_HIT + DCW_ON_CHIP + DCW_ON_CHIP_IV + DCW_ON_CHIP_CHIP_HIT + ICW_REQ_CHIP_HIT + ICW_ON_CHIP + ICW_ON_CHIP_IV + ICW_ON_CHIP_CHIP_HIT) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100"
+    "MetricExpr": "((DCW_REQ_CHIP_HIT + DCW_ON_CHIP + DCW_ON_CHIP_IV + DCW_ON_CHIP_CHIP_HIT + ICW_REQ_CHIP_HIT + ICW_ON_CHIP + ICW_ON_CHIP_IV + ICW_ON_CHIP_CHIP_HIT) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100 if has_event(DCW_REQ_CHIP_HIT) else 0"
   },
   {
     "BriefDescription": "Percentage sourced from Level 4 Local cache on same book",
     "MetricName": "l4lp",
-    "MetricExpr": "((DCW_REQ_DRAWER_HIT + DCW_ON_CHIP_DRAWER_HIT + DCW_ON_MODULE + DCW_ON_DRAWER + IDCW_ON_MODULE_IV + IDCW_ON_MODULE_CHIP_HIT + IDCW_ON_MODULE_DRAWER_HIT + IDCW_ON_DRAWER_IV + IDCW_ON_DRAWER_CHIP_HIT + IDCW_ON_DRAWER_DRAWER_HIT + ICW_REQ_DRAWER_HIT + ICW_ON_CHIP_DRAWER_HIT + ICW_ON_MODULE + ICW_ON_DRAWER) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100"
+    "MetricExpr": "((DCW_REQ_DRAWER_HIT + DCW_ON_CHIP_DRAWER_HIT + DCW_ON_MODULE + DCW_ON_DRAWER + IDCW_ON_MODULE_IV + IDCW_ON_MODULE_CHIP_HIT + IDCW_ON_MODULE_DRAWER_HIT + IDCW_ON_DRAWER_IV + IDCW_ON_DRAWER_CHIP_HIT + IDCW_ON_DRAWER_DRAWER_HIT + ICW_REQ_DRAWER_HIT + ICW_ON_CHIP_DRAWER_HIT + ICW_ON_MODULE + ICW_ON_DRAWER) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100 if has_event(DCW_REQ_DRAWER_HIT) else 0"
   },
   {
     "BriefDescription": "Percentage sourced from Level 4 Remote cache on different book",
     "MetricName": "l4rp",
-    "MetricExpr": "((DCW_OFF_DRAWER + IDCW_OFF_DRAWER_IV + IDCW_OFF_DRAWER_CHIP_HIT + IDCW_OFF_DRAWER_DRAWER_HIT + ICW_OFF_DRAWER) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100"
+    "MetricExpr": "((DCW_OFF_DRAWER + IDCW_OFF_DRAWER_IV + IDCW_OFF_DRAWER_CHIP_HIT + IDCW_OFF_DRAWER_DRAWER_HIT + ICW_OFF_DRAWER) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100 if has_event(DCW_OFF_DRAWER) else 0"
   },
   {
     "BriefDescription": "Percentage sourced from memory",
     "MetricName": "memp",
-    "MetricExpr": "((DCW_ON_CHIP_MEMORY + DCW_ON_MODULE_MEMORY + DCW_ON_DRAWER_MEMORY + DCW_OFF_DRAWER_MEMORY + ICW_ON_CHIP_MEMORY + ICW_ON_MODULE_MEMORY + ICW_ON_DRAWER_MEMORY + ICW_OFF_DRAWER_MEMORY) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100"
+    "MetricExpr": "((DCW_ON_CHIP_MEMORY + DCW_ON_MODULE_MEMORY + DCW_ON_DRAWER_MEMORY + DCW_OFF_DRAWER_MEMORY + ICW_ON_CHIP_MEMORY + ICW_ON_MODULE_MEMORY + ICW_ON_DRAWER_MEMORY + ICW_OFF_DRAWER_MEMORY) / (L1I_DIR_WRITES + L1D_DIR_WRITES)) * 100 if has_event(DCW_ON_CHIP_MEMORY) else 0"
   },
   {
     "BriefDescription": "Cycles per Instructions from Finite cache/memory",
     "MetricName": "finite_cpi",
-    "MetricExpr": "L1C_TLB2_MISSES / INSTRUCTIONS"
+    "MetricExpr": "L1C_TLB2_MISSES / INSTRUCTIONS if has_event(L1C_TLB2_MISSES) else 0"
   },
   {
     "BriefDescription": "Estimated Instruction Complexity CPI infinite Level 1",
     "MetricName": "est_cpi",
-    "MetricExpr": "(CPU_CYCLES / INSTRUCTIONS) - (L1C_TLB2_MISSES / INSTRUCTIONS)"
+    "MetricExpr": "(CPU_CYCLES / INSTRUCTIONS) - (L1C_TLB2_MISSES / INSTRUCTIONS) if has_event(INSTRUCTIONS) else 0"
   },
   {
     "BriefDescription": "Estimated Sourcing Cycles per Level 1 Miss",
     "MetricName": "scpl1m",
-    "MetricExpr": "L1C_TLB2_MISSES / (L1I_DIR_WRITES + L1D_DIR_WRITES)"
+    "MetricExpr": "L1C_TLB2_MISSES / (L1I_DIR_WRITES + L1D_DIR_WRITES) if has_event(L1C_TLB2_MISSES) else 0"
   },
   {
     "BriefDescription": "Estimated TLB CPU percentage of Total CPU",
     "MetricName": "tlb_percent",
-    "MetricExpr": "((DTLB2_MISSES + ITLB2_MISSES) / CPU_CYCLES) * (L1C_TLB2_MISSES / (L1I_PENALTY_CYCLES + L1D_PENALTY_CYCLES)) * 100"
+    "MetricExpr": "((DTLB2_MISSES + ITLB2_MISSES) / CPU_CYCLES) * (L1C_TLB2_MISSES / (L1I_PENALTY_CYCLES + L1D_PENALTY_CYCLES)) * 100 if has_event(CPU_CYCLES) else 0"
   },
   {
     "BriefDescription": "Estimated Cycles per TLB Miss",
     "MetricName": "tlb_miss",
-    "MetricExpr": "((DTLB2_MISSES + ITLB2_MISSES) / (DTLB2_WRITES + ITLB2_WRITES)) * (L1C_TLB2_MISSES / (L1I_PENALTY_CYCLES + L1D_PENALTY_CYCLES))"
+    "MetricExpr": "((DTLB2_MISSES + ITLB2_MISSES) / (DTLB2_WRITES + ITLB2_WRITES)) * (L1C_TLB2_MISSES / (L1I_PENALTY_CYCLES + L1D_PENALTY_CYCLES)) if has_event(DTLB2_MISSES) else 0"
   }
 ]
-- 
2.43.0



