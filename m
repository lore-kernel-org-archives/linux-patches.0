Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6557119CD07;
	Tue, 27 May 2025 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366981; cv=none; b=ZUWaJ2XxiMwB9z+9AyrG8Llfky+SzIsFaqQMUR83Rkl7Kp1tARiMZRfe8LwO8IDuwjgZd/fK9LdXNEe6UdVJckFD7RTJvrUQwAiq2yRyjMgMtqsfQ8WmisifNHCHWad5w5OAiZHMmy5cKBpa2WfIZM0QRs/deEf4F00KQbJksLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366981; c=relaxed/simple;
	bh=JE9GHUiFaWgK9jaRmInCKXymOaSlT2wbEDiLJQHwck0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgLH7l1IdjoDPwxMIB0I/c4qD9b7zRKTxTz2dwcYLb036ZIW5YN9JbN3pQRNdx+jX7B/eTxB4tOpTxVO5GEpza/qTzxlk9AAnl5J2I6aS1niYGVyK3jsmeAlCQhHu1FVq8MJl58CpSSrHAtlFZIrd+r69L7CcsRlKfHGf+LT4es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYFm9aXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYFm9aXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF50C4CEE9;
	Tue, 27 May 2025 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366981;
	bh=JE9GHUiFaWgK9jaRmInCKXymOaSlT2wbEDiLJQHwck0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYFm9aXZrAn/znTtZW+MbaYWogl+FUoEh0qGhu71DX48zw40DZlHHdllnJRmir/CK
	 2Psz2t6bSHJF//4sqYbkGdMoYlAJx1O5j6by5G/uHXAblhkG2cX1QjP84Y6OErhQCz
	 PtybfKUXdkINymUsKl/LKZp2zODeKc330Bjdu2Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 239/783] coresight: change coresight_trace_id_maps lock type to raw_spinlock_t
Date: Tue, 27 May 2025 18:20:36 +0200
Message-ID: <20250527162522.849178363@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 4cf364ca57d851e192ce02e98d314d22fa514895 ]

coresight_trace_id_map->lock can be acquired while coresight devices'
drvdata_lock.

But the drvdata_lock can be raw_spinlock_t (i.e) coresight-etm4x.

To address this, change type of coresight_trace_id_map->lock to
raw_spinlock_t

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250306121110.1647948-4-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c  |  2 +-
 .../hwtracing/coresight/coresight-trace-id.c  | 22 +++++++++----------
 include/linux/coresight.h                     |  2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index 4936dc2f7a56b..4fe837b02e314 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -1249,7 +1249,7 @@ struct coresight_device *coresight_register(struct coresight_desc *desc)
 
 	if (csdev->type == CORESIGHT_DEV_TYPE_SINK ||
 	    csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) {
-		spin_lock_init(&csdev->perf_sink_id_map.lock);
+		raw_spin_lock_init(&csdev->perf_sink_id_map.lock);
 		csdev->perf_sink_id_map.cpu_map = alloc_percpu(atomic_t);
 		if (!csdev->perf_sink_id_map.cpu_map) {
 			kfree(csdev);
diff --git a/drivers/hwtracing/coresight/coresight-trace-id.c b/drivers/hwtracing/coresight/coresight-trace-id.c
index 378af743be455..7ed337d54d3e3 100644
--- a/drivers/hwtracing/coresight/coresight-trace-id.c
+++ b/drivers/hwtracing/coresight/coresight-trace-id.c
@@ -22,7 +22,7 @@ enum trace_id_flags {
 static DEFINE_PER_CPU(atomic_t, id_map_default_cpu_ids) = ATOMIC_INIT(0);
 static struct coresight_trace_id_map id_map_default = {
 	.cpu_map = &id_map_default_cpu_ids,
-	.lock = __SPIN_LOCK_UNLOCKED(id_map_default.lock)
+	.lock = __RAW_SPIN_LOCK_UNLOCKED(id_map_default.lock)
 };
 
 /* #define TRACE_ID_DEBUG 1 */
@@ -131,11 +131,11 @@ static void coresight_trace_id_release_all(struct coresight_trace_id_map *id_map
 	unsigned long flags;
 	int cpu;
 
-	spin_lock_irqsave(&id_map->lock, flags);
+	raw_spin_lock_irqsave(&id_map->lock, flags);
 	bitmap_zero(id_map->used_ids, CORESIGHT_TRACE_IDS_MAX);
 	for_each_possible_cpu(cpu)
 		atomic_set(per_cpu_ptr(id_map->cpu_map, cpu), 0);
-	spin_unlock_irqrestore(&id_map->lock, flags);
+	raw_spin_unlock_irqrestore(&id_map->lock, flags);
 	DUMP_ID_MAP(id_map);
 }
 
@@ -144,7 +144,7 @@ static int _coresight_trace_id_get_cpu_id(int cpu, struct coresight_trace_id_map
 	unsigned long flags;
 	int id;
 
-	spin_lock_irqsave(&id_map->lock, flags);
+	raw_spin_lock_irqsave(&id_map->lock, flags);
 
 	/* check for existing allocation for this CPU */
 	id = _coresight_trace_id_read_cpu_id(cpu, id_map);
@@ -171,7 +171,7 @@ static int _coresight_trace_id_get_cpu_id(int cpu, struct coresight_trace_id_map
 	atomic_set(per_cpu_ptr(id_map->cpu_map, cpu), id);
 
 get_cpu_id_out_unlock:
-	spin_unlock_irqrestore(&id_map->lock, flags);
+	raw_spin_unlock_irqrestore(&id_map->lock, flags);
 
 	DUMP_ID_CPU(cpu, id);
 	DUMP_ID_MAP(id_map);
@@ -188,12 +188,12 @@ static void _coresight_trace_id_put_cpu_id(int cpu, struct coresight_trace_id_ma
 	if (!id)
 		return;
 
-	spin_lock_irqsave(&id_map->lock, flags);
+	raw_spin_lock_irqsave(&id_map->lock, flags);
 
 	coresight_trace_id_free(id, id_map);
 	atomic_set(per_cpu_ptr(id_map->cpu_map, cpu), 0);
 
-	spin_unlock_irqrestore(&id_map->lock, flags);
+	raw_spin_unlock_irqrestore(&id_map->lock, flags);
 	DUMP_ID_CPU(cpu, id);
 	DUMP_ID_MAP(id_map);
 }
@@ -204,9 +204,9 @@ static int coresight_trace_id_map_get_system_id(struct coresight_trace_id_map *i
 	unsigned long flags;
 	int id;
 
-	spin_lock_irqsave(&id_map->lock, flags);
+	raw_spin_lock_irqsave(&id_map->lock, flags);
 	id = coresight_trace_id_alloc_new_id(id_map, preferred_id, traceid_flags);
-	spin_unlock_irqrestore(&id_map->lock, flags);
+	raw_spin_unlock_irqrestore(&id_map->lock, flags);
 
 	DUMP_ID(id);
 	DUMP_ID_MAP(id_map);
@@ -217,9 +217,9 @@ static void coresight_trace_id_map_put_system_id(struct coresight_trace_id_map *
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&id_map->lock, flags);
+	raw_spin_lock_irqsave(&id_map->lock, flags);
 	coresight_trace_id_free(id, id_map);
-	spin_unlock_irqrestore(&id_map->lock, flags);
+	raw_spin_unlock_irqrestore(&id_map->lock, flags);
 
 	DUMP_ID(id);
 	DUMP_ID_MAP(id_map);
diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index 6ddcbb8be5165..d5ca0292550b2 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -238,7 +238,7 @@ struct coresight_trace_id_map {
 	DECLARE_BITMAP(used_ids, CORESIGHT_TRACE_IDS_MAX);
 	atomic_t __percpu *cpu_map;
 	atomic_t perf_cs_etm_session_active;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 };
 
 /**
-- 
2.39.5



