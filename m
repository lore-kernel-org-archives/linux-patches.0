Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA3C1BC063;
	Thu,  6 Jun 2024 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683502; cv=none; b=RlUvaJt1FYxpVvbhp2adfAS7uOj2q0FyIN2orXfy79ci3LSkDZxTQJJ5v7Hws5cNZ2533LknNvmU10bddy6QjpuhMsPbrXY5mKh3tR4F/P4YqtNrHZwmkRcaWxboVgX6f1vbLtUzyfC0SiIyuR2gbymV/comp5blfyXnMrETouw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683502; c=relaxed/simple;
	bh=Ebhs69Ms08mLnW2FlCb4tMheCVU3wa2QVhxkGEUkzbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZA2sNDV/dpBKZ7fAcWDk64Rnb3XSssRbrtfv1fIgCk81oILNyOgicfNsNg88S8x7ne2mFd86yogXRQw4eUY55syGQcXBxdiaX82OVQ+diukHlm5q5f9iykfBUnRc27IRFWhHmYL8pNOqimGgTLAcqI3tCNUUuKE+rnJnD7/dMaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/JIu1Rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/JIu1Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE01C2BD10;
	Thu,  6 Jun 2024 14:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683502;
	bh=Ebhs69Ms08mLnW2FlCb4tMheCVU3wa2QVhxkGEUkzbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/JIu1RhjLjmGLp2OoQWLZKphWg4uzPhsoi7roawPR1DR6wQHJW+kfP8pUmvh8V6Q
	 5VBJZonwaDz3PGPH0cfmOOv0g97lvPF7Cdu4O3oa4iDEPrC7nkh+j+cvY45pd4L50l
	 hVzh++iXkpwgIqO7sCNfnj3JApcSvOmhXlkMyicA=
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
Subject: [PATCH 6.6 444/744] perf test shell arm_coresight: Increase buffer size for Coresight basic tests
Date: Thu,  6 Jun 2024 16:01:56 +0200
Message-ID: <20240606131746.742521749@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index f1bf5621160fb..4d4e685775303 100755
--- a/tools/perf/tests/shell/test_arm_coresight.sh
+++ b/tools/perf/tests/shell/test_arm_coresight.sh
@@ -186,7 +186,7 @@ arm_cs_etm_snapshot_test() {
 
 arm_cs_etm_basic_test() {
 	echo "Recording trace with '$*'"
-	perf record -o ${perfdata} "$@" -- ls > /dev/null 2>&1
+	perf record -o ${perfdata} "$@" -m,8M -- ls > /dev/null 2>&1
 
 	perf_script_branch_samples ls &&
 	perf_report_branch_samples ls &&
-- 
2.43.0



