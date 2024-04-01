Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD12D63E;
	Mon,  1 Apr 2024 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990384; cv=none; b=DDXmNUVHsJeKQFsdBtNFrYpFGYWyVTRDxs6643ALF08Kpq27iZ12va7Gm7HdLTg33kS4zWQXGEiMnafZj5FfVuR/ilQU6wSfU+PbTFqcaDBZvzmh9h74e08ZcFTFXjU7hu4/YkZ+bUmvhZsuFoafstXluJG1IiOwF4eVMlWAvA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990384; c=relaxed/simple;
	bh=mWEIuM9kw7tJbCNVN98DUdS/rtYiLc2S5BEsd99USfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2AJO0lVL6W2YrGv94hySeO7BIX9jcj2+ncRjWt5j0xLMykmKn/Wz4rEcTewjw8t3cWworWnIlg7o/G+EMGMzHYzWX7sTRnxbx5bg8XDb5/g1yP0DRAhY8QbVTEuE7673IdJRZpAVpubdGOAhhdxNwa3q1TTe4RpNX2bxewesZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lusRpvia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lusRpvia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6559AC433C7;
	Mon,  1 Apr 2024 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990383;
	bh=mWEIuM9kw7tJbCNVN98DUdS/rtYiLc2S5BEsd99USfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lusRpviamLPhKs8wYH7iy3E3B7hxlxrzjtxBRGwq5iGeQ4djmj6Yh0RkN2FQr0tfQ
	 ct7w08/LOEx30uZ3lGc5djn493A1DkvVi4Wo+dHALH0s6tLqqKSjdXNgYZQiBTcF1g
	 ey1dTY7w1S3jXwAnLSWvsAwskMbhEVcHi9gPSroE=
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
Subject: [PATCH 6.6 307/396] perf top: Use evsels cpus to replace user_requested_cpus
Date: Mon,  1 Apr 2024 17:45:56 +0200
Message-ID: <20240401152557.068437633@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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


