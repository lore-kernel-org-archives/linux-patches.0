Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5A862A0C;
	Tue, 23 Jan 2024 00:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971123; cv=none; b=HKM1GBmG69hY2iuZPqlVgXoavgjQHxQLMwaUGzqomPHZd0xM1lS1cTMi9yYdmPSHc9OwCF0MxrsTwWPZxA8E+5eHjeI5hmdUa5AhXQTo3UB4q/avFL3fyWbFeE6Jv7k7kIpMAl9sPh586FRs3SHXl6WhXFFP3k3UVB/+hpBJfQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971123; c=relaxed/simple;
	bh=0lKzXC9Kid5kT5epMfeI25CKGY6pLqJyCTKavM3Q/Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qt+q3MgM46pm2u8RgC6HctwjpqPObYU0DE9y1QjXsc/Imbxh/XMxZmWOX+QekcG4CBWDRo1cgSoKsEE5QQT31R/xDDF3cxh+7IDvhc6lz/Ywk3OBQYHwMhoSb+WbrUHtrziD+Du4rtUDA0zZNMyKAhCmfYlgcgWkpuMzWNo8hUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jI1ucQCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jI1ucQCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22244C43390;
	Tue, 23 Jan 2024 00:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971123;
	bh=0lKzXC9Kid5kT5epMfeI25CKGY6pLqJyCTKavM3Q/Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jI1ucQCPzWW87tGLnQ7OZN9UjhUSPvetp6i8RakPLeOSuWBtzvtXtemgDWg919XHV
	 vaW+6IJu7Y5xBeF0gJTcwfwH9kyppQGAeQTgPXoAAMZf4828r5hajitplcVUCsWLKP
	 tZhA+UYJitDXY+6j54nwoNUU5MS4x3xKIPOadd0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/417] drm/panfrost: Ignore core_mask for poweroff and disable PWRTRANS irq
Date: Mon, 22 Jan 2024 15:55:53 -0800
Message-ID: <20240122235758.291969588@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c08715f033c5..55d243048516 100644
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
 
 	return 0;
 }
@@ -369,11 +374,10 @@ void panfrost_gpu_power_on(struct panfrost_device *pfdev)
 
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
@@ -385,7 +389,7 @@ void panfrost_gpu_power_off(struct panfrost_device *pfdev)
 	if (ret)
 		dev_err(pfdev->dev, "tiler power transition timeout");
 
-	gpu_write(pfdev, L2_PWROFF_LO, pfdev->features.l2_present & core_mask);
+	gpu_write(pfdev, L2_PWROFF_LO, pfdev->features.l2_present);
 	ret = readl_poll_timeout(pfdev->iomem + L2_PWRTRANS_LO,
 				 val, !val, 0, 1000);
 	if (ret)
-- 
2.43.0



