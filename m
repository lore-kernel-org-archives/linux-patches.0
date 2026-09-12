Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6223783B0;
	Sat, 12 Sep 2026 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231420; cv=none; b=kmMDTgzseJzewjWLC3NJZjhDipWPP1wOutUUxkMjCsaQ9FoF8YULqEABfPmCtEhDri0KxmxFYrGyYraArnIcnhOWvT3uc9Jv2faKhGTicBF+lYjpN9q2+Y13LftRTqnmOouqUt4x88TbfKPMnsGokVp6M+EnGPKkyq9Ya2VnQp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231420; c=relaxed/simple;
	bh=cmtuqaBhk4iHEcYpo5zXRsIqZBa876xTPaNLxFvWjGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsOuRiWA/86lx9+W/v2ZbOiJKiFwKGttSdAgyBEvy+jU0CR6Cs7NRKeo+W1oFVJ6IEMpl1TQ9QXpB2ZYjBn0qpKro3ymsP44j3QXvqUlnZ0ZCv4ptMmJm7bYFgzwQloFU9GysFLM/Bccxcx4IxeSe/szWDnAUCICrP3qubM7HVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8ASo4Ef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8ASo4Ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500031F000FF;
	Sat, 12 Sep 2026 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231419;
	bh=AcWXDkL22K1bsaNB4IIVGmscsj1uBnCQgeAXCLVpBjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8ASo4EfRTfaTwZMPT6px/0Izj5Pu1U+Rv4L80q9Dz7SLJ+VrYLyhuSsTwbLdpCrq
	 WMAlb9WX+aqTi5uqzsh0aDKVdrWid4MqKc7OZ/90ImwYnN/a6FkMKazX4BA10TR6Hn
	 Sitr7WVRC9h4uxSi9rWUd9QJKYwgOWwFNPwX56Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0968/1191] dmaengine: qcom-bam-dma: fix autosuspend cleanup during removal
Date: Sat, 12 Sep 2026 09:01:36 +0200
Message-ID: <20260912065609.957556409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8417883b24c04..68295eed43d8e 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1397,6 +1397,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	struct bam_device *bdev = platform_get_drvdata(pdev);
 	u32 i;
 
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_force_suspend(&pdev->dev);
 
 	of_dma_controller_free(pdev->dev.of_node);
-- 
2.53.0



