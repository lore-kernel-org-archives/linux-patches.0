Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6F8471271;
	Tue, 21 Jul 2026 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657477; cv=none; b=VIAirUSnEu2Xug2tqVVmWWtuOYtKcFdV9jopC8eGYlDxIGy0Qm3hgGnwu7Fvleyvd8gbaIHvkbd1hVH5iV9UNe+VNCftIq8RcRpRBgyOtQEh3I204x2YJ9u/U1GTqzrGQIuzr2+cLzPC2xNnJDAKQ/uuACPs63NF9eZZlN0VrCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657477; c=relaxed/simple;
	bh=MkfvUX6jF8ONRwSPNN3AXu7pgqvWZegKHcIXslSwduM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWCYmZwLCdeXk7JJz/REDIpOpWIb+Z2weS3V40LOlbSZUlSW22vjkWZZ126foHGqsyCaLZol4hsLJcAvop1ACHZeArxu4BikBdzJcMdo6PnDJYzt9cgkCME60dlL0jd+XIFUT9e6AlIsD5iu2AaFnQ90frEzPk5/w7i+slmy4Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSmNYTjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSmNYTjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D2E1F000E9;
	Tue, 21 Jul 2026 18:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657476;
	bh=JlnanKeyhbAF7oIOhvSDYAmTthH/IM+Wg4ZIK5f1As4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSmNYTjCDT3AL3Npz38YdLCD/VNQj0ijRU1EyNPNbCElyLoWGsHTvKb14mCO2gSnY
	 P6cI9dKpyRWP/WlxLfUhbcZhB6BoRtWKk+jIzq28JXkjooGgn2w0O4h11pbrHMzHio
	 fitG7UiMhdCLgzbtuceLz7zwFjD1Auf3T+pKp+sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0778/1611] perf hwmon: Fix fd check to accept fd 0 in hwmon_pmu__describe_items()
Date: Tue, 21 Jul 2026 17:14:54 +0200
Message-ID: <20260721152532.886678448@linuxfoundation.org>
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
index c3bc9e427cdbb7..900868b6f8919d 100644
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



