Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2C75FF08;
	Tue, 13 Feb 2024 17:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845215; cv=none; b=S1EdlZoPaU/xj9/mA5l3521gOCeY/agkYJmCb+hDSw7IyllQqu3U9dhFV9O5MnWSzLbeWNwbL/yOqmKt9av5nx0ou7c7y1gEVXqxuJf3Ken810Lf6PklHNjxdFAEl4zHbACRmvaYGKpHpeb/umA/wTFY8ZWeXCyEA1EIkSJJjVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845215; c=relaxed/simple;
	bh=TBiu7g7/aDu6TYPV3YcSoh9hP/sfv0G+xoNThvvyO2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/gnJDww2Wq8GR+OIvCg9pPVlU2jhlisBsPEDjGngeArj4Gk+Ghr6FTwt/C4dVuTJy/588/T7QvjwQWIVA6cITnb1XjcLAjeeC/bDBqWcU0Fnv/63DQiwTeVmmnUz0QrnJ7Of2cD4a6R4nE+REbkSLHAaOlVLU4W/USGqo3a1uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tt3v2T4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tt3v2T4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6727C433C7;
	Tue, 13 Feb 2024 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845215;
	bh=TBiu7g7/aDu6TYPV3YcSoh9hP/sfv0G+xoNThvvyO2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tt3v2T4pixSHH9EosG7w4D9EQqdJe05vUWiWvlaYZddJpr6yt1IqypYJ3bfl08rep
	 oIlbXLOmBYbCAJdn95Q6A2mDDPu4XoViZqnQl7HyjMjQ0iakiafNz7KXY3iG/FtYoG
	 UM9rs/DpMJOxKhtISjxRCoD5xPSH0XB4/rkuSO6Y=
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
Subject: [PATCH 6.6 007/121] perf evlist: Fix evlist__new_default() for > 1 core PMU
Date: Tue, 13 Feb 2024 18:20:16 +0100
Message-ID: <20240213171853.170359615@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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
index c779b9f2e622..8a8fe1fa0d38 100644
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



