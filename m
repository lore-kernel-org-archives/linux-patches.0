Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D9C2E64F;
	Fri, 24 Nov 2023 18:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmJq6mx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9056FC433C7;
	Fri, 24 Nov 2023 18:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851790;
	bh=XSVTCRNFKY7G7FoeZHTnLfxxaOduatcIXM0tmfE9dHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmJq6mx8jfpbkBFBSJztRWenaxFMQSxrRjskMScYbVzmPbwIbELRVyIi3PLd8moIj
	 LMn7cQ+zCs1W5BSWFWxDp6EeSAsLQabHzVZMGd+3GdriCAvmFm2m0Oe5MffZdbUwCM
	 zZUApNBV+9KuV3KZhUSpOa6jv7F9gnZF5fXW49jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhenwei pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/372] virtio-blk: fix implicit overflow on virtio_max_dma_size
Date: Fri, 24 Nov 2023 17:48:04 +0000
Message-ID: <20231124172013.756345828@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: zhenwei pi <pizhenwei@bytedance.com>

[ Upstream commit fafb51a67fb883eb2dde352539df939a251851be ]

The following codes have an implicit conversion from size_t to u32:
(u32)max_size = (size_t)virtio_max_dma_size(vdev);

This may lead overflow, Ex (size_t)4G -> (u32)0. Once
virtio_max_dma_size() has a larger size than U32_MAX, use U32_MAX
instead.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Message-Id: <20230904061045.510460-1-pizhenwei@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index a7697027ce43b..efa5535a8e1d8 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -900,6 +900,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	u16 min_io_size;
 	u8 physical_block_exp, alignment_offset;
 	unsigned int queue_depth;
+	size_t max_dma_size;
 
 	if (!vdev->config->get) {
 		dev_err(&vdev->dev, "%s failure: config access disabled\n",
@@ -998,7 +999,8 @@ static int virtblk_probe(struct virtio_device *vdev)
 	/* No real sector limit. */
 	blk_queue_max_hw_sectors(q, -1U);
 
-	max_size = virtio_max_dma_size(vdev);
+	max_dma_size = virtio_max_dma_size(vdev);
+	max_size = max_dma_size > U32_MAX ? U32_MAX : max_dma_size;
 
 	/* Host can optionally specify maximum segment size and number of
 	 * segments. */
-- 
2.42.0



