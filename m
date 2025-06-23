Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173CA24DCFD;
	Mon, 23 Jun 2025 13:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685941; cv=none; b=mwdqFlqgFDBqvfhR6+0ZqLTn3AG1FP+2WlXOY9YOcBGS+LwXeDnRyvnxmVY8YGQDVby9EUfVQ0tRnF4MhaNEKbCXWEHxu05ZcAvaeOmGw7cJA7Kiu1RzCsNgHYRIdgCRz6UZ49cViSpb7s5+2l+kVower4dR3Gy4taR5LtffYyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685941; c=relaxed/simple;
	bh=CG5Dz6HYwuQh+9pVqNHMJTOng9Pt2g6Kpo3AkjDgZmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufkdeVk4NaAnLhS/3YaTipFn0OkN2xEeqgmZfeUL5QCEWHcmmdSSU5nm9/BdEBPz8r7aM/dQXVS94FHEZo3kzdwR23dU7pw4HhE0Ed27MFl7FGK7io13zthted5J/yeiHSAX+ac2+n7zKLAh8h9yYOd6OKrHH019SdOzxVnww9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+QPFd/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+QPFd/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC7AC4CEEA;
	Mon, 23 Jun 2025 13:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685941;
	bh=CG5Dz6HYwuQh+9pVqNHMJTOng9Pt2g6Kpo3AkjDgZmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+QPFd/BZo/wA9urpJ/3Lv69kBWP6N1qborXILSfw+N+aSLHHM8SKAyFExyoJ8MGN
	 JcZGJFqDA/oCeyoMHNa3VZ3dOD8jpnf1cH594gSPz1X4WCF6ozlIaRqHATYtcOJ9yC
	 dBl6kBWzbC+fndmwjqUwTAA2X/IRjOggfLRwQSqE=
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
Subject: [PATCH 5.10 081/355] perf tests switch-tracking: Fix timestamp comparison
Date: Mon, 23 Jun 2025 15:04:42 +0200
Message-ID: <20250623130629.248667020@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index db5e1f70053a8..7b28d468fc6e8 100644
--- a/tools/perf/tests/switch-tracking.c
+++ b/tools/perf/tests/switch-tracking.c
@@ -255,7 +255,7 @@ static int compar(const void *a, const void *b)
 	const struct event_node *nodeb = b;
 	s64 cmp = nodea->event_time - nodeb->event_time;
 
-	return cmp;
+	return cmp < 0 ? -1 : (cmp > 0 ? 1 : 0);
 }
 
 static int process_events(struct evlist *evlist,
-- 
2.39.5



