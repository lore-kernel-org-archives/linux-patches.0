Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15F6302CCE;
	Tue, 12 Aug 2025 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021551; cv=none; b=jn37EAcbbXDWkMQzxu8klNh/ZxM7fdPQQiRZ1wHNCyl/6NLkSJSahvc1nA5vwDJENMlcVMfN34PToKoPzDdVwp7eMxro7cliUdNzmx4zOX5vC0qGerLWy9uV6z13Alb2Pw8lel5fT+hfSxpqVTqs2IWAKW5Tp8cPVDTDbuGpeeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021551; c=relaxed/simple;
	bh=3Ed1A4+0ggbzdZ0ibisARZoaiplzFwLRWMVOGxN1VmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjeJZdheJUR49oT73526i3GtKLOnpes1XRROFssGO8vh4eV3wrPtQ3ID4E62oc0fXqh7sdvK19yvwAcHo2ze9xT96UGusgoDsLepCxpS9dZP8uCxEiGBqbNEVTuY/hIFapK8cXcXUYUmoqe9Uu4CSurcCbgblDHMFKZcLFfmfAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGe5krkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGe5krkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B443FC116C6;
	Tue, 12 Aug 2025 17:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021551;
	bh=3Ed1A4+0ggbzdZ0ibisARZoaiplzFwLRWMVOGxN1VmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGe5krkgmk+ICL5U4iymvoDQ/HDo4Bxg6pCPsEIRUCO+hrkKV4s5EUPm6woUZq+Q9
	 ZEM38HBq48d/23uSY6GXMVMch83COF74WOczY3J31BZtqij3J7dVyfHvhpxOkj+luE
	 ySG2pDURkaoZT8VwHP/s+FD2z4SeqeKRONy/xNk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/262] Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:28:30 +0200
Message-ID: <20250812172958.304172507@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b010c4209ea3..29ad2f5ffabe 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -585,7 +585,8 @@ static struct erdma_mtt *erdma_create_cont_mtt(struct erdma_dev *dev,
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



