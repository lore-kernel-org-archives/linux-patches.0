Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ADD1494D9;
	Fri,  6 Dec 2024 14:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496011; cv=none; b=FmJN6YQ6MuZiESO3K+B8ZeyIGxbquQKXKaXr7Qic2rsAokR45VcgyCkZkNJ7sXFalVtMoPMsOIJK3Io/GY3bRuEgm1oq1Vf+BND6jSApqQtC3E47bFy8uEv7SNjvDz3jLWzD2Tzadfeb0mYnEOpm5dXTHNw4vD9fUpwmS0UewXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496011; c=relaxed/simple;
	bh=mco0ndoLYL/8FAsbplILlJe8gHXc8SfBw0tRYkzyLBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPaq65F6pq6GhDqc807CodFenZ4lsix0DvNcIPqjoe5M007TSytZeke9katNXUF0/26+P80KlVR+5E6lPxdsyZO1TXwIqswFGIZVulg5MpaH0tskv1c2hntc4k0Hxzbeij0JojZQOD8SZCJIk0OGI6/4qOVCXXA6skbBjhJjQ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06YhAxxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06YhAxxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6133FC4CEDC;
	Fri,  6 Dec 2024 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496010;
	bh=mco0ndoLYL/8FAsbplILlJe8gHXc8SfBw0tRYkzyLBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06YhAxxE9dO/qlUfnP/7oWkrsEv3fod/i697pPZFxw9IdMdQ+WN6X26MZwMIPsU+r
	 ajcRAhhMrFFasYJMEua8G0x07eN6zt1bmsSU3oNO5u0D690KKbCYhxCcRD+FSfi8bx
	 tjnvJK8ZKY9UpyXml1X/WkbcFEG0xM5k4fRFPiqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.12 027/146] media: platform: rga: fix 32-bit DMA limitation
Date: Fri,  6 Dec 2024 15:35:58 +0100
Message-ID: <20241206143528.712250683@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Keeping <jkeeping@inmusicbrands.com>

commit 953c03d8cb41d08fe6994f5d94c4393ac9da2f13 upstream.

The destination buffer flags are assigned twice but source is not set in
what looks like a copy+paste mistake.  Assign the source queue flags so
the 32-bit DMA limitation is handled consistently.

Fixes: ec9ef8dda2a2 ("media: rockchip: rga: set dma mask to 32 bits")
Cc: <stable@vger.kernel.org>
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rga/rga.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -102,7 +102,7 @@ queue_init(void *priv, struct vb2_queue
 	src_vq->drv_priv = ctx;
 	src_vq->ops = &rga_qops;
 	src_vq->mem_ops = &vb2_dma_sg_memops;
-	dst_vq->gfp_flags = __GFP_DMA32;
+	src_vq->gfp_flags = __GFP_DMA32;
 	src_vq->buf_struct_size = sizeof(struct rga_vb_buffer);
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->rga->mutex;


