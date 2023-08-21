Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914191171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2091C433C9;
	Mon, 21 Aug 2023 20:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648194;
	bh=32zIn/A27SspaR11ax4q2PvpMvS/Y+OO1CANTNiTtnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaAOWJxBDUOihkxKAE0gSgLY1A3Ba5W+h9j+DMVAvYww8QNKvb3RgHBOLGwsZ0kcg
	 tYAp7HCWZCLarYUEnI0QGDOTjpX70GsHGYU7/PEfxCSnTmYGPPJNa8gXKph/nb5BKG
	 niz+WUjSiONb+2StJvg3sGrnCo98A72+0WikNzvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 088/234] virtio-vdpa: Fix cpumask memory leak in virtio_vdpa_find_vqs()
Date: Mon, 21 Aug 2023 21:40:51 +0200
Message-ID: <20230821194132.676169701@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit df9557046440b0a62250fee3169a8f6a139f55a6 ]

Free the cpumask allocated by create_affinity_masks() before returning
from the function.

Fixes: 3dad56823b53 ("virtio-vdpa: Support interrupt affinity spreading mechanism")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Message-Id: <20230726191036.14324-1-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_vdpa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 989e2d7184ce4..961161da59000 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -393,11 +393,13 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 	cb.callback = virtio_vdpa_config_cb;
 	cb.private = vd_dev;
 	ops->set_config_cb(vdpa, &cb);
+	kfree(masks);
 
 	return 0;
 
 err_setup_vq:
 	virtio_vdpa_del_vqs(vdev);
+	kfree(masks);
 	return err;
 }
 
-- 
2.40.1



