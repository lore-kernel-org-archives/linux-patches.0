Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6425222B8DF;
	Tue, 21 Jul 2026 18:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660104; cv=none; b=aR39L/k68Ao9sSZPgS1BjpkkWbfPALNFY8S14h7nFVrDoru03AH5Wgi9rFnOCRstUnGV2V1jlBuFylhnBtA0q2IiM5fibJgzf5ACUj/z3VpYWXRZZttWoLDWBa2aWURW/qNBc91Kavqp9SKCeCzytFdXkpwO2/alXC1NaB9nibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660104; c=relaxed/simple;
	bh=PIDDDzYmm3rW9TuND3bpId7qsuAZ/Q6RnVMr75XSTwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mG5rxYJtgSk8zp8EstEtf/nLQ6FLyguxADuhmM/kAKs4P6NO9UQsWRn5hlOfiRSJFn7kDlk+IrBBxTZqEidNfvY6JI61Met9vOY2EKrF8CZTJzJ9+szy+eWgpSmyUPAc+x5ZYqOU3B6rmUfvaCBBJG7pesaATfiAE8EhTk5gz2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXAqjxis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXAqjxis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A021F000E9;
	Tue, 21 Jul 2026 18:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660103;
	bh=B4jEFKvSVg/N6LMCQsWxNADHNQoJaIBw52AIKw+2NZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXAqjxisnj5c/bJr5V03b7i7CJwhuHdtXiBklk/GjvKBdkrQH55E0ZUfiML6tdVYJ
	 wYyE3snLXQL6qRtdKjJLTDTguEV9joSTGOZ2MocU5xfXp7wU5umhNaZCpiXCc8tWQB
	 4WT9lPnqIoytie7MsXOrpXORt3/2VU5L4s2INR7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	David Ahern <dsahern@gmail.com>,
	Gabriel Marin <gmx@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0853/2077] perf sched: Add missing mmap2 handler in timehist
Date: Tue, 21 Jul 2026 17:08:46 +0200
Message-ID: <20260721152612.909942132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 91182741369b261c441e63e6678893032a6d7e4c ]

perf_sched__timehist() registers event handlers for options using the
sched->tool struct. It registers handlers for MMAP, COMM, EXIT, FORK, etc.
but completely omits registering a handler for MMAP2 events.

Failing to register both MMAP and MMAP2 handlers causes modern systems
(which primarily output MMAP2 records) to silently drop VMA map mappings.
This results in uninitialized machine/thread mapping structures, making it
impossible to resolve shared library instruction pointers (IPs) to dynamic
symbols/DSOs during timehist callchain analysis.

Fix this by correctly registering perf_event__process_mmap2 in
sched->tool inside perf_sched__timehist().

Fixes: 49394a2a24c78ce0 ("perf sched timehist: Introduce timehist command")
Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Gabriel Marin <gmx@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 555247568e7a61..241c2f808f7b02 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3299,6 +3299,7 @@ static int perf_sched__timehist(struct perf_sched *sched)
 	 */
 	sched->tool.sample	 = perf_timehist__process_sample;
 	sched->tool.mmap	 = perf_event__process_mmap;
+	sched->tool.mmap2	 = perf_event__process_mmap2;
 	sched->tool.comm	 = perf_event__process_comm;
 	sched->tool.exit	 = perf_event__process_exit;
 	sched->tool.fork	 = perf_event__process_fork;
-- 
2.53.0



