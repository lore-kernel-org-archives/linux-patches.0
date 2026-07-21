Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30F346F49E;
	Tue, 21 Jul 2026 19:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660570; cv=none; b=D/81VM59dlb+KxJTvZH7sdLOZglg5Wm60jvPhW8lk5Wbm1DxcVkgxcJGgcp5sXsbavx4GBBg5gXdBOf5r6+zXy3Ob9zpdvwm+7P+PmSodR3rIHePbfFkTx7GHFlSXbT1L+yziuEsRICkQI1qfXwYp3oqgYEx5c8wTNMwzLeO5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660570; c=relaxed/simple;
	bh=5EqYyQ4VQHCAlywCFUce76gbWIKvtkXHoroEK1boVno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3Us4o78SXb5l3jHo/2TJnsNrJTKb0yo9BJY2VSx7cpp7Ie6kgh1GAJeLvn3sukZH+dOOgA1y/EJOE/XJU/xdfsN6VlnJdx4Cw+tLaxD4AnAnt2kfd9cgKGEjwdlSVC08IPxE1LzX2JbvoBdXKoc3VvLd2r0NFngX+eJ2JRjfpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZpieWt/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZpieWt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DAF1F00A3A;
	Tue, 21 Jul 2026 19:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660568;
	bh=yU24QiCmZFwsGq78TD22KzMeU5bhKEEOs03qGMOLzj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZpieWt/m4HDAVqSo2W6bdxsereSsm5EfL0qOoKC0UU4rHWQfSfCk/9d42E1LXzKw
	 O4pESz4efBWeQ9Q+xQwu6ChPVx/Q5ZcnxXHmGMbmyUZryc/b+NuAi0vwg7qz+8XnuE
	 5o0KFMmmS5mYLkQeCroicwxmgDZq7kjRA5I8/NYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1012/2077] perf hwmon: Fix off-by-one null termination on sysfs reads
Date: Tue, 21 Jul 2026 17:11:25 +0200
Message-ID: <20260721152616.687452932@linuxfoundation.org>
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

[ Upstream commit 1847c5fae344a0fb9cc0f95be40b378359c6fc3b ]

Three functions read sysfs files into fixed-size stack buffers using
the full buffer size, then null-terminate at buf[read_len].  If the
read fills the buffer exactly, read_len equals sizeof(buf) and the
null byte writes one past the array, corrupting an adjacent stack
variable.

Fix all three by reading sizeof(buf) - 1 bytes, reserving space for
the null terminator:

  - hwmon_pmu__read_events(): buf[128]
  - hwmon_pmu__describe_items(): buf[64]
  - evsel__hwmon_pmu_read(): buf[32]

Fixes: 53cc0b351ec99278 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index dbf6a71af47f9a..d895cd74f2a05f 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -289,7 +289,7 @@ static int hwmon_pmu__read_events(struct hwmon_pmu *pmu)
 			if (fd < 0)
 				continue;
 
-			read_len = read(fd, buf, sizeof(buf));
+			read_len = read(fd, buf, sizeof(buf) - 1);
 
 			while (read_len > 0 && buf[read_len - 1] == '\n')
 				read_len--;
@@ -432,7 +432,7 @@ static size_t hwmon_pmu__describe_items(struct hwmon_pmu *hwm, char *out_buf, si
 			is_alarm ? "_alarm" : "");
 		fd = openat(dir, buf, O_RDONLY);
 		if (fd > 0) {
-			ssize_t read_len = read(fd, buf, sizeof(buf));
+			ssize_t read_len = read(fd, buf, sizeof(buf) - 1);
 
 			while (read_len > 0 && buf[read_len - 1] == '\n')
 				read_len--;
@@ -816,7 +816,7 @@ int evsel__hwmon_pmu_read(struct evsel *evsel, int cpu_map_idx, int thread)
 
 	count = perf_counts(evsel->counts, cpu_map_idx, thread);
 	fd = FD(evsel, cpu_map_idx, thread);
-	len = pread(fd, buf, sizeof(buf), 0);
+	len = pread(fd, buf, sizeof(buf) - 1, 0);
 	if (len <= 0) {
 		count->lost++;
 		return -EINVAL;
-- 
2.53.0



