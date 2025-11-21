Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED72A3F9D2;
	Fri, 21 Nov 2025 13:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730928; cv=none; b=dcqCtCks8LfPuVeaGhLKSSZi8iUUPODr1qh8XIt4XbNQmkYd6eEIA+4ctbfRL4JlcHI+DL1N43YfamnSoAgbOr5mphojgPXZ4ACzt9cOL1jsfTrbd/b5U+61vFh26W1Vtr1OTWzNL6ZqK2xdF2pYdeNMpt6s1MyOtznFXKuNXRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730928; c=relaxed/simple;
	bh=QLwipdWQcfxEy4gT3589nfZJx2sqPRV6ASC2LnzRJHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0DoL+uL9huHdEkN6Uk6FRBIuvD2Q4oJUW8md8BponbJWL1BdN+Isf7Y3ToK1gj4WknhgxNlKVXgYjVQ+oTmjI+Of5DbRjWw8OtnkI6HxoKERQFE2FkoLaoOsvWownsw2NiEzTzJdS0sKzDT7jgu1PG2V7uDj791/jo+Q8sQLaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyJHe1fU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyJHe1fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F49C4CEF1;
	Fri, 21 Nov 2025 13:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730927;
	bh=QLwipdWQcfxEy4gT3589nfZJx2sqPRV6ASC2LnzRJHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyJHe1fUrgUyL8o7hzVIMAzrJmFiN8gn39Y5EaiUs5piTF8b7FKvzqmdKTzWrSjJD
	 eXyZARiOg1Dc9hBpZ2Z9XmI33mbuy3sPhkUhh8vGniwdRmKB4inN03OgtxRtSHlS+t
	 LZEpwgGwnzfyKgViPPa9QVD6pAHGjWQxnpL/3s3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 030/247] drm/amdkfd: fix suspend/resume all calls in mes based eviction path
Date: Fri, 21 Nov 2025 14:09:37 +0100
Message-ID: <20251121130155.685554184@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit 079ae5118e1f0dcf5b1ab68ffdb5760b06ed79a2 ]

Suspend/resume all gangs should be done with the device lock is held.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 73 ++++++-------------
 1 file changed, 21 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 6c5c7c1bf5eda..6e7bc983fc0b6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1209,6 +1209,15 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 	pr_debug_ratelimited("Evicting process pid %d queues\n",
 			    pdd->process->lead_thread->pid);
 
+	if (dqm->dev->kfd->shared_resources.enable_mes) {
+		pdd->last_evict_timestamp = get_jiffies_64();
+		retval = suspend_all_queues_mes(dqm);
+		if (retval) {
+			dev_err(dev, "Suspending all queues failed");
+			goto out;
+		}
+	}
+
 	/* Mark all queues as evicted. Deactivate all active queues on
 	 * the qpd.
 	 */
@@ -1221,23 +1230,27 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 		decrement_queue_count(dqm, qpd, q);
 
 		if (dqm->dev->kfd->shared_resources.enable_mes) {
-			int err;
-
-			err = remove_queue_mes(dqm, q, qpd);
-			if (err) {
+			retval = remove_queue_mes(dqm, q, qpd);
+			if (retval) {
 				dev_err(dev, "Failed to evict queue %d\n",
 					q->properties.queue_id);
-				retval = err;
+				goto out;
 			}
 		}
 	}
-	pdd->last_evict_timestamp = get_jiffies_64();
-	if (!dqm->dev->kfd->shared_resources.enable_mes)
+
+	if (!dqm->dev->kfd->shared_resources.enable_mes) {
+		pdd->last_evict_timestamp = get_jiffies_64();
 		retval = execute_queues_cpsch(dqm,
 					      qpd->is_debug ?
 					      KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES :
 					      KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0,
 					      USE_DEFAULT_GRACE_PERIOD);
+	} else {
+		retval = resume_all_queues_mes(dqm);
+		if (retval)
+			dev_err(dev, "Resuming all queues failed");
+	}
 
 out:
 	dqm_unlock(dqm);
@@ -3098,61 +3111,17 @@ int kfd_dqm_suspend_bad_queue_mes(struct kfd_node *knode, u32 pasid, u32 doorbel
 	return ret;
 }
 
-static int kfd_dqm_evict_pasid_mes(struct device_queue_manager *dqm,
-				   struct qcm_process_device *qpd)
-{
-	struct device *dev = dqm->dev->adev->dev;
-	int ret = 0;
-
-	/* Check if process is already evicted */
-	dqm_lock(dqm);
-	if (qpd->evicted) {
-		/* Increment the evicted count to make sure the
-		 * process stays evicted before its terminated.
-		 */
-		qpd->evicted++;
-		dqm_unlock(dqm);
-		goto out;
-	}
-	dqm_unlock(dqm);
-
-	ret = suspend_all_queues_mes(dqm);
-	if (ret) {
-		dev_err(dev, "Suspending all queues failed");
-		goto out;
-	}
-
-	ret = dqm->ops.evict_process_queues(dqm, qpd);
-	if (ret) {
-		dev_err(dev, "Evicting process queues failed");
-		goto out;
-	}
-
-	ret = resume_all_queues_mes(dqm);
-	if (ret)
-		dev_err(dev, "Resuming all queues failed");
-
-out:
-	return ret;
-}
-
 int kfd_evict_process_device(struct kfd_process_device *pdd)
 {
 	struct device_queue_manager *dqm;
 	struct kfd_process *p;
-	int ret = 0;
 
 	p = pdd->process;
 	dqm = pdd->dev->dqm;
 
 	WARN(debug_evictions, "Evicting pid %d", p->lead_thread->pid);
 
-	if (dqm->dev->kfd->shared_resources.enable_mes)
-		ret = kfd_dqm_evict_pasid_mes(dqm, &pdd->qpd);
-	else
-		ret = dqm->ops.evict_process_queues(dqm, &pdd->qpd);
-
-	return ret;
+	return dqm->ops.evict_process_queues(dqm, &pdd->qpd);
 }
 
 int reserve_debug_trap_vmid(struct device_queue_manager *dqm,
-- 
2.51.0



