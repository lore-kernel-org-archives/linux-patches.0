Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94862580CC;
	Mon,  9 Jun 2025 13:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476643; cv=none; b=KgUB7vj4hTwkSU+FqiXLx3c/5+qRCSC/bj5XlauTK22Fmv5AwtuF/Kg+etXKgr70DhK2i5odNpwVC1RFN47xbXmWxar6lLSxe3B3MTZ+zGgT7ZkgtFi8IwBxI8JSlEJIvLOb6vk5Rm4aXBXTjRy12derzSMS3T8WI9mykG9Q7aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476643; c=relaxed/simple;
	bh=CzsR/YWJHA63OqV2kX9vqTxOmlDz3/W80JAj7YN2HAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uN4p7IjFRfqstKQ1cNLGFo72Fhz+DShPl22Teye3kepITH3hxgEI/oRMDlEKjlI358zgLkCOBaGhQkv36cIIiSV40EgrBMUjTuPNeTPFNkHOOb7GkiE1PEg3XXBeD9VpBDHUHwijKGpOCg1Hq8tdRSi3v6fNHDFqfe+nCFjSF7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrVLdeiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrVLdeiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733B8C4CEEB;
	Mon,  9 Jun 2025 13:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476643;
	bh=CzsR/YWJHA63OqV2kX9vqTxOmlDz3/W80JAj7YN2HAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrVLdeiqDoBrRTMoM21a0J71VYhz6+9nwnt7wUvsOnh3WIHHhN8e/ohNWFC3rR8ez
	 4GlgGGnvwW63/+jdItMWxKo46DyEOPPNYtQ398gsGh5PbCCgeETfYPmoDQRnJ0Ks56
	 d7HXST0qQZb9xVR02oSDGFRHM5ct3andIBqP/c9spZ8iqUT7Sjyok1o7VfDgInaLFc
	 Z/p+L9twHmAycZO6igKDKt+A8FlYouNB1AjLAkhZSLVCr+uKmYuKXpvQX28bWunK70
	 JPk1+lsBuDTG2ck4YAa3rgap5M3iq74OWQ7KsrIq3HkyV2tKIWA/bGERvzdyFmXCU0
	 oYWXpgpqg7Qyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yifan Zhang <yifan1.zhang@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.15 05/35] amd/amdkfd: fix a kfd_process ref leak
Date: Mon,  9 Jun 2025 09:43:21 -0400
Message-Id: <20250609134355.1341953-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134355.1341953-1-sashal@kernel.org>
References: <20250609134355.1341953-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
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
index fecdb67940750..3a926eb82379b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -1331,6 +1331,7 @@ void kfd_signal_poison_consumed_event(struct kfd_node *dev, u32 pasid)
 	user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
 	if (unlikely(user_gpu_id == -EINVAL)) {
 		WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%x\n", dev->id);
+		kfd_unref_process(p);
 		return;
 	}
 
-- 
2.39.5

