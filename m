Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05AA42D76B;
	Tue, 21 Jul 2026 19:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660654; cv=none; b=aRKE3Gx/XkODwuxWHd12CyFkWomV8CYNY8u8tyf1X+9Zx7Vv2zhGr/8zFFHTH0BjxiiSD/rsEnLoxbt4RtIY8/PZNTQERN5FtSIMWLQyqajIJxvhTWMAGna3i8Ndb5J4GGVBj1ZFq9+Bw4E2xQFm+qxyMv6+nvdIHSDia2BX+uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660654; c=relaxed/simple;
	bh=3vGzLPkh01qIreL7lzsEd1yfPFHboRRnuDp5KBGVDU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drKNbRt1/RPhbzo5Xtivcdqtd3SSiNd1vtTo+9c2U4o326ejLgWmI9uDVPt5UPbrz6NVF9ezKsa+ZIl+WFttPjXxqrZdqGFljknlmiGlo4upLjFOHZ+lqjTTP/EZ5+XTFJozkhZcogt9Ww4wdApRc9Hk1M7j4ArOBwmqf4cdbAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGtwBNz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGtwBNz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615721F000E9;
	Tue, 21 Jul 2026 19:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660652;
	bh=WWNsz3CH4nab44zPQJjGpTHXWVmBJ/oNSe1E0eAy4Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGtwBNz7vTzZxApT3J21uo1sWoOkBCvilQtoaMgPvahKlzdagwNlLbLRMC/v4+Rvu
	 3ju4rafvM9AVBj6tGROeqo853L2gYa+FUHBW6lUTHnoKDo/e56zPkdWp0OB5DFL5mq
	 uMQ9iKMb/HiGoBEYYLmxpy6hvGF8Jy9Q0h6Pmuuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1017/2077] perf hwmon: Guard label read against empty or failed reads
Date: Tue, 21 Jul 2026 17:11:30 +0200
Message-ID: <20260721152616.808580160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 34d3d93fac6d92237cb9d730ca04c37ed361c7a6 ]

hwmon_pmu__read_events() reads label files with read() into a stack
buffer, strips trailing newlines, then checks buf[0] == '\0'.  When
read() returns 0 (empty file) or -1 (error), the buffer is never
written, so buf[0] reads uninitialized stack memory.  If the garbage
byte is non-zero, the code falls through to strdup(buf) which copies
arbitrary stack data as the label string.

Fix by checking read_len <= 0 before accessing buf contents, closing
the fd and skipping the entry.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 53cc0b351ec99278 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index bdcbe887579a1f..efd3067a2e5910 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -295,8 +295,11 @@ static int hwmon_pmu__read_events(struct hwmon_pmu *pmu)
 			while (read_len > 0 && buf[read_len - 1] == '\n')
 				read_len--;
 
-			if (read_len > 0)
-				buf[read_len] = '\0';
+			if (read_len <= 0) {
+				close(fd);
+				continue;
+			}
+			buf[read_len] = '\0';
 
 			if (buf[0] == '\0') {
 				pr_debug("hwmon_pmu: empty label file %s %s\n",
-- 
2.53.0



