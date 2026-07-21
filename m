Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BAB415F1A;
	Tue, 21 Jul 2026 18:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660365; cv=none; b=ki2gSyOiU+DLg6HaoPJEoobcNI4TS1m2WYj9pZ4a8GDQ7oTRqBa+HB/0nPtJsCPVXiiv615UCbnX+8jQ2SNWf7a+ZViU5MRXkt9wNm0/kNZhICy9huYaM1n6Gp7KnH+GwTt+36hdWoM56SMQ7tq0wptWpFNzP7yTvLQK+tVLmAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660365; c=relaxed/simple;
	bh=3diuGa4J70GYaOv32kwMsyIIrVeLLgNtK9ahnECaN4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTISO/xSkNoa5cKu/ffiPRA+JVb2u87FZKR6gwa1uTmxfsZJVLlNIry84dtcIXHEpYQYDCXfRJlMsCu+on0sApRVd9P81KDj0lWwpt72bmAhDqCddeCthsDuaOE4n+0x/gdxB1hfo+src8VZHa6GqWRMOhAFeLkFEAOgelJKbjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vz4FwvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vz4FwvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1DB1F000E9;
	Tue, 21 Jul 2026 18:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660364;
	bh=SnZC/pfe5Gnyg82eji5+ig3NKZWladba7v1vuCqtHyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vz4FwvCi6oIScdvD0PfIxfNi52Dy7LqrVCcZ/bqTGXP3iikOC58yWNkzkSIif3Ca
	 w/iwL1GVqfkiZBrW34/QXdYRnwleXG4AS99keHsNgiArVjrCVmOKPqhNGXmcodlv3I
	 xEEqlAPiNIt6QXyplcxgbtEuLU0eId+Xhun+/OGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Stanislav Fomichev <stfomichev@yandex-team.ru>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0951/2077] perf timechart: Fix cpu2y() OOB read on untrusted CPU index
Date: Tue, 21 Jul 2026 17:10:24 +0200
Message-ID: <20260721152615.248529373@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit e2496db45bfd8dfb6154ec415798fee330f1cc0a ]

cpu2y() indexes topology_map[cpu] without bounds checking.  The array
is allocated with nr_cpus entries (from env->nr_cpus_online), but
callers pass sample CPU values from perf.data which can exceed that
size with cross-machine recordings.

Track the topology_map allocation size and bounds-check the CPU
argument in cpu2y() before indexing.  Out-of-bounds CPUs fall back
to the identity mapping (cpu2slot(cpu)), which is the same behavior
as when no topology is available.

Fixes: c507999790438cde ("perf timechart: Add support for topology")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/svghelper.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index e360e7736c7ba6..826bd2577344b2 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -47,13 +47,13 @@ static double cpu2slot(int cpu)
 }
 
 static int *topology_map;
+static int topology_map_size;
 
 static double cpu2y(int cpu)
 {
-	if (topology_map)
+	if (topology_map && cpu >= 0 && cpu < topology_map_size)
 		return cpu2slot(topology_map[cpu]) * SLOT_MULT;
-	else
-		return cpu2slot(cpu) * SLOT_MULT;
+	return cpu2slot(cpu) * SLOT_MULT;
 }
 
 static double time2pixels(u64 __time)
@@ -736,7 +736,8 @@ static int str_to_bitmap(char *s, cpumask_t *b, int nr_cpus)
 		return -1;
 
 	perf_cpu_map__for_each_cpu(cpu, idx, map) {
-		if (cpu.cpu >= nr_cpus) {
+		/* perf_cpu_map__new("") returns cpu.cpu == -1 */
+		if (cpu.cpu < 0 || cpu.cpu >= nr_cpus) {
 			ret = -1;
 			break;
 		}
@@ -794,6 +795,7 @@ int svg_build_topology_map(struct perf_env *env)
 		fprintf(stderr, "topology: no memory\n");
 		goto exit;
 	}
+	topology_map_size = nr_cpus;
 
 	for (i = 0; i < nr_cpus; i++)
 		topology_map[i] = -1;
-- 
2.53.0



