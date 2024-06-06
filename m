Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B65A196D9C;
	Thu,  6 Jun 2024 14:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682926; cv=none; b=QYv0JliPVPXs8wJQc6zU/PJn7y2vg2wyd7kUl+h8Agjt1oQwKP82xsxf6OmzNHGqyeC6S6z5077BI5SrVbqY6t4pYKrO0pDEBco9/WS9b59Ja541c+oAjkcOFcWljGce9C+u4JXY8tdLLO2czU7miiiLtdtMpWMLc/bsmqyeoaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682926; c=relaxed/simple;
	bh=6yXUm04UsXrtUOpXE6L8L/CPLeHdZRzpb5rcdwGYBro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD3BD7d+3SBvZMm5h7M7+ZoxlClPm9EfGnRQBpBYBgy7NCBfyZXh3WbXFnZgwQdmI5pMFnncd8n6is92G+3IQFU2Cg3dtedoRW/F4dTW/3krRJrPKzb5C/cPj9yIimK/JfB4G33E/yY1issC0VP3kfqf+HZse93q/uem/j88S7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNn98ErR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNn98ErR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C2BC32782;
	Thu,  6 Jun 2024 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682926;
	bh=6yXUm04UsXrtUOpXE6L8L/CPLeHdZRzpb5rcdwGYBro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNn98ErReFiOYcxP+ezno2sYutUuTwof4wjrfqmk0zO044MOoAV13+ivGkiiRn6wG
	 24QW1OIe7uKQYA8kZSRpfycbxXhdfuO4ZlmG64I4Jy7Nu3DH9SUZf1Hc8EGKif2t9D
	 VVhPPStFGbIV475ligN4lfoHrWh/mRBzJ2fetrII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Clark <james.clark@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Suzuki Poulouse <suzuki.poulose@arm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 052/374] perf test shell arm_coresight: Increase buffer size for Coresight basic tests
Date: Thu,  6 Jun 2024 16:00:31 +0200
Message-ID: <20240606131653.574956459@linuxfoundation.org>
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

[ Upstream commit 10b6ee3b597b1b1b4dc390aaf9d589664af31df9 ]

These tests record in a mode that includes kernel trace but look for
samples of a userspace process. This makes them sensitive to any kernel
compilation options that increase the amount of time spent in the
kernel. If the trace buffer is completely filled before userspace is
reached then the test will fail. Double the buffer size to fix this.

The other tests in the same file aren't sensitive to this for various
reasons, for example the iterate devices test filters by userspace trace
only. But in order to keep coverage of all the modes, increase the
buffer size rather than filtering by userspace for the basic tests.

Fixes: d1efa4a0a696e487 ("perf cs-etm: Add separate decode paths for timeless and per-thread modes")
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20240326113749.257250-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_arm_coresight.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/test_arm_coresight.sh b/tools/perf/tests/shell/test_arm_coresight.sh
index 65dd852071250..3302ea0b96723 100755
--- a/tools/perf/tests/shell/test_arm_coresight.sh
+++ b/tools/perf/tests/shell/test_arm_coresight.sh
@@ -188,7 +188,7 @@ arm_cs_etm_snapshot_test() {
 
 arm_cs_etm_basic_test() {
 	echo "Recording trace with '$*'"
-	perf record -o ${perfdata} "$@" -- ls > /dev/null 2>&1
+	perf record -o ${perfdata} "$@" -m,8M -- ls > /dev/null 2>&1
 
 	perf_script_branch_samples ls &&
 	perf_report_branch_samples ls &&
-- 
2.43.0



