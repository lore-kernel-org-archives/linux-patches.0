Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C981735C6B2;
	Sat, 12 Sep 2026 09:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206190; cv=none; b=UHZH9/xpHzlOlSERlmU92Wesr3JRMkU7cYDH2IrMQRh2edyU1Mgh9iccpbkEak754p4oW9WN5camekO8tCE4xGEwU4kOyQxyPzoMTxpO3BxgBwN1gg9uqP9br6qc716cSQAS4kQ9dKs08tM8QA5w/JQtpFCl5QOA4X1yyuVCAUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206190; c=relaxed/simple;
	bh=fjBtUncIh9FqRgofWbNyviKua/gHtGtfatYvxjKIkTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mkf7Yh/Q6JhGzOAtYpLhuzk1SpUoIXUWh5fP9xA/2+XkeFj4aWtBNTAiOKr6Zinw++FcQTZoSTAuZC1DDWKo8UAhCfsE2T03P6YYoQV9cqJfxrVRNEQiR6GC340zbz97umYAhbSrD1R84EJsbls1wjO44rhyA7eIzAJ1MQylhUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZw9wSx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZw9wSx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834481F000FF;
	Sat, 12 Sep 2026 09:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206188;
	bh=vE21Uvy5Y58koH9TjoAyOkTyXbmwmGp+RJy9Ziq0c1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZw9wSx7sCRo4SKRa4pOpGyFFqVxPtc2xEVakqTOkfVMbf4OlCmc/pOqAGBrJvTYi
	 Bj5ahxtbv3nFIZkdv8nxd8qew274VYC13AWJj26Epywf60Vlk9paBi3nJyZTj1qmXc
	 umoePq3yFmQ3FqpRcAWduo72d5uRDeiqTb0zEoZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0156/1518] perf test metrics: Update all metrics for possibly failing default metrics
Date: Sat, 12 Sep 2026 08:38:45 +0200
Message-ID: <20260912065627.021138531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 91c1949d768520d9befa7761eb97c3826997da25 ]

Default metrics may use unsupported events and be ignored. These
metrics shouldn't cause metric testing to fail.

Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 8953bfd8820b ("perf tests: Skip metrics validation if system-wide recording lacks permission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_all_metrics.sh | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/stat_all_metrics.sh b/tools/perf/tests/shell/stat_all_metrics.sh
index 6fa585a1e34c9..a7edf01b39433 100755
--- a/tools/perf/tests/shell/stat_all_metrics.sh
+++ b/tools/perf/tests/shell/stat_all_metrics.sh
@@ -25,8 +25,13 @@ for m in $(perf list --raw-dump metrics); do
     # No error result and metric shown.
     continue
   fi
-  if [[ "$result" =~ "Cannot resolve IDs for" ]]
+  if [[ "$result" =~ "Cannot resolve IDs for" || "$result" =~ "No supported events found" ]]
   then
+    if [[ "$m" == @(l1_prefetch_miss_rate|stalled_cycles_per_instruction) ]]
+    then
+      # Default metrics that may use unsupported events.
+      continue
+    fi
     echo "Metric contains missing events"
     echo $result
     err=1 # Fail
-- 
2.53.0



