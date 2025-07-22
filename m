Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F52CA32;
	Tue, 22 Jul 2025 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193362; cv=none; b=bSZ9qA9tkVLICpikp9vFa+2WxgKwxVR/Q5hCpajwswcFEewlIG0O2JHOXkjVDLHu0Wuvtd0OAD0Z6HgpprqpARcy9LG0FTj8d/p4YM8pBM81Z0lYdule7OoD2pFqDUbbCBK4qbq6bV6vsy/EhxgBmHmE9xxMIwn7SQc8WP7yn/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193362; c=relaxed/simple;
	bh=7372EADKLiKZ1Gd/Jn1tHc8+bC9UfXIzAlEVgxiJFhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+jfPIOwIoHsHgSaFJM7nz0bt88BxDgETGKTuKigMKm3xMCi0fEyHebuKIFUeyqfJ2uJPRCCGNLxiZmYHpiYwKdHw4PvRmIPBzaP/ZEn3z14jT8B+S1h73pddS7R6w3EcyWVqMIz8gz182cFYTaCqdVkGc79ZdYIMrlXNmp8fMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB1JRHxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB1JRHxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21F6C4CEEB;
	Tue, 22 Jul 2025 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193362;
	bh=7372EADKLiKZ1Gd/Jn1tHc8+bC9UfXIzAlEVgxiJFhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TB1JRHxlJSuLmQGUNPimwKdFt6kIYH8A4bxZsLSiXXgj9mg2dmYpZNRVfHXu4tndD
	 Klajb5eajQvqlCHRKyMurMaGL02m6t4LkKJisIwngJJGHhONmf/APcxEI2n/LcOFlu
	 GU9TTczRfyjPId1awLzr+DOYD0syJRdvfR3/QF24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 035/187] drm/amdgpu: Increase reset counter only on success
Date: Tue, 22 Jul 2025 15:43:25 +0200
Message-ID: <20250722134347.066733062@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 86790e300d8b7bbadaad5024e308c52f1222128f upstream.

Increment the reset counter only if soft recovery succeeded. This is
consistent with a ring hard reset behaviour where counter gets
incremented only if hard reset succeeded.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 25c314aa3ec3d30e4ee282540e2096b5c66a2437)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -463,6 +463,7 @@ bool amdgpu_ring_soft_recovery(struct am
 {
 	unsigned long flags;
 	ktime_t deadline;
+	bool ret;
 
 	if (unlikely(ring->adev->debug_disable_soft_recovery))
 		return false;
@@ -477,12 +478,16 @@ bool amdgpu_ring_soft_recovery(struct am
 		dma_fence_set_error(fence, -ENODATA);
 	spin_unlock_irqrestore(fence->lock, flags);
 
-	atomic_inc(&ring->adev->gpu_reset_counter);
 	while (!dma_fence_is_signaled(fence) &&
 	       ktime_to_ns(ktime_sub(deadline, ktime_get())) > 0)
 		ring->funcs->soft_recovery(ring, vmid);
 
-	return dma_fence_is_signaled(fence);
+	ret = dma_fence_is_signaled(fence);
+	/* increment the counter only if soft reset worked */
+	if (ret)
+		atomic_inc(&ring->adev->gpu_reset_counter);
+
+	return ret;
 }
 
 /*


