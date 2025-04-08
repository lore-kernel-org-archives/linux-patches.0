Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B122686BC;
	Tue,  8 Apr 2025 12:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116586; cv=none; b=t49oRTJjkO0giUWJ9J08z6avuHNqOg+eyz6QKesf/eX9LQxldtB2v4hgvqhEd7zU4VYr6zAdD0JtU4eGlp0k6Go5He3aGgNpFuHirpf2XMWHjEknuAhFdVnFChDdVui/DqGDF796EheEURI76l2vGbpaT7lJd9XOdUHDLbuCBKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116586; c=relaxed/simple;
	bh=HoLeRRum2yyKMPeDprDytTuTtEdXJfYUdrSadoPuZI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSzleTig8dUjiKcKWivrLMQGSYyjpX/6pD6CbBGgmVVi2zxWMYsZv3em/m5pHNW9ZVHk0OvsKILtDkFU84lLk6JMjS0WvfNlMkOP6iqs+zv/YGdGFtfL7g3KYVmhyAa638wUISsKqcr26NBTsLkHS8JZqbaG9A0o9mc3TeTjLRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APNkPzye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APNkPzye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CD4C4CEE5;
	Tue,  8 Apr 2025 12:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116586;
	bh=HoLeRRum2yyKMPeDprDytTuTtEdXJfYUdrSadoPuZI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APNkPzyepc4/Gezyy06mTfUMXRjTq/BcfoosIS1TmIHrH+ZIj+uHrHeyjP4oKSYk9
	 XVcZ+VdcH9SF0JyWI/s/yaFTVz/+OKKmWoSL8Z4RvjskUv1dTKtN9/8Rc3ajnLnVZs
	 gFBiUkEAB/Sez/lhfcKK6CYcbf9G5X9B+GXPjqRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/423] perf evlist: Add success path to evlist__create_syswide_maps
Date: Tue,  8 Apr 2025 12:48:40 +0200
Message-ID: <20250408104850.254643406@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit fe0ce8a9d85a48642880c9b78944cb0d23e779c5 ]

Over various refactorings evlist__create_syswide_maps has been made to
only ever return with -ENOMEM. Fix this so that when
perf_evlist__set_maps is successfully called, 0 is returned.

Reviewed-by: Howard Chu <howardchu95@gmail.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250228222308.626803-3-irogers@google.com
Fixes: 8c0498b6891d7ca5 ("perf evlist: Fix create_syswide_maps() not propagating maps")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evlist.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a9df84692d4a8..dac87dccaaaa5 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1434,19 +1434,18 @@ static int evlist__create_syswide_maps(struct evlist *evlist)
 	 */
 	cpus = perf_cpu_map__new_online_cpus();
 	if (!cpus)
-		goto out;
+		return -ENOMEM;
 
 	threads = perf_thread_map__new_dummy();
-	if (!threads)
-		goto out_put;
+	if (!threads) {
+		perf_cpu_map__put(cpus);
+		return -ENOMEM;
+	}
 
 	perf_evlist__set_maps(&evlist->core, cpus, threads);
-
 	perf_thread_map__put(threads);
-out_put:
 	perf_cpu_map__put(cpus);
-out:
-	return -ENOMEM;
+	return 0;
 }
 
 int evlist__open(struct evlist *evlist)
-- 
2.39.5



