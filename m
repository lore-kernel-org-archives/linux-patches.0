Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB172580CC;
	Mon,  9 Jun 2025 13:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476849; cv=none; b=U0Vfwd0gujWqW+qDmj6SgjyN7S2ydHEsvJm9NAzct2m2PnEbjpWGWd6yP6geWcAN/3VTHaYtAVjffpelYF7APG1fBIpKgzXCj0IVADyoSzZRg/rvlDlpAWMbiM2Ik+AT07LNtjcYyrfP8CY1eeczIwNQdynNKschBYnw64mbboo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476849; c=relaxed/simple;
	bh=HbKVVEbnkk8gbo7YK/Y1ugepkRcYjELGxIZ+UCbmhpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BIeXibCMsYIeKxBn/w/FNXQIsB9GVYvokCLVB8uMl9333pPBSlWSqT6MCdskP6ml3+EpFhYixqmUd55qf2Jdfs52ktzyqPFhLX6mA5BwZ0XrFiDOvlfa7ZC6R+QQec6X5Rv7x5w2DlgrlJZKQtepib/uJbmP/qmQ9sF8bo1VRCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FItY5wN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FItY5wN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E4DC4CEF0;
	Mon,  9 Jun 2025 13:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476849;
	bh=HbKVVEbnkk8gbo7YK/Y1ugepkRcYjELGxIZ+UCbmhpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FItY5wN2rXmOD2InpzX9sAOzTGN+382PsC5o0BEapu7RX1fwCh8y0oiV3LGuAg53p
	 WsIyZ9sVxKdv3RHj+/zIpkAEQZByFfzmuf52olh8QyQiWmMrBYg2O67FmJdjOrRSqx
	 mikVRHx1Ks6z2NJ6gKhQG3aTIWnq/tbUedWEGKVfmTRl7NO3FPpAzYTkrPCvLqH7sy
	 jo5ZxAR1vrMuKZOacgFsK2RLSX+yp8+7qW7K4alIz8IH9U45QV8iz1jxC8rDkexu4c
	 Epo/vf6+MPtdiw8XwO9yftmDtGfbJS3zQ/RVYKF2iJjduKIFDFjiYmHZTSK6Z9Y6on
	 jeEmnZhZzwoIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yifan Zhang <yifan1.zhang@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 02/16] amd/amdkfd: fix a kfd_process ref leak
Date: Mon,  9 Jun 2025 09:47:11 -0400
Message-Id: <20250609134725.1344921-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134725.1344921-1-sashal@kernel.org>
References: <20250609134725.1344921-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.141
Content-Transfer-Encoding: 8bit

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 90237b16ec1d7afa16e2173cc9a664377214cdd9 ]

This patch is to fix a kfd_prcess ref leak.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Bug Analysis

This patch fixes a clear **resource leak bug** where a reference count
is not properly decremented in an error path. Specifically:

1. **The leak occurs in `kfd_signal_poison_consumed_event()`** at line
   1334 where the function returns early without calling
   `kfd_unref_process(p)`:
  ```c
  if (unlikely(user_gpu_id == -EINVAL)) {
  WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%x\n", dev->id);
  return;  // BUG: Missing kfd_unref_process(p)
  }
  ```

2. **The function `kfd_lookup_process_by_pasid()` increments the
   reference count** on the kfd_process object (as confirmed by
   examining the kernel source). This means every successful call must
   be paired with `kfd_unref_process()`.

3. **The fix is minimal and correct**: It simply adds the missing
   `kfd_unref_process(p)` call before the early return, ensuring the
   reference count is properly decremented.

## Why This Should Be Backported

1. **It's a clear bug fix**: This fixes a reference count leak that will
   cause memory to be leaked every time this error path is hit. Over
   time, this could lead to significant memory exhaustion.

2. **The fix is minimal and contained**: Only one line is added, making
   it low-risk for regression. The change doesn't alter any logic or
   introduce new features.

3. **It affects user-visible behavior**: When GPU errors occur and this
   code path is triggered repeatedly, the memory leak could impact
   system stability and performance.

4. **Similar to previously backported commits**: Looking at the
   historical examples, commit #4 which also fixed a memory leak in
   create_process failure was marked for backporting and included "Cc:
   stable@vger.kernel.org".

5. **The bug is in error handling code**: While the error condition
   might be rare (invalid GPU ID), when it does occur, the leak happens
   every time. Error handling bugs are particularly important to fix
   because they can accumulate unnoticed.

6. **No architectural changes**: This is a simple bug fix that doesn't
   change any APIs, data structures, or introduce new functionality.

The commit follows the stable kernel rules perfectly: it fixes a real
bug, is minimal in scope, has clear consequences if not fixed (memory
leak), and doesn't introduce new features or risky changes.

 drivers/gpu/drm/amd/amdkfd/kfd_events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 2880ed96ac2e3..80d567ba94846 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -1340,6 +1340,7 @@ void kfd_signal_poison_consumed_event(struct kfd_dev *dev, u32 pasid)
 	user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
 	if (unlikely(user_gpu_id == -EINVAL)) {
 		WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%x\n", dev->id);
+		kfd_unref_process(p);
 		return;
 	}
 
-- 
2.39.5

