Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AB48F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD59C433C7;
	Sun, 16 Jul 2023 20:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539035;
	bh=15Ww9JzwZFyKJ37u2c8y8UIlSsnBC4+pR60qbDapO/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w51PF8bWIcVTavWOCaOvxalimUGiU6EsgHBowcnaKiysCJECgPV8OkChoN+v5x/4s
	 HlGPsjTBs4ztbaz0kT9Y3bUSE8nI++chJZ2MDAYR803PaC8ExoMYwv4U9i1nE52Lmp
	 R0u9g9Ko0Yy+or/862YQUdojQyY8rXko0Ub+inaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Feng Liu <feliu@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 657/800] virtio-vdpa: Fix unchecked call to NULL set_vq_affinity
Date: Sun, 16 Jul 2023 21:48:30 +0200
Message-ID: <20230716195004.371909670@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit fe37efba475375caa2dbc71cb06f53f7086277ef ]

The referenced patch calls set_vq_affinity without checking if the op is
valid. This patch adds the check.

Fixes: 3dad56823b53 ("virtio-vdpa: Support interrupt affinity spreading mechanism")
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Message-Id: <20230504135053.2283816-1-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Feng Liu <feliu@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_vdpa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index eb6aee8c06b2c..989e2d7184ce4 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -385,7 +385,9 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 			err = PTR_ERR(vqs[i]);
 			goto err_setup_vq;
 		}
-		ops->set_vq_affinity(vdpa, i, &masks[i]);
+
+		if (ops->set_vq_affinity)
+			ops->set_vq_affinity(vdpa, i, &masks[i]);
 	}
 
 	cb.callback = virtio_vdpa_config_cb;
-- 
2.39.2



