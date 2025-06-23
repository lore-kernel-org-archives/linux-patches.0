Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D49724DFF3;
	Mon, 23 Jun 2025 13:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684764; cv=none; b=G6ChjymvQMeUsyZAQR8IGhdEzvQzfZMndJcRoUP2Dqaw4pI48U+w1x5OdfS6ZGDlidr+n+3M151Cwxx+93e0yWJzQoVDoM2Gzs/GKiEVpzQFQa9iOdexNX/A71eBah7YcnDcBhDAlUIwKDVcjLPA6b345vDLYVmN8VxMwQgVjvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684764; c=relaxed/simple;
	bh=44GKPhUdjyF3f7bWPBqDPJb66fEU0Tca3oo6xdkjC34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bI7bYuD0s+i9/BFADynsPkf9I6eCuxrzXJjOUr+2fg0kq4j8oyqTrzXCvH6WUd0PWRpBOV7WDW3jlr+JvAalyq3BLdQLGLBXFYpvARe/PyygbnFMlR9yEHX9k3dFuQIjBBPK1rwd0BzwTY8NV8L/4LzjZxtVX6c6Q0cQ1P28lJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwT+IiNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwT+IiNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A365CC4CEEA;
	Mon, 23 Jun 2025 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684764;
	bh=44GKPhUdjyF3f7bWPBqDPJb66fEU0Tca3oo6xdkjC34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwT+IiNMsa3MRLDiqQooPZ9TynMfgDyz569KrsXrrhmYQA43NOc5df5OOpavQgpcJ
	 Xh9TrBZgeLYwHEORDio0bvJgT4VWoHO8XyB6JkHtPQobCJrQit/URUBtE01HzakDGD
	 T8NJxY5zdy0VIIQNxRDVIdWkOQfq1Qpg6gqyNJRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Leo Yan <leo.yan@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/222] perf tests switch-tracking: Fix timestamp comparison
Date: Mon, 23 Jun 2025 15:06:35 +0200
Message-ID: <20250623130613.916846456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 628e124404b3db5e10e17228e680a2999018ab33 ]

The test might fail on the Arm64 platform with the error:

  # perf test -vvv "Track with sched_switch"
  Missing sched_switch events
  #

The issue is caused by incorrect handling of timestamp comparisons. The
comparison result, a signed 64-bit value, was being directly cast to an
int, leading to incorrect sorting for sched events.

The case does not fail everytime, usually I can trigger the failure
after run 20 ~ 30 times:

  # while true; do perf test "Track with sched_switch"; done
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : FAILED!
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : FAILED!
  106: Track with sched_switch                                         : Ok
  106: Track with sched_switch                                         : Ok

I used cross compiler to build Perf tool on my host machine and tested on
Debian / Juno board.  Generally, I think this issue is not very specific
to GCC versions.  As both internal CI and my local env can reproduce the
issue.

My Host Build compiler:

  # aarch64-linux-gnu-gcc --version
  aarch64-linux-gnu-gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0

Juno Board:

  # lsb_release -a
  No LSB modules are available.
  Distributor ID: Debian
  Description:    Debian GNU/Linux 12 (bookworm)
  Release:        12
  Codename:       bookworm

Fix this by explicitly returning 0, 1, or -1 based on whether the result
is zero, positive, or negative.

Fixes: d44bc558297222d9 ("perf tests: Add a test for tracking with sched_switch")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20250331172759.115604-1-leo.yan@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/switch-tracking.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/switch-tracking.c b/tools/perf/tests/switch-tracking.c
index ffa592e0020ee..ffe3831fb7bf2 100644
--- a/tools/perf/tests/switch-tracking.c
+++ b/tools/perf/tests/switch-tracking.c
@@ -254,7 +254,7 @@ static int compar(const void *a, const void *b)
 	const struct event_node *nodeb = b;
 	s64 cmp = nodea->event_time - nodeb->event_time;
 
-	return cmp;
+	return cmp < 0 ? -1 : (cmp > 0 ? 1 : 0);
 }
 
 static int process_events(struct evlist *evlist,
-- 
2.39.5



