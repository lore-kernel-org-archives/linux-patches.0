Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98334288C01;
	Tue, 22 Jul 2025 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192755; cv=none; b=BF/5isxx6TXFAFY/qprA3gaoTwht0d2OvdZ1afhaE2C12pNIjooGOqBlWFhzmCjXs++AfmyVy+RvblsnzrzzpgR+H4x1CanbjHx1iIlDbjuAgrLNuYEMwp7rNux8cMVY5CMjfXUrLkiU0jJgDFErXi9f36lX69OkXxYyWEN1SzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192755; c=relaxed/simple;
	bh=atazycSlGP97zp9ICzaIcL+FJxNVftlYn/DdB62puRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jujFejX9xvWPty3Zf63V3jf4XoP7uQX9Jom9kntnhaDq4eIPWmF3FmbQquUl0EJ4sMuJ24Auwmi7GWE5tLCV38wEpd90cS8SW8sp557Xzlq/am63/vrHmNQYFtWDxENW2yR1EyHyIrIUSySv7cALdi/cFk9/qziAaM/R7qHTEtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M57eP/AI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M57eP/AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F88C4CEEB;
	Tue, 22 Jul 2025 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192755;
	bh=atazycSlGP97zp9ICzaIcL+FJxNVftlYn/DdB62puRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M57eP/AIT7Tzeq0rQmKrK/OLYOQFVOHqEJtfmv9zc7KGY+uOSRxy9ae5lD6FJqLAP
	 43o0WSKgHDUJQnywRWP1zB0PZMw46+WF/M+ySTk34ytOl/ki6mYByvJftyNBma90U8
	 kRXTqYU9cn9M84S6Iyrsn4SFj15TBiE6mjb5PFFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 030/158] drm/amdgpu: Increase reset counter only on success
Date: Tue, 22 Jul 2025 15:43:34 +0200
Message-ID: <20250722134341.868086679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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
@@ -439,6 +439,7 @@ bool amdgpu_ring_soft_recovery(struct am
 {
 	unsigned long flags;
 	ktime_t deadline;
+	bool ret;
 
 	if (unlikely(ring->adev->debug_disable_soft_recovery))
 		return false;
@@ -453,12 +454,16 @@ bool amdgpu_ring_soft_recovery(struct am
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


