Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAED83C09E0;
	Sat, 17 Oct 2026 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259829; cv=none; b=cn4WR4ZmLfJbWyxstndRbylTs0kufc1ZX4oXI3z7QAnJ5J0pV+rbuR22Whppd08KTb5NQJC579MCTjhbOtNqt+pToq61aZ4JfhDXfg5DbpwIsEYjyP2J0khbFtYG1qraQL2HSzyEBmtBWo9Ox9CDwPuBpE8opT8srm4KiKh6IvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259829; c=relaxed/simple;
	bh=8YPkNezbRzrJr2qpjIQcHY37RnUtHvimVYYHO0BihE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7rNVNY5FnXfRnxURN09qVReRsYf2FkCp67jqQYl4zdi8jxzdlhAcAq/xp+tB89T1Pj+5j5etp+7NVXsJbrsPILALfoOwEcIFwlL4P8lGfUnZvB745NVVvNpzBiZwkC+mByE0ovjQIYqDmq/Ucl4ztGGd8SkbzxrbN0Pxo6NviI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDuOslNy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDuOslNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E15F1F000C4;
	Sat, 17 Oct 2026 17:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259828;
	bh=eubviB7C4SHMmgqb0tyWqWcpb918UlG/bvcZE7h0bQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDuOslNyTemoHC4RQm2TJNYEPipf5zmqDnc3nqDYt73uS2JJuP4I6T7SJdsG2149e
	 VLi67ds3CTHZGaPamKWHJit2pHbzVAPvkHHy5eVCPeaQJo+Sf+k1wjd+MQXP+KfVKd
	 Vp6cZOJPxPxgGkOqB2/SwmuAPDaoGSHeVI8r0iSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priya Hosur <Priya.Hosur@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1344/1674] drm/amdkfd: Add TLB flush after MES queue eviction/suspension
Date: Sat, 17 Oct 2026 18:00:16 +0200
Message-ID: <20261017160505.654855932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priya Hosur <Priya.Hosur@amd.com>

[ Upstream commit 94e25cb6ab7f4f025bcdcd8ea79fda30f12843a4 ]

MES (Micro Engine Scheduler) does not perform heavy-weight TLB
invalidation after unmapping queues, unlike HWS which does this
automatically. This causes a race condition where in-flight DMA
descriptors can access memory that has been unmapped, leading to page
faults and GPU queue hangs during SVM page migration.

The issue manifests as KFDSVMRangeTest.MultiThreadMigrationTest
failures on gfx1151 (Strix Point) with XNACK mode 1 enabled - the GPU
compute queue hangs with packets submitted but never consumed.

Add kfd_flush_tlb() calls after MES queue removal in two locations:
- evict_process_queues_cpsch(): after all queues removed during eviction
- suspend_queues(): after debug/criu queue suspension (with mem_fence barrier)

This ensures all in-flight memory accesses from unmapped queues are
flushed before memory is freed or migrated.

Signed-off-by: Priya Hosur <Priya.Hosur@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f5c4f88e0f9c45a8fb9dfac0c1df726c95e41b77)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 6b274e4f0af35..7e4bba9d07f8b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1151,6 +1151,14 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 			}
 		}
 	}
+	/*
+	 * Heavy-weight TLB flush after MES removes queues to ensure
+	 * in-flight memory accesses complete before memory is freed/migrated.
+	 * HWS does this automatically, MES does not.
+	 */
+	if (dqm->dev->kfd->shared_resources.enable_mes)
+		kfd_flush_tlb(pdd, TLB_FLUSH_HEAVYWEIGHT);
+
 	pdd->last_evict_timestamp = get_jiffies_64();
 	if (!dqm->dev->kfd->shared_resources.enable_mes)
 		retval = execute_queues_cpsch(dqm,
@@ -2992,8 +3000,12 @@ int suspend_queues(struct kfd_process *p,
 		if (!per_device_suspended) {
 			dqm_unlock(dqm);
 			mutex_unlock(&p->event_mutex);
-			if (total_suspended)
+			if (total_suspended) {
 				amdgpu_amdkfd_debug_mem_fence(dqm->dev->adev);
+				/* Heavy-weight TLB flush after MES suspends queues */
+				if (pdd->drm_priv)
+					kfd_flush_tlb(pdd, TLB_FLUSH_HEAVYWEIGHT);
+			}
 			continue;
 		}
 
-- 
2.53.0



