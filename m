Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A428F43079F;
	Tue, 21 Jul 2026 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662587; cv=none; b=gINHX2mv8IPlJJA1PTmtoJSf9mWdzNIGHhHHKr8xzY/9fVRzswkDj771NUN2+Uue53aqzINkfDgYGh6pZUmcKFswvCUgR1vLXxCKhvSkIa1XrjSJqAcl/lbLpqR3t2VkWcqXryOk8rOtrxad3KukJ3PhQZjDMtYBT8UW9EMerfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662587; c=relaxed/simple;
	bh=HaVLFfW/jjA4XQFk5XX7mqBWG3JsU6Fjj0w8HzS8/4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6XrbDdXibPqNJf7To8CVrjkzB+DBXfH/5vgW+HH1reLszg3FKb13Aekw8RVXPjIh7cY1BE96149M81SXkCRlZyouoC4Sel4KjWUqaldrxaQLste8FlfQv1mBXNkpDmGHeLMA3ZspiBs5CBxRZpdLKJNCMsvo0qY30o+JQOLvOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxW2zn1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxW2zn1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7791F000E9;
	Tue, 21 Jul 2026 19:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662586;
	bh=cB+oVKHwG1xPLLPcBkzPaCxdzMnT6oY66yY/vRtIw7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxW2zn1/AJBFQg+pl+dVbp5z9AH0HY8dZA9WGMYcJRWIQ8jqMyuTJ3xlSW2No/1BZ
	 vdshj3bIHwNoOytKQw1ygdrjSu2eZ6O0wsTAACWBfLRMcmclxUX9yMbUdz4auy0qau
	 a3nDMU4e4WHz9mYu1f5QpXR+LNvICmVd8c1HESQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0499/1276] perf tools: Use perf_env__get_cpu_topology() in machine__resolve()
Date: Tue, 21 Jul 2026 17:15:42 +0200
Message-ID: <20260721152457.271289003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 5484b43a0ec8231c36fba6ead654cb72dbba8b8f ]

machine__resolve() accesses env->cpu[al->cpu].socket_id after checking
al->cpu >= 0 and env->cpu != NULL, but without validating al->cpu
against env->nr_cpus_avail.  Since al->cpu comes from the untrusted
perf.data sample, a crafted file with a large CPU index causes an
out-of-bounds heap read.

Use perf_env__get_cpu_topology() which validates both NULL and bounds.
Also bounds-check al->cpu before the cast to struct perf_cpu (int16_t):
without this, values like 65536 silently truncate to 0, bypassing the
accessor's internal check and returning CPU 0's topology.

Fixes: 0c4c4debb0adda4c ("perf tools: Add processor socket info to hist_entry and addr_location")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/event.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index aac96d5d191700..1e5085817e8250 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -12,6 +12,7 @@
 #include <linux/zalloc.h>
 #include "cpumap.h"
 #include "dso.h"
+#include "env.h"
 #include "event.h"
 #include "debug.h"
 #include "hist.h"
@@ -763,8 +764,18 @@ int machine__resolve(struct machine *machine, struct addr_location *al,
 	if (al->cpu >= 0) {
 		struct perf_env *env = machine->env;
 
-		if (env && env->cpu)
-			al->socket = env->cpu[al->cpu].socket_id;
+		/*
+		 * Bounds-check al->cpu (s32) before casting to struct perf_cpu
+		 * (int16_t): without this, e.g. 65536 truncates to 0 and silently
+		 * returns CPU 0's topology.  Can go once perf_cpu.cpu is widened.
+		 */
+		if (env && al->cpu < env->nr_cpus_avail) {
+			struct cpu_topology_map *topo;
+
+			topo = perf_env__get_cpu_topology(env, (struct perf_cpu){ al->cpu });
+			if (topo)
+				al->socket = topo->socket_id;
+		}
 	}
 
 	if (al->map) {
-- 
2.53.0



