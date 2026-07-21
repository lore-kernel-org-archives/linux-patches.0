Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900B140928C;
	Tue, 21 Jul 2026 19:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660689; cv=none; b=iC1ijtBSttXdIhaDLYFqJpq42st6H5CqbD+T2NBTxuoBvrB9/E9+twXmf1rcNKl7EL21nxwzwGWNG8lpmg528qQTQsNxXWGvht+j9zDM7u9faP9P0RPwv6Nuke/XChl2+mlbeSxkKl/ANQojeJ9IgZQO7s9FtMAlHd+Y9YS+xFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660689; c=relaxed/simple;
	bh=8JeJ49FmSfX+BO5SrmTsho9+wiCMEhvsFyIbLpI7z8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRVFzfbBQT/YPHa30R/mDFKZ+N+c2ADQASlQPssQpRpDCSPbesLRwTDMcnrQTp0gUwbtQeUHo0yB67Zf1LAeGgaZXVxJ06StKECFruTHrUYf0/IiuQB++GLFUJVY6CSbGJoVL7eEBdMaxuHneXqdm/5drM35p5jOJ0gdSSZmCH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTbv14Xr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTbv14Xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78991F000E9;
	Tue, 21 Jul 2026 19:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660687;
	bh=oEedOmGQiSdyLeuK6PfQd1tPbmTrBbW6sbeHwvxo9/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTbv14Xr4HWyeO5ZxKmAzJwgs2Flm1LraCYQD7VVgHnSpSSRRoLzDpKDty1OO3KcM
	 ljX2NDLunNWXsy1piwm01nGPI5jrO3CEBBBYZytZFn0UdWApZwwgRGxrDutPGZ9ncO
	 5QRcDJmWpmW7V9bKCwC4O2lYU817+go5pdF3eyB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1075/2077] perf hwmon: Fix fd check to accept fd 0 in hwmon_pmu__describe_items()
Date: Tue, 21 Jul 2026 17:12:28 +0200
Message-ID: <20260721152618.178557801@linuxfoundation.org>
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

[ Upstream commit cfafef390ca9c753b34c7e97b5abee4cab0ce270 ]

hwmon_pmu__describe_items() checks 'if (fd > 0)' after openat(), which
incorrectly rejects fd 0.  While fd 0 is normally stdin, if stdin has
been closed (common in daemon/service contexts), the kernel reuses fd 0
for the next open.  With fd > 0, the sysfs file is not read and the fd
is leaked.

Change to 'if (fd >= 0)' to match the standard openat() error check.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 53cc0b351ec99278 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index efd3067a2e5910..ed544dca70c380 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -435,7 +435,7 @@ static size_t hwmon_pmu__describe_items(struct hwmon_pmu *hwm, char *out_buf, si
 			hwmon_item_strs[bit],
 			is_alarm ? "_alarm" : "");
 		fd = openat(dir, buf, O_RDONLY);
-		if (fd > 0) {
+		if (fd >= 0) {
 			ssize_t read_len = read(fd, buf, sizeof(buf) - 1);
 
 			while (read_len > 0 && buf[read_len - 1] == '\n')
-- 
2.53.0



