Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7A32CA9;
	Tue, 12 Aug 2025 18:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024475; cv=none; b=NVBPhf3GXUUpHah6hpRFre86dQ6B2skBWoRAWxqNvxQjco4UGk/S+EgrbhfLzBN2P+GRRFyzpWA5OmaLbrxbKrC7ECgqf7j7TiKncKuaUUu8NPpIPruxtX5F56IbKhn45lAzHQahB8luGWs4epMKbrYN1Zh5KZy0vi0k+PGKcng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024475; c=relaxed/simple;
	bh=PVpxcwhH1mo17vndFoZwnnC9DBEMKfvWVuUcHIm3sO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEdl/6HDFC/kpWncRHhTBsJr5zhDzplBjTpmxyz0FXZbInUtzp3NUXdKFhn9h/mUfXwFwFLFnKYvGOcOWso89nkaqPWaDjvveg74M6F8fg9tk2RC9lPcei35+/yZ++C5OJ9Ymq1dKSb2uknZwGfYuz8ilRH3eMZet6aY3MmOMyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Siqy7Cqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Siqy7Cqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00BCC4CEF0;
	Tue, 12 Aug 2025 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024475;
	bh=PVpxcwhH1mo17vndFoZwnnC9DBEMKfvWVuUcHIm3sO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Siqy7CqdEh9vao7U9R51U3o4AW7aHbqrHvElgX5SCZl+nSlRcyh6vjbTeNV01V/Zq
	 QQdHs8LI5AohdmZkekihXfJ5rntbHk9tsLtcDwVpt+QBXHK7dBf3tc3l1kz7g6rM39
	 l5AzZzUL/QilX1hwUpzIEfh3CW+V10EchwLjtSgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 351/627] Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:30:46 +0200
Message-ID: <20250812173432.634039945@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 1db50f7b7a793670adcf062df9ff27798829d963 ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: ed10435d3583 ("RDMA/erdma: Implement hierarchical MTT")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20250630092346.81017-2-fourier.thomas@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index af36a8d2df22..ec0ad4086066 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -629,7 +629,8 @@ static struct erdma_mtt *erdma_create_cont_mtt(struct erdma_dev *dev,
 static void erdma_destroy_mtt_buf_sg(struct erdma_dev *dev,
 				     struct erdma_mtt *mtt)
 {
-	dma_unmap_sg(&dev->pdev->dev, mtt->sglist, mtt->nsg, DMA_TO_DEVICE);
+	dma_unmap_sg(&dev->pdev->dev, mtt->sglist,
+		     DIV_ROUND_UP(mtt->size, PAGE_SIZE), DMA_TO_DEVICE);
 	vfree(mtt->sglist);
 }
 
-- 
2.39.5



