Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A6F1D88D0;
	Sun,  7 Sep 2025 20:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276350; cv=none; b=Jo3Gi2xORDNvrqZQEAqqEQ6T+br5zEXyZm3Thg0M0sH9z8hgoNOYpk3VsY4Hc3aWykO2K+15oNX8NZXlyRz2gzZGe6n13PIIbdGxIFPczqDXRFYCZsj5yE7Or0gfTSw75fw4coWWR7NOOlx6f+SsJt5sncMI1JmEJFRM58YNWdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276350; c=relaxed/simple;
	bh=hpny7kz4F3gEbLhGEDWqgQVCdisZ0q4uB2jqv5jzh0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCa2JqBXthx+2/6vY1RLCANvzddvtOshzAmpcWq6HP/NDi6s1trb/d+6d+lMSvrMxxrKMMN0s2w/RvoC5zHhVR0Db/+YOGf4ww2lf30GcFhdZmZDpLxTPHJtoDSfa/zVGEMmpivZMUZBcQVXcdUI3nCzUen5JIVxn4EY2Guoo9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNOkkgyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNOkkgyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E7FC4CEF0;
	Sun,  7 Sep 2025 20:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276350;
	bh=hpny7kz4F3gEbLhGEDWqgQVCdisZ0q4uB2jqv5jzh0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNOkkgyjbsjrTaheUb8k+R7bHzOc1PTrpR4gFFtUMjzTs7Mpyv3Kqfy5eVtiJPPYT
	 JoAyKtC1zIR3GlU6Ul/fgbwmcTwu3fN6i8pLxxbXB9StZUpKMsdCgLDqP/6qlg+Bds
	 RcjskLtXNDQTxqgUu95WdYrGZmkU+AlGucwUgrYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 078/104] Revert "drm/amdgpu: Avoid extra evict-restore process."
Date: Sun,  7 Sep 2025 21:58:35 +0200
Message-ID: <20250907195609.697698934@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

This reverts commit 71598a5a7797f0052aaa7bcff0b8d4b8f20f1441 which is
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
@@ -2024,11 +2024,13 @@ void amdgpu_vm_adjust_size(struct amdgpu
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


