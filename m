Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A934302F8;
	Tue, 21 Jul 2026 19:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662518; cv=none; b=PVmcxTZJ+Dk9ZH1a0HZNZck5LtV08Z5z9gx7EEvrFUKNtLG3gOCdKI9t8g8OgjcJeZYN/lTWAEHyWglgek+lWJv0P9IxaHWZaCS9x/Tm6Jd4YdjHIvvm5bnyTDQmWA/vMH1sVw26Rd4LIDsp8a09yoJesIZArqga6hiOpG+xzY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662518; c=relaxed/simple;
	bh=aizgJQxU+NILWO2/o1QXiQ5sJOug+qwdqIDpGXwsawY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWMgFlrMMLypIq3zXH9Cfoz5LgK2J1yxtHxpgDy8kS0GLBxCvSvJ8MV36+MxLbgR9LcoqY083XgP0qpVFDxSgte2pZdMQR8L86HgRIMVHQ3he7bLlmqQ/R2fn/mDlh8MnCTK3d2APCLVjcdUn9iklsZta465CK2qX0kGe8wOq4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+wWOOjP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+wWOOjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218C31F00A3D;
	Tue, 21 Jul 2026 19:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662517;
	bh=hqHu2z92Nsux7c6FrmM7TjCqZ+H8508evSJkkC8br00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+wWOOjPjscFt9PJjwInQ/lPOql/HXVEILTSTBI/pRcgx47c4wob3ONBRQpFTia8n
	 QJXd0kaw7jyt7L0mvKqYUipXDUNZNIKMdxXehIigPNbDL7ux9DDUYrKBP0WwalQkXf
	 x22jGE1WSGffax34LPqNNLJJay4y8NidnXs4E7f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Stanislav Fomichev <stfomichev@yandex-team.ru>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0476/1276] perf timechart: Fix cpu2y() OOB read on untrusted CPU index
Date: Tue, 21 Jul 2026 17:15:19 +0200
Message-ID: <20260721152456.755182446@linuxfoundation.org>
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
index 2b04f47f4db0f0..d553a40f2c6add 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -46,13 +46,13 @@ static double cpu2slot(int cpu)
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
@@ -734,7 +734,8 @@ static int str_to_bitmap(char *s, cpumask_t *b, int nr_cpus)
 		return -1;
 
 	perf_cpu_map__for_each_cpu(cpu, idx, map) {
-		if (cpu.cpu >= nr_cpus) {
+		/* perf_cpu_map__new("") returns cpu.cpu == -1 */
+		if (cpu.cpu < 0 || cpu.cpu >= nr_cpus) {
 			ret = -1;
 			break;
 		}
@@ -792,6 +793,7 @@ int svg_build_topology_map(struct perf_env *env)
 		fprintf(stderr, "topology: no memory\n");
 		goto exit;
 	}
+	topology_map_size = nr_cpus;
 
 	for (i = 0; i < nr_cpus; i++)
 		topology_map[i] = -1;
-- 
2.53.0



