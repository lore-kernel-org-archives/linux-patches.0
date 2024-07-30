Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC841A6195;
	Tue, 30 Jul 2024 16:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358550; cv=none; b=gUmA9enTpT3gey/SQ+wLvo+7AuFqnvNdOcYZybK3dtb4AzctTY4YlS8NxXfiDytW6YTogBPvhU+G3rdlzeyKXz5zGZdP5KnJmJzRVsbqCglStRPiWZquMl1w8WJdJtCB9gtaoEa2cxtcq0AtkccfMgicycTAKkb+3Ts/ykb6jaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358550; c=relaxed/simple;
	bh=Ny9QKlxxydlA7elX9dnZeEETRH/WaqkUIsi3HQ0M/wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPIQCoMsvpeNUgxvb8kb1cuJAcO2RZlw2zBZFRKTigsA6gySaub1+1hOKDRu5YvHnovDdi0sfG4cEuLDIoQejbZ16O+HrUSZTb95VtKOXnPqIPraCukm72ZDyP8yW9hTW4LLqtFXdms7FgRmC04KA4mDfjktL1y8+RtvP82Jvmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZCeQcQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZCeQcQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7751C32782;
	Tue, 30 Jul 2024 16:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358550;
	bh=Ny9QKlxxydlA7elX9dnZeEETRH/WaqkUIsi3HQ0M/wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZCeQcQcIqb+Z9kMuQ0D5fq8wU8CKSOuWzzqF3t388BeU/5LRx6WUzwUXGRtFdirr
	 BlswTcmCzZtARAjm1zMCr2WkPcfR337uwZb3AXYoL7KDrbxgYnxRCokiIgTqkZqWSi
	 j4JRaezuNP/6p0qQP6KsJwSkxqlQJeVh+H6Gb65o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	ravi.bangoria@amd.com,
	james.clark@arm.com,
	prime.zeng@hisilicon.com,
	cuigaosheng1@huawei.com,
	jonathan.cameron@huawei.com,
	linuxarm@huawei.com,
	yangyicong@huawei.com,
	robh@kernel.org,
	renyu.zj@linux.alibaba.com,
	kjain@linux.ibm.com,
	john.g.garry@oracle.com,
	linux-arm-kernel@lists.infradead.org,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 346/809] perf pmus: Fixes always false when compare duplicates aliases
Date: Tue, 30 Jul 2024 17:43:42 +0200
Message-ID: <20240730151738.300105397@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit dd9a426eade634bf794c7e0f1b0c6659f556942f ]

In the previous loop, all the members in the aliases[j-1] have been freed
and set to NULL. But in this loop, the function pmu_alias_is_duplicate()
compares the aliases[j] with the aliases[j-1] that has already been
disposed, so the function will always return false and duplicate aliases
will never be discarded.

If we find duplicate aliases, it skips the zfree aliases[j], which is
accompanied by a memory leak.

We can use the next aliases[j+1] to theck for duplicate aliases to
fixes the aliases NULL pointer dereference, then goto zfree code snippet
to release it.

After patch testing:
 $ perf list --unit=hisi_sicl,cpa pmu

 uncore cpa:
   cpa_p0_rd_dat_32b
        [Number of read ops transmitted by the P0 port which size is 32 bytes.
         Unit: hisi_sicl,cpa]
   cpa_p0_rd_dat_64b
        [Number of read ops transmitted by the P0 port which size is 64 bytes.
         Unit: hisi_sicl,cpa]

Fixes: c3245d2093c1 ("perf pmu: Abstract alias/event struct")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Cc: ravi.bangoria@amd.com
Cc: james.clark@arm.com
Cc: prime.zeng@hisilicon.com
Cc: cuigaosheng1@huawei.com
Cc: jonathan.cameron@huawei.com
Cc: linuxarm@huawei.com
Cc: yangyicong@huawei.com
Cc: robh@kernel.org
Cc: renyu.zj@linux.alibaba.com
Cc: kjain@linux.ibm.com
Cc: john.g.garry@oracle.com
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240614094318.11607-1-hejunhao3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/pmus.c b/tools/perf/util/pmus.c
index b9b4c5eb50027..6907e3e7fbd16 100644
--- a/tools/perf/util/pmus.c
+++ b/tools/perf/util/pmus.c
@@ -477,8 +477,8 @@ void perf_pmus__print_pmu_events(const struct print_callbacks *print_cb, void *p
 	qsort(aliases, len, sizeof(struct sevent), cmp_sevent);
 	for (int j = 0; j < len; j++) {
 		/* Skip duplicates */
-		if (j > 0 && pmu_alias_is_duplicate(&aliases[j], &aliases[j - 1]))
-			continue;
+		if (j < len - 1 && pmu_alias_is_duplicate(&aliases[j], &aliases[j + 1]))
+			goto free;
 
 		print_cb->print_event(print_state,
 				aliases[j].pmu_name,
@@ -491,6 +491,7 @@ void perf_pmus__print_pmu_events(const struct print_callbacks *print_cb, void *p
 				aliases[j].desc,
 				aliases[j].long_desc,
 				aliases[j].encoding_desc);
+free:
 		zfree(&aliases[j].name);
 		zfree(&aliases[j].alias);
 		zfree(&aliases[j].scale_unit);
-- 
2.43.0



