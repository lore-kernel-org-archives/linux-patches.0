Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EED946EF7A;
	Tue, 21 Jul 2026 19:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661995; cv=none; b=hTHoUHQ/z/SDCy05n3gN2cJYMOCF8U5daKJ8AYciCfWr0+uHBkrhH7V5H2sxWH64EqjyqPegjqDt3uNBHXbwOaH9hX1VWyq7w0XpNt+pIVUafC1w4Qa0FZq05W9pMQSxfDETOorKRFo5TM9/Cus5/6smEpxxHnGSZ50rvMJkNlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661995; c=relaxed/simple;
	bh=ecZkZEpZMZ+cx1M9wyeIv9tUj5kieqklucLamjfR7YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZU4LRlbg1Xa6z5MWu1zBmFu3HPIrm5AoMxusxqSloZ/MbH1vpofP0BJzcfMTli7zDgJaiyRwbsR9BgFJdp1wExli3RnPxyJWhDhYtRav02g8N3BjvirsxD75Wvy1zL+Y9fQM0OtYmMkh4gxViWuLdFMZqgcWUT4DULHWfPT0ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGwKbUQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGwKbUQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE881F000E9;
	Tue, 21 Jul 2026 19:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661993;
	bh=wGtH8PtC939p/i88QhaNixDkj34qGiHLz2OdAy48hHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGwKbUQaOjg3/zq9tgS50fDS95I0Zw8jcaMEkjadJkNHEUbFzrYKbXwxtyvZfGuMN
	 WiEfBU72+lXNNLUIAdqSnAtIwveeuqpidpHUHPZxbAP1bbCfdVJAYa8QTI+p802hKU
	 IL5DkTaGHL8H/fqSGWdSzCIizcb7ypO7BgfZzlio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0234/1276] drm/amdkfd: always resume_all after suspend_all
Date: Tue, 21 Jul 2026 17:11:17 +0200
Message-ID: <20260721152451.327597687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 56ae73c92e200e630c2bdf1e98c88b86c8483b37 ]

Need to restore any good queues even if the suspend_all
failed for some.  Always run remove_queue as that will
schedule a GPU reset is removing the queue fails.

v2: move resume_all after remove

Fixes: eb067d65c33e ("drm/amdkfd: Update BadOpcode Interrupt handling with MES")
Reviewed-by: Amber Lin <Amber.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 20 ++++++-------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index e19f088c7dcf06..9035eebe9cd63b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2925,32 +2925,24 @@ int kfd_dqm_suspend_bad_queue_mes(struct kfd_node *knode, u32 pasid, u32 doorbel
 
 		list_for_each_entry(q, &qpd->queues_list, list) {
 			if (q->doorbell_id == doorbell_id && q->properties.is_active) {
-				ret = suspend_all_queues_mes(dqm);
-				if (ret) {
-					dev_err(dev, "Suspending all queues failed");
-					goto out;
-				}
+				/* suspend all queues will save any good queues and mark the rest as bad */
+				suspend_all_queues_mes(dqm);
 
 				q->properties.is_evicted = true;
 				q->properties.is_active = false;
 				decrement_queue_count(dqm, qpd, q);
 
+				/* this will remove the bad queue and sched a GPU reset if needed */
 				ret = remove_queue_mes(dqm, q, qpd);
-				if (ret) {
-					dev_err(dev, "Removing bad queue failed");
-					goto out;
-				}
-
-				ret = resume_all_queues_mes(dqm);
 				if (ret)
-					dev_err(dev, "Resuming all queues failed");
-
+					dev_err(dev, "Removing bad queue failed");
+				/* resume the good queues */
+				resume_all_queues_mes(dqm);
 				break;
 			}
 		}
 	}
 
-out:
 	dqm_unlock(dqm);
 	return ret;
 }
-- 
2.53.0



