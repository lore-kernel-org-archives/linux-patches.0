Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1795956B68;
	Tue, 23 Jan 2024 00:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970026; cv=none; b=rXwd1ec3z5Y7SAKq/1RD+NlfEhKzHMqTNMRzqdB+4mWlJONgnL1xrbV6bwzq7MKJaEzeE03aWhZ5d+kkiIA/GuuyPew8VSdamBUqF9ATzABGj++sLCXXjdAA1FOq1IZHdvYwbVTPdeZVkgFiRRkYYfZJBq4vlUlvMID/f9PItEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970026; c=relaxed/simple;
	bh=B8PlIyshybOGtQb2oOTKlPPjUe6sKUAOQqgHTEp2+EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lck+j1+EdH32cTaIjo7YRuG9LWvm8KExWDufy3cFAT9ZVbdDaHBk4gJnOzpiAghgJ7oEDhAhp5T/pG14FhXE6+mydSqBKEXYJb2wRO5RB1nuyH9VtihX5veKIEuXyBU6ICoQp8gBolkvilE45U0DFCRK7kbm0PvOOCyzWXiLkUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDdOI1oI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDdOI1oI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774E8C433C7;
	Tue, 23 Jan 2024 00:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970025;
	bh=B8PlIyshybOGtQb2oOTKlPPjUe6sKUAOQqgHTEp2+EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDdOI1oISCG2s18SdPTXFa4g//84vZlN2mqkmwtaW2YBXze1OIuDNd8EBdua1uRup
	 cJsVDReigc7TIYPfmirQqUFQlZSTB9PLzF3X6vfZ87OokWSMY8HLhMZ3f3CogMoCCq
	 03kAn4mzxlq9uzyRWguIBVyztOzy4d0jnAgG9c+0=
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
Subject: [PATCH 6.7 567/641] perf db-export: Fix missing reference count get in call_path_from_sample()
Date: Mon, 22 Jan 2024 15:57:51 -0800
Message-ID: <20240122235835.901731855@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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



