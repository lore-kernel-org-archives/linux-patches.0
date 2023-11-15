Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D673DB91
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZW6VC3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A687C433C9;
	Wed, 15 Nov 2023 19:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076716;
	bh=vL5sD+wXikLpB0SNAPvF/KJGavoA5i8niOhW5vRw8t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZW6VC3nmghqg4kAMWmb+sICSM1gc93pbbfdkhj1c3hsx/sFDVlKwpicAgEsCu4tG
	 uNexRBNzYJOLipQtYUJPO4GcoY2aozMO/5l5hRo2JbPBn9zv0z4v4fI8eFFKVPyWeN
	 rvHpLVUUM4UhNp/njh28aRXJ2gcTw72y5WzhLIOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Yury Norov <yury.norov@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/603] sched/topology: Fix sched_numa_find_nth_cpu() in CPU-less case
Date: Wed, 15 Nov 2023 14:09:08 -0500
Message-ID: <20231115191613.361360889@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

[ Upstream commit 617f2c38cb5ce60226042081c09e2ee3a90d03f8 ]

When the node provided by user is CPU-less, corresponding record in
sched_domains_numa_masks is not set. Trying to dereference it in the
following code leads to kernel crash.

To avoid it, start searching from the nearest node with CPUs.

Fixes: cd7f55359c90 ("sched: add sched_numa_find_nth_cpu()")
Reported-by: Yicong Yang <yangyicong@hisilicon.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Yicong Yang <yangyicong@hisilicon.com>
Cc: Mel Gorman <mgorman@suse.de>
Link: https://lore.kernel.org/r/20230819141239.287290-4-yury.norov@gmail.com

Closes: https://lore.kernel.org/lkml/CAAH8bW8C5humYnfpW3y5ypwx0E-09A3QxFE1JFzR66v+mO4XfA@mail.gmail.com/T/
Closes: https://lore.kernel.org/lkml/ZMHSNQfv39HN068m@yury-ThinkPad/T/#mf6431cb0b7f6f05193c41adeee444bc95bf2b1c4
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 05a5bc678c089..423d08947962c 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2122,12 +2122,16 @@ static int hop_cmp(const void *a, const void *b)
  */
 int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 {
-	struct __cmp_key k = { .cpus = cpus, .node = node, .cpu = cpu };
+	struct __cmp_key k = { .cpus = cpus, .cpu = cpu };
 	struct cpumask ***hop_masks;
 	int hop, ret = nr_cpu_ids;
 
 	rcu_read_lock();
 
+	/* CPU-less node entries are uninitialized in sched_domains_numa_masks */
+	node = numa_nearest_node(node, N_CPU);
+	k.node = node;
+
 	k.masks = rcu_dereference(sched_domains_numa_masks);
 	if (!k.masks)
 		goto unlock;
-- 
2.42.0



