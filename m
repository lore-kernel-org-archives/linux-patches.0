Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0191170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F890C433C8;
	Mon, 11 Sep 2023 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441621;
	bh=UfgcpOqVv9npvDzEkORKlMCgLllIuq4053v20k6oSqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIpcukW/kI4UByXY8RN4HmCs9yMWc1i+BCsJwP0l0KZ0nBqU1f1BOnzPQTvhFXG7V
	 perf2oHXLZurUq5+yYicvuuEANOqqmA8e0RrCholl/QtTLUCzrgA34IoH1xgYyTsWE
	 QvwfNhODBbkzSjxZ/6UEfbnmNyz1WIaKo83dzH3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 478/739] media: mediatek: vcodec: fix potential double free
Date: Mon, 11 Sep 2023 15:44:37 +0200
Message-ID: <20230911134704.493778637@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit be40f524b6edac4fb9a98ef79620fd9b9497a998 ]

The "lat_buf->private_data" needs to be set to NULL to prevent a
double free.  How this would happen is if vdec_msg_queue_init() failed
twice in a row and on the second time it failed earlier than on the
first time.

The vdec_msg_queue_init() function has a loop which does:
	for (i = 0; i < NUM_BUFFER_COUNT; i++) {

Each iteration initializes one element in the msg_queue->lat_buf[] array
and then the clean up function vdec_msg_queue_deinit() frees each
element of the msg_queue->lat_buf[] array.  This clean up code relies
on the assumption that every element is either initialized or zeroed.
Leaving a freed pointer which is non-zero breaks the assumption.

Fixes: b199fe46f35c ("media: mtk-vcodec: Add msg queue feature for lat and core architecture")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c b/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c
index 04e6dc6cfa1de..f2d21b5bc5c3a 100644
--- a/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec_msg_queue.c
@@ -231,6 +231,7 @@ void vdec_msg_queue_deinit(struct vdec_msg_queue *msg_queue,
 			mtk_vcodec_mem_free(ctx, mem);
 
 		kfree(lat_buf->private_data);
+		lat_buf->private_data = NULL;
 	}
 
 	if (msg_queue->wdma_addr.size)
-- 
2.40.1



