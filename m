Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80D92EE5F4;
	Tue, 17 Jun 2025 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175143; cv=none; b=Xau+gU7ahRCXcpPX0iefsPtuRteZBq3Mbq+MF5SV8vTGHDGuWRSwhPnyOdVEUFJ1Qo1kBUSiOb9H3dixoWbRBnmFFgrKafOBC4cZBRNfS+jtR6ETLeqlsW6xSQG2+2pqVR7FKogSQeawSVb1rCtjoLAl0EkRty1ddDWQyWH3vqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175143; c=relaxed/simple;
	bh=TkKJGXe/jkjnOc+TLmMR6UN480rIdcPU34dOfHtxbbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVOEb7L3JTwyJ9CvHrzNcSAeBOtvYCu9Wqnkz1fUBwFzyvdrMHvfTt6Y8CtZ3hq2m/jZNp7TFnrO/qkAIq1AlzM+K5PRvuljtDsQG783g/czt6EfQUPAdrQBCClFQ0vcdYXeph7XFs54k88FYmOXmoclJBtQBLgpTBxyxRYY6gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMAjUYUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMAjUYUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26167C4CEF1;
	Tue, 17 Jun 2025 15:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175143;
	bh=TkKJGXe/jkjnOc+TLmMR6UN480rIdcPU34dOfHtxbbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMAjUYUx5uCbBZnrmP0fy/EE1kMYytPW9hi6ze7rF61yVrbmE7B3DMSGNNMcC7BN7
	 oi5oMjyiRwPCK4MXfdv712xWBYT4KkRuiXNTHtAPe5E3Ub5o8jkWayled9mwpOyDeU
	 Q7xckvh91EA8zSFHlC+5himu238MuXnjRIs+hruM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/512] drm/panthor: Update panthor_mmu::irq::mask when needed
Date: Tue, 17 Jun 2025 17:20:39 +0200
Message-ID: <20250617152422.540251448@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 8ba64cf2f358079d09faba7529aad2b0a46c7903 ]

When we clear the faulty bits in the AS mask, we also need to update
the panthor_mmu::irq::mask field otherwise our IRQ handler won't get
called again until the GPU is reset.

Changes in v2:
- Add Liviu's R-b

Changes in v3:
- Add Steve's R-b

Fixes: 647810ec2476 ("drm/panthor: Add the MMU/VM logical block")
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250404080933.2912674-4-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 0e6f94df690dd..b57824abeb9ee 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -780,6 +780,7 @@ int panthor_vm_active(struct panthor_vm *vm)
 	if (ptdev->mmu->as.faulty_mask & panthor_mmu_as_fault_mask(ptdev, as)) {
 		gpu_write(ptdev, MMU_INT_CLEAR, panthor_mmu_as_fault_mask(ptdev, as));
 		ptdev->mmu->as.faulty_mask &= ~panthor_mmu_as_fault_mask(ptdev, as);
+		ptdev->mmu->irq.mask |= panthor_mmu_as_fault_mask(ptdev, as);
 		gpu_write(ptdev, MMU_INT_MASK, ~ptdev->mmu->as.faulty_mask);
 	}
 
-- 
2.39.5



