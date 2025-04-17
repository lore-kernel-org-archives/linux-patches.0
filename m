Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A15D2517AF;
	Thu, 17 Apr 2025 18:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915514; cv=none; b=c+0p8qMjDRNY8eAXtOPsu/SrX1qGlUzSQ54Pt6kLWlSzRZ//EetK6W4tVEUgLGTz2X5I9RE0JLEHJk1RkE6ifmmLR44rPoEnXhCKmThNJ6lksZ8DjyRCwLZZ+/dbDrb13t7ZBVohB49dsmbtP4thpEPF8qQQSiRVDrt5Vx/NW4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915514; c=relaxed/simple;
	bh=hxIInT2Gf8/huYLT2HwBtk8wCi3wxu7/iVDtbpnxd/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onnEqgCCbYEPeOLbCz8x9O3ATXsuGI6p4dn42LML+xDdFjJaMD/KwPgmy5I5t2VzuIp1dfsAaSCVP9IqEtkhFQM7+X850FqYMT1mHdJTgGWTgVfc8F1Ms2PEATBiOxFpnqnDm7VemR/5Fs2tJ/iBLebv8SKnpI/LVVrxee6KVko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXzdcZfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXzdcZfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A221C4CEE4;
	Thu, 17 Apr 2025 18:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915514;
	bh=hxIInT2Gf8/huYLT2HwBtk8wCi3wxu7/iVDtbpnxd/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXzdcZfg/ngQg2ZiRYnSSOivkkt3HYaJdJ7JA6VX4ILd7C1l4X6VM0tW6bnZMHcWo
	 vrUtZXM94JqbdCRQVa4llG/nUfMjs5zkFrT4QTIjUyQBjb7XTbZYemp0E8c1+uxgo6
	 bhyfFM1weuVXyMh/EdUXhtFLlCsMYl1tbtCCxTRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/393] drm/amdgpu: Fix the race condition for draining retry fault
Date: Thu, 17 Apr 2025 19:49:19 +0200
Message-ID: <20250417175113.613046456@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emily Deng <Emily.Deng@amd.com>

[ Upstream commit f844732e3ad9c4b78df7436232949b8d2096d1a6 ]

Issue:
In the scenario where svm_range_restore_pages is called, but
svm->checkpoint_ts has not been set and the retry fault has not been
drained, svm_range_unmap_from_cpu is triggered and calls svm_range_free.
Meanwhile, svm_range_restore_pages continues execution and reaches
svm_range_from_addr. This results in a "failed to find prange..." error,
 causing the page recovery to fail.

How to fix:
Move the timestamp check code under the protection of svm->lock.

v2:
Make sure all right locks are released before go out.

v3:
Directly goto out_unlock_svms, and return -EAGAIN.

v4:
Refine code.

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 31 +++++++++++++++-------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 8c61dee5ca0db..b50283864dcd2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -2992,19 +2992,6 @@ svm_range_restore_pages(struct amdgpu_device *adev, unsigned int pasid,
 		goto out;
 	}
 
-	/* check if this page fault time stamp is before svms->checkpoint_ts */
-	if (svms->checkpoint_ts[gpuidx] != 0) {
-		if (amdgpu_ih_ts_after(ts,  svms->checkpoint_ts[gpuidx])) {
-			pr_debug("draining retry fault, drop fault 0x%llx\n", addr);
-			r = 0;
-			goto out;
-		} else
-			/* ts is after svms->checkpoint_ts now, reset svms->checkpoint_ts
-			 * to zero to avoid following ts wrap around give wrong comparing
-			 */
-			svms->checkpoint_ts[gpuidx] = 0;
-	}
-
 	if (!p->xnack_enabled) {
 		pr_debug("XNACK not enabled for pasid 0x%x\n", pasid);
 		r = -EFAULT;
@@ -3024,6 +3011,21 @@ svm_range_restore_pages(struct amdgpu_device *adev, unsigned int pasid,
 	mmap_read_lock(mm);
 retry_write_locked:
 	mutex_lock(&svms->lock);
+
+	/* check if this page fault time stamp is before svms->checkpoint_ts */
+	if (svms->checkpoint_ts[gpuidx] != 0) {
+		if (amdgpu_ih_ts_after(ts,  svms->checkpoint_ts[gpuidx])) {
+			pr_debug("draining retry fault, drop fault 0x%llx\n", addr);
+			r = -EAGAIN;
+			goto out_unlock_svms;
+		} else {
+			/* ts is after svms->checkpoint_ts now, reset svms->checkpoint_ts
+			 * to zero to avoid following ts wrap around give wrong comparing
+			 */
+			svms->checkpoint_ts[gpuidx] = 0;
+		}
+	}
+
 	prange = svm_range_from_addr(svms, addr, NULL);
 	if (!prange) {
 		pr_debug("failed to find prange svms 0x%p address [0x%llx]\n",
@@ -3148,7 +3150,8 @@ svm_range_restore_pages(struct amdgpu_device *adev, unsigned int pasid,
 	mutex_unlock(&svms->lock);
 	mmap_read_unlock(mm);
 
-	svm_range_count_fault(node, p, gpuidx);
+	if (r != -EAGAIN)
+		svm_range_count_fault(node, p, gpuidx);
 
 	mmput(mm);
 out:
-- 
2.39.5



