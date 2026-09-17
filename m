Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5EB4F392D;
	Thu, 17 Sep 2026 16:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660854; cv=none; b=JBEDk1fzyQ5dUEcuMqCqnjD+bFN58IZn5YAah/f7tSYX2o0zPRCLXZXJQ35IJHIHpYMi4rNQHf1UDElQ1Jkcv3OBLeJx6FgSVRGwUpYaVllTQDqsAyBt59Kgy1XvFeIkBi/fiXP8D/dHVYOpdRlJg7MV+qylYqZ+dCGyTEAboL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660854; c=relaxed/simple;
	bh=Cl18hntfLuSHMEm7E5vPMWAcrfXydLquZ+3QBBNmMwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkZzHKT+FDNF6l1WFXWrxvmpfjp5JNo4Md4aBevsFAMAM6weG2F2KRX5D7olrVAf0qOyySgqNKN9FcC4nhdhcqiwswpePhMoW27Ffza9GY8WOOXAYxGlfrS+9ilvfxyUgONsfxrD4qIisZIDHo7nRArmGPOojXlBn5Fnu25++0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lRPCt3o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lRPCt3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E29C1F000FF;
	Thu, 17 Sep 2026 16:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660852;
	bh=a+XEMmBW7CWRhTLmZQD7/Y/RXyq1+lh1nhwZ8e568Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lRPCt3oNfJ6RlCkhQxZSr5IpObw4hw4byZXwm0juHF4R3FuIJSXSX6rurF38Gfqt
	 4imd96AHMHJWq7SgPMNKjKR4+X3neWLJO8y76Sh3JOr8qJcmqDXOxzXuVn1XZaaqgV
	 KtJ2mnPMhXTK/Y7qbE6xi/mDzmqyT36IcsfeVVPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 729/733] s390/pai: Move locking to event init and delete
Date: Thu, 17 Sep 2026 16:17:17 +0100
Message-ID: <20260917151411.151520318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit e8df39dacb7d98d2b2aea431ca652d9fadf5efa3 ]

Move mutex locking from per CPU allocation to event allocation.
No functional change.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 9ecc4d033879 ("s390/pai: Support CPU hotplug for PMU PAI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_pai.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/arch/s390/kernel/perf_pai.c
+++ b/arch/s390/kernel/perf_pai.c
@@ -138,21 +138,19 @@ static void pai_free(struct pai_mapptr *
 }
 
 /* Adjust usage counters and remove allocated memory when all users are
- * gone.
+ * gone. Called under mutex_lock.
  */
 static void pai_event_destroy_cpu(int idx, int cpu)
 {
 	struct pai_mapptr *mp = per_cpu_ptr(pai_root[idx].mapptr, cpu);
 	struct pai_map *cpump = mp->mapptr;
 
-	mutex_lock(&pai_reserve_mutex);
 	debug_sprintf_event(paidbg, 5, "%s users %d refcnt %u\n",
 			    __func__, cpump->active_events,
 			    refcount_read(&cpump->refcnt));
 	if (refcount_dec_and_test(&cpump->refcnt))
 		pai_free(mp);
 	pai_root_free(idx);
-	mutex_unlock(&pai_reserve_mutex);
 }
 
 static void pai_event_destroy(struct perf_event *event)
@@ -160,6 +158,7 @@ static void pai_event_destroy(struct per
 	int cpu = 0, idx = PAI_PMU_IDX(event);
 
 	free_page(PAI_SAVE_AREA(event));
+	mutex_lock(&pai_reserve_mutex);
 	if (event->cpu == -1) {
 		struct cpumask *mask = PAI_CPU_MASK(event);
 
@@ -169,6 +168,7 @@ static void pai_event_destroy(struct per
 	} else {
 		pai_event_destroy_cpu(idx, event->cpu);
 	}
+	mutex_unlock(&pai_reserve_mutex);
 }
 
 static void paicrypt_event_destroy(struct perf_event *event)
@@ -232,12 +232,10 @@ static u64 paicrypt_getall(struct perf_e
 	return sum;
 }
 
-/* Check concurrent access of counting and sampling for crypto events.
- * This function is called in process context and it is save to block.
- * When the event initialization functions fails, no other call back will
- * be invoked.
- *
- * Allocate the memory for the event.
+/* Allocate all per-CPU data structures. This function is called in
+ * process context and can block. In case of error all partly allocated
+ * memory is released and the reference counters adjusted correctly.
+ * Called under mutex_lock.
  */
 static int pai_alloc_cpu(int idx, int cpu)
 {
@@ -246,11 +244,10 @@ static int pai_alloc_cpu(int idx, int cp
 	struct pai_mapptr *mp;
 	int rc;
 
-	mutex_lock(&pai_reserve_mutex);
 	/* Allocate root node */
 	rc = pai_root_alloc(idx);
 	if (rc)
-		goto unlock;
+		goto out;
 
 	/* Allocate node for this event */
 	mp = per_cpu_ptr(pai_root[idx].mapptr, cpu);
@@ -308,12 +305,12 @@ undo:
 		 */
 		pai_root_free(idx);
 	}
-unlock:
-	mutex_unlock(&pai_reserve_mutex);
+out:
 	/* If rc is non-zero, no increment of counter/sampler was done. */
 	return rc;
 }
 
+/* Called under mutex_lock */
 static int pai_alloc(struct perf_event *event)
 {
 	int idx = PAI_PMU_IDX(event);
@@ -390,10 +387,12 @@ static int pai_event_init(struct perf_ev
 		}
 	}
 
+	mutex_lock(&pai_reserve_mutex);
 	if (event->cpu >= 0)
 		rc = pai_alloc_cpu(idx, event->cpu);
 	else
 		rc = pai_alloc(event);
+	mutex_unlock(&pai_reserve_mutex);
 	if (rc) {
 		free_page(PAI_SAVE_AREA(event));
 		goto out;


