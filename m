Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624641;
	b=e0UNie5LmziENTkJM5U/SFPkmNlEJvOB5UVxlnK60Fch2MsfeoHzvrv5WF0nlpXGCrBK
	 X2a7aT/eaf5FjNz7gnowq4LCjzOBVIiTxTcS9L7wnYeLKmonfXU/U8K5XHGNGJd+uJGnI
	 3y8AFR/SAMuFviyqhYK2LZZSPVZJmHhlNdFLXs4y0skIUxIfQpgRg904huNUyxsngoZqw
	 qgZRT4G7OQCrTrBrtMpBQ9iEkqCFezXXugZwpvuW8Jv3buvfACHdUgC9iZYTEI2TwKHcD
	 bASNQ2O+ghdCKZTHzNw1Ol/ENQTyVjxSenhyHyegiLscqwZ5in1qpZkEY91mHA6V1RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YaQVR+164czSmGDzLxm4ScdqQ0C91y++XYVBjWHNX0o=;
	b=laUDxUJoZItjhYzvJIe9unBOwXkiHa4xL6pBIYNuqK7T3+zjhHze1IbtiACBTMNhsxlW
	 KL5v/9ydR9PI1stH7smpkSp7MTXymaVYZIElY//mz3q4/OpQu8GzKh9XYNG6zVfFzYw8G
	 gFNprvRodspt4ZSBFQQSPS9n7tqhoAMAtt/dqUhm0jofQWgXBDJQguIunnC67bHpXJMLX
	 m1RFG1AYc6E1awwuND2VbDITCHvJb4AmG/nxirpKBEwY1t1X54IEAFI6gOnrGpto5oWYP
	 QoIEB6q1Z1jhfQWZ+ylFZMTfN6fJJ81FrLkc+IfPUzW7VLcCIKgWC6OdMPifWkkIZGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hs6Si1aY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02232606A338;
	Wed, 25 Nov 2026 16:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hs6Si1aY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7DF1F000CA;
	Wed, 25 Nov 2026 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624640;
	bh=YaQVR+164czSmGDzLxm4ScdqQ0C91y++XYVBjWHNX0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hs6Si1aYjlNUOp3wAqIA6LwkT6kncIn35E2b5IyF7jKCiYI2VRIMyxohs853bbwwF
	 TViAdNFsgxdw6a5zUJX+vFe818W9m4rz3CTHTVcj+n0jrTEpSiDzIMtawOKlSAurnL
	 VF6fWbPoq4My0IgusYGsdiZiUOL4Y1QqArmZE5WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/816] perf/core: Simplify perf_pmu_register()
Date: Wed, 25 Nov 2026 15:30:06 +0100
Message-ID: <20261125143855.180493924@linuxfoundation.org>
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

[ Upstream commit 6c8b0b835f003647e593c08331a4dd2150d5eb0e ]

Using the previously introduced perf_pmu_free() and a new IDR helper,
simplify the perf_pmu_register error paths.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20241104135518.198937277@infradead.org
Stable-dep-of: 3bbd85b2f67a ("perf: Fix racy update of cpc->hrtimer_interval")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/idr.h  | 17 +++++++++++
 kernel/events/core.c | 71 ++++++++++++++++++--------------------------
 2 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index da5f5fa4a3a6a..cd729be369b36 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -15,6 +15,7 @@
 #include <linux/radix-tree.h>
 #include <linux/gfp.h>
 #include <linux/percpu.h>
+#include <linux/cleanup.h>
 
 struct idr {
 	struct radix_tree_root	idr_rt;
@@ -124,6 +125,22 @@ void *idr_get_next_ul(struct idr *, unsigned long *nextid);
 void *idr_replace(struct idr *, void *, unsigned long id);
 void idr_destroy(struct idr *);
 
+struct __class_idr {
+	struct idr *idr;
+	int id;
+};
+
+#define idr_null ((struct __class_idr){ NULL, -1 })
+#define take_idr_id(id) __get_and_null(id, idr_null)
+
+DEFINE_CLASS(idr_alloc, struct __class_idr,
+	     if (_T.id >= 0) idr_remove(_T.idr, _T.id),
+	     ((struct __class_idr){
+	     	.idr = idr,
+		.id = idr_alloc(idr, ptr, start, end, gfp),
+	     }),
+	     struct idr *idr, void *ptr, int start, int end, gfp_t gfp);
+
 /**
  * idr_init_base() - Initialise an IDR.
  * @idr: IDR handle.
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5a200b3c770d9..d7df3a9749433 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11890,52 +11890,49 @@ static void perf_pmu_free(struct pmu *pmu)
 	free_percpu(pmu->cpu_pmu_context);
 }
 
-int perf_pmu_register(struct pmu *pmu, const char *name, int type)
+DEFINE_FREE(pmu_unregister, struct pmu *, if (_T) perf_pmu_free(_T))
+
+int perf_pmu_register(struct pmu *_pmu, const char *name, int type)
 {
-	int cpu, ret, max = PERF_TYPE_MAX;
+	int cpu, max = PERF_TYPE_MAX;
 
-	pmu->type = -1;
+	struct pmu *pmu __free(pmu_unregister) = _pmu;
+	guard(mutex)(&pmus_lock);
 
-	mutex_lock(&pmus_lock);
-	ret = -ENOMEM;
 	pmu->pmu_disable_count = alloc_percpu(int);
 	if (!pmu->pmu_disable_count)
-		goto unlock;
+		return -ENOMEM;
 
-	if (WARN_ONCE(!name, "Can not register anonymous pmu.\n")) {
-		ret = -EINVAL;
-		goto free;
-	}
+	if (WARN_ONCE(!name, "Can not register anonymous pmu.\n"))
+		return -EINVAL;
 
-	if (WARN_ONCE(pmu->scope >= PERF_PMU_MAX_SCOPE, "Can not register a pmu with an invalid scope.\n")) {
-		ret = -EINVAL;
-		goto free;
-	}
+	if (WARN_ONCE(pmu->scope >= PERF_PMU_MAX_SCOPE,
+		      "Can not register a pmu with an invalid scope.\n"))
+		return -EINVAL;
 
 	pmu->name = name;
 
 	if (type >= 0)
 		max = type;
 
-	ret = idr_alloc(&pmu_idr, NULL, max, 0, GFP_KERNEL);
-	if (ret < 0)
-		goto free;
+	CLASS(idr_alloc, pmu_type)(&pmu_idr, NULL, max, 0, GFP_KERNEL);
+	if (pmu_type.id < 0)
+		return pmu_type.id;
 
-	WARN_ON(type >= 0 && ret != type);
+	WARN_ON(type >= 0 && pmu_type.id != type);
 
-	pmu->type = ret;
+	pmu->type = pmu_type.id;
 	atomic_set(&pmu->exclusive_cnt, 0);
 
 	if (pmu_bus_running && !pmu->dev) {
-		ret = pmu_dev_alloc(pmu);
+		int ret = pmu_dev_alloc(pmu);
 		if (ret)
-			goto free;
+			return ret;
 	}
 
-	ret = -ENOMEM;
 	pmu->cpu_pmu_context = alloc_percpu(struct perf_cpu_pmu_context);
 	if (!pmu->cpu_pmu_context)
-		goto free;
+		return -ENOMEM;
 
 	for_each_possible_cpu(cpu) {
 		struct perf_cpu_pmu_context *cpc;
@@ -11976,32 +11973,22 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 	/*
 	 * Now that the PMU is complete, make it visible to perf_try_init_event().
 	 */
-	if (!idr_cmpxchg(&pmu_idr, pmu->type, NULL, pmu)) {
-		ret = -EINVAL;
-		goto free;
-	}
+	if (!idr_cmpxchg(&pmu_idr, pmu->type, NULL, pmu))
+		return -EINVAL;
 	list_add_rcu(&pmu->entry, &pmus);
 
-	ret = 0;
-unlock:
-	mutex_unlock(&pmus_lock);
-
-	return ret;
-
-free:
-	if (pmu->type >= 0)
-		idr_remove(&pmu_idr, pmu->type);
-	perf_pmu_free(pmu);
-	goto unlock;
+	take_idr_id(pmu_type);
+	_pmu = no_free_ptr(pmu); // let it rip
+	return 0;
 }
 EXPORT_SYMBOL_GPL(perf_pmu_register);
 
 void perf_pmu_unregister(struct pmu *pmu)
 {
-	mutex_lock(&pmus_lock);
-	list_del_rcu(&pmu->entry);
-	idr_remove(&pmu_idr, pmu->type);
-	mutex_unlock(&pmus_lock);
+	scoped_guard (mutex, &pmus_lock) {
+		list_del_rcu(&pmu->entry);
+		idr_remove(&pmu_idr, pmu->type);
+	}
 
 	/*
 	 * We dereference the pmu list under both SRCU and regular RCU, so
-- 
2.53.0



