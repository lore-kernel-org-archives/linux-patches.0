Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B63982C60;
	Tue, 29 Apr 2025 17:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948228; cv=none; b=tlP1uotj5UbjNgG2nS9US37HER4ldE4K3x+mmhqhbU3FFpB83fDXdykTEWbYW3aKvIqAya3V2ygeMIEjchNO6UObJ5RTYpibNPH6D6a2gufuWMEUuun50PjmKdkP5hHAiZYGuijFabQSTuwKWstV3x9HLJWfbLIdGq+R763amXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948228; c=relaxed/simple;
	bh=TBk9GDyRFMlEy3rM8aqRozZ4LKi9U1PMmEvQmdHxqXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u50BFADvj1rjEN3LP/vYupjWf9GO+KlW1Yxv1NiZZKfR7WRxxemGDgixNSuDZPeru9Hdzipyftp2iJaHPb2UzzsEZTN31H+j9+Nebu3/HVRmzW4qfON6ydlkXsPdDGvu1dlQ4kMtS+aauBkS6zhsgT1xV5ea7MWvGSd7lwwE2aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpJjHVoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpJjHVoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAC3C4CEE9;
	Tue, 29 Apr 2025 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948227;
	bh=TBk9GDyRFMlEy3rM8aqRozZ4LKi9U1PMmEvQmdHxqXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpJjHVoKPJvcMUjX4ZQaQBgMNI/7/r2y7rgW0Ku2Zb+t36eape1OS+ZKPSmDqW/CB
	 3qMPHTw+H6FDuCDVe3Omy/xyBvKxC25pHeARtdLAf57iMlbJf1+5ZFqTsW2bNWS2Ot
	 uF4gZmFoeyRs/1C63qQ4ZP3Uzt2UE0h69jYL14Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/280] iommu: Clear iommu-dma ops on cleanup
Date: Tue, 29 Apr 2025 18:42:47 +0200
Message-ID: <20250429161124.368993101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 280e5a30100578106a4305ce0118e0aa9b866f12 ]

If iommu_device_register() encounters an error, it can end up tearing
down already-configured groups and default domains, however this
currently still leaves devices hooked up to iommu-dma (and even
historically the behaviour in this area was at best inconsistent across
architectures/drivers...) Although in the case that an IOMMU is present
whose driver has failed to probe, users cannot necessarily expect DMA to
work anyway, it's still arguable that we should do our best to put
things back as if the IOMMU driver was never there at all, and certainly
the potential for crashing in iommu-dma itself is undesirable. Make sure
we clean up the dev->dma_iommu flag along with everything else.

Reported-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Closes: https://lore.kernel.org/all/CAGXv+5HJpTYmQ2h-GD7GjyeYT7bL9EBCvu0mz5LgpzJZtzfW0w@mail.gmail.com/
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/e788aa927f6d827dd4ea1ed608fada79f2bab030.1744284228.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 83c8e617a2c58..13c2a00f8aac1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -503,6 +503,9 @@ static void iommu_deinit_device(struct device *dev)
 	dev->iommu_group = NULL;
 	module_put(ops->owner);
 	dev_iommu_free(dev);
+#ifdef CONFIG_IOMMU_DMA
+	dev->dma_iommu = false;
+#endif
 }
 
 DEFINE_MUTEX(iommu_probe_device_lock);
-- 
2.39.5



