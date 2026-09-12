Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF7429000;
	Sat, 12 Sep 2026 13:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218085; cv=none; b=htR5e/AHErWej4pvZR3GjqwVUKq1SN/k0Tj0gQq738kX3Q/1Wszt/9s+cIbsfQGtsIfaWS7m3M7Qq/P+xmLt4mghY+xKLW1Xj17b33AYdypomcmREg9Qv8vKASxHX+G/9tAxfpx3dm0p60YDPRm4LfHmVMGSMC3hSb/Wqio773k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218085; c=relaxed/simple;
	bh=dZmSI1GmagaBfT/fJ/AlysAQ4pmpadHbUKSLB801gRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGXyk1QQ9PynDYdNt3jShyGEkeyUr3i2esMpmCiyEhgXyeJnVQsFDbUlG61+8TMhlRTdIvVvG20WbcI9EjDmvfxbgWgjs1ZCQAWwx5ZPhzwEe0KMBeJP9Fa43diJj41Si5tX0w7fgmev2j6oTVGyBub7JJyFkE6CP6+beWe/bvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5w0uQXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5w0uQXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FF31F000FF;
	Sat, 12 Sep 2026 13:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218084;
	bh=+Si/oIIHSIbLd3Q3YrLqm2Spyuml9P2dD7BKdhcZ2HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5w0uQXvz/10zu+zFzG03ddOgLdbJopVrZgNNZqjhNtFQqL5fZxowP1pbTiAPCXsf
	 XI6Q48jqtqO9EXTAFYMSYRcMnWiySL7OasHP7HVSOeyOMGbqhLnxbuc4suikPjUzwl
	 amdYHlb5n7v/Fq+u+6hLYPoUYwwHM2DjubUJi+t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1073/1376] dmaengine: qcom-bam-dma: fix autosuspend cleanup during removal
Date: Sat, 12 Sep 2026 08:58:19 +0200
Message-ID: <20260912065631.476567653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 348bb9a5c87bd..cf647662ae81c 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1391,6 +1391,7 @@ static void bam_dma_remove(struct platform_device *pdev)
 	struct bam_device *bdev = platform_get_drvdata(pdev);
 	u32 i;
 
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_force_suspend(&pdev->dev);
 
 	of_dma_controller_free(pdev->dev.of_node);
-- 
2.53.0



