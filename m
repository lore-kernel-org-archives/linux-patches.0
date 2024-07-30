Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC977188012;
	Tue, 30 Jul 2024 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357162; cv=none; b=du1ZZlqZi6zE9TSqgY+MlTAZ8Uta4q+f+/MpAU9YPlBNd439TrZY4vAEl0wSm6byq1qnsLrVQGaQ0fW/iEzCfvqvxE9tvxAOOuo8d6tZWA03vY4f8aT9NQ6+zOXRyuxFomOGiwybU52iokiJ64qspuyFef8Q4ayMCY6nglpywwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357162; c=relaxed/simple;
	bh=k+MPZvISK33eEfEnAyDAQiMSWgCq9VwvvA+EaA5iDb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiBabxb5ox5DdL4+FlBfu7mfJRZprFLdY1n/JWYqWbG/ujxFHZ6j40cDMkAeL+04na4HokdtwgPz2VumTgNGrYK1P1WgorV8AYnj/FKFuGQchW3DigMUdQR1oQnizdxymVjOp18G8Yu5Sv+qZGoLtu27OgLKdqy8Ctypd0YOsTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esjcqGxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esjcqGxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F74BC32782;
	Tue, 30 Jul 2024 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357161;
	bh=k+MPZvISK33eEfEnAyDAQiMSWgCq9VwvvA+EaA5iDb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esjcqGxPizT1l+zJ1TaItlPGaH6dOvOaRZ8zyLdXesgRYACdwlVG7AS0P/74x0j1K
	 Y9Xz2suy/DbPK/QpOhavjxlvrx6QflGmrJk1Q7fW+WpFHvqtGm1ZzutioDEOMbBKCR
	 eRpwMI3MYrfjVG3n9NooS+CdONWQieCMGYNThsuM=
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
Subject: [PATCH 6.6 225/568] perf pmus: Fixes always false when compare duplicates aliases
Date: Tue, 30 Jul 2024 17:45:32 +0200
Message-ID: <20240730151648.676260568@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index cec869cbe163a..54a237b2b8538 100644
--- a/tools/perf/util/pmus.c
+++ b/tools/perf/util/pmus.c
@@ -470,8 +470,8 @@ void perf_pmus__print_pmu_events(const struct print_callbacks *print_cb, void *p
 	qsort(aliases, len, sizeof(struct sevent), cmp_sevent);
 	for (int j = 0; j < len; j++) {
 		/* Skip duplicates */
-		if (j > 0 && pmu_alias_is_duplicate(&aliases[j], &aliases[j - 1]))
-			continue;
+		if (j < len - 1 && pmu_alias_is_duplicate(&aliases[j], &aliases[j + 1]))
+			goto free;
 
 		print_cb->print_event(print_state,
 				aliases[j].pmu_name,
@@ -484,6 +484,7 @@ void perf_pmus__print_pmu_events(const struct print_callbacks *print_cb, void *p
 				aliases[j].desc,
 				aliases[j].long_desc,
 				aliases[j].encoding_desc);
+free:
 		zfree(&aliases[j].name);
 		zfree(&aliases[j].alias);
 		zfree(&aliases[j].scale_unit);
-- 
2.43.0



