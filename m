Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBDA47125C;
	Tue, 21 Jul 2026 18:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657246; cv=none; b=edlnGAPnUZJOEF/0h9+lLTcH62+lW8cuXExjVQ5TmIjC64+P5hSFHG2qSktNv8VEX1KuYPjwnc0df8FMbxQsZ1+FJTS+1pCceHYVBW9xunb86QkRFrixU+dXgrumzwxvG4T82PcAzs8k4x1ViXcl/SQ7//5rQ7wf989Co//YNQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657246; c=relaxed/simple;
	bh=gv2fYR2sx5rOlR/ZDXe7FwxVR6whx6Z3aS3HPGHjOr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yf5SBtue2UczzfgBwD/JnwsNh2oM4HPwyip5UDAYXGse9Q2K7U57/q6Zi6lsKkpmo8FGBV3Y/InX0n2kj6Qucqo+SF+WlTB5YF4rpZRq39KtwsUSASLuMd1vez40hYjbzMhV5JWCjsDrxmhwQB3IZzIUxF1FJa2b/W4/eY/cWb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0NTLMUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0NTLMUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7135C1F000E9;
	Tue, 21 Jul 2026 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657244;
	bh=DLZS5Ipvc7DtLv1m0+E0ah1yAf58tnFtUpjLPdMER+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0NTLMUErQR6hHbzePJQk+kWN3LCgkhqKz6vLhHnyozJCZTTHtEkG0zIYIhSsAFQJ
	 MY3APA836ht7MK8qDFosAxJ0T0giPbhfM4P+npgr8337BeTq2leMALrGeblworYgCZ
	 3FiTGehv5XP2kutZuGcBkovg2VZKPF4NYoVcmuPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0690/1611] perf tools: Use perf_env__get_cpu_topology() in machine__resolve()
Date: Tue, 21 Jul 2026 17:13:26 +0200
Message-ID: <20260721152530.900714603@linuxfoundation.org>
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
index fcf44149feb20c..f3c331c7024728 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -15,6 +15,7 @@
 #include <linux/zalloc.h>
 #include "cpumap.h"
 #include "dso.h"
+#include "env.h"
 #include "event.h"
 #include "debug.h"
 #include "hist.h"
@@ -786,8 +787,18 @@ int machine__resolve(struct machine *machine, struct addr_location *al,
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
 
 	/* Account for possible out-of-order switch events. */
-- 
2.53.0



