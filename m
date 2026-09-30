Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149BB370AC7;
	Wed, 30 Sep 2026 18:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793920; cv=none; b=NGUUe6AWc7KPleP3/coPfrKlyJMCAyVmTVXhaxIauzDJwggd6Y5MZpgkUu3wPDxbBbKnbRnq6tkTCkdu9YHJ4e8K6WD0k6H3U+4KaAY5rK3D4217/IJ0DeAwqVduRmeB2OcbaRrLThNAyrN/9iah4xBOPnEKturYutDAbppjIvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793920; c=relaxed/simple;
	bh=FIgImKGQqQcQV+K53EKXTKVYwAJXfpFkALBnW5V+sNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txcXTX5PLSxqIjAmzqKfwVfZFXoU3n9nhXI5R5FBMctLJPshD3uRdOWvVHBWMUMHP2NZVOGFVdJ8kuTE39H2bAfOWPgudA6nvixwEXdMM7/vLCUhw9LtajtgnBlkLtrHGzPDzFw9gsV1AWgLUBoTUrMn9SyHsqHtklzCbO5Xwqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBOxfAVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBOxfAVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8A81F00899;
	Wed, 30 Sep 2026 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793918;
	bh=nyX7Yv2PIkEKtH5qAOmlBG+wAYxiw3PhIsTW4dc+/yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBOxfAVx89+SKZyE5ZuQ4YlPzWKmbxSkvWZQeAZe/WzoGJK11Fj3NqlO/9yNxRClG
	 xjm58ai0CD2fh5c7Qnfak1wLnrZFeZBciKYjg8+EoOuIxog8uQEPIvaH9Womc8bd4k
	 vJllVJO12fwF4HBrUNGmcJ6XgWVHehLLQOE3MA7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Yu <2426767509@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0028/1193] media: dm1105: fix missing error check for dma_alloc_coherent
Date: Wed, 30 Sep 2026 17:11:52 +0200
Message-ID: <20260930152434.917475462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



