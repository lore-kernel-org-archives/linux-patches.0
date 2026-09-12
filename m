Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759D61DE4EF;
	Sat, 12 Sep 2026 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222495; cv=none; b=g+m8RJLBbLhhHbklNjw5e8wX61/ShWZsWoOX/DpXWLiqqgUQKxwvawH5s+Ime8C0P1BFKVr7LsDuubm1YEeBayVpy+Q9h5U5g/3sNdoClss2My8bZJuSmK+wRlXwgbpWzXHTbDk8Yh6GlCzD+CCdBFMYsbrf1ut7QF5oWG4eg+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222495; c=relaxed/simple;
	bh=fMNMPVqXVULL/9BfGQVCRVb64JK0S/CUVVuT2Cka4ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/lviMucwNWPBoliDnb0FRLxFMliiIgsJlvWXmGkurjinpanoEoqZ+4qg4sjYEPvqfqMLc/p2jgPdrwEfawh3lu8xzEIGl8rBzeY8HZYn9Su7PjESKJauGgKDO3xY1QaBpxA+WDx37iP3WcpbhVTlilkC9eBL00UWkbHYaKw55Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5xGtG2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5xGtG2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164AC1F000FF;
	Sat, 12 Sep 2026 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222494;
	bh=6KE/1h92BiSq50+gCgZWjlgPpMu4aMsCmK+7G/PVwwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5xGtG2RWNCuPNOfeNSlPT0N9RM3TTS1F3XoWV6XRDtsSqvfr/RMu/S9vuY7nYjQO
	 oepwzZHh37IfnCF1Js4MaG14OVzUZggp3f3qMMZ0DvwG4MuD63nn2qgUBso/uTLxf7
	 pyv6bPHdBxivpJx+mTWfB1b5Hc+vNh88QbAxBgOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0599/1424] perf test metrics: Update all metrics for possibly failing default metrics
Date: Sat, 12 Sep 2026 08:50:31 +0200
Message-ID: <20260912065620.707131900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



