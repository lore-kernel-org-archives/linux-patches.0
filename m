Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC741DDC1;
	Tue, 27 Aug 2024 14:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769989; cv=none; b=h9G61/S9NEAMo4pZ//75zrBuvi3M9FxdRb8K2b3/JjxQwuCHtwYJpKQkDVFd3LLT8mfDjvaihPossNped+dobY2DrW4Y9yz90BFhpSCfz62o1IvNe2QpbvK12cAAnpzYcuHmsbbvcuGTokJkJtcVGnloSVmOykM2oOVZ0imtG9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769989; c=relaxed/simple;
	bh=h83k4+CiOdnJwSf/60bCOFoVn5rnxXXIJb/kwRPopCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6G0fLSuneBRgbOXl/21S+xo0G4+D7cOGDv+Rz3npROPeQ2SRRwzU5Bd6TD+hYCbsvl+Zh2NSQsziZiK3s+UqNH1jBC1kxh0W5KIusM55cGQKGbC5ekUnD1pBKENt/YfBPbYTpx7ryk1Wt+Ix8M3hR7omd6DcfJK2DalWQPBN5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWCMtjX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWCMtjX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CE5C6106D;
	Tue, 27 Aug 2024 14:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769989;
	bh=h83k4+CiOdnJwSf/60bCOFoVn5rnxXXIJb/kwRPopCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWCMtjX2IuhPPkVQoM29CuRUHGmhojT5eHntmoVXwkEw+Q+YJAgxSu9nHvkm8QtaR
	 iWuCaQpvq1xykYZ8eqDledl1LwrS+oqyLhjOV2UaYoWjLxluEO8d7gleU4GJNrVEB1
	 uGzKbLhSUTu9bYNM+pIFHqnsoMEHALO66NU35LrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/341] sched/topology: Handle NUMA_NO_NODE in sched_numa_find_nth_cpu()
Date: Tue, 27 Aug 2024 16:35:26 +0200
Message-ID: <20240827143847.022606069@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit 9ecea9ae4d3127a09fb5dfcea87f248937a39ff5 ]

sched_numa_find_nth_cpu() doesn't handle NUMA_NO_NODE properly, and
may crash kernel if passed with it. On the other hand, the only user
of sched_numa_find_nth_cpu() has to check NUMA_NO_NODE case explicitly.

It would be easier for users if this logic will get moved into
sched_numa_find_nth_cpu().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Link: https://lore.kernel.org/r/20230819141239.287290-6-yury.norov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 3 +++
 lib/cpumask.c           | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8c1e183329d97..3a13cecf17740 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2126,6 +2126,9 @@ int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 	struct cpumask ***hop_masks;
 	int hop, ret = nr_cpu_ids;
 
+	if (node == NUMA_NO_NODE)
+		return cpumask_nth_and(cpu, cpus, cpu_online_mask);
+
 	rcu_read_lock();
 
 	/* CPU-less node entries are uninitialized in sched_domains_numa_masks */
diff --git a/lib/cpumask.c b/lib/cpumask.c
index a7fd02b5ae264..34335c1e72653 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -146,9 +146,7 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
 	/* Wrap: we always want a cpu. */
 	i %= num_online_cpus();
 
-	cpu = (node == NUMA_NO_NODE) ?
-		cpumask_nth(i, cpu_online_mask) :
-		sched_numa_find_nth_cpu(cpu_online_mask, i, node);
+	cpu = sched_numa_find_nth_cpu(cpu_online_mask, i, node);
 
 	WARN_ON(cpu >= nr_cpu_ids);
 	return cpu;
-- 
2.43.0



