Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7AC21B191;
	Sat, 30 May 2026 18:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166475; cv=none; b=rO5FIYp9CIYKjXWxbjSLU2hE5KQEBb8sm8ELnx/8KPZZXCoTbJofgnQRArufOo34sEiFgAgBwgo4SHy8i/B4RPs5zr2jXoJlTyy9XtiOyx9Jjj+CTgpJf/1kWyIsT8dqBdW8OYjVsfGx8b+e5VI09paFU4j9ygp96MjgRHDx2co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166475; c=relaxed/simple;
	bh=f4TlGzUUvwj8vdR2PpKhMmX2h8jyAnuuP4E4quJoSQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMJkI3tQEZp60Lw/tnf9+cCftW08CNP/IoHupiD1XKVmlBDuMY/+FugrMEP2uNpWa6wh89aSgBsh5efVW54nUTVIBjSCSFYp2Iyews7qOq9ge5L8IFdirHSs1wlxb9MWuU0cvFv5sqbRGO4moPrxaIqRx1TltlXWj3rcb3nTNEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YR/ULmrp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YR/ULmrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E451F00893;
	Sat, 30 May 2026 18:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166474;
	bh=69Mom6/04XiZvpFkvtXlMD5TuLOIU2tXrdQ8b9Tr7RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YR/ULmrpmPL4rnloaDXxIwLwW+GcbQ1k7nar5LUsrzwfpkMNVXDh5yqpDji3shGl6
	 6+NTdngi3KVt+YZVhtzY+sWG+N8t1v7a7u2YvPJlNijzCc3+uzxvJlQf+xxyHrHhpu
	 ialdRpmenWe0vPajmJxxHtcKXb4sxnp8ywe34PEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 384/589] perf expr: Return -EINVAL for syntax error in expr__find_ids()
Date: Sat, 30 May 2026 18:04:25 +0200
Message-ID: <20260530160234.894106721@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 3a61fd866ef9aaa1d3158b460f852b74a2df07f4 ]

expr__find_ids() propagates the parser return value directly.  For syntax
errors, the parser can return a positive value, but callers treat it as
success, e.g., for below case on Arm64 platform:

  metric expr 100 * (STALL_SLOT_BACKEND / (CPU_CYCLES * #slots) - BR_MIS_PRED * 3 / CPU_CYCLES) for backend_bound
  parsing metric: 100 * (STALL_SLOT_BACKEND / (CPU_CYCLES * #slots) - BR_MIS_PRED * 3 / CPU_CYCLES)
  Failure to read '#slots' literal: #slots = nan
  syntax error

Convert positive parser returns in expr__find_ids() to -EINVAL, as a
result, the error value will be respected by callers.

Before:

  perf stat -C 5
  Failure to read '#slots'Failure to read '#slots'Failure to read '#slots'Failure to read '#slots'Segmentation fault

After:

  perf stat -C 5
  Failure to read '#slots'Cannot find metric or group `Default'

Fixes: ded80bda8bc9 ("perf expr: Migrate expr ids table to a hashmap")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/expr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/expr.c b/tools/perf/util/expr.c
index 53482ef53c411..15f857fb0e713 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -239,5 +239,6 @@ int expr__find_other(const char *expr, const char *one,
 	if (one)
 		expr__del_id(ctx, one);
 
-	return ret;
+	/* A positive value means syntax error, convert to -EINVAL */
+	return ret > 0 ? -EINVAL : ret;
 }
-- 
2.53.0



