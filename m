Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B877911710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390CAC433C8;
	Mon, 11 Sep 2023 15:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445631;
	bh=yzwBLj3nGHdYQGmJOasXxjW+RXhT68QCoX/dvxDVreo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hp0e+lstBUqCcNytIJjPyXhFG1OqkhTEamEhVNVuBoF3jfWWamkpXsddza7ky8yhQ
	 +uMguJaalvKRPKCSjiRoncyfG2zjNfzTIKA+7k4OauTN9o8YoVSLtaPZkrqOGbTGTa
	 LdMsUnX/p7Gz7YJol9qie3OKrqk2z4rWb5pq+nfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 416/600] media: mediatek: vcodec: fix resource leaks in vdec_msg_queue_init()
Date: Mon, 11 Sep 2023 15:47:29 +0200
Message-ID: <20230911134645.949116160@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cf10b0bb503c974ba049d6f888b21178be20a962 ]

If we encounter any error in the vdec_msg_queue_init() then we need
to set "msg_queue->wdma_addr.size = 0;".  Normally, this is done
inside the vdec_msg_queue_deinit() function.  However, if the
first call to allocate &msg_queue->wdma_addr fails, then the
vdec_msg_queue_deinit() function is a no-op.  For that situation, just
set the size to zero explicitly and return.

There were two other error paths which did not clean up before returning.
Change those error paths to goto mem_alloc_err.

Fixes: b199fe46f35c ("media: mtk-vcodec: Add msg queue feature for lat and core architecture")
Fixes: 2f5d0aef37c6 ("media: mediatek: vcodec: support stateless AV1 decoder")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c b/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c
index 675f62814f94e..a81212c0ade9d 100644
--- a/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c
@@ -313,6 +313,7 @@ int vdec_msg_queue_init(struct vdec_msg_queue *msg_queue,
 	err = mtk_vcodec_mem_alloc(ctx, &msg_queue->wdma_addr);
 	if (err) {
 		mtk_v4l2_err("failed to allocate wdma_addr buf");
+		msg_queue->wdma_addr.size = 0;
 		return -ENOMEM;
 	}
 	msg_queue->wdma_rptr_addr = msg_queue->wdma_addr.dma_addr;
-- 
2.40.1



