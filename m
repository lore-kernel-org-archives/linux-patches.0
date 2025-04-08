Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C81D267F68;
	Tue,  8 Apr 2025 11:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113332; cv=none; b=W0BUDPui4TOMErR9PlowPPLZ5zfag2U3189/dU27qA7UsojqGNC0Lgmw01djJp3GwwLpCQfT9YftoHeaRK4k0MCH8L5lZ7Eq9p9EdtVHevkPkTmNt199N5vDH8VP+rJoimKGssRoYR1TU4onfILYLWrxMERw++4PFjuVjaDGNC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113332; c=relaxed/simple;
	bh=3wvO/A5Kl63hJfysu7auIJ8KywnM15uuu+27C3JzzZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvl6xfzSvVIqlKhpAgQhfhwbn5vdPI4J09j/+EMnXx1jr7DSCzD58b9rb7ZHvHmviBHwKdZ/zhnyE2EXMCiNPIZHjaf17V867xAKGhBh3Yv1/IV5i2qBsN7EMnxk0o+14D4VomMrnxk+bsWoMTseaOs7SNesP1IV2jRKJ8if8UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqfi0YM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqfi0YM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC83BC4CEE5;
	Tue,  8 Apr 2025 11:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113332;
	bh=3wvO/A5Kl63hJfysu7auIJ8KywnM15uuu+27C3JzzZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqfi0YM64+vP9dVqdZzLHMffgDsXzI5DplorKmhqoJnl6K3bGxkH3rZWORRxfqzfS
	 Z3+fDEgrFomoBz5Gclo/JCJhoRAbozrifg0UmK2hockPNfkvCz0oY/lkcHYP+74ibK
	 ijc74HOu2gvxk058la3wIB7Mv0p9W0NQwiyEuqhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/268] perf evlist: Add success path to evlist__create_syswide_maps
Date: Tue,  8 Apr 2025 12:48:52 +0200
Message-ID: <20250408104831.760736351@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1eadb4f7c1b9d..f86a1eb4ea36a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1362,19 +1362,18 @@ static int evlist__create_syswide_maps(struct evlist *evlist)
 	 */
 	cpus = perf_cpu_map__new(NULL);
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



