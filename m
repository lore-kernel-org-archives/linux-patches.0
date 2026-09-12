Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5E349CCD;
	Sat, 12 Sep 2026 19:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240001; cv=none; b=AqzQCiJmxoSZsIQ0QPGx7BK88sWfnUQrx2l+li9g71F+PTRk3Zl6bGnzZJ9oCj+HUIrirOAnHcUW/HNLCJFFeLFlh9qbHTnVzDLEjENGBggejNhzpLVhRZY54WPuPSpU8D+0NUcBsya1jQ96fqHT5OHXXjHZmFliiyzxHzT0AYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240001; c=relaxed/simple;
	bh=4FQu9NzfJ7z1p93BPM5iKBGf4jYfRkAHhTE+VnJaaX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asLU2Qemfzr1FbtCRtpLzDk6fLjlJ5Vj61A57bPamG2r0AG+elFSCBCa5Yjph7LULmyJmxreRnG8BxymMn8DzK60WhLLgRwxj9EI83KBXjx+O4Md3mkIuuC6DfxBncQX4W8fKVQgjsPrvcyZE9AEtOz5eq+oJgySClYo1uBulIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpHrZBZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpHrZBZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DA11F000FF;
	Sat, 12 Sep 2026 19:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240000;
	bh=DJ0d2y3f2tKDcCMbpeqEl3C9plCLWsZ1jb4wC5qcDHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpHrZBZMQ1R45+Rn4i+IO3DJp2jrJVLTHVvbCyKlqlXU86L50733T8O/lsM6Ne5Tg
	 98Us0IKCyF8/pfO1Aytb27V8cC3a3AwURvOgItynTnwL+3JYmFkTaqqGhHEel8qRcQ
	 8hBDaiijMYRH+pmagKq2kS5WzVVWy5YIOThe3B7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 780/935] dmaengine: qcom-bam-dma: fix autosuspend cleanup during removal
Date: Sat, 12 Sep 2026 09:03:30 +0200
Message-ID: <20260912065544.717339478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit a50184171235045d96104811414b25cf5338cf86 ]

bam_dma_probe() calls pm_runtime_use_autosuspend(), but
bam_dma_remove() does not call the matching
pm_runtime_dont_use_autosuspend() when removing the device.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call before forcing
the device into runtime suspend during removal.

This issue was found by manual code inspection.

Fixes: 7d2545599f5b ("dmaengine: qcom-bam-dma: Add pm_runtime support")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260808110642.2770355-1-lgs201920130244@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/bam_dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 02740ec274df4..51c9e7c6b2abe 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1373,6 +1373,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	struct bam_device *bdev = platform_get_drvdata(pdev);
 	u32 i;
 
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_force_suspend(&pdev->dev);
 
 	of_dma_controller_free(pdev->dev.of_node);
-- 
2.53.0



