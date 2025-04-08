Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6672126E170;
	Tue,  8 Apr 2025 12:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114794; cv=none; b=YChwx4qkhoWVOTlYYMLdNNEgaxTDFAWo9cBAv+p7vXfjipN6z+Qb1QLA+sElJtFPNx07T/BeEXOUl+Y8BbbYRTyieUQ9N27I4BptDPfUO7Qopc7njeNs7tccPJs6Kps42hjtul+U2FIeOM3HmJQHugG/loGbV0osz7chqdHud1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114794; c=relaxed/simple;
	bh=xSoWjXHMZV46N3QlD1sOh7hAZkAzNgxYRE06AAOrH2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDn/o8Ugrpn5/P129rZSor++KqLBL6lyIEzXsfoMdlzmnKIQjKIsxl9ixZQk4WwViX1gm5IXo+9x10gBdQJ5Qz3JsAiYV6qcUQWjdJW/PHyB2RUWu/wsj03DWYh99j7K6HKChBkPE6UfzauCsthrpJ1Qw3YhhyGKv4ORO/flB84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0k5ZnZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0k5ZnZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CA5C4CEEA;
	Tue,  8 Apr 2025 12:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114794;
	bh=xSoWjXHMZV46N3QlD1sOh7hAZkAzNgxYRE06AAOrH2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0k5ZnZ0dNcCvN20IRSDnv8kpH6iTj02bOFLigcwIpNWgIRbu7viEHKBuVPsx/XNs
	 o0zWx4VPb08aZfQUmWGtOjzgTG+wOeP8MmQvBtbbsTnILPaIf5THdStIFispyNVWA6
	 RQDRBzSIHAjUzBn2w8XK69idBh0hTZC2CSX16o18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 237/499] perf evlist: Add success path to evlist__create_syswide_maps
Date: Tue,  8 Apr 2025 12:47:29 +0200
Message-ID: <20250408104857.126607537@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



