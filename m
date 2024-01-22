Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBF87CF0E;
	Tue, 23 Jan 2024 02:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975729; cv=none; b=GzO/OeJsua0FCKbltJwyTQOqCCUIfK1Xn63NI9QRMCW7XOX/46lGUytsHqozXIRtw0s1OZefOFKuEFmeYrjxEsO2MHw8dFBmFihSx0AFvRzX+6wDXYvdqXFPcdk0HmkJK9o7Iv7Gf09z6ky/SQnrEef5YuSbMbI2YZWLRFy7FFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975729; c=relaxed/simple;
	bh=Dg5AlIfMNifJ3hLyf1B3nxRg5IuwndycYvbQBJtOCqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqjzQe7Chx8UoyILQvx41AIpjm9JDPuyIybL7kU6BiPUk5lk8fYKkuLMCFVG3Z6ODHZnSTua2e0uOSczVDJf0wTzzsQx1aSNqe5RUJJOXHD2oqMBcWKoa+Xb9YlO6A06Lx5XcKmUUOtTtbsXI6RsPLnlU9MbuPyWdxRcWFG3Ch0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz8ngsL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz8ngsL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0905AC433A6;
	Tue, 23 Jan 2024 02:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975729;
	bh=Dg5AlIfMNifJ3hLyf1B3nxRg5IuwndycYvbQBJtOCqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qz8ngsL0IcJZrtzZlNK4M/An+x5gp3BCJ81sFU03xApAZaNv9STnw6EQPh/FO7XBh
	 2JSyST2n61oo9WmVdTl+AFOM9pcTA5BIobjg84rV/FTWWXZFsuy+Ix6Gp2Y+699me2
	 C2lo8eY5r3WxxTJWxiUTQTklMh2F8sEqWpNDtyfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Gainey <ben.gainey@arm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 513/583] perf db-export: Fix missing reference count get in call_path_from_sample()
Date: Mon, 22 Jan 2024 15:59:24 -0800
Message-ID: <20240122235827.778933133@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Ben Gainey <ben.gainey@arm.com>

[ Upstream commit 1e24ce402c97dc3c0ab050593f1d5f6fde524564 ]

The addr_location map and maps fields in the inner loop were missing
calls to map__get()/maps__get(). The subsequent addr_location__exit()
call in each loop puts the map/maps fields causing use-after-free
aborts.

This issue reproduces on at least arm64 and x86_64 with something
simple like `perf record -g ls` followed by `perf script -s script.py`
with the following script:

    perf_db_export_mode = True
    perf_db_export_calls = False
    perf_db_export_callchains = True

    def sample_table(*args):
        print(f'sample_table({args})')

    def call_path_table(*args):
        print(f'call_path_table({args}')

Committer testing:

This test, just introduced by Ian Rogers, now passes, not segfaulting
anymore:

  # perf test "perf script tests"
   95: perf script tests                                               : Ok
  #

Fixes: 0dd5041c9a0eaf8c ("perf addr_location: Add init/exit/copy functions")
Signed-off-by: Ben Gainey <ben.gainey@arm.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231207140911.3240408-1-ben.gainey@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/db-export.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
index b9fb71ab7a73..106429155c2e 100644
--- a/tools/perf/util/db-export.c
+++ b/tools/perf/util/db-export.c
@@ -253,8 +253,8 @@ static struct call_path *call_path_from_sample(struct db_export *dbe,
 		 */
 		addr_location__init(&al);
 		al.sym = node->ms.sym;
-		al.map = node->ms.map;
-		al.maps = thread__maps(thread);
+		al.map = map__get(node->ms.map);
+		al.maps = maps__get(thread__maps(thread));
 		al.addr = node->ip;
 
 		if (al.map && !al.sym)
-- 
2.43.0



