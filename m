Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1499A11707
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8860CC433C8;
	Mon, 21 Aug 2023 19:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647638;
	bh=dSaRez5M8vk01g6Q5wIkMeyrpF/zL5mIDqFYlx/DBqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bONK+1PggmH94J0z9hXFEh5uQfnoFiMGSUUxcfMfckoG7KXySQmRjYUtaLBFYgtLU
	 IEqWwkzyURwGVld2OZ3two+7F/UTeCCVVWcUSEvSRyQpJMWAmHPcvcd5FIpgCb8Gkc
	 sescsUknfDq5+cIxls9FhZaxkAniAHQc86HEY8EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xieyongji@bytedance.com,
	Jason Wang <jasowang@redhat.com>,
	Maxime Coquelin <maxime.coquelin@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/194] vduse: Use proper spinlock for IRQ injection
Date: Mon, 21 Aug 2023 21:41:04 +0200
Message-ID: <20230821194126.494846320@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxime Coquelin <maxime.coquelin@redhat.com>

[ Upstream commit 7ca26efb09a1543fddb29308ea3b63b66cb5d3ee ]

The IRQ injection work used spin_lock_irq() to protect the
scheduling of the softirq, but spin_lock_bh() should be
used.

With spin_lock_irq(), we noticed delay of more than 6
seconds between the time a NAPI polling work is scheduled
and the time it is executed.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Cc: xieyongji@bytedance.com

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
Message-Id: <20230705114505.63274-1-maxime.coquelin@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 72f924ec4658d..edcd74cc4c0f7 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -899,10 +899,10 @@ static void vduse_dev_irq_inject(struct work_struct *work)
 {
 	struct vduse_dev *dev = container_of(work, struct vduse_dev, inject);
 
-	spin_lock_irq(&dev->irq_lock);
+	spin_lock_bh(&dev->irq_lock);
 	if (dev->config_cb.callback)
 		dev->config_cb.callback(dev->config_cb.private);
-	spin_unlock_irq(&dev->irq_lock);
+	spin_unlock_bh(&dev->irq_lock);
 }
 
 static void vduse_vq_irq_inject(struct work_struct *work)
@@ -910,10 +910,10 @@ static void vduse_vq_irq_inject(struct work_struct *work)
 	struct vduse_virtqueue *vq = container_of(work,
 					struct vduse_virtqueue, inject);
 
-	spin_lock_irq(&vq->irq_lock);
+	spin_lock_bh(&vq->irq_lock);
 	if (vq->ready && vq->cb.callback)
 		vq->cb.callback(vq->cb.private);
-	spin_unlock_irq(&vq->irq_lock);
+	spin_unlock_bh(&vq->irq_lock);
 }
 
 static int vduse_dev_queue_irq_work(struct vduse_dev *dev,
-- 
2.40.1



