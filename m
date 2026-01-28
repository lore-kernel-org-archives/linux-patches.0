Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8EA2F25EF;
	Wed, 28 Jan 2026 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615506; cv=none; b=eBWzeDAhXBc93fXU/ZtTMIVGIVzXd3I8y89DnGkgtXsklTFH2LrOgj0QERpuOSuo5IHkZH5MMqs8BxSqLeDsOwQa9AlTOEsaGcFYpcVB5+c/E1pVk6euLwLBzmAhKNqT4rlQXY4ZT4K6k2GALEz+UgK0GSZd2gRQMRZX1roP0X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615506; c=relaxed/simple;
	bh=AJui6H2xwrVVMAdw8YVYpWeMYk+/ki2qCAy/P/hvxiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhZiTQdUytBj1zFs8QgR+8GaZ05k90kTpyLqA5Ai0iWUOoftc9rDrthXbXr7XhpKXuCkMDk9ZGlYYp5LDYYFW245bCrRn37853XCZs8FjUS0TRi2Lp+sVbkY/l2qDF7S3Hi0q7TlgzreyOElGV7QbcGAAGoOgidEw7ok4nlJ8Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N335CAiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N335CAiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E14C4CEF1;
	Wed, 28 Jan 2026 15:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615506;
	bh=AJui6H2xwrVVMAdw8YVYpWeMYk+/ki2qCAy/P/hvxiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N335CAiRoKcERpjwcT1pwMXH4fvxCY1DNDb0ZQQaOYzRC693PMe7GkYds0hj2vXdn
	 2JAlLcypEFKgtwBPc6rKYUebslGV20paSciP1lZewSIoFEd5U+vwfrf+JmfJ639iPl
	 sX8DwerNnSFEFpgplMxV2w06qaqEUVDpQyNruppk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faisal Bukhari <faisalbukhari523@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/227] perf parse-events: Fix evsel allocation failure
Date: Wed, 28 Jan 2026 16:20:50 +0100
Message-ID: <20260128145344.532080588@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Faisal Bukhari <faisalbukhari523@gmail.com>

[ Upstream commit 1eb217ab2e737609f8a861b517649e82e7236d05 ]

If evsel__new_idx() returns NULL, the function currently jumps to label
'out_err'.  Here, references to `cpus` and `pmu_cpus` are dropped.
Also, resources held by evsel->name and evsel->metric_id are freed.

But if evsel__new_idx() returns NULL, it can lead to NULL pointer
dereference.

Fixes: cd63c22168257a0b ("perf parse-events: Minor __add_event refactoring")
Signed-off-by: Faisal Bukhari <faisalbukhari523@gmail.com>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index cd9315d3ca117..4723c2955f22e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -286,8 +286,11 @@ __add_event(struct list_head *list, int *idx,
 		event_attr_init(attr);
 
 	evsel = evsel__new_idx(attr, *idx);
-	if (!evsel)
-		goto out_err;
+	if (!evsel) {
+		perf_cpu_map__put(cpus);
+		perf_cpu_map__put(pmu_cpus);
+		return NULL;
+	}
 
 	if (name) {
 		evsel->name = strdup(name);
-- 
2.51.0



