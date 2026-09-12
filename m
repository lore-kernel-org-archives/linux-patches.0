Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F45343893;
	Sat, 12 Sep 2026 12:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214575; cv=none; b=bmjBCNrTiOKkd95zFc8tEjq0/UskcCkzlixjPC15N0mC+l4FhpBD1E0rKdypmvLdp0Pzlv1CjE7VC9A5/RgWCtjcEBJg4rNmR9ElEkiN0wKOK9hfuTRBsCYZl/wPmx/1ge6ShqBk+bum7FQqhHyZfXa1GiAoPUIyaOLglWIiL0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214575; c=relaxed/simple;
	bh=X6KXIkhIRKycPQe8JmB0oqrU47/Ueo2IEE5lmuCH+Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqDwsGviNxo32mmmxHKxbZYhWHQbqVB56MKU1lQ+EjE3gWRhPr8svwp0e6z9sDl8dyx5tqnv+sl/4vpHStcuOd3FYvW6VSC9AkqTMka1QHH2BW3C7qFrXQnDjQ3QdbZChtBvZU7qKTZ+2GBDDUseCW78h8XXjU/jsNjHZn2LF8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjtYGhQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjtYGhQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC3B1F000FF;
	Sat, 12 Sep 2026 12:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214574;
	bh=viNLwGH6CRhhllj8Ar/ha23IRY3PkRnSXDrqr67uwY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjtYGhQ9PCpzgFwvgM9+F6KtnKl19VY6O4j8EOGujbZH/X0NogoKa7xmRr7frb/Kw
	 mx/hX0Gh8TJne+oTV19rHFzwwM1Z3Y4ItyYkQEV2dMGY/+J9A1HqwWjos+WfSrWilN
	 SWFm8ib/j/3yfF93SkskgTrW8UpigbRJtSKcqYHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0354/1376] perf test metrics: Update all metrics for possibly failing default metrics
Date: Sat, 12 Sep 2026 08:46:20 +0200
Message-ID: <20260912065615.440483588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



