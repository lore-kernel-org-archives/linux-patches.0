Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E2B28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0970C4339B;
	Mon, 30 Jan 2023 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087430;
	bh=MwGR2s2lL5hnC3LIoOSoJ2WZAFV1IJjPwVwxdNiDufY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mW2Zj1HI0eowEHtHqeIAImNkUTrAvTC3RpLy5eBO+mXkpiQTJZcbGOYNgJp8aV/Db
	 4+fs9va6rANcl/Ko20hnXNNqvdmhExC8CgY9B53HtVSgaq11FvYHAv+SO0ZEh4o1t5
	 sHLpTSXbHZVjW8n2ftMSMql7iSSxeWo7yKHuxb1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/313] drm/amdkfd: Add sync after creating vram bo
Date: Mon, 30 Jan 2023 14:50:09 +0100
Message-Id: <20230130134344.794833888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit ba029e9991d9be90a28b6a0ceb25e9a6fb348829 ]

There will be data corruption on vram allocated by svm
if the initialization is not complete and application is
writting on the memory. Adding sync to wait for the
initialization completion is to resolve this issue.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 64fdf63093a0..63feea08904c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -570,6 +570,15 @@ svm_range_vram_node_new(struct amdgpu_device *adev, struct svm_range *prange,
 		goto reserve_bo_failed;
 	}
 
+	if (clear) {
+		r = amdgpu_bo_sync_wait(bo, AMDGPU_FENCE_OWNER_KFD, false);
+		if (r) {
+			pr_debug("failed %d to sync bo\n", r);
+			amdgpu_bo_unreserve(bo);
+			goto reserve_bo_failed;
+		}
+	}
+
 	r = dma_resv_reserve_fences(bo->tbo.base.resv, 1);
 	if (r) {
 		pr_debug("failed %d to reserve bo\n", r);
-- 
2.39.0



