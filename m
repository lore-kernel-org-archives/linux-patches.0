Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458231ABEA5;
	Mon, 14 Oct 2024 14:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916711; cv=none; b=GEpb3eLjxSnVTzkvWgIynmUj8KpeMz1kJ/84G+glgRJk88U4TGKiY8r7Fq6vL+I/6Ip87/zd954GwdyHaTC3wJX82WeEdU6xRVu7dFiXPP7X5o1xnU345bEdiaCzyy25dIwbYIFhgVgSkJ/whc9wthNnta7Q+70c07hCHHcYHIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916711; c=relaxed/simple;
	bh=e8LfM5Q5GqKOQiF6f6KWSJk5a2O5iDxciUgeuqe1NLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLA945LNIVjZfXQZUgw+dIrYFbBzoNbVlkX0K2ywhumEGCEIqhFniYTe3YcAldj4vlTRJFpgma5MwBKTnlOH25rw73owYuB5BDy7jm8n0cAz0zpnXefjWSb5zG1jzxBpDyjVNxrMkZMBldHpWUTDYKNiToOwMfJWb2qCnI1r38Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQSPbeEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQSPbeEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB101C4CEC3;
	Mon, 14 Oct 2024 14:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916711;
	bh=e8LfM5Q5GqKOQiF6f6KWSJk5a2O5iDxciUgeuqe1NLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQSPbeEH0IeTedJfgoOGOdD+++halmmg4ZxrczQXjLWOGpLQU0EoPIg2pkfQkTPv/
	 IKubpHC621DMte6I+YKJAWE6eJ6x0bUHxAFy77Z+edR6eUrASy2WIKKu4YI3Fh4qw+
	 JDXLEKuM27VAkHiIzD4f4yYm5cjV0aqGLVe8nAKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/213] perf sched: Fix memory leak in perf_sched__map()
Date: Mon, 14 Oct 2024 16:19:03 +0200
Message-ID: <20241014141044.438882977@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d36b06d4d877..8143828fdc585 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3252,8 +3252,6 @@ static int perf_sched__lat(struct perf_sched *sched)
 
 static int setup_map_cpus(struct perf_sched *sched)
 {
-	struct perf_cpu_map *map;
-
 	sched->max_cpu.cpu  = sysconf(_SC_NPROCESSORS_CONF);
 
 	if (sched->map.comp) {
@@ -3262,16 +3260,15 @@ static int setup_map_cpus(struct perf_sched *sched)
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
 
@@ -3311,20 +3308,34 @@ static int setup_color_cpus(struct perf_sched *sched)
 
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



