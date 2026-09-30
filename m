Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA8C5218B1;
	Wed, 30 Sep 2026 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790620; cv=none; b=ioXwSrQdnwns11ZYQeIvp0lQi6CYOyQz8vkl2/YMuJXvwTiIwNvVtZN/9f1nhgArHZk45bgzI6aeuf5+2vEBtAIylZypAHPQ92kEJlYvJc5HudEq4ngtzz+/Y2dznWmx9LIMeCUVRJQfRSxYojFRb3BOUwGzCNKbyCgdwtE3oc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790620; c=relaxed/simple;
	bh=Xi/acRpE5Gr56TCm1Ifdc8pZSWPIt+PkGkmPZJTD+8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMFFcCZXE6A48SM0WN8Dbkc+WahjTgGCYLOVGwasRYjcTo6U5LNPtsL++44Me9JZT99aAIwYqhtbDSIBmeEeAPsRoVYv2Y/nSyOJ5LCZ3iRsLIdlVznEGmFD4lAd2ht4qmjBczc3HhSgGvoHe6rgrAKCsECYcsutU/ltohkJz5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IB+S+jD9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IB+S+jD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C4D1F000FF;
	Wed, 30 Sep 2026 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790619;
	bh=vjR6sdVUnoZl/PLUma2CNAQaoLr369g+xU2AWLadj00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IB+S+jD90dr/HNSPqY+WPVSY6Z7SPmLexle/f77Y7XjpdIILsCTOFfu/KfO1/X9WF
	 138nBeeVNZTjYSwhNhSl13Qy64606S/h3kPx6AcbyVRSTe3/o5eUwUMi8K0pN9bXGc
	 hB0h2pe5GnNMosApJOYAxSOy+moFXInvOWlxbd+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Yu <2426767509@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/752] media: dm1105: fix missing error check for dma_alloc_coherent
Date: Wed, 30 Sep 2026 17:18:06 +0200
Message-ID: <20260930152358.502711191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 57f7e4df41b22..f20bea8623af7 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -767,6 +767,8 @@ static void dm1105_ir_exit(struct dm1105_dev *dm1105)
 
 static int dm1105_hw_init(struct dm1105_dev *dev)
 {
+	int ret;
+
 	dm1105_disable_irqs(dev);
 
 	dm_writeb(DM1105_HOST_CTR, 0);
@@ -777,7 +779,10 @@ static int dm1105_hw_init(struct dm1105_dev *dev)
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



