Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E77263C90;
	Tue,  8 Apr 2025 11:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111625; cv=none; b=mcG+Hdlu/C79nZ8kWJBuQaFONxdg0ggDWt+NqSVFCXm917yMJvFXCuPZ5vPIwd1d0ksxFEGnrckMcNr7BjNr2OykbJslwm6BGQNWCcvSEnSxsXkuSBnPyqFHKhhq6gyi6ghcdWC4hzdJ7oBZ6ZbdnittNtvwZRdcw0RC/CzcqT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111625; c=relaxed/simple;
	bh=9/QtRIkO3A87fb1WTd8OUiKBXsqrk4nzxX0HFslPKyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQuiDI6l1BmbM4CT3DN/btNeoIvgS0FjLDhz9I/0y+EhFpSKAcewkCDwBqmFsL2t7DK6Ir0o8B0heBdHoRtCNHa4i3nXO6TCbLTq0kmssfBn3utSfPUClV9Ub8lduG0igOT590LPVIPR3KJOb/VSR+Pa4I0YhRj5WEBOnGiJNfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILcVTqud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILcVTqud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7AEC4CEEB;
	Tue,  8 Apr 2025 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111625;
	bh=9/QtRIkO3A87fb1WTd8OUiKBXsqrk4nzxX0HFslPKyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILcVTqudCGsYeEuFmlNzjhADzJzJu8qyznMflN5bAj2s1/ih29pCYf79enbBvXO/O
	 HnBvKJ9m6Ac0PFbQoFirDdkBOvguzI+qU/4/mToCVhJVnadVR0JQ9Z1r0iLtR+YiBP
	 rvvCJwHoAZPQ3VSWrZzr5xsHyoFerois7FYSyqZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 498/731] perf evlist: Add success path to evlist__create_syswide_maps
Date: Tue,  8 Apr 2025 12:46:35 +0200
Message-ID: <20250408104925.858738667@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index f0dd174e2debd..633df7d9204c2 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1373,19 +1373,18 @@ static int evlist__create_syswide_maps(struct evlist *evlist)
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



