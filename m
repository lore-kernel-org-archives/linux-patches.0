Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39438EEBB;
	Tue, 23 Jan 2024 00:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969515; cv=none; b=sOqhTFTXs8MFjjLDkH6OcoezitjmjKOlgEIZvWmZKBnUx3GNxnh48O18NOKHxpnLu0MzccX94RcbvYkE7caNK0Mxd08BDWvTSYHdIFn0fkNxkuwWZSHm+CLW/DTE24soiZKWDTnMzdeTCQ+I3iCsLYTKV5tsT3U9zUlF4xibtwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969515; c=relaxed/simple;
	bh=UiDPsrmtV7xq38V/wJ2OaCVzdtYcgOFDQiSb8J4DB4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyk9tJRfcw2qU9tYiz5ffGclUtUUhg9s8IeIRYfcNpteGR6yrjGNZsgU0o51Io2X7/Scg3Pqvr/ePWL56MommNaxcuda/6kVCor7o1BY2L6yFGA+YZXv1J3fa2+NDdUmZyTt4TN08aBFSv/1lGWqmRbCBWdyuj8otybjNx3HR6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veJs0PBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veJs0PBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2D4C43141;
	Tue, 23 Jan 2024 00:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969514;
	bh=UiDPsrmtV7xq38V/wJ2OaCVzdtYcgOFDQiSb8J4DB4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veJs0PBKPNBmgSqAAAObrlyooLAL8SOfyJDBD4OMrQ0iBqJW2taxgIER1nyKTrTeD
	 EajJibkgS7OOvWtHaPnag2maxPF3E8FF5352lTmf5cEM2Aq0rDYHdpuw6CSbnszS4f
	 Mt2BKbpn06BPobT+UKog5aZxxgrw9E65j1y9gfLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 289/641] drm/panfrost: Ignore core_mask for poweroff and disable PWRTRANS irq
Date: Mon, 22 Jan 2024 15:53:13 -0800
Message-ID: <20240122235826.937111956@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit a4f5892914ca7709ea6d191f0edace93a5935966 ]

Some SoCs may be equipped with a GPU containing two core groups
and this is exactly the case of Samsung's Exynos 5422 featuring
an ARM Mali-T628 MP6 GPU: the support for this GPU in Panfrost
is partial, as this driver currently supports using only one
core group and that's reflected on all parts of it, including
the power on (and power off, previously to this patch) function.

The issue with this is that even though executing the soft reset
operation should power off all cores unconditionally, on at least
one platform we're seeing a crash that seems to be happening due
to an interrupt firing which may be because we are calling power
transition only on the first core group, leaving the second one
unchanged, or because ISR execution was pending before entering
the panfrost_gpu_power_off() function and executed after powering
off the GPU cores, or all of the above.

Finally, solve this by:
 - Avoid to enable the power transition interrupt on reset; and
 - Ignoring the core_mask and ask the GPU to poweroff both core groups

Fixes: 22aa1a209018 ("drm/panfrost: Really power off GPU cores in panfrost_gpu_power_off()")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231204114215.54575-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index 97f097ee5c1d..311cf4525e1e 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -71,7 +71,12 @@ int panfrost_gpu_soft_reset(struct panfrost_device *pfdev)
 	}
 
 	gpu_write(pfdev, GPU_INT_CLEAR, GPU_IRQ_MASK_ALL);
-	gpu_write(pfdev, GPU_INT_MASK, GPU_IRQ_MASK_ALL);
+
+	/* Only enable the interrupts we care about */
+	gpu_write(pfdev, GPU_INT_MASK,
+		  GPU_IRQ_MASK_ERROR |
+		  GPU_IRQ_PERFCNT_SAMPLE_COMPLETED |
+		  GPU_IRQ_CLEAN_CACHES_COMPLETED);
 
 	/*
 	 * All in-flight jobs should have released their cycle
@@ -418,11 +423,10 @@ void panfrost_gpu_power_on(struct panfrost_device *pfdev)
 
 void panfrost_gpu_power_off(struct panfrost_device *pfdev)
 {
-	u64 core_mask = panfrost_get_core_mask(pfdev);
 	int ret;
 	u32 val;
 
-	gpu_write(pfdev, SHADER_PWROFF_LO, pfdev->features.shader_present & core_mask);
+	gpu_write(pfdev, SHADER_PWROFF_LO, pfdev->features.shader_present);
 	ret = readl_relaxed_poll_timeout(pfdev->iomem + SHADER_PWRTRANS_LO,
 					 val, !val, 1, 1000);
 	if (ret)
@@ -434,7 +438,7 @@ void panfrost_gpu_power_off(struct panfrost_device *pfdev)
 	if (ret)
 		dev_err(pfdev->dev, "tiler power transition timeout");
 
-	gpu_write(pfdev, L2_PWROFF_LO, pfdev->features.l2_present & core_mask);
+	gpu_write(pfdev, L2_PWROFF_LO, pfdev->features.l2_present);
 	ret = readl_poll_timeout(pfdev->iomem + L2_PWRTRANS_LO,
 				 val, !val, 0, 1000);
 	if (ret)
-- 
2.43.0



