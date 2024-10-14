Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C51E1CC16F;
	Mon, 14 Oct 2024 15:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919672; cv=none; b=O2rQ5oWRRSxqVv7YVCNEf9n7L63KhmiqHkTioWOq+Ox6TJ1N6esBZBsGCqFhWWHW0KcpHxw0mcja/kBcV953aSnD0eh7VAOpY6CYeCB59qFouHGJ4Wir8lEfbcCZyv9TE0cU3W5OSD1s8b5ZgUKpWTg4GRCELZSEzGpXp4ucO3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919672; c=relaxed/simple;
	bh=Lctxc1ae2l1tiTCgHV9XcDmynfQ1dPmyOTbq7h6p4UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxzwhVYuhTqubXMt6mVUZKii1UfPYQnfCSnP1+I1pX9qU87wZc6t7Q0PWHIjgOtYMu7RT3+udyNSePoNRykWieOj2nYB83G0ahcwdJfKY8+4uuWzXhOInHkO7VBYNNos65eZIl+TDdEbef1xz44yHPl5ocvePEypNWysQOeXN7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHv0ZE7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHv0ZE7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3143C4CEC3;
	Mon, 14 Oct 2024 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919672;
	bh=Lctxc1ae2l1tiTCgHV9XcDmynfQ1dPmyOTbq7h6p4UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHv0ZE7/ZAE2JqDc8zON/vIHEmyzejzSWTmo25YIIme+/2nRLw1M5hPAk+lLy+Ngf
	 mvlwSFK6VVoeodQ2t+FkbATrEOPXe9DmRL3oX6SNK/zI67b6FH8yLdGSSbgkgMyjop
	 ZTbxs5uLwOmhDuB4waK2Wh6yYTVPiq0IOR/Lg8WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 675/798] perf sched: Fix memory leak in perf_sched__map()
Date: Mon, 14 Oct 2024 16:20:29 +0200
Message-ID: <20241014141244.585339845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit ef76a5af819743d405674f6de5d0e63320ac653e ]

perf_sched__map() needs to free memory of map_cpus, color_pids and
color_cpus in normal path and rollback allocated memory in error path.

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240206083228.172607-3-yangjihong1@huawei.com
Stable-dep-of: 1a5efc9e13f3 ("libsubcmd: Don't free the usage string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 41 ++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2d595dde2d121..8abd48a99ec5e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3240,8 +3240,6 @@ static int perf_sched__lat(struct perf_sched *sched)
 
 static int setup_map_cpus(struct perf_sched *sched)
 {
-	struct perf_cpu_map *map;
-
 	sched->max_cpu.cpu  = sysconf(_SC_NPROCESSORS_CONF);
 
 	if (sched->map.comp) {
@@ -3250,16 +3248,15 @@ static int setup_map_cpus(struct perf_sched *sched)
 			return -1;
 	}
 
-	if (!sched->map.cpus_str)
-		return 0;
-
-	map = perf_cpu_map__new(sched->map.cpus_str);
-	if (!map) {
-		pr_err("failed to get cpus map from %s\n", sched->map.cpus_str);
-		return -1;
+	if (sched->map.cpus_str) {
+		sched->map.cpus = perf_cpu_map__new(sched->map.cpus_str);
+		if (!sched->map.cpus) {
+			pr_err("failed to get cpus map from %s\n", sched->map.cpus_str);
+			zfree(&sched->map.comp_cpus);
+			return -1;
+		}
 	}
 
-	sched->map.cpus = map;
 	return 0;
 }
 
@@ -3299,20 +3296,34 @@ static int setup_color_cpus(struct perf_sched *sched)
 
 static int perf_sched__map(struct perf_sched *sched)
 {
+	int rc = -1;
+
 	if (setup_map_cpus(sched))
-		return -1;
+		return rc;
 
 	if (setup_color_pids(sched))
-		return -1;
+		goto out_put_map_cpus;
 
 	if (setup_color_cpus(sched))
-		return -1;
+		goto out_put_color_pids;
 
 	setup_pager();
 	if (perf_sched__read_events(sched))
-		return -1;
+		goto out_put_color_cpus;
+
+	rc = 0;
 	print_bad_events(sched);
-	return 0;
+
+out_put_color_cpus:
+	perf_cpu_map__put(sched->map.color_cpus);
+
+out_put_color_pids:
+	perf_thread_map__put(sched->map.color_pids);
+
+out_put_map_cpus:
+	zfree(&sched->map.comp_cpus);
+	perf_cpu_map__put(sched->map.cpus);
+	return rc;
 }
 
 static int perf_sched__replay(struct perf_sched *sched)
-- 
2.43.0



