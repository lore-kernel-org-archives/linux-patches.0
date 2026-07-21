Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2889379C3C;
	Tue, 21 Jul 2026 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649156; cv=none; b=Cox2Uoqhv+xycLP3I91m1xjQn3SHfuRYONz+MxWs/SJRwq1+GTRb1WWjjet6Vf2/ftK3YkSUQqX1zZwhrJn35B0SfBPYSQBPjc8KRcH6pOHt71EQr44HbepbGDSqYSH25ZC9M17e7+13raK78q35L0ed2Nipxa2BapD87nxJoTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649156; c=relaxed/simple;
	bh=Tapg4DcJexSZkYUH7Ji7C87+VlfL2VXmBT51FbhCPlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3HcU9w4DAgjerlTQzJwcPwiuLNhwK34uaFi1HTD6+ea7zIJcaB5yL9RewpzdUF15R8rI/yI8Tp5+fw1RY+c+pgeW9YHg3av86cc1P0D0+EA67hM0Weqi+qSu3r9p6M/54b74Lekm1uPL/a7fD2o2bBImuq2bG6C6hjHSX9My3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGQOC0yr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGQOC0yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF451F000E9;
	Tue, 21 Jul 2026 15:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649155;
	bh=20H5JX+wo54k5ydHEkReNnB0hzlZNyg1e4YyAbQcPCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGQOC0yrmXPk/o5WKmxBRD8P+XRAZx75FPUC4MWfIcbDLqnU0aWpnwrdYAM0YoqFz
	 LOzkZ6bkp5wvVIlwUbO4oCYEB2QnMoCKJVlswfnfrt8yMATEYOZIy6+dqxXWPaOuKm
	 zYuOdM5Y43aaQtj76s/abRkdcp1bVDAzQQ0bV/go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0472/2077] drm/amdkfd: always resume_all after suspend_all
Date: Tue, 21 Jul 2026 17:02:25 +0200
Message-ID: <20260721152603.931566938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 31187ddbb79ea2..ee413117b0ff68 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -3095,32 +3095,24 @@ int kfd_dqm_suspend_bad_queue_mes(struct kfd_node *knode, u32 pasid, u32 doorbel
 
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
 	kfd_unref_process(p);
 	return ret;
-- 
2.53.0



