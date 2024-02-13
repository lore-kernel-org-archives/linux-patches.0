Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA35AD55;
	Tue, 13 Feb 2024 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845621; cv=none; b=KnERPXcl7/21FuexC/eMx4nC4DM/J5TXwiRe1T46Q+T32t2j5q3utmmnMA2ODc1WeuVjp5Wr+0E9k9mBEBQYbHEvs53eg2mGK/QVjHmEh0s2DApKeFUpgAhWvSco/HE3WTVB7+HI21UCO3gQ6MInRrTHVmIHE+4y2O2s13TCmBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845621; c=relaxed/simple;
	bh=Lbm0sAo5PR876wGKBrtGQmSQH8Sb4ZSJ1UqwVpqnea0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiLCTFaBbyx7njVy1oEN5ZdpPg6NtxPXPOKQwrM20bZd0SH0PZArGpcUyqtw9d3CAaQHgUIkkdgRN6adylJHW6cQPQtibY2RflmYt6e1M8XJei8ZT9a5onnof5CPOsOx0rrqcXfthfOsKqe3Gl42aT4LareMq6WkO9J/8m92GFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qe5bh/dO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qe5bh/dO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71110C433F1;
	Tue, 13 Feb 2024 17:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845621;
	bh=Lbm0sAo5PR876wGKBrtGQmSQH8Sb4ZSJ1UqwVpqnea0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qe5bh/dO84tT8B2HfIc7/9zyFEAONddfGtCeyG44O/IWKRdrgQtFy7y/ziiYDXNpR
	 RI2Fsuh3VRP2SAmWvLMO8MqhZ3UxhlC9eLsxrdvhsLtFFDSNhcIZtFtkVSb8k8tNUO
	 iEeLpDn2BPxCNPuMY6jrXy3SM1wzZgPDqvsjqNic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Changbin Du <changbin.du@huawei.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Yang Jihong <yangjihong1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 011/124] perf evlist: Fix evlist__new_default() for > 1 core PMU
Date: Tue, 13 Feb 2024 18:20:33 +0100
Message-ID: <20240213171854.064122081@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: James Clark <james.clark@arm.com>

[ Upstream commit 7814fe24a6211a610db0b408d87420403b5b7a36 ]

The 'Session topology' test currently fails with this message when
evlist__new_default() opens more than one event:

  32: Session topology                                                :
  --- start ---
  templ file: /tmp/perf-test-vv5YzZ
  Using CPUID 0x00000000410fd070
  Opening: unknown-hardware:HG
  ------------------------------------------------------------
  perf_event_attr:
    type                             0 (PERF_TYPE_HARDWARE)
    config                           0xb00000000
    disabled                         1
  ------------------------------------------------------------
  sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8 = 4
  Opening: unknown-hardware:HG
  ------------------------------------------------------------
  perf_event_attr:
    type                             0 (PERF_TYPE_HARDWARE)
    config                           0xa00000000
    disabled                         1
  ------------------------------------------------------------
  sys_perf_event_open: pid 0  cpu -1  group_fd -1  flags 0x8 = 5
  non matching sample_type
  FAILED tests/topology.c:73 can't get session
  ---- end ----
  Session topology: FAILED!

This is because when re-opening the file and parsing the header, Perf
expects that any file that has more than one event has the sample ID
flag set. Perf record already sets the flag in a similar way when there
is more than one event, so add the same logic to evlist__new_default().

evlist__new_default() is only currently used in tests, so I don't
expect this change to have any other side effects. The other tests that
use it don't save and re-open the file so don't hit this issue.

The session topology test has been failing on Arm big.LITTLE platforms
since commit 251aa040244a3b17 ("perf parse-events: Wildcard most
"numeric" events") when evlist__new_default() started opening multiple
events for 'cycles'.

Fixes: 251aa040244a3b17 ("perf parse-events: Wildcard most "numeric" events")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@arm.com>
[ This was failing as well on a Rocket Lake Refresh/14700k Intel hybrid system - Arnaldo ]
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Ian Rogers <irogers@google.com>
Tested-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yang Jihong <yangjihong1@huawei.com>
Closes: https://lore.kernel.org/lkml/CAP-5=fWVQ-7ijjK3-w1q+k2WYVNHbAcejb-xY0ptbjRw476VKA@mail.gmail.com/
Link: https://lore.kernel.org/r/20240124094358.489372-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evlist.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index e36da58522ef..b0ed14a6da9d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -103,7 +103,14 @@ struct evlist *evlist__new_default(void)
 	err = parse_event(evlist, can_profile_kernel ? "cycles:P" : "cycles:Pu");
 	if (err) {
 		evlist__delete(evlist);
-		evlist = NULL;
+		return NULL;
+	}
+
+	if (evlist->core.nr_entries > 1) {
+		struct evsel *evsel;
+
+		evlist__for_each_entry(evlist, evsel)
+			evsel__set_sample_id(evsel, /*can_sample_identifier=*/false);
 	}
 
 	return evlist;
-- 
2.43.0



