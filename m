Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4021D5ABA;
	Sat, 14 Feb 2026 01:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031121; cv=none; b=M5DsLv4PUgKPY1KqUjCNcxQIGvdfXLZdh5V94IzTKKbhDTf0vnyV5lQnwCZqBjQdXeeCj017o/WasYCh4gcNvoS0d0n7hotMivYAs7S6x6t2CkZ2PwdHHTC0QQ1pR66bIsGKF48OJWTkp7cVqzXLGSgKG366WJ8Fg8qgzaIl2dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031121; c=relaxed/simple;
	bh=n8BwvGUhkkiXOh5h53cZMMu0g4KQyvmLpZOJwh0ystk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGchC2WmyRsj1eanYM5yxV8dO/6xX8dNaejD4Y93HghVN/6VKJ2biIUB9LMxIu3pjkJUjERuHFu1GTAlZs0TVRIYPZH6bsdbMKEi3chrpwy73IxzMOROKaD/rK3NCPM9q2+jdpjmRlr+bcFVdqrbemC7/rxCcadOYSyJr+Bv1vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gOrXvfyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOrXvfyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1A4C116C6;
	Sat, 14 Feb 2026 01:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031121;
	bh=n8BwvGUhkkiXOh5h53cZMMu0g4KQyvmLpZOJwh0ystk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOrXvfyPpwJnRd1/IY8GuouYY5vdnsn+NGiPOrlQIvuAHforuoeStEght5drMQtID
	 vIy4fvqI+O10jHUnZ55vjIDWaGwlOvLumiHHejYO3WN9W6ENMsrpvFdxW3m4Skb9R8
	 96vm8Tm2G26UWG5AlqnS+8InHQl4cZCVJ3VZDTKdz3RDTMzvN78LBxXeT2m1DxOOaV
	 UOzROIYcuch6m3LgvtcLy+32XHG+nPNRtm5XVjmeRiE6CUajTYjixVjWoFIxR29Vt2
	 p+O7dIsZ7ypRNbM+yFstKEwFwYzTqJr8JNkXy1OCD4AblCrfZg6gAAM3MY4vLUoAjo
	 fS0JYwHHSPGIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Donet Tom <donettom@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philip Yang <yangp@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amdkfd: Relax size checking during queue buffer get
Date: Fri, 13 Feb 2026 19:59:11 -0500
Message-ID: <20260214010245.3671907-71-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 42ea9cf2f16b7131cb7302acb3dac510968f8bdc ]

HW-supported EOP buffer sizes are 4K and 32K. On systems that do not
use 4K pages, the minimum buffer object (BO) allocation size is
PAGE_SIZE (for example, 64K). During queue buffer acquisition, the driver
currently checks the allocated BO size against the supported EOP buffer
size. Since the allocated BO is larger than the expected size, this check
fails, preventing queue creation.

Relax the strict size validation and allow PAGE_SIZE-sized BOs to be used.
Only the required 4K region of the buffer will be used as the EOP buffer
and avoids queue creation failures on non-4K page systems.

Acked-by: Christian König <christian.koenig@amd.com>
Suggested-by: Philip Yang <yangp@amd.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The commit being analyzed fixes a bug introduced by `629568d25fea8`
("Validate queue cwsr area and eop buffer size"), which added overly
strict validation. The validation was correct for 4K-page systems but
broke non-4K-page systems. The current fix relaxes the validation to
properly handle the page-size alignment used by the memory allocator.

### Conclusion

This is a clear, small, well-reviewed bug fix that restores GPU compute
functionality on non-4K page size systems. The change is logically
correct (allowing larger-than-needed buffers and aligning to page size
boundaries), has minimal risk, and has been thoroughly reviewed by AMD
GPU subsystem maintainers. It fixes a regression introduced by a prior
validation commit.

The fix meets all stable kernel criteria: it's obviously correct, fixes
a real and severe bug (complete loss of GPU compute on affected
systems), is small in scope (4 lines, 1 file), and introduces no new
features.

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_queue.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
index 80c4fa2b0975d..2822c90bd7be4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -275,8 +275,8 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
 
 	/* EOP buffer is not required for all ASICs */
 	if (properties->eop_ring_buffer_address) {
-		if (properties->eop_ring_buffer_size != topo_dev->node_props.eop_buffer_size) {
-			pr_debug("queue eop bo size 0x%x not equal to node eop buf size 0x%x\n",
+		if (properties->eop_ring_buffer_size < topo_dev->node_props.eop_buffer_size) {
+			pr_debug("queue eop bo size 0x%x is less than node eop buf size 0x%x\n",
 				properties->eop_ring_buffer_size,
 				topo_dev->node_props.eop_buffer_size);
 			err = -EINVAL;
@@ -284,7 +284,7 @@ int kfd_queue_acquire_buffers(struct kfd_process_device *pdd, struct queue_prope
 		}
 		err = kfd_queue_buffer_get(vm, (void *)properties->eop_ring_buffer_address,
 					   &properties->eop_buf_bo,
-					   properties->eop_ring_buffer_size);
+					   ALIGN(properties->eop_ring_buffer_size, PAGE_SIZE));
 		if (err)
 			goto out_err_unreserve;
 	}
-- 
2.51.0

