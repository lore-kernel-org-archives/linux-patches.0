Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3392D0C75;
	Sat, 12 Sep 2026 12:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215799; cv=none; b=Kicg5/ngefLRWVVocUsoCSzbD1qVktyAy05OSL05iad8Ra0LhmWrP8g7jUSooH+oVkR4sbyTvZsPgyYTWLwIzpFwzhz9iH+ZylPzSib06aiTxm3iAYUGGstf2u44ttRruDdAvjObmdNni2blwK3K51OyVgrGJoXBWt+xcQcvfiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215799; c=relaxed/simple;
	bh=fmv8bJVc/5MpK+Zvr1JJcHdNLwYJ8cojNipsBwE98xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPLbjtoKlBM6IZqzt1l8yCFpANHMqxuiEpBYdVDXyrvlbZmYhFHQb/lZLGHpZ36L0UfNTCACalN9OiegwxQwDE1I2H/qTylGhR6rVGploXCNq/eg2dOpGj04Aq3uV15xkUSv7TnUcW2tIFQyX1uXOVqpGtTUfg1pgsrb6F7V7/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPReopL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPReopL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C611F000FF;
	Sat, 12 Sep 2026 12:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215798;
	bh=xOdoMBohon5glxJ+u76kDbMvyY788Vv+phtCyghXydY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPReopL5oNUvJIBdmygRmWAbSiP3/jfnI9Q10QSkvr47noZHFYSFWNog1b3uPJLkI
	 fJbvG/yHxlvw2rEJ/QXVXBRtUH5N1ia8NUt9WU0QmBTiwE7O/rBR7o25jMRP3iAxTZ
	 ZBKBh5LVAu4cLh8zZFM8vB2SaVH+1CM+6LoJ/lBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nazar Kazakov <nazar.kazakov@codethink.co.uk>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0563/1376] perf jevents: Add more components to the metric sorting order
Date: Sat, 12 Sep 2026 08:49:49 +0200
Message-ID: <20260912065620.081788615@linuxfoundation.org>
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

[ Upstream commit 557f8b3ca8c8e58d5bc3084734bc7a470b043922 ]

Nazar Kazakov reported non-deterministic builds due to the metrics
being reordered in the jevents.py output. The metrics were largely
only being sorted by name, add in the expressions and descriptions.

Reported-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Closes: https://lore.kernel.org/linux-perf-users/20260706175624.692736-1-nazar.kazakov@codethink.co.uk/
Fixes: 40769665b63d ("perf jevents: Parse metrics during conversion")
Tested-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/jevents.py | 5 +++--
 tools/perf/pmu-events/metric.py  | 6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
index 4145e02777531..87cbbafb41e08 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -540,13 +540,14 @@ const struct pmu_table_entry {_pending_events_tblname}[] = {{
 def print_pending_metrics() -> None:
   """Optionally close metrics table."""
 
-  def metric_cmp_key(j: JsonEvent) -> Tuple[bool, str, str]:
+  def metric_cmp_key(j: JsonEvent) -> Tuple[str, str, str, str]:
     def fix_none(s: Optional[str]) -> str:
       if s is None:
         return ''
       return s
 
-    return (j.desc is not None, fix_none(j.pmu), fix_none(j.metric_name))
+    return (fix_none(j.pmu), fix_none(j.metric_name), j.metric_expr.ToPerfJson(),
+            fix_none(j.desc))
 
   global _pending_metrics
   if not _pending_metrics:
diff --git a/tools/perf/pmu-events/metric.py b/tools/perf/pmu-events/metric.py
index 92acd89ed97aa..ac322891c4f1b 100644
--- a/tools/perf/pmu-events/metric.py
+++ b/tools/perf/pmu-events/metric.py
@@ -445,7 +445,11 @@ class Metric:
 
   def __lt__(self, other):
     """Sort order."""
-    return self.name < other.name
+    if self.name != other.name:
+      return self.name < other.name
+    if not self.expr.Equals(other.expr):
+      return self.expr.ToPerfJson() < other.expr.ToPerfJson()
+    return self.description < other.description
 
   def AddToMetricGroup(self, group):
     """Callback used when being added to a MetricGroup."""
-- 
2.53.0



