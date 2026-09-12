Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1405B343893;
	Sat, 12 Sep 2026 07:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199000; cv=none; b=ZgRDCwlmaG0neEwDvY/wJ0k7ctv9u7FF7Bvyj/A8Y7w9eM4Xuqqi+Ib6t9SDYYDjVc5Fh2ziO6evCNdVdkZg1GOx3i2BsZaiuPhiPc8bQ/DWdthTQc8ePHf0CfPQn6vvwd6IHQ5hx2r4jRwKps9bknODTiHpIkFZJWrGXJ4/op0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199000; c=relaxed/simple;
	bh=yd09Tb7S06/ipVTSSvbcObyPk9FkbmXqE7bhoZvk4eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLD9Rf2JxZ7oXleZ94snNlsqaouBP1/wfiqM3zNrgh1WWAViV6A97JrhKuJJiEreSl/XWQtMAl/tsjRrkApUnTid1qcWqynRCK35jelq9eaWQD33i/Oz2z9b5+ckrH+ETSerNcSDG2TkYVyQTWt7DLRpgZ7oQe/9q7P8pw6UjCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SwOcFUw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SwOcFUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03CC1F000FF;
	Sat, 12 Sep 2026 07:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198999;
	bh=0RSdg+NihTl1KlGbFX0yb9pMg3gOMfiRjr81JBKK9HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SwOcFUwVdx6xn8XMyHtYF61O6wqCDvcCS9J2ZF/mtXw82ckWmWgLllvTz+RcDtGZ
	 1m7xJqzts8prkOpZ21ChmP5CPx9eBxH/leUzvKXMILnaExvR7I0AXzfwli3hyfFLLS
	 XPCNS/uPSB8240dv2se585DrUazZi89kLQqwCxOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nazar Kazakov <nazar.kazakov@codethink.co.uk>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0458/1815] perf jevents: Add more components to the metric sorting order
Date: Sat, 12 Sep 2026 08:36:48 +0200
Message-ID: <20260912065659.640742153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 376dc2d241621..3c6cfeefbd5dc 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -570,13 +570,14 @@ static const struct pmu_table_entry {_pending_events_tblname}[] = {{
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
index a91ccb5977f08..11c7162825f4b 100644
--- a/tools/perf/pmu-events/metric.py
+++ b/tools/perf/pmu-events/metric.py
@@ -623,7 +623,11 @@ class Metric:
 
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



