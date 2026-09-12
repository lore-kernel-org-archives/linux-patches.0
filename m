Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AEE344DB5;
	Sat, 12 Sep 2026 08:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203236; cv=none; b=XywifJ9+KGXq1zAfWhEz196fCeVgWVXL+gUXcrBgUaqt2G8HYhJvF5qlLGopqyqrP9ky/31cZ/CY1F7Hg/Mv9pBx5Xvv/ojg/Zg5JfYm+9ei7QGueFY3YMEHwSU+poIJfx0MvE3sEUAAv5CsvHUu0uwpSQpB6huWUNtJiATpZiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203236; c=relaxed/simple;
	bh=d+5HLuK8kD/CgMglT1Zs2Rzs93Wj05RwWjMCSD4ytds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srHsmdWeDU7KtRLB6bfusFwtmuJ5sBPzd125/8Sv6SHbG33/JKPCYCqUL/M0sOPRmowWp9UARM4x6oFerWxyQomfd075lA49gL+nECKak+cfNE/Yk+oamcC8LMw5Ddqewk8dj89leF9rEytgU/JrS9glZNuNXe8zve6EbDl0XOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZFy51Dq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZFy51Dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37831F000FF;
	Sat, 12 Sep 2026 08:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203235;
	bh=myIJ09wO9sciF4f8m2JUkJP9v1o8nF9OSZJg1tHtRmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZFy51DqlikGJQ2ct+HPdD8ZVgsn00W1QJEAEThOW8oA1GHb1Rl0DkE7gmdPIbGTT
	 98Bv+ldIhm23ghGJ+1e6f8pnbZE+tbJhANRAFItfOocDZawLrD8p4bhpYWd9obA7Go
	 S74NBnKiWYMPKEpA+DX25I1z94x3ZwoJuhJ11EzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1365/1815] dmaengine: qcom-bam-dma: fix autosuspend cleanup during removal
Date: Sat, 12 Sep 2026 08:51:55 +0200
Message-ID: <20260912065721.074685108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1bb26af0405f3..05a3b1f9e0c23 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1401,6 +1401,7 @@ static void bam_dma_remove(struct platform_device *pdev)
 	struct bam_device *bdev = platform_get_drvdata(pdev);
 	u32 i;
 
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_force_suspend(&pdev->dev);
 
 	of_dma_controller_free(pdev->dev.of_node);
-- 
2.53.0



