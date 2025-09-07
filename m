Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B279D528;
	Sun,  7 Sep 2025 20:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276804; cv=none; b=ivVSB7SvJUus2dq4cOJIhAsuvVjDRMcDbQPbtT01fPaL5OUISrZ/bgJBuHOoS+cYFKfK59dxUIbvHAWweCgKiHUuHg0hDNWPdT4ZafZFZXYEBIVfVMUbZCdfyeporJbTPpeAju5LQIgHMkC3FHhlb4kxyXq2t3PTkIAzn6lHsQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276804; c=relaxed/simple;
	bh=9nwNBIALRDMR3h/I35sq213paScKty787gFU/aYQVfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLb/fozGt4TIXs1NbkR7HoBXz90xrEuihPjzSMxqpjdgqURy8QdxDnaf8ahqsjt1x8is6m4k9ethwUL50ZvKdf4HuvbXUOVU5NnrdKp4osRSFzwNWHDqf8uK8J4toACDfnewY1qWiQ6bGqANF25F00KJbaiskJkEkDDXDUomgOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKftRTXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKftRTXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF52C4CEF0;
	Sun,  7 Sep 2025 20:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276804;
	bh=9nwNBIALRDMR3h/I35sq213paScKty787gFU/aYQVfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKftRTXBvLXWVMSKIog8BbqhRBsIfSy+DQ5YgpmtDDHYI9JEuFLwWJm3quw3TKvfa
	 SY5eP1VWZuGOwxdS+WgxFa6QAK/vJk0mNoe3cmWgfu7x3sonMoG5FyksKoNUhoqZui
	 aQy2I6Lh9DSgpEHDV+vVrmpc3zq313Ybyms338vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 098/121] Revert "drm/amdgpu: Avoid extra evict-restore process."
Date: Sun,  7 Sep 2025 21:58:54 +0200
Message-ID: <20250907195612.368834750@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

This reverts commit a3201e3b7cf10bcd3d7eef4859d275eb6d98e12a which is
commit 1f02f2044bda1db1fd995bc35961ab075fa7b5a2 upstream.

This commit introduced a regression, however the fix for the regression:
aa5fc4362fac ("drm/amdgpu: fix task hang from failed job submission
during process kill") depends on things not yet present in 6.12.y and
older kernels.  Since this commit is more of an optimization, just
revert it for 6.12.y and older stable kernels.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x - 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2125,11 +2125,13 @@ void amdgpu_vm_adjust_size(struct amdgpu
  */
 long amdgpu_vm_wait_idle(struct amdgpu_vm *vm, long timeout)
 {
-	timeout = drm_sched_entity_flush(&vm->immediate, timeout);
+	timeout = dma_resv_wait_timeout(vm->root.bo->tbo.base.resv,
+					DMA_RESV_USAGE_BOOKKEEP,
+					true, timeout);
 	if (timeout <= 0)
 		return timeout;
 
-	return drm_sched_entity_flush(&vm->delayed, timeout);
+	return dma_fence_wait_timeout(vm->last_unlocked, true, timeout);
 }
 
 /**


