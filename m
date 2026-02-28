Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234B54A2E2D;
	Sat, 28 Feb 2026 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300874; cv=none; b=YIGIBLzW/SvikCIt7kapAKnej6PA2wpq3mSssv1xPxPTYd8PZtE5VvTKDj5CizGiXOzdTNs0NEm8pbl8VdRZZkC8BBaQ55SrZIegpvo6iEAqhOk6n/NZcvAOO1JSWAkZpKJ4ScZJd5UK12h/oP/Sy8tEAqeI2R+nCjb7RHq43C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300874; c=relaxed/simple;
	bh=fdtVAyDrdTokdNcRh+fvjutoC6iD9TB5Wv2JSQ7+d+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLNsr5lKFaKgtZYCpP2/MWh4/6B60L8jce0md+ZASclfe0LCyH+cfZkfXqH+ev5xV4v9XMBT/M8Kim5RHvpnTxNMvUT7gP0MrF2ZOJYkq6SpYMMSZuEx3EBPfZ25FoaDoQ1zu0dkSsrU1Ev6APsjjRdZw+2CB2W8AQSuVXuN9zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ya0Ijktu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ya0Ijktu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43A1C116D0;
	Sat, 28 Feb 2026 17:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300874;
	bh=fdtVAyDrdTokdNcRh+fvjutoC6iD9TB5Wv2JSQ7+d+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya0IjktuByX7jRCuZNuoSZkdan0m22fN7mgEPEM8KgzZHVKl6VnGs03Mbp4YZLmeu
	 TgxGN76BP72/cbvJWdVTj7Kh6nahC7mfXEwg0Dl9Wkzl5+WIgZhSSuZd2QDRDGJPlu
	 eN0ZUJ3gkpjIC/KS/L7Fh32DCZpSAB4y2LRRBRzh5QWzOVTOV+h8vHp5C9TNzjNYRf
	 ESxoj31yG78Zv4wfv/ufhJnNWop1gqog2utDfqJOZ5Ja3eUUpmrg+95D8zjT5DMT0e
	 Fz/y20jGI/C5guD4xx/iFjzDbkMS89UXfzjo9CaEymmfAVupm00W4rH71b3xYiLSjC
	 3adLH0Nyfi7Qg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Richter <tmricht@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Jan Polensky <japo@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/752] perf test stat tests: Fix for virtualized machines
Date: Sat, 28 Feb 2026 12:35:13 -0500
Message-ID: <20260228174750.1542406-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit e272628902c1c96731e2d9f62a7fc77767686eb0 ]

On s390 'perf test's 'perf stat tests', subtest test_hybrid fails for
z/VM systems.  The root cause is this statement:

  $(perf stat -a -- sleep 0.1 2>&1 |\
                  grep -E "/cpu-cycles/[uH]*|  cpu-cycles[:uH]* -c)

The 'perf stat' output on a s390 z/VM system is

  # perf stat -a -- sleep 0.1 2>&1
  Performance counter stats for 'system wide':

        56      context-switches  #     46.3 cs/sec  cs_per_second
  1,210.41 msec cpu-clock         #     11.9 CPUs  CPUs_utilized
        12      cpu-migrations    #      9.9 migrations/sec ...
        81      page-faults       #     66.9 faults/sec ...

        0.100891009 seconds time elapsed

The grep command does not match any single line and exits with error
code 1.

As the bash script is executed with 'set -e', it aborts with the first
error code being non-zero.

Fix this and use 'wc -l' to count matching lines instead of 'grep ... -c'.

Output before:

  # perf test 102
  102: perf stat tests                      : FAILED!
  #

Output after:

  # perf test 102
  102: perf stat tests                      : Ok
  #

Fixes: bb6e7cb11d97ce19 ("perf tools: Add fallback for exclude_guest")
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/stat.sh b/tools/perf/tests/shell/stat.sh
index 985adc02749e2..d72d16d0b8c46 100755
--- a/tools/perf/tests/shell/stat.sh
+++ b/tools/perf/tests/shell/stat.sh
@@ -196,7 +196,7 @@ test_hybrid() {
   fi
 
   # Run default Perf stat
-  cycles_events=$(perf stat -a -- sleep 0.1 2>&1 | grep -E "/cpu-cycles/[uH]*|  cpu-cycles[:uH]*  " -c)
+  cycles_events=$(perf stat -a -- sleep 0.1 2>&1 | grep -E "/cpu-cycles/[uH]*|  cpu-cycles[:uH]*  "  | wc -l)
 
   # The expectation is that default output will have a cycles events on each
   # hybrid PMU. In situations with no cycles PMU events, like virtualized, this
-- 
2.51.0

