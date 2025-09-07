Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662181DE8AF;
	Sun,  7 Sep 2025 20:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277300; cv=none; b=B9VTYdRPiHnoeSAckswJMAzrzFPD3s3ge2lY/rb2LwzQtusE3erN0oP53sxmuL+QsWecpCT/zlfV1rD3IOb5uEo9o2E8rVwyODCe3skZZ6AbvUYpCEGw3Pe73lY6LreiKDZCYq7Xq9GWtTy4pPo8bWoT6IAyyjwQbCCubrHeqWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277300; c=relaxed/simple;
	bh=rQzHRK7+JQ4neuRN9VeQQ5jd4Lax/7FUKAss6bc8ctQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iH3BdJ7ynWDXeDrj0vzjaDIMN+mJT5xmuUlN0+7w0Jn4RG4pEFqIQniNLGq5X2WRrgj+fAXBCn5DyHkp+VHIF8T2+wvZ6Fk33xXad1J8EmpbEjZ/AiNPRSjPfCaJdaUOZ2faqcnAfnlemMUWzdJNljAW/1pnVJF5uuGMymumdzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V51p1TaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V51p1TaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDCCC4CEF0;
	Sun,  7 Sep 2025 20:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277300;
	bh=rQzHRK7+JQ4neuRN9VeQQ5jd4Lax/7FUKAss6bc8ctQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V51p1TaOXRZgjLZflj3x8z/13zLnZfmBiD/04eYeDWvnNt0I7GmOeyIQwdzxKYajp
	 UfSniGSsaZWpBqI0AxBn1tleLMPYkYTOAKhc4Z7pFDvnrOsIGkdRlYU/T4zhuz82Ox
	 DLoqOtGWQ3mGp76xYFtZhMoS0YC82wliWaHSr7Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 149/175] Revert "drm/amdgpu: Avoid extra evict-restore process."
Date: Sun,  7 Sep 2025 21:59:04 +0200
Message-ID: <20250907195618.379899492@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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
@@ -2292,11 +2292,13 @@ void amdgpu_vm_adjust_size(struct amdgpu
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
 
 static void amdgpu_vm_destroy_task_info(struct kref *kref)


