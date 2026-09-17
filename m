Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A83361967;
	Thu, 17 Sep 2026 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661052; cv=none; b=tG0tddT1sFHBTLiqFV7OQx+HcEqCxf1IR/geyncMNZK8T/DzdtRaNFwG6o6B+4IzQ9cgb+nFAla1dO1tZI6QHheeC1kXdUdfW9Rss3tK9iC82ptDvFl73W4Em9oj7TK0pRSO0dCu3nV3pQSBzr8gyTf/YA8y7Bo+WyeLc87k9wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661052; c=relaxed/simple;
	bh=KXhCyjs2AXCuKxLEiJXWMoxbo0g8AOmxwt36A93Kq1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfigrCHOKqZTe5gY1QbcLS8Rmv//5JDmFrplgDFBw2+IUsmNRbkzMM+03JXHGapf9R9d79A34FyTMIHeySWM0ULsbM9oASOOWD9HGciG8HAg4ezzVKNo7wecEZR3685ePixBToWfXuTZB0tdGIQyqgUjUAGLbYOF2Z85xK547dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boptJ5AN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boptJ5AN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4961F000FF;
	Thu, 17 Sep 2026 16:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661051;
	bh=CSVyq3UDnwjQtdKYAnzgKDn1vEsH5sgLGtkscOnzMII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boptJ5ANNpqlEI/qOZ8XYLUyFNtpfn5eR4eq1I05aG9pw9DqvFFc8m+vHdcULmvzX
	 IgXdjH0t72+gQb75H8HwId9bvE1PPdzdci0RzSMNo2CGajGfuNNycmrh7C8QuYtWLB
	 fdvbhvv39ZS0XwMiln0OMzVBWpoJZQCCrCprM1AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Yu <2426767509@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0065/1250] media: dm1105: fix missing error check for dma_alloc_coherent
Date: Thu, 17 Sep 2026 15:57:40 +0100
Message-ID: <20260917151553.705656156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaoyang Yu <2426767509@qq.com>

[ Upstream commit 3eaac9e02d8591d3c790db572ef1c8fa5a841fdb ]

The return value of dm1105_dma_map(), which handles DMA memory allocation,
is ignored in dm1105_hw_init(). If dma_alloc_coherent() fails, the driver
will proceed using a NULL pointer for DMA transfers, leading to a kernel
oops or invalid hardware access.

Fix this by checking the return value and propagating -ENOMEM on failure.

Signed-off-by: Zhaoyang Yu <2426767509@qq.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/dm1105/dm1105.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index c1d55b9836744..abd86488064b5 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -768,6 +768,8 @@ static void dm1105_ir_exit(struct dm1105_dev *dm1105)
 
 static int dm1105_hw_init(struct dm1105_dev *dev)
 {
+	int ret;
+
 	dm1105_disable_irqs(dev);
 
 	dm_writeb(DM1105_HOST_CTR, 0);
@@ -778,7 +780,10 @@ static int dm1105_hw_init(struct dm1105_dev *dev)
 	dm_writew(DM1105_TSCTR, 0xc10a);
 
 	/* map DMA and set address */
-	dm1105_dma_map(dev);
+	ret = dm1105_dma_map(dev);
+	if (ret)
+		return -ENOMEM;
+
 	dm1105_set_dma_addr(dev);
 	/* big buffer */
 	dm_writel(DM1105_RLEN, 5 * DM1105_DMA_BYTES);
-- 
2.53.0



