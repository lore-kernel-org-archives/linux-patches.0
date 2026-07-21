Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC0446C4DD;
	Tue, 21 Jul 2026 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657128; cv=none; b=AcQP8ZMqfLYhOi0hu/WMGia6uW9xPziCvBdZ8Eu319WmfRSaXRoMrtav/yyF4nWl7zrCK4zm5a73O2+2bMjcAab7uVAYbsILgMP4CdzTT8aMLKkbsgO8a7DBBGxuYLoP1onrCNz9QrYcywQKH8adw2NAeQlST5loLGs9MFwubM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657128; c=relaxed/simple;
	bh=k5zTy9IUpMH+QLOIjD/Ibxc837A1lH8xLu7fFqGCicE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0SDewsdpMMDRROlaVVVoSDOH/0uQ1q0CMs/BXeu9fsHyqLi0ZHEwrxlFyYK9oEooArBcumCIfN5FyPZ064aI8f/n6Pbcjrkm/8kIXkwSpOeJ5CKJYt75fbtLvyy2ojWfOnSGphAjG2MEq9dvntEw1RZekQ4mInio9X8umQGX/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYU1kTQ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYU1kTQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CDA1F000E9;
	Tue, 21 Jul 2026 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657126;
	bh=woO0/Uy9SVNe8st+G6+zU30XibhMn0xK3YL0aKXMwv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYU1kTQ8VMQqwxukPkpcy+P9BNeV1cSEHdhSeSFpgkm22uNqbuqnIZ2IBu6ZC2eq6
	 kXtBR6Fp90jhLGdWUMCzgVeJQmJHzMLA5r7TS+LKES7BlBrZXeKNjRbRBo2nG4zrBC
	 tdIcwXYvMt6E6ksI+8RGhT9c9fpjLq3cYOcnCVyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0645/1611] perf c2c: Bounds-check CPU and node IDs before bitmap and array access
Date: Tue, 21 Jul 2026 17:12:41 +0200
Message-ID: <20260721152529.899736331@linuxfoundation.org>
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

[ Upstream commit 65117c3da50f749f4c22eb7a7effc53453dff57f ]

c2c_he__set_cpu() passes sample->cpu directly to __set_bit(cpu, cpuset)
after only checking for the (u32)-1 sentinel.  The cpuset bitmap is
allocated with c2c.cpus_cnt bits (from env->nr_cpus_avail), so a crafted
perf.data with CPU IDs exceeding that count causes out-of-bounds heap
writes.

c2c_he__set_node() similarly passes the node ID from mem2node__node()
to __set_bit(node, nodeset) after only checking for negative values.
The nodeset bitmap is sized to c2c.nodes_cnt (from env->nr_numa_nodes),
so a node ID exceeding that causes OOB writes.

process_sample_event() indexes c2c.cpu2node[cpu] and
c2c_he->node_stats[node] without bounds checking.  Both arrays are
sized to c2c.cpus_cnt and c2c.nodes_cnt respectively.

Add bounds checks in all three paths:
  - c2c_he__set_cpu(): return if sample->cpu >= c2c.cpus_cnt
  - c2c_he__set_node(): return if node >= c2c.nodes_cnt
  - process_sample_event(): clamp cpu to 0 if >= cpus_cnt,
    guard node_stats access with bounds check

Fixes: 1e181b92a2da ("perf c2c report: Add 'node' sort key")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 9e9ff471ddd16e..f67645aa8c1e4a 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -232,6 +232,10 @@ static void c2c_he__set_cpu(struct c2c_hist_entry *c2c_he,
 		      "WARNING: no sample cpu value"))
 		return;
 
+	/* cpuset bitmap has c2c.cpus_cnt bits from env->nr_cpus_avail */
+	if (sample->cpu >= (unsigned int)c2c.cpus_cnt)
+		return;
+
 	__set_bit(sample->cpu, c2c_he->cpuset);
 }
 
@@ -249,6 +253,10 @@ static void c2c_he__set_node(struct c2c_hist_entry *c2c_he,
 	if (WARN_ONCE(node < 0, "WARNING: failed to find node\n"))
 		return;
 
+	/* nodeset bitmap has c2c.nodes_cnt bits from env->nr_numa_nodes */
+	if (node >= c2c.nodes_cnt)
+		return;
+
 	__set_bit(node, c2c_he->nodeset);
 
 	if (c2c_he->paddr != sample->phys_addr) {
@@ -348,7 +356,12 @@ static int process_sample_event(const struct perf_tool *tool __maybe_unused,
 		 * Doing node stats only for single callchain data.
 		 */
 		int cpu = sample->cpu == (unsigned int) -1 ? 0 : sample->cpu;
-		int node = c2c.cpu2node[cpu];
+		int node;
+
+		/* cpu2node[] has c2c.cpus_cnt entries; large u32 wraps signed negative */
+		if (cpu < 0 || cpu >= c2c.cpus_cnt)
+			cpu = 0;
+		node = c2c.cpu2node[cpu];
 
 		mi = mi_dup;
 
@@ -365,7 +378,9 @@ static int process_sample_event(const struct perf_tool *tool __maybe_unused,
 		c2c_he = container_of(he, struct c2c_hist_entry, he);
 		c2c_add_stats(&c2c_he->stats, &stats);
 		c2c_add_stats(&c2c_hists->stats, &stats);
-		c2c_add_stats(&c2c_he->node_stats[node], &stats);
+		/* node_stats[] has c2c.nodes_cnt entries */
+		if (node >= 0 && node < c2c.nodes_cnt)
+			c2c_add_stats(&c2c_he->node_stats[node], &stats);
 
 		compute_stats(c2c_he, &stats, sample->weight);
 
-- 
2.53.0



