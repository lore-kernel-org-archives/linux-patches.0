Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE2625A2A3;
	Mon,  9 Jun 2025 13:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476717; cv=none; b=At0hGS6k5/ZmSdlu9O4aXMLzCjl0gSwaJWoYCY16L+/eOaocauMVxeywN8bFeZjNDkBiJVhQnIPAClBw1rFgHpe1jTo0GWmITUBZADgdQMR9xNVo3SilNtvK7CeDVqpqcpfLSI3u9cHEVIrlPSoUV8EMLLO24NwaSwpRxAU8BXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476717; c=relaxed/simple;
	bh=CzsR/YWJHA63OqV2kX9vqTxOmlDz3/W80JAj7YN2HAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qgS2zKFQ9y62KzbGyBsHVPI3BONgUpu96sSJWil1cJ8Jrg/thlMK8A7Kbx84f8RsryUZWHB/J5vj3fJkZk/2cBXlyzAFslixWaPUHME8wVPrp3JtZL1XDNmY0ehYNiqulCiH4Whm4KW6AIz45oP70EWtf14480fagfAM7Pz2mRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qMejn/Et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qMejn/Et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2B0C4CEF0;
	Mon,  9 Jun 2025 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476717;
	bh=CzsR/YWJHA63OqV2kX9vqTxOmlDz3/W80JAj7YN2HAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMejn/Et9Y/g5kmabL3tqz8TpygBqTCsJButZVX3RhJFrsRGm2XKSbzRjTwRb8aX5
	 Sa8DP/FyElcQl/QoeAGLG7TcfzLDD34nGpCwHFIZ8MmY8JWoI4D9CPY5hwCOvlJt1u
	 RRmuVi6MlL/ZHIwwgHqFAtA1VKRc0tGWHvLn2VWpx4hW3Ap/N0gMrMLqiysxJLa2y+
	 ELWaPX9sZFLZXaMGzxREZL8+xZnnskVheCsC/TzNCqjQ6vryV0KTMWdIhFTi+obIRn
	 Hn9wIJIqy01Z10SDYasr7uI2vtcj7bcWAu1/W2CDBEUUSqvIiPOJxTwUXrQwYkopH2
	 wF1kRVqjKbLNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yifan Zhang <yifan1.zhang@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.14 04/29] amd/amdkfd: fix a kfd_process ref leak
Date: Mon,  9 Jun 2025 09:44:45 -0400
Message-Id: <20250609134511.1342999-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134511.1342999-1-sashal@kernel.org>
References: <20250609134511.1342999-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
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

