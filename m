Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4005476058;
	Tue, 21 Jul 2026 17:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656406; cv=none; b=jrbaEpkwvwJGh0GcqKdBzZfMPEicNc88prRSZLKyz3LY+0EIy6MVRusnrETUI922g3NcZy/RK3Kh54jle8d5CwD++/dyEgl2E/iPHjIFQDeRvhy+zSCap2NVRyJ8++q/7TrQb7A4GGPITMsfqmW+0NMcFbYdBuGAsmqIgCJWkTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656406; c=relaxed/simple;
	bh=PS+j3HdasplhqLbU7sfYkO0AkJmRq/ycAJkkJKniT6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuhmitVcEKSAIflr5PxD2VX9JVYXijw3+xTGaiV1sr0T+kaMeVgtB1sWsgNr/PLW64jEXtuDKE2dmvE50iJVF0v81/H3J8keeSheFpwC7AxfmUjQJC5nroE5d74P+eufb3hJ8Ieh1acoKwVv1Vd8IZmy8WYRejO98Ww5pzyv6MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBTX8Rq9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBTX8Rq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A1F1F00A3A;
	Tue, 21 Jul 2026 17:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656405;
	bh=hAZPwQYfq4niOS9BR5I8bQYHAXaxQyBvN+O264hrcoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBTX8Rq9IO+93x/lszj1Ya1Pea/Dyl3hCOMfkJP3o8SFQuQWHa6d7xRBmk9W1DRVF
	 BkTQvlx7walxivDxpdIZk+c7BGgLcbG0OYuW1m6d2HO2K9Ev0kVKSrpQPG0w5Jbmsz
	 TnOpEwQAckpUpmOOezsyp3uXs2HBOcx77AET269k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0332/1611] drm/amdkfd: always resume_all after suspend_all
Date: Tue, 21 Jul 2026 17:07:28 +0200
Message-ID: <20260721152522.566641876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fa183a9db09bdf..18d03f33c62027 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -3073,32 +3073,24 @@ int kfd_dqm_suspend_bad_queue_mes(struct kfd_node *knode, u32 pasid, u32 doorbel
 
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



