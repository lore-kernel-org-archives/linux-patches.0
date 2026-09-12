Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5E53612EF;
	Sat, 12 Sep 2026 20:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243207; cv=none; b=KOUlI8i4KNPoKjVSb5polhkbWfJNOYtSm1sYyIOEs9nJQ551kACe9tg1X+1jbIyDMGfM8YyZKnBo23RDihSRmN0ZSQZYGEzwUevUDlaj8bALO0+1kdvjBTdi/LOOZ2l477FC/s+HrdTEMKqqpxUKjY3Sy0Ri1Yp83m7o2aGm6zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243207; c=relaxed/simple;
	bh=AOHyy7lhmG46h6Uqhrg0DznqEUhndo6acaKEXYfGnbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAzfdJ+ar1SE3A6rMXGZZokv9v0fmIRxx8McTdSr4VAUnHxHolxXKqyGxDhL07pBJEtXoEvwU5BxYrRe8BJ7rtSvKQE5lckhHyT4qZK0eYXTGJjGtP+lH7U9qFy+rUPDBxgbBXq76K5HGQsNkZwNMjoBtuaQBCvFC+PsxP0FQ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXDsQKDA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXDsQKDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699AF1F00893;
	Sat, 12 Sep 2026 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243205;
	bh=5gats7Nj/szXtkzZurCf+qaeTbbSTBCkj433VOiXtCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXDsQKDAK4Y6U/kmGpsQjbBjZGcFzeIWp67apcf9dBng/1g3PHXrQCSpRduTPIw9T
	 1kqDt/YlPnrvfHPhdhTpnRKY2KIyX4WyREbT1Mpyed9DZkhI8NW4dyt2rbaR1qYpzR
	 +MuJ1PVQrijsfI6A4lflt+WJXwpUMw2GvqDfAvaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 674/798] dmaengine: qcom-bam-dma: fix autosuspend cleanup during removal
Date: Sat, 12 Sep 2026 09:05:02 +0200
Message-ID: <20260912065532.549828311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 86a1c239b36c5..db9359d259e24 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1390,6 +1390,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	struct bam_device *bdev = platform_get_drvdata(pdev);
 	u32 i;
 
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_force_suspend(&pdev->dev);
 
 	of_dma_controller_free(pdev->dev.of_node);
-- 
2.53.0



