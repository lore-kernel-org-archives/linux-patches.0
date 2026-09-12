Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9953D47C2;
	Sat, 12 Sep 2026 07:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197369; cv=none; b=h5c2S38xCjlLVO+s+qTClVHCb4sPt8j8FZMD41S1JwHp/qtMNRu9I8PidKISrDbJ/JfEdogut2SrpB6NgqHoqkqNuAixroBlEKXkn8gzsI+W1VAkPIvUO1BjKX3EPKgW45cNrFLxKsajNFVIBdw1l8c2+Wnk1/aZ0katRl7fSRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197369; c=relaxed/simple;
	bh=GxNxbSuU3HRn4xCtbP2RLeMCt6n6+QStDQsVpuMLqrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFKRdk60HfvPVqTn9LPCM+xVgK6BX6Eja3M/NC8QJPLQO8d4kGdiuvyOQlYxK6pbnRkq3IQCOICZiM1zzlL0xxuSZo9hBNya2ocSEXQC4181qe3ua+e4chf+9VLsUZ9NN2yqiy7SqcCJej4ISo26g+7JmlTopkyBaPZEcdwFdnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljjOjpZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljjOjpZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F1A1F000FF;
	Sat, 12 Sep 2026 07:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197367;
	bh=XFFskHHYNFjnbUrAFXdM9QSSazsLnphUjiEIZavdJjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljjOjpZpA/EQHskp9vnajvqsTSbCE2eQ0fBPfusDiRYkaRBF1nQYBZdHB8Hg+Xyq6
	 t6OmNU8kxnas1qjRWPqK6Rc7xwbS7b0z1hlSmRt6/zabw/MbctzHxY9rHcsmYAFD09
	 NjgMF/7DtPLb4o6bOsGVpTH9Mr0P2z8nIlFbrkdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Golla Nagendra <nagendra.golla@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0160/1815] dmaengine: zynqmp_dma: fix race between runtime PM and device removal
Date: Sat, 12 Sep 2026 08:31:50 +0200
Message-ID: <20260912065652.766477770@linuxfoundation.org>
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

From: Golla Nagendra <nagendra.golla@amd.com>

[ Upstream commit 516ba2d8b7aac4238f9fcbd58579c43c71b9b695 ]

In zynqmp_dma_remove(), runtime PM was disabled only after checking
state and doing a manual suspend. This can race with runtime PM in the
remove/unbind (rmmod) path.

Disable runtime PM first, then suspend only if the device is not already
suspended. To prevent any further runtime PM transitions.

Fixes: 72dd8b2914b5 ("dmaengine: zynqmp_dma: Add shutdown operation support")
Co-developed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Signed-off-by: Golla Nagendra <nagendra.golla@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260630064844.705173-2-nagendra.golla@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index f6a812e49ddca..ca2dee0012c87 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1170,9 +1170,9 @@ static void zynqmp_dma_remove(struct platform_device *pdev)
 	dma_async_device_unregister(&zdev->common);
 
 	zynqmp_dma_chan_remove(zdev->chan);
-	if (pm_runtime_active(zdev->dev))
-		zynqmp_dma_runtime_suspend(zdev->dev);
 	pm_runtime_disable(zdev->dev);
+	if (!pm_runtime_status_suspended(zdev->dev))
+		zynqmp_dma_runtime_suspend(zdev->dev);
 }
 
 static const struct of_device_id zynqmp_dma_of_match[] = {
-- 
2.53.0



