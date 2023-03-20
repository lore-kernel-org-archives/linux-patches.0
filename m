Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F141C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC648C433EF;
	Mon, 20 Mar 2023 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325438;
	bh=+4SDLqKtYyc36Kv8dUBvjY7sF/JLdSOcZCb+nFhNOxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LycORzXkte9Y3dX/tdWeUTcwkbDlVzmGnZ6h6iV0mulYLRM+WJ2C8Hs6kZcrWuSnm
	 wrI9l8Qf7ceBJm1tGw+kjXDm+9wrzT8cEj/UmgC+Xklb1caCGUNmq09rVfR6Hpb7fd
	 9c3cgDGlYUR0ZVyTe6+y8hgiy4IfUP5TDyuWUbXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 043/211] vdpa_sim: set last_used_idx as last_avail_idx in vdpasim_queue_ready
Date: Mon, 20 Mar 2023 15:52:58 +0100
Message-Id: <20230320145515.039197909@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

[ Upstream commit b4cca6d48eb3fa6f0d9caba4329b1a2b0ff67a77 ]

Starting from an used_idx different than 0 is needed in use cases like
virtual machine migration.  Not doing so and letting the caller set an
avail idx different than 0 causes destination device to try to use old
buffers that source driver already recover and are not available
anymore.

Since vdpa_sim does not support receive inflight descriptors as a
destination of a migration, let's set both avail_idx and used_idx the
same at vq start.  This is how vhost-user works in a
VHOST_SET_VRING_BASE call.

Although the simple fix is to set last_used_idx at vdpasim_set_vq_state,
it would be reset at vdpasim_queue_ready.  The last_avail_idx case is
fixed with commit 0e84f918fac8 ("vdpa_sim: not reset state in
vdpasim_queue_ready").  Since the only option is to make it equal to
last_avail_idx, adding the only change needed here.

This was discovered and tested live migrating the vdpa_sim_net device.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Message-Id: <20230302181857.925374-1-eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 8839232a3fcbc..61bde476cf9c8 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -76,6 +76,17 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 			  (uintptr_t)vq->device_addr);
 
 	vq->vring.last_avail_idx = last_avail_idx;
+
+	/*
+	 * Since vdpa_sim does not support receive inflight descriptors as a
+	 * destination of a migration, let's set both avail_idx and used_idx
+	 * the same at vq start.  This is how vhost-user works in a
+	 * VHOST_SET_VRING_BASE call.
+	 *
+	 * Although the simple fix is to set last_used_idx at
+	 * vdpasim_set_vq_state, it would be reset at vdpasim_queue_ready.
+	 */
+	vq->vring.last_used_idx = last_avail_idx;
 	vq->vring.notify = vdpasim_vq_notify;
 }
 
-- 
2.39.2



