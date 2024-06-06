Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA57E19750E;
	Thu,  6 Jun 2024 14:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682909; cv=none; b=YOXLzQEyRU4mzvQ2inttGJDMII84EibQ6zBCT64HZEUPaN+6YEAQ3Q5634ivwmxsiQAKGaI7k68saZzy+c5U0K+rOzbmCh5yEaIk1BdlN7cu65hIPDntxihTFhMhjKm1GhmIglV+s8PUI3KFgi4g+9CHJtlInPg8GRp3VO6+SUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682909; c=relaxed/simple;
	bh=bprqkH+xezxvMOPl4f3T+z7VmAMNA1suEkFAsKoFzoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c49rXzJu7eSPP3CUIFlGt2/xBOm4uhcL3veVRFf9N3HQUj9S9vpDECLT0U/hANEMcQ81h+lLNoToolfL+A9ggMeQhghbFcNYas6Cn3Nm9uWhxvCldFB60h74ia9eg+mwR8FCpSSmjJ89EqswSbwEKZPo+8GIs4KZsE2ICqbMVZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1rhIqQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1rhIqQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A2BC2BD10;
	Thu,  6 Jun 2024 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682909;
	bh=bprqkH+xezxvMOPl4f3T+z7VmAMNA1suEkFAsKoFzoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1rhIqQmBu2wAGaScWfvIk3WiaM109HQoKbDgVILTyGyMCEIB0lVdePqUE8Xkzif2
	 aTxg8D6TYoEYq7QlDISO4+7MNlp0aicHd6oJeO3nmlQ7UOYbbygnRYrth5N2PpwQZQ
	 8BoLANbCEE2bICUGjM/MjaQpPcgUUMoSCxCO8CvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Spoorthy S <spoorts2@in.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 036/374] perf map: Remove kernel map before updating start and end addresses
Date: Thu,  6 Jun 2024 16:00:15 +0200
Message-ID: <20240606131653.034344309@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit df12e21d4e15e48a5e7d12e58f1a00742c4177d0 ]

In a debug build there is validation that mmap lists are sorted when
taking a lock. In machine__update_kernel_mmap() the start and end
addresses are updated resulting in an unsorted list before the map is
removed from the list. When the map is removed, the lock is taken which
triggers the validation and the failure:

  $ perf test "object code reading"
  --- start ---
  perf: util/maps.c:88: check_invariants: Assertion `map__start(prev) <= map__start(map)' failed.
  Aborted

Fix it by updating the addresses after removal, but before insertion.
The bug depends on the ordering and type of debug info on the system and
doesn't reproduce everywhere.

Fixes: 659ad3492b913c90 ("perf maps: Switch from rbtree to lazily sorted array for addresses")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Spoorthy S <spoorts2@in.ibm.com>
Link: https://lore.kernel.org/r/20240410103458.813656-4-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 527517db31821..07c22f765fab4 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1549,8 +1549,8 @@ static int machine__update_kernel_mmap(struct machine *machine,
 	updated = map__get(orig);
 
 	machine->vmlinux_map = updated;
-	machine__set_kernel_mmap(machine, start, end);
 	maps__remove(machine__kernel_maps(machine), orig);
+	machine__set_kernel_mmap(machine, start, end);
 	err = maps__insert(machine__kernel_maps(machine), updated);
 	map__put(orig);
 
-- 
2.43.0



