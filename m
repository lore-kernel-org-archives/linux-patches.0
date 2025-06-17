Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07BC2ED16E;
	Tue, 17 Jun 2025 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175816; cv=none; b=KuMip9Ei7L/lsmboHThkC6nA960bfSPgrLMlOKtKe0Zlbqyrwmt+QxzHmib075WcQhoto3Pdx88wjA5c1SwLjyM0bXeXX+Haz+enat3kjcW8kCtdVv8GwE/WXiC15+Lou/gGNvRQ+KOChRWVQZTDsCju5xWqOqo6ERBF5mK5g8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175816; c=relaxed/simple;
	bh=6bfCWE4Rr4oRbfc6VqBNayYNlANscTj8esYh1v2Sdg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiPCNC/j512SKoWMCdNWiS3bjUtTJEL+T8XlNW3nImJb3zJxVs08qNbusXZTsvuwvfMqL+2MzljDclaoSARZyDAiPRBSEESVNMlnYImqiFxrT8clPs2JrTpYgmfHexSNZtqQV3WoSKFGCyDSL3bzxLmr4dLksN0D1rjg/Jgy1PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uodpiwNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uodpiwNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A23C4CEE3;
	Tue, 17 Jun 2025 15:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175816;
	bh=6bfCWE4Rr4oRbfc6VqBNayYNlANscTj8esYh1v2Sdg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uodpiwNTXFwTHtazodptuqq0gDg92Oq1vSwPRCGJjvTjDFd9Sojh12Fgo5sa9yvJm
	 wWl2rcYzoAjAPbDVevKHRIO1ZQDOsoxGMU26/x6ROjEHMuJZ2r3dGtBNdrhdJzgCZn
	 qiwqK7oVjXemQqTAjDevrYHMqYt0SKm/XtbltHmw=
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
Subject: [PATCH 6.6 215/356] perf tests switch-tracking: Fix timestamp comparison
Date: Tue, 17 Jun 2025 17:25:30 +0200
Message-ID: <20250617152346.861017776@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e52b031bedc5a..2c7bdf4fd55ed 100644
--- a/tools/perf/tests/switch-tracking.c
+++ b/tools/perf/tests/switch-tracking.c
@@ -258,7 +258,7 @@ static int compar(const void *a, const void *b)
 	const struct event_node *nodeb = b;
 	s64 cmp = nodea->event_time - nodeb->event_time;
 
-	return cmp;
+	return cmp < 0 ? -1 : (cmp > 0 ? 1 : 0);
 }
 
 static int process_events(struct evlist *evlist,
-- 
2.39.5



