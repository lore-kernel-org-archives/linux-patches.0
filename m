Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC64635C6AC;
	Tue, 21 Jul 2026 22:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673825; cv=none; b=XH6dNnqqvmQm75f5+aNW0BZwkkd0IAZX1O1xoAhNcuPjiZpDzGKBicEfhax39PhzCT1Tj/lqQ7ffzBu8oTeOYVN9hU7+F3Ak1SRbt9NRGguNOM5K59jKpWCl5enxPJzrYZXlsgIt48HGuyHBOmWArtjQp7L0JYmnVJUFKXJMnWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673825; c=relaxed/simple;
	bh=sIETCdCkUBU8sdRijIaVdh2FIuPGTIbgjYhYYhcuujU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMt79VHrQ+gxnKKVy0uT7UtLvsxhsP6kcz3iGli2IAoyRgByvNd2AE8QAZZux8a3+wtO0YI8PHqE51JwBoTA/h5iQVVrG6kOJlFTRDndO+eVDoKze3AteJOI+HgqrCWcsMGOikxtZrbVZguqSD5Uq+h+eeMucnUNIgeT1Leatkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAhv2R5r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAhv2R5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1311F000E9;
	Tue, 21 Jul 2026 22:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673824;
	bh=V7ACwZBvhWxs8hhtjipYlEOk/OZ/WBfel2KjB2+pXug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iAhv2R5rhnlUl8IvMCwr9QiUUXszuo1AOEv/Zeghg6Fu1PcMrc1j+SaFsQ96WiRHa
	 eng2e9vpHOjFdKfNeC2zT8bG1hsklUxOGQmF9tA34w531nHEOIHD3N2Ugv9uXpoOU7
	 oo/sIvael5OZAuMXW2w7EcBjsOrELi0qVE3Zosc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/699] perf tools: Use perf_env__get_cpu_topology() in machine__resolve()
Date: Tue, 21 Jul 2026 17:21:06 +0200
Message-ID: <20260721152402.620720384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7e440fa90c9383..50de291e528518 100644
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
@@ -656,8 +657,18 @@ int machine__resolve(struct machine *machine, struct addr_location *al,
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



