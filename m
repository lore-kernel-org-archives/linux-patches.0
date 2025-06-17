Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1122EE60C;
	Tue, 17 Jun 2025 15:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175633; cv=none; b=CVdQ22syXn5QgxinH2qfjoRBxc8r8j5qTK/GHAEqfLGdBoZxF6AngLIbFBzUb4wNGM54dscDWMMOeuswEzIfDR9LPeSzQFVeY3mhqPLMaaRvxqdLWvD31yLqXOmf2nG+F1qqbLA5zyi3naCMjTwhYZxv1nWwLFoknLRVe/n7N5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175633; c=relaxed/simple;
	bh=0m2NXWCYyHmZiQQJKfEEbAse7iB8ulMXJEEngwtdRr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQUnAU+DovZdsPAgvn1cxg/OLf+42/KyBveVT/pCXcIe+pQZYQiX1sV3qQ932yLuIWTEjNPMz7FrtcwhpsJrgDxRk5xpFkL/4P9UjVZyZ3aMvn7x5K7tlO2yt0kFGjKTSVuhSU4vBlZVRH9UVJvxuHRRQ4KFJYacxUXzLQlqY+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SG+6tYmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SG+6tYmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81411C4CEF1;
	Tue, 17 Jun 2025 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175633;
	bh=0m2NXWCYyHmZiQQJKfEEbAse7iB8ulMXJEEngwtdRr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SG+6tYmZgolpD2tT/pOXabx1Qjvn5slRh5T6T/UtNP7GMXnEcu9EWFERfgMm9IMF9
	 0cnYegB5XtKmb8mb77q0U/M/5EO6zNhlSALJGZlvXPq9wRiFPfzMclxwm/zqEhBzah
	 G6epBUkcicksoPaCjObnWGWkZ3QzWnKLzvljD88I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 108/780] drm/panthor: Update panthor_mmu::irq::mask when needed
Date: Tue, 17 Jun 2025 17:16:56 +0200
Message-ID: <20250617152455.905480425@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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
index 12a02e28f50fd..7cca97d298ea1 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -781,6 +781,7 @@ int panthor_vm_active(struct panthor_vm *vm)
 	if (ptdev->mmu->as.faulty_mask & panthor_mmu_as_fault_mask(ptdev, as)) {
 		gpu_write(ptdev, MMU_INT_CLEAR, panthor_mmu_as_fault_mask(ptdev, as));
 		ptdev->mmu->as.faulty_mask &= ~panthor_mmu_as_fault_mask(ptdev, as);
+		ptdev->mmu->irq.mask |= panthor_mmu_as_fault_mask(ptdev, as);
 		gpu_write(ptdev, MMU_INT_MASK, ~ptdev->mmu->as.faulty_mask);
 	}
 
-- 
2.39.5



