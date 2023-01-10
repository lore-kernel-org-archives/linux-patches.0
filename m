Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1CCA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C3FC433D2;
	Tue, 10 Jan 2023 18:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374528;
	bh=3v1tbgt8f+wJj3/4QmTmrSWte1NuklcXtCS5w4O09Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSJMgTiGTUJsi27b15doKWvlcpI+WINXUiN0e4AHqe3bC9Q7S8WvHzQ8B0YEX+SzP
	 oBIWa1shrE85Y4d/JbOWNdvy/V99MKwxhPQKtqIrMSNBYUZY9trXlVku1thDcNBmn6
	 /HBA+2sZK64r5Xm4QYY0z7wvw/BW6XdCnsqrK0tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/159] vdpa_sim: fix vringh initialization in vdpasim_queue_ready()
Date: Tue, 10 Jan 2023 19:03:15 +0100
Message-Id: <20230110180019.808086429@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 794ec498c9fa79e6bfd71b931410d5897a9c00d4 ]

When we initialize vringh, we should pass the features and the
number of elements in the virtqueue negotiated with the driver,
otherwise operations with vringh may fail.

This was discovered in a case where the driver sets a number of
elements in the virtqueue different from the value returned by
.get_vq_num_max().

In vdpasim_vq_reset() is safe to initialize the vringh with
default values, since the virtqueue will not be used until
vdpasim_queue_ready() is called again.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20221110141335.62171-1-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index b071f0d842fb..b20689f8fe89 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -67,8 +67,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 
-	vringh_init_iotlb(&vq->vring, vdpasim->dev_attr.supported_features,
-			  VDPASIM_QUEUE_MAX, false,
+	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
 			  (struct vring_avail *)
 			  (uintptr_t)vq->driver_addr,
-- 
2.35.1



