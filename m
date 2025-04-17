Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDA325744F;
	Thu, 17 Apr 2025 18:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914256; cv=none; b=HuerW9iKojJUxzuzdJk1uQ7dDVLqnlNE3JWj4M2HYYcLb1RvWAaaEpF5VyDq4vOgatRd1rmMMkEXmqt08KP/Yj/COuzzxFmFhxmUV5BmqVSkHTdYsIwvA4jaM9fyhzJUIuQcBQxI6XpOLfpEKi3CJ2wn+C/ux/NcEWWCqoZWBq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914256; c=relaxed/simple;
	bh=9+87UxtW2Ih3wIr3BS5bKTJuCjmDAp5FuSdpN8oFQyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTaNhl/tpFP68k3GFbzspkRvAAn6Pf6FBnoGMFJ/NzgK0QcDzYWdDjMkDXDwxynUb12UBZIerpfbz6HBVwZ9VHkR3dMjBXkG2k21HQ3Ia5etcw18AqFfCcMKNulZ4ySjipabfECV4zu9CTPrj3DuMwuF17C4HPLdYZ/nGczTwVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzhSpO7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzhSpO7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4071C4CEE4;
	Thu, 17 Apr 2025 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914255;
	bh=9+87UxtW2Ih3wIr3BS5bKTJuCjmDAp5FuSdpN8oFQyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzhSpO7OjhHL190PqL+VasVfOg1e8V+AFncVAi9WABE+ZD34BHtD65poXnUI6PICz
	 btFY5V9Mf4aXw8rbc2Y8JQoc3dO/9KcNXgMBcHY8h50Wu4Yj6dMD0tfm136MC58HsJ
	 X5Qc4db4hESg6dhcI4ObkrU9ULaCAkxGgJjvmwNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 157/414] drm/amdgpu: Fix the race condition for draining retry fault
Date: Thu, 17 Apr 2025 19:48:35 +0200
Message-ID: <20250417175117.754646563@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 1b04d54f9a69c..4eeea51c9a0eb 100644
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
@@ -3149,7 +3151,8 @@ svm_range_restore_pages(struct amdgpu_device *adev, unsigned int pasid,
 	mutex_unlock(&svms->lock);
 	mmap_read_unlock(mm);
 
-	svm_range_count_fault(node, p, gpuidx);
+	if (r != -EAGAIN)
+		svm_range_count_fault(node, p, gpuidx);
 
 	mmput(mm);
 out:
-- 
2.39.5



