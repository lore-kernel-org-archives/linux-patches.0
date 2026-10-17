Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B4F3939A4;
	Sat, 17 Oct 2026 17:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259647; cv=none; b=H44yIkMCH/dH0Deafr8KX7a2ZRG9Mmc9QcFyHHYUxxCu6KoZDmWtMlnWob1mg5as/4kMn3urS17w3jbfvKf8Np22Tap5PGmWSiNSeG5dSOSH4sSRrcfdOp6yCcGOYhqbyJjcO6kEYMHBXsn3g0hWs/kDd/p57O6ngQVfTJGOIBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259647; c=relaxed/simple;
	bh=dwzUIxposYONLfDfAv7d/pSevZOpPZMCUqIZDOoLiUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOTgXaa+Lz3ncCFvWnZ9hx0uay79Xf9q39PNg4U4gT4TsAnDZtwwOowjEPbxxgU1g9/IH0EV8gHO5UGKCYZ9sCmZIOLNp7AXnXRGEhNoCSq0rmoYwvIlY+q8EdyTmplXf3CZN9bPQ+8JUB9eMnIJv7NG+EmuYQ5D/KLkbf7B6eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1qHVtGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1qHVtGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E881F000C4;
	Sat, 17 Oct 2026 17:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259646;
	bh=5WuSQzHihPdFR98T3MXdX9eVDWr3hhJKpDWMliGn2qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1qHVtGdn1FuvT0SB3mp515hgRnwcpxNnFBgQvNQhxmiwl7mHRnEm6t7Iwjva/XLF
	 qOxek2gc1IFFOc3SY/X+trzHUc9TZdUETg+bh5bellMLvG24x/eTXPJqMdwniIREsT
	 /f4Is9+eLk5BrTezxuT7ClRMGkVZgl7PmYXVVUhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1232/1674] perf tools: Use perf_env__get_cpu_topology() in machine__resolve()
Date: Sat, 17 Oct 2026 17:58:24 +0200
Message-ID: <20261017160502.761916184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 68f45e9e63b6e..b118766c16e65 100644
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
@@ -743,8 +744,18 @@ int machine__resolve(struct machine *machine, struct addr_location *al,
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



