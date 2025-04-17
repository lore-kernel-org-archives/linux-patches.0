Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FCD22E3E6;
	Thu, 17 Apr 2025 18:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913007; cv=none; b=qfZh0NL2X3COTBtNvt76dDTOVNbXJ0SDt6hW/WqWBI+W0NBB2k8o1GVGDMcsA0QKlXZEUow4/FtgwIeLhTiO5QjTvdB8Yf4eyv/8skGbBex1I1E8nMRBNJ5vWtR6RFzsGvGIdOOQhOBEf/KChN0F/FQZeaq29JTu/injAYOzdc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913007; c=relaxed/simple;
	bh=RR9sc7IQyLszuV6t+3GS3TPKFcilhcd4/bJ8FVL7BWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/FeNji3id1nJo5GEQxNYc3Si4ccREQb3AJuYxnTHaP55WPeMuvGiRaZQNtTIUdSaCwWz1tlcbAesjdPAG2eY1iRqOElyDLlhnlxV6exzE4AoD6LGEOlNsM/Z0E67x8NhiPT+jCZLwgHdINwXywa0Dqg6HelmhbSHVKf0QlfWp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ow3tJzCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ow3tJzCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E693C4CEEA;
	Thu, 17 Apr 2025 18:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913007;
	bh=RR9sc7IQyLszuV6t+3GS3TPKFcilhcd4/bJ8FVL7BWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ow3tJzCbm1suHDPCgt8OxKcj4p0OR5vFSkxWL8DI/vm+shtLETT27L+gzcZOP5yLE
	 w1KPNfat2dkpvfpyYgSC41t2c3Wp/Xo4SeEDvKOoIfJyi/TJFWt7sU944CNjdqns9g
	 gBtcHALGPb20AO00MiNWo0dDUlcjPXGm9JUlo2N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 167/449] drm/amdkfd: Fix pqm_destroy_queue race with GPU reset
Date: Thu, 17 Apr 2025 19:47:35 +0200
Message-ID: <20250417175124.702648534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 7919b4cad5545ed93778f11881ceee72e4dbed66 ]

If GPU in reset, destroy_queue return -EIO, pqm_destroy_queue should
delete the queue from process_queue_list and free the resource.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 6c02bc36d6344..d79caa1a68676 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -548,7 +548,7 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 			pr_err("Pasid 0x%x destroy queue %d failed, ret %d\n",
 				pqm->process->pasid,
 				pqn->q->properties.queue_id, retval);
-			if (retval != -ETIME)
+			if (retval != -ETIME && retval != -EIO)
 				goto err_destroy_queue;
 		}
 		kfd_procfs_del_queue(pqn->q);
-- 
2.39.5



