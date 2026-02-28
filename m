Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F501421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301174; cv=none; b=caEfpKTIDv6aulkNFWahno9TmzZ6Jxmpsa44TlEs5hCjoBVoditC7fVtMNY2tAAiJJ5JBzJAwxXb0SBFHU7Uh3koTXzG+m52OCm34W+ovNgNuID+nGdgUVbduru59M6CRvfVinEDn4eyhv6yv/Ll/MgV2DZYgZo457+GdUCD3K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301174; c=relaxed/simple;
	bh=z8eRY8bN5a0UQuv65XikCmAhs5rOFSvNg/vI4y0GN+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW0N9xsC7MT3jFdn7iMi7RimA13wDMsIEoh9WgEExpGNnY9Zgi3gu9kp7x58vbHnTg0viNWb5BX2l5DfNYHz9DL+UVq6PXp5fQxuwou+/pCLU2o7MSxV1EhU49Oz3pnUawoOkSmxsWyrFY8KNl7xXHVXHvqenAMQFZuFPLMuUG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DoylkwZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DoylkwZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB2DC116D0;
	Sat, 28 Feb 2026 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301174;
	bh=z8eRY8bN5a0UQuv65XikCmAhs5rOFSvNg/vI4y0GN+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoylkwZkhrNbxXBVEaLSwsrL8g6ognC6ajLuE1HdzJHMjzh0QzWMpH0Jt3ea9XSkJ
	 whtQ21VsLTKfFBiADy336VdDzX1SdS1y3me8jSeyLkwosNQ1v1Wml+V9jQLbQlWsJM
	 d5AeacnJI/O978jGyrZSGMkcAA6figOAK+cR3VB091PXxbFa2FuXcvUxZpQyxDqsvo
	 hpuXMO6jv0UWCQkM8Q4JXHK+XND+8QZgtE6JaAmq2AvhlyOlvqGBQ9F1ZTaPgRayWD
	 BmTnFxJ0c4sdm6SCq6vbGigB2CRd+/9rRHkxGN07gWNl1E5uM87VauHpEyXn44I+xJ
	 fHpXWrS/sAmPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sam Day <me@samcday.com>,
	David Heidelberg <david@ixit.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 341/752] usb: gadget: f_fs: fix DMA-BUF OUT queues
Date: Sat, 28 Feb 2026 12:40:52 -0500
Message-ID: <20260228174750.1542406-341-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sam Day <me@samcday.com>

[ Upstream commit 0145e7acd29855dfba4a2f387d455b5d9a520f0e ]

Currently, DMA_FROM_DEVICE is used when attaching DMABUFs to IN
endpoints and DMA_TO_DEVICE for OUT endpoints. This is inverted from
how it should be.

The result is IOMMU read-only mappings placed on OUT queues,
triggering arm-smmu write faults.

Put differently, OUT endpoints flow data from host -> gadget, meaning
the UDC peripheral needs to have write access to the buffer to fill it
with the incoming data.

This commit flips the directions and updates the implicit-sync helpers
so IN endpoints act as readers and OUT endpoints as writers.

Signed-off-by: Sam Day <me@samcday.com>
Tested-by: David Heidelberg <david@ixit.cz>  # OnePlus 6T on sdm845-next-20251119
Link: https://patch.msgid.link/20260108-ffs-dmabuf-ioctl-fix-v1-2-e51633891a81@samcday.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 47cfbe41fdff8..2061c38d772ca 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1489,7 +1489,7 @@ static int ffs_dmabuf_attach(struct file *file, int fd)
 		goto err_dmabuf_detach;
 	}
 
-	dir = epfile->in ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	dir = epfile->in ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 
 	err = ffs_dma_resv_lock(dmabuf, nonblock);
 	if (err)
@@ -1619,7 +1619,7 @@ static int ffs_dmabuf_transfer(struct file *file,
 	/* Make sure we don't have writers */
 	timeout = nonblock ? 0 : msecs_to_jiffies(DMABUF_ENQUEUE_TIMEOUT_MS);
 	retl = dma_resv_wait_timeout(dmabuf->resv,
-				     dma_resv_usage_rw(epfile->in),
+				     dma_resv_usage_rw(!epfile->in),
 				     true, timeout);
 	if (retl == 0)
 		retl = -EBUSY;
@@ -1664,7 +1664,7 @@ static int ffs_dmabuf_transfer(struct file *file,
 	dma_fence_init(&fence->base, &ffs_dmabuf_fence_ops,
 		       &priv->lock, priv->context, seqno);
 
-	resv_dir = epfile->in ? DMA_RESV_USAGE_WRITE : DMA_RESV_USAGE_READ;
+	resv_dir = epfile->in ? DMA_RESV_USAGE_READ : DMA_RESV_USAGE_WRITE;
 
 	dma_resv_add_fence(dmabuf->resv, &fence->base, resv_dir);
 	dma_resv_unlock(dmabuf->resv);
-- 
2.51.0

