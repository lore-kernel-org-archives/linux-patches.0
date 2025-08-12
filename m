Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB02C2FE57A;
	Tue, 12 Aug 2025 18:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022648; cv=none; b=hJLaXMWo0Y0QdFN3fDASAJRIQYTWTY/lwtFEWPwcGt/7DSrY3lyPMmVCwi3Xj+PgfdMfJ6BvEJRUU+dAwJOwnIiTz3hb/R8goJGaeHL4q/H68Kr7l5Zg4OyrnAFFePb2Ngu+OS3w7zLVQbHFv92hQo1rIpdMyqEZCmmOyzto2A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022648; c=relaxed/simple;
	bh=a2Yugctz6Y4mcqn3Wg0ro3xG4R6AO6JyDqlvkyikF7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyYSM5jbOjKRo1rO8FDtpxiwRNwAYSzHmDlHgCO2VLmWiFON+2X1cavsJlMEUblP80AGWDExGKUckjoEjdZUSfA9/+aNPfNfUAaKDOUuRxJZQUIpGb8Ftsg2YpprOs3zlYt/wpUuidjy0+NYqaLixwZBIVMtTOcyeAFvb6gO+0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyTfdVxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyTfdVxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A231C4CEF6;
	Tue, 12 Aug 2025 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022647;
	bh=a2Yugctz6Y4mcqn3Wg0ro3xG4R6AO6JyDqlvkyikF7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyTfdVxfbDyb4X0ikFgK84LC1NqkQUl4JtCrvAQWNo42dM2oUqnDoWrFe7fxGStva
	 DK+w7+FVT9Mnnr5zgwzSxcywETLPT84xUVP0vo2lyhZOkFzC/GroL3m/lGCvTskml+
	 RiXDxL/wFCIxTNNavzQ+UuXX6VHJvkojAnwO9K5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/369] Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:27:51 +0200
Message-ID: <20250812173021.314257709@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 51d619edb6c5..e56ba86d460e 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -597,7 +597,8 @@ static struct erdma_mtt *erdma_create_cont_mtt(struct erdma_dev *dev,
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



