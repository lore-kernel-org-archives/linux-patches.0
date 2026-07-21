Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC7440912B;
	Tue, 21 Jul 2026 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660500; cv=none; b=PStJsxSBB/vSyxeTF20THWvTSqHai8n3QVFI/99h8JHEwj64PGk7duoSEbD3XD0KeVzZjE6qf0+567tlo4HpdXKXqTyofG3wxNwHVj09b/aWAUsK5TRc1zGipN1hoRgMqRzvG1fu4DvHTA8rGVY8zhQ/01usvxQ5CKxnwWJZ+rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660500; c=relaxed/simple;
	bh=ud9FddlT4hVJmqWb/7zvzDbzEsM+zqUX1RAT8qKdIxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrLAr8oRrWkqy6OwdfgQ6jOVAEqJhkwdY1BQe3wvzZABgVrHud7eSuuuDtlZisPPGes4On2Qp3xgJXeErlQORGMFr+UMK3rlBKlZHYo/jdKT1MY4DJaYYdvKGHXxp6TmP2ARvK5khMwuQHrixRjOfLiyhupMo4Z/hYcfvx4dl08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eF4bxR5j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eF4bxR5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6B01F00AC4;
	Tue, 21 Jul 2026 19:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660467;
	bh=VXnxwlLsb5/msb6qYU4lN0iS6YzI18c1wZ/COznNsEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eF4bxR5jiIKIN/m5WWum898uHdygu2vOdgh7WVPkWoz53fptxatlHtDaTwMJp/Lqo
	 Kaa/utlpBnf5rVPaNCpxgnmXBWOecw54Apmt9Q26p5AowNGkutl54lv1KtSVc1USIo
	 CXRC1gKGBPmT/TGvepSlmP8VD2/bf6gAp37OScVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0991/2077] perf tools: Use scnprintf() in build_id__snprintf() and hwmon read_events()
Date: Tue, 21 Jul 2026 17:11:04 +0200
Message-ID: <20260721152616.192067997@linuxfoundation.org>
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

[ Upstream commit e33711d5e757011bb6d3506af4d6c97dad412b8f ]

build_id__snprintf() and hwmon_pmu__read_events() accumulate formatted
output via snprintf(), which returns the would-have-been-written count
on truncation.  In build_id__snprintf(), this inflates the return
value beyond the buffer size.  In hwmon_pmu__read_events(), len
overshoots out_buf_len and the next 'out_buf_len - len' underflows.

Switch both to scnprintf() which returns actual bytes written.

In build_id__snprintf(), also tighten the loop guard from
'offs < bf_size' to 'offs + 1 < bf_size': since scnprintf() returns
at most size-1, offs never reaches bf_size, and the original condition
would spin doing zero-byte writes once the buffer fills.

Fixes: fccaaf6fbbc59910 ("perf build-id: Change sprintf functions to snprintf")
Fixes: 53cc0b351ec99278 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/build-id.c  |  7 +++++--
 tools/perf/util/hwmon_pmu.c | 12 ++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index fdb35133fde43a..3c286cdbe6e0e6 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -93,8 +93,11 @@ int build_id__snprintf(const struct build_id *build_id, char *bf, size_t bf_size
 		return 0;
 	}
 
-	for (size_t i = 0; i < build_id->size && offs < bf_size; ++i)
-		offs += snprintf(bf + offs, bf_size - offs, "%02x", build_id->data[i]);
+	if (bf_size > 0)
+		bf[0] = '\0';
+
+	for (size_t i = 0; i < build_id->size && offs + 1 < bf_size; ++i)
+		offs += scnprintf(bf + offs, bf_size - offs, "%02x", build_id->data[i]);
 
 	return offs;
 }
diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index fb3ffa8d32ad2a..dbf6a71af47f9a 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -442,12 +442,12 @@ static size_t hwmon_pmu__describe_items(struct hwmon_pmu *hwm, char *out_buf, si
 
 				buf[read_len] = '\0';
 				val = strtoll(buf, /*endptr=*/NULL, 10);
-				len += snprintf(out_buf + len, out_buf_len - len, "%s%s%s=%g%s",
-						len == 0 ? " " : ", ",
-						hwmon_item_strs[bit],
-						is_alarm ? "_alarm" : "",
-						(double)val / 1000.0,
-						hwmon_units[key.type]);
+				len += scnprintf(out_buf + len, out_buf_len - len, "%s%s%s=%g%s",
+						 len == 0 ? " " : ", ",
+						 hwmon_item_strs[bit],
+						 is_alarm ? "_alarm" : "",
+						 (double)val / 1000.0,
+						 hwmon_units[key.type]);
 			}
 			close(fd);
 		}
-- 
2.53.0



