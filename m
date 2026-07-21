Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AE622B8DF;
	Tue, 21 Jul 2026 18:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660312; cv=none; b=enz5oJIKvRVNo25kkQBIHDALFieBj0Jnx/VInVfsDvhdFV2vsHItpA48knX7p0pRfPl/euAxoEUVNc4VDBHmevVyyOy3QkmGmNi/0w4VQbp/oYZ5j1jOJAs2oQ1nA/2lZTFAUCBiaoiDCxE+HyTKyzmZYqj7gMWjb0RbQFZhViI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660312; c=relaxed/simple;
	bh=jKRhPa8PjKPMO+jfcw7eN1d5vygtDPxW0aXqHRlc2nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G5gXknUoG39zIC4b//ShLzGIh+pMiJxRoFNk3NVY235M3jNrFjugOEgXGPYxO2l5zVmsROX5fWLa9GdZRJaLmnYKRdO8fsIUaVnL3VWppJUHFMZztZeB91UuPdd7kUdRihnV5VbX3zWXzdVbGQGDYv/0FJpGjbmPw5i+eXhmoDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6oNEh0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6oNEh0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991CF1F00A3A;
	Tue, 21 Jul 2026 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660311;
	bh=OS2OJ+agxnwuvj6jvcT3+/AIehPHH8FFz1bMVxBnvYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6oNEh0a79LSfn0HGsjkXhpMhPTGmdMPVtxh3CCGRItcbVz0mdxlseMumZKXdGel7
	 YF+64cZ2F4p2Wq9McUJYsSV5ftk1lyvElYXEDRIKmYheEwSSc2bHR8iaUQZ8u4g1P9
	 djYkzE9iYFsgoYKcDKHLA/0puv8fXGHChYPphkMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0933/2077] perf sched: Fix comp_cpus heap overflow with cross-machine recordings
Date: Tue, 21 Jul 2026 17:10:06 +0200
Message-ID: <20260721152614.824009354@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit c8b04142078a9ccb9e402ab7c38de7123256f4a5 ]

setup_map_cpus() allocates comp_cpus based on
sysconf(_SC_NPROCESSORS_CONF), the host machine's CPU count.  But
map_switch_event() indexes comp_cpus using cpus_nr derived from
bitmap_weight(comp_cpus_mask, MAX_CPUS), where comp_cpus_mask is
declared as DECLARE_BITMAP(..., MAX_CPUS) with MAX_CPUS=4096.

When analyzing a perf.data recording from a machine with more CPUs
than the analysis host (e.g. 128-CPU server recording analyzed on an
8-CPU laptop), cpus_nr exceeds the allocation size, causing a heap
buffer overflow.

Also fix a type mismatch: comp_cpus is 'struct perf_cpu *' (2 bytes
per element) but was allocated with sizeof(int) (4 bytes per element).

Allocate comp_cpus with MAX_CPUS entries using the correct element
size, matching the comp_cpus_mask bitmap bounds.  Remove the
sysconf(_SC_NPROCESSORS_CONF) initialization of max_cpu — its only
consumer was the comp_cpus allocation, and max_cpu is dynamically
updated from the recording's events during processing.  Fix the
non-compact path to use max_cpu.cpu + 1 as cpus_nr, converting from
0-based index to count — sysconf() returned a count which masked
this off-by-one.

Fixes: 99623c628f54 ("perf sched: Add compact display option")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 13d9a15a553ec9..6f5d5f3ce715c7 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1677,7 +1677,7 @@ static int map_switch_event(struct perf_sched *sched, struct evsel *evsel,
 			new_cpu = true;
 		}
 	} else
-		cpus_nr = sched->max_cpu.cpu;
+		cpus_nr = sched->max_cpu.cpu + 1;
 
 	timestamp0 = sched->cpu_last_switched[this_cpu.cpu];
 	sched->cpu_last_switched[this_cpu.cpu] = timestamp;
@@ -3577,10 +3577,8 @@ static int perf_sched__lat(struct perf_sched *sched)
 
 static int setup_map_cpus(struct perf_sched *sched)
 {
-	sched->max_cpu.cpu  = sysconf(_SC_NPROCESSORS_CONF);
-
 	if (sched->map.comp) {
-		sched->map.comp_cpus = calloc(sched->max_cpu.cpu, sizeof(int));
+		sched->map.comp_cpus = calloc(MAX_CPUS, sizeof(*sched->map.comp_cpus));
 		if (!sched->map.comp_cpus)
 			return -1;
 	}
-- 
2.53.0



