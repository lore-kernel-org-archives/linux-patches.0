Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247431C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA3BC433D2;
	Mon, 20 Mar 2023 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325094;
	bh=hO22jz36PVa0rP3aqafck/3Njl/82iGYwwUmUrv3lnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oev2C7SyIc+pEVwMroGg35ByIhRgyYIia3uTlEjm58T8gRvjzBmtKnQUQ84S7ydDP
	 +JCQiuJ4jr634N6/p7Bits4VBXIL2esSEpw7f8xjqxL2AgQhtQkXIOcTWpx26GdPNh
	 ZppwAXHn6NqBKcZG4mF270V3q/oeHKV15mUtH9Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/198] vdpa_sim: not reset state in vdpasim_queue_ready
Date: Mon, 20 Mar 2023 15:52:59 +0100
Message-Id: <20230320145509.187982304@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eugenio Pérez <eperezma@redhat.com>

[ Upstream commit 0e84f918fac8ae61dcb790534fad5e3555ca2930 ]

vdpasim_queue_ready calls vringh_init_iotlb, which resets split indexes.
But it can be called after setting a ring base with
vdpasim_set_vq_state.

Fix it by stashing them. They're still resetted in vdpasim_vq_reset.

This was discovered and tested live migrating the vdpa_sim_net device.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Message-Id: <20230118164359.1523760-2-eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index cb88891b44a8c..8839232a3fcbc 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -66,6 +66,7 @@ static void vdpasim_vq_notify(struct vringh *vring)
 static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
+	uint16_t last_avail_idx = vq->vring.last_avail_idx;
 
 	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
@@ -74,6 +75,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 			  (struct vring_used *)
 			  (uintptr_t)vq->device_addr);
 
+	vq->vring.last_avail_idx = last_avail_idx;
 	vq->vring.notify = vdpasim_vq_notify;
 }
 
-- 
2.39.2



