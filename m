Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25F047A62;
	Mon,  1 Apr 2024 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989002; cv=none; b=fpwhFJu3qAwiOcZBPu3XKMany96CUU5I8iyzx2SnYVM6eIyGYCvBDBmDh2DCTXvpoKbMae0PAqS2gIEEJZ4TS6aDVr8jn5j8MT5H+fOYD82EfGaWkpE/RCHVpbNh1T/mw2SrtvjxpLdUTAtC7W5FcMgVcmXlncSVLA43vJV+ot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989002; c=relaxed/simple;
	bh=Q/9cKqpcE7RM9dNPmNNo3RMkWivwAnQuIIwbshVXlMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKocUJmcuh4j+pPnR61gNu2b87iIqWkMls3Qm8nwoJU0aAQ27O7WBiqfDI2OhILU7Kv+vycIJwjUT44TmQWF/ZvpMqk+OYX1+0BtIzM+Ptj34aaseMc2N5Fe/UdaK7SopLgjBKTo6NFovC+vtxmYBLg+vrqtOPNOQCqbgHyoY3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzhbfihS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzhbfihS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04595C433F1;
	Mon,  1 Apr 2024 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989002;
	bh=Q/9cKqpcE7RM9dNPmNNo3RMkWivwAnQuIIwbshVXlMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzhbfihSZ9cgulgwm53G6XBexmPxBsODcbpMVn6jQVfzQCINTtGT/Zr28pRhuZztE
	 XneeDzfZq87mj2KBSx5wymBq2TVoXbi/fMa4jq3E6F19Buhsx7mMkh2lqyx+7M7oh/
	 Lrho16eRmCw+ru7eMQ6IL8IkD4bmY7fRfqRwaVtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Hector Martin <marcan@marcan.st>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.7 324/432] perf top: Use evsels cpus to replace user_requested_cpus
Date: Mon,  1 Apr 2024 17:45:11 +0200
Message-ID: <20240401152602.862295840@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 5fa695e7da4975e8d21ce49f3718d6cf00ecb75e upstream.

perf top errors out on a hybrid machine
 $perf top

 Error:
 The cycles:P event is not supported.

The perf top expects that the "cycles" is collected on all CPUs in the
system. But for hybrid there is no single "cycles" event which can cover
all CPUs. Perf has to split it into two cycles events, e.g.,
cpu_core/cycles/ and cpu_atom/cycles/. Each event has its own CPU mask.
If a event is opened on the unsupported CPU. The open fails. That's the
reason of the above error out.

Perf should only open the cycles event on the corresponding CPU. The
commit ef91871c960e ("perf evlist: Propagate user CPU maps intersecting
core PMU maps") intersect the requested CPU map with the CPU map of the
PMU. Use the evsel's cpus to replace user_requested_cpus.

The evlist's threads are also propagated to the evsel's threads in
__perf_evlist__propagate_maps(). For a system-wide event, perf appends
a dummy event and assign it to the evsel's threads. For a per-thread
event, the evlist's thread_map is assigned to the evsel's threads. The
same as the other tools, e.g., perf record, using the evsel's threads
when opening an event.

Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hector Martin <marcan@marcan.st>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/ZXNnDrGKXbEELMXV@kernel.org/
Link: https://lore.kernel.org/r/20231214144612.1092028-1-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-top.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1027,8 +1027,8 @@ static int perf_top__start_counters(stru
 
 	evlist__for_each_entry(evlist, counter) {
 try_again:
-		if (evsel__open(counter, top->evlist->core.user_requested_cpus,
-				     top->evlist->core.threads) < 0) {
+		if (evsel__open(counter, counter->core.cpus,
+				counter->core.threads) < 0) {
 
 			/*
 			 * Specially handle overwrite fall back.


