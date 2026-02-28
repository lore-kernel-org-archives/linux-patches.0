Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC396340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301029; cv=none; b=rn+O7HRciCJIE+d6VatLZwJY6T0GK5s0dRXqQXXRRu9y4pjyqOVTSVdwdGtRJ3KDj4sto2/MxFDFr1oeGttiBb20Xc2cbZnaNUSncjythRW66tNI373VfAP7UhD/bH+fNvWsapMxSuzkD+NWZuQ31VY1hz1epV6PDYK17Tv8lhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301029; c=relaxed/simple;
	bh=BzE1gBPpCyLPPTAUrwMVtOT5vUOURwrYx36Nm0Pv+ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oFdGWewIw7+Se/ivau2LlJfTxh+SLvVHJIcHS5x5KDeczW4VCyy1gR4TL+qzBRUPsAlW8s3D8Zr9C2r1b0fPwvFkUEQEGe8ik2Fyh3U39go7mAoKCheqy5JCNJvpnWJ9FE37Pb++vTtdxCd9IYCcjKHcZAbIAdNtwrXEf79E+ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/xwYu6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/xwYu6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF31CC19423;
	Sat, 28 Feb 2026 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301029;
	bh=BzE1gBPpCyLPPTAUrwMVtOT5vUOURwrYx36Nm0Pv+ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/xwYu6di6e/kd/PSDwiUWvCqHcXrq50QXjReBO9X0fQVomIbjQRGtKA2Whb9jFb6
	 SqAfDQlbF+jMolpKfsL9K5ZTZkVjgDmBGWW5gl2LprsGHFezON7jYVLLhPl9xsma6e
	 pB8Dlj5Nf1fSg+/lpDG14/MMoorlT9NsDMDzc5CJa/8iWBea6VP7DrZvWXx2TgK+ak
	 okqWrWyZkHVeBp8C3lgLU8Pdc8Qi1BKRlMrdnxJ17vnYXbid2GW/8FL63WEoXOk3sb
	 NGO39tuoq6QS6ilGYcWF1t+Ebkxm42H4QbAVDwvuV3DCvGKCCG+O1a0LzLDSQWv+5l
	 o4iWJWFZElRqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Donet Tom <donettom@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philip Yang <yangp@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/752] drm/amdkfd: Relax size checking during queue buffer get
Date: Sat, 28 Feb 2026 12:37:58 -0500
Message-ID: <20260228174750.1542406-167-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 42ea9cf2f16b7131cb7302acb3dac510968f8bdc ]

HW-supported EOP buffer sizes are 4K and 32K. On systems that do not
use 4K pages, the minimum buffer object (BO) allocation size is
PAGE_SIZE (for example, 64K). During queue buffer acquisition, the driver
currently checks the allocated BO size against the supported EOP buffer
size. Since the allocated BO is larger than the expected size, this check
fails, preventing queue creation.

Relax the strict size validation and allow PAGE_SIZE-sized BOs to be used.
Only the required 4K region of the buffer will be used as the EOP buffer
and avoids queue creation failures on non-4K page systems.

Acked-by: Christian König <christian.koenig@amd.com>
Suggested-by: Philip Yang <yangp@amd.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
index 80c4fa2b0975d..2822c90bd7be4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -275,8 +275,8 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
 
 	/* EOP buffer is not required for all ASICs */
 	if (properties->eop_ring_buffer_address) {
-		if (properties->eop_ring_buffer_size != topo_dev->node_props.eop_buffer_size) {
-			pr_debug("queue eop bo size 0x%x not equal to node eop buf size 0x%x\n",
+		if (properties->eop_ring_buffer_size < topo_dev->node_props.eop_buffer_size) {
+			pr_debug("queue eop bo size 0x%x is less than node eop buf size 0x%x\n",
 				properties->eop_ring_buffer_size,
 				topo_dev->node_props.eop_buffer_size);
 			err = -EINVAL;
@@ -284,7 +284,7 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
 		}
 		err = kfd_queue_buffer_get(vm, (void *)properties->eop_ring_buffer_address,
 					   &properties->eop_buf_bo,
-					   properties->eop_ring_buffer_size);
+					   ALIGN(properties->eop_ring_buffer_size, PAGE_SIZE));
 		if (err)
 			goto out_err_unreserve;
 	}
-- 
2.51.0

