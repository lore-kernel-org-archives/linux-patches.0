Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077AF46E007;
	Tue, 21 Jul 2026 18:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657307; cv=none; b=jXgMCU/nsVdCoMCtrWsQw92t0VHVzJDw79ipZtxCrDtl5Sg8WdBt8xEU/OS8pJo5XADf5uChMQ50gic1Xn5d7djrRQnyRFCNq02hBUBkgSN7JIeoGG7BguIZwe6u8w749Y1NyyaSsVeqBC/sAw4KWu4HfZBUM2aC/u41eiCG/Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657307; c=relaxed/simple;
	bh=2BgLfn1bgoY2FrqDgtX0t4M2vUBmsA9BuHM4AwjpfOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+1n2Zoxoocv8AlTsrrkggf5ogj02TkwF+6cVcd94Siyu/Q9UBG73CfyxbaHK0tzVCzGVweFdR4ILndrBf3tEb4EvGH1UKWMVUrq13jbI3E71MlXoEUat0ZCdurDoCccvZRQiguXfvJaOba0WWkzMfJWczWsz4ot4Cx2IdXkVCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2+Upow2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2+Upow2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE5F1F00A3E;
	Tue, 21 Jul 2026 18:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657301;
	bh=k1wTAEFDE0hOqyx9/0WXuVOPzM/iUQoy5o5Y3nN73AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2+Upow2zf1kUVolA2MX3aGgjU2dliru+WEz2QM9GN3qgKsVdsMZd0WBzNHSUeP4A
	 ep58+KB2VQRqkUiXyj0QbVUNwWsc+JoFoqZscPF+yjFGDNp8hH9cfmUBvqk/rG4sps
	 yWySwVcDAMBSmiIf9fXYvH8WXEdvzxJTa7MPVGcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0714/1611] perf hwmon: Fix off-by-one null termination on sysfs reads
Date: Tue, 21 Jul 2026 17:13:50 +0200
Message-ID: <20260721152531.441440848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5c27256a220a51..c4efeaae2607ec 100644
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



