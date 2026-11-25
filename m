Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624637;
	b=uM6jMilHrH1h0XTNsT4QeoCsERdRLDJdpJTGJF2bt8B2qPFMZWJC/o6hsGiXRNUWMMhF
	 ux+1d024wfxrHGDfdWW2bgGppxBSf0nsbJ+88nvWFnTRlqra4AzR9xfIzlhkUIfxp3vKo
	 lo0YUb8Cdn8oi1eXekdLWh1Dvd1lIKhn3EOflsP7HsSh66/SRJdWhRhGXCw2VyL9bU1Rf
	 7dHKzDus9B2cz8Wmana0LksDwppP0dvH+XdEY4mu89Z2LPx/WsNw3sVjw5l07WFTss5l3
	 FVcMwCLA/kwMg5WvKYodXDs3rNRrTB752Sjnbb7KYtwASRslHYOh5y6x1/9qLOzEFHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T1YunJRWDj8GhPjXMQTEXLdD7Tw51KNbvmZG77DD8J4=;
	b=WLM7F1WN7iNBAvHSOBt/rarHqt8vvHJhrqW9pbn4/W3DtqPHfnZA5+/gWe8JaIpzHiPK
	 sk8zs7V0bYzBvwUBR4DJ+1hNbEy2TY4rMCPXYNbUghD6+LWyUALX2jRlIw4lVfKSy7/ij
	 UlKsXfW0Kmfc8V044f8hrA9TE3x4AQ42LLolQh9CNz1ddDmTPbrwncYLEYQunl7SH3+b5
	 7ji10u4+q2a6pPBTK2j0+qkCP71VuJ2Mvlou8spn4n797A7NPeRuY7GTvdG9ndG/EVRvu
	 6mEWaNkaS66439Dv+4txhPqUdAdyH8AL4cYEIqFT4d03YgGTXbZqS9lYsmURCS0tAMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bgWR2wA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6BA606A336;
	Wed, 25 Nov 2026 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2bgWR2wA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0601F000E1;
	Wed, 25 Nov 2026 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624637;
	bh=T1YunJRWDj8GhPjXMQTEXLdD7Tw51KNbvmZG77DD8J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2bgWR2wA6AeCd0m6atWbNuUcrJ9Ah3hc9zEeg/zQLquSEtr/s9LQjNtkFw3tGU7u7
	 xAXYnSQr2xXsQZ/RnIKtz4F7LoTjsHOSlEh9FMTcCd6GaDtUtnsCaIoHeMu99/NDWJ
	 NqWXmcEHRBXKf3/WpeE2WqGvrAzRYYo8hvVQdjWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/816] perf/core: Simplify the perf_pmu_register() error path
Date: Wed, 25 Nov 2026 15:30:05 +0100
Message-ID: <20261125143855.156771381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 8f4c4963d28349cbf1920ab71edea8276f6ac4c5 ]

The error path of perf_pmu_register() is of course very similar to a
subset of perf_pmu_unregister(). Extract this common part in
perf_pmu_free() and simplify things.

[ mingo: Forward ported it ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20241104135518.090915501@infradead.org
Stable-dep-of: 3bbd85b2f67a ("perf: Fix racy update of cpc->hrtimer_interval")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 67 ++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 37 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 21a54cedd854b..5a200b3c770d9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11651,11 +11651,6 @@ static int perf_event_idx_default(struct perf_event *event)
 	return 0;
 }
 
-static void free_pmu_context(struct pmu *pmu)
-{
-	free_percpu(pmu->cpu_pmu_context);
-}
-
 /*
  * Let userspace know that this PMU supports address range filtering:
  */
@@ -11861,6 +11856,7 @@ static int pmu_dev_alloc(struct pmu *pmu)
 
 free_dev:
 	put_device(pmu->dev);
+	pmu->dev = NULL;
 	goto out;
 }
 
@@ -11882,25 +11878,38 @@ static bool idr_cmpxchg(struct idr *idr, unsigned long id, void *old, void *new)
 	return true;
 }
 
+static void perf_pmu_free(struct pmu *pmu)
+{
+	free_percpu(pmu->pmu_disable_count);
+	if (pmu_bus_running && pmu->dev && pmu->dev != PMU_NULL_DEV) {
+		if (pmu->nr_addr_filters)
+			device_remove_file(pmu->dev, &dev_attr_nr_addr_filters);
+		device_del(pmu->dev);
+		put_device(pmu->dev);
+	}
+	free_percpu(pmu->cpu_pmu_context);
+}
+
 int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 {
 	int cpu, ret, max = PERF_TYPE_MAX;
 
+	pmu->type = -1;
+
 	mutex_lock(&pmus_lock);
 	ret = -ENOMEM;
 	pmu->pmu_disable_count = alloc_percpu(int);
 	if (!pmu->pmu_disable_count)
 		goto unlock;
 
-	pmu->type = -1;
 	if (WARN_ONCE(!name, "Can not register anonymous pmu.\n")) {
 		ret = -EINVAL;
-		goto free_pdc;
+		goto free;
 	}
 
 	if (WARN_ONCE(pmu->scope >= PERF_PMU_MAX_SCOPE, "Can not register a pmu with an invalid scope.\n")) {
 		ret = -EINVAL;
-		goto free_pdc;
+		goto free;
 	}
 
 	pmu->name = name;
@@ -11910,24 +11919,23 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 
 	ret = idr_alloc(&pmu_idr, NULL, max, 0, GFP_KERNEL);
 	if (ret < 0)
-		goto free_pdc;
+		goto free;
 
 	WARN_ON(type >= 0 && ret != type);
 
-	type = ret;
-	pmu->type = type;
+	pmu->type = ret;
 	atomic_set(&pmu->exclusive_cnt, 0);
 
 	if (pmu_bus_running && !pmu->dev) {
 		ret = pmu_dev_alloc(pmu);
 		if (ret)
-			goto free_idr;
+			goto free;
 	}
 
 	ret = -ENOMEM;
 	pmu->cpu_pmu_context = alloc_percpu(struct perf_cpu_pmu_context);
 	if (!pmu->cpu_pmu_context)
-		goto free_dev;
+		goto free;
 
 	for_each_possible_cpu(cpu) {
 		struct perf_cpu_pmu_context *cpc;
@@ -11968,8 +11976,10 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 	/*
 	 * Now that the PMU is complete, make it visible to perf_try_init_event().
 	 */
-	if (!idr_cmpxchg(&pmu_idr, pmu->type, NULL, pmu))
-		goto free_context;
+	if (!idr_cmpxchg(&pmu_idr, pmu->type, NULL, pmu)) {
+		ret = -EINVAL;
+		goto free;
+	}
 	list_add_rcu(&pmu->entry, &pmus);
 
 	ret = 0;
@@ -11978,20 +11988,10 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 
 	return ret;
 
-free_context:
-	free_percpu(pmu->cpu_pmu_context);
-
-free_dev:
-	if (pmu->dev && pmu->dev != PMU_NULL_DEV) {
-		device_del(pmu->dev);
-		put_device(pmu->dev);
-	}
-
-free_idr:
-	idr_remove(&pmu_idr, pmu->type);
-
-free_pdc:
-	free_percpu(pmu->pmu_disable_count);
+free:
+	if (pmu->type >= 0)
+		idr_remove(&pmu_idr, pmu->type);
+	perf_pmu_free(pmu);
 	goto unlock;
 }
 EXPORT_SYMBOL_GPL(perf_pmu_register);
@@ -12010,14 +12010,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_srcu(&pmus_srcu);
 	synchronize_rcu();
 
-	free_percpu(pmu->pmu_disable_count);
-	if (pmu_bus_running && pmu->dev && pmu->dev != PMU_NULL_DEV) {
-		if (pmu->nr_addr_filters)
-			device_remove_file(pmu->dev, &dev_attr_nr_addr_filters);
-		device_del(pmu->dev);
-		put_device(pmu->dev);
-	}
-	free_pmu_context(pmu);
+	perf_pmu_free(pmu);
 }
 EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
-- 
2.53.0



