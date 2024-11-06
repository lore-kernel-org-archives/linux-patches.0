Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4241F668B;
	Wed,  6 Nov 2024 12:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896927; cv=none; b=ttztoWtpE7STJD4hc2aQ53kHjcbQBX5REWRzcZN/O3h/WP8Ai7YD6/sSkS0ZIvtqTofyNNfiEnIuIgFFpJsMX+u7AkV5GQM7NRv0EgWmmSIy2voVVr+1GELeSqavpaNdyKjrVNlT2A92OPjqmcigvnWPTXmcVZl3yglCYSZgLFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896927; c=relaxed/simple;
	bh=ownBqU+z5f8d3CuaB2UOtLmfKb85BNgKsHRWowWfvHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf6rHgXt8ge6wHn/2dlKbi4psaM+BnPzKfmN/Us6JTErQd6qMwhTbZyv2IqTSaTq/VPCOj8DvaxITSQ+BFU6SIU9nyG2WTCo4gs1h47SiZdqBVKmOJwyKNCVRfeGAmBJmZa49CxtxtRYjmXgfaC85ZxfglZ0uXjdyRrRMDBjrrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZglItxOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZglItxOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A2FC4CECD;
	Wed,  6 Nov 2024 12:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896927;
	bh=ownBqU+z5f8d3CuaB2UOtLmfKb85BNgKsHRWowWfvHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZglItxODNNzfKiuScApFlnejurPOlE0PkHC219OF/U4LLeo5kpo9gJh74TV4GS4q8
	 voDfS+40j7BKzG8E9tINhJPxNrp6vmXDgSnQPy0sMLdCMiQX0qGDjl3ZUq3fNxMo4G
	 l+8eosBMiXS9P5KEbh4MWvVFwum8qeo6EB2hYH+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/126] cpufreq: Generalize of_perf_domain_get_sharing_cpumask phandle format
Date: Wed,  6 Nov 2024 13:03:22 +0100
Message-ID: <20241106120306.081312093@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit d182dc6de93225cd853de4db68a1a77501bedb6e ]

of_perf_domain_get_sharing_cpumask currently assumes a 1-argument
phandle format, and directly returns the argument. Generalize this to
return the full of_phandle_args, so it can be used by drivers which use
other phandle styles (e.g. separate nodes). This also requires changing
the CPU sharing match to compare the full args structure.

Also, make sure to of_node_put(args.np) (the original code was leaking a
reference).

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: c0f02536fffb ("cpufreq: Avoid a bad reference count on CPU node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/mediatek-cpufreq-hw.c | 14 +++++++++-----
 include/linux/cpufreq.h               | 28 +++++++++++++++------------
 2 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/cpufreq/mediatek-cpufreq-hw.c b/drivers/cpufreq/mediatek-cpufreq-hw.c
index 7f326bb5fd8de..62f5a9d64e8fa 100644
--- a/drivers/cpufreq/mediatek-cpufreq-hw.c
+++ b/drivers/cpufreq/mediatek-cpufreq-hw.c
@@ -162,6 +162,7 @@ static int mtk_cpu_resources_init(struct platform_device *pdev,
 	struct mtk_cpufreq_data *data;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
+	struct of_phandle_args args;
 	void __iomem *base;
 	int ret, i;
 	int index;
@@ -170,11 +171,14 @@ static int mtk_cpu_resources_init(struct platform_device *pdev,
 	if (!data)
 		return -ENOMEM;
 
-	index = of_perf_domain_get_sharing_cpumask(policy->cpu, "performance-domains",
-						   "#performance-domain-cells",
-						   policy->cpus);
-	if (index < 0)
-		return index;
+	ret = of_perf_domain_get_sharing_cpumask(policy->cpu, "performance-domains",
+						 "#performance-domain-cells",
+						 policy->cpus, &args);
+	if (ret < 0)
+		return ret;
+
+	index = args.args[0];
+	of_node_put(args.np);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, index);
 	if (!res) {
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 9d208648c84d5..1976244b97e3a 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -1123,10 +1123,10 @@ cpufreq_table_set_inefficient(struct cpufreq_policy *policy,
 }
 
 static inline int parse_perf_domain(int cpu, const char *list_name,
-				    const char *cell_name)
+				    const char *cell_name,
+				    struct of_phandle_args *args)
 {
 	struct device_node *cpu_np;
-	struct of_phandle_args args;
 	int ret;
 
 	cpu_np = of_cpu_device_node_get(cpu);
@@ -1134,41 +1134,44 @@ static inline int parse_perf_domain(int cpu, const char *list_name,
 		return -ENODEV;
 
 	ret = of_parse_phandle_with_args(cpu_np, list_name, cell_name, 0,
-					 &args);
+					 args);
 	if (ret < 0)
 		return ret;
 
 	of_node_put(cpu_np);
 
-	return args.args[0];
+	return 0;
 }
 
 static inline int of_perf_domain_get_sharing_cpumask(int pcpu, const char *list_name,
-						     const char *cell_name, struct cpumask *cpumask)
+						     const char *cell_name, struct cpumask *cpumask,
+						     struct of_phandle_args *pargs)
 {
-	int target_idx;
 	int cpu, ret;
+	struct of_phandle_args args;
 
-	ret = parse_perf_domain(pcpu, list_name, cell_name);
+	ret = parse_perf_domain(pcpu, list_name, cell_name, pargs);
 	if (ret < 0)
 		return ret;
 
-	target_idx = ret;
 	cpumask_set_cpu(pcpu, cpumask);
 
 	for_each_possible_cpu(cpu) {
 		if (cpu == pcpu)
 			continue;
 
-		ret = parse_perf_domain(cpu, list_name, cell_name);
+		ret = parse_perf_domain(cpu, list_name, cell_name, &args);
 		if (ret < 0)
 			continue;
 
-		if (target_idx == ret)
+		if (pargs->np == args.np && pargs->args_count == args.args_count &&
+		    !memcmp(pargs->args, args.args, sizeof(args.args[0]) * args.args_count))
 			cpumask_set_cpu(cpu, cpumask);
+
+		of_node_put(args.np);
 	}
 
-	return target_idx;
+	return 0;
 }
 #else
 static inline int cpufreq_boost_trigger_state(int state)
@@ -1198,7 +1201,8 @@ cpufreq_table_set_inefficient(struct cpufreq_policy *policy,
 }
 
 static inline int of_perf_domain_get_sharing_cpumask(int pcpu, const char *list_name,
-						     const char *cell_name, struct cpumask *cpumask)
+						     const char *cell_name, struct cpumask *cpumask,
+						     struct of_phandle_args *pargs)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.43.0



