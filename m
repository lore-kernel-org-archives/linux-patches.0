Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0041A1A7AFD;
	Wed, 20 Nov 2024 12:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107591; cv=none; b=jOEB6lk4o0yQf8IAFHa+cjueffzEZ7gkSkk1oMmAEcV0hiy6RcnDs8jJa1R6FNXBmy4hc2nTHmCNH8hN4atoEowg0uyWxZNhQu6dYbg2oqecCoAweN3ygFxgjTSp5aMo5k1nLZhu1eAk+fw7n9rSb6yQX01yjDnWYrdc0CpSmMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107591; c=relaxed/simple;
	bh=IkMDTci/vZj+FOEv0MbBuOzjQW6xVBH689Y5clI9Axg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxiyG6feu21BdkTh1ovu1WdwI7TouR3KCAbETqcYemi/qtTxoGjFjDzEgXdAp42PWW/5NRkKbiizprxLzr5TNiDQqjyZCsD/uvUOCfBOi/jdCLQ42+qHvB70IO3dIXUUtAbOBq0jS3qpMZt2nAjVfubvXG+OP64CmU1j1pvd5Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aDNjjcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aDNjjcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14B8C4CECD;
	Wed, 20 Nov 2024 12:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107590;
	bh=IkMDTci/vZj+FOEv0MbBuOzjQW6xVBH689Y5clI9Axg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1aDNjjczTzE6ya3ZYRkNmxZr/J79P7F0MfjXmuA5ZXJz5aY0OrAzsEwmRR27tBQzg
	 jOiE4bLqrwN5hMLjLjsS7zcE8ZqgIllyx7K0ibQ4h0SZwMlB4LZ0FVzWLMHjHhXata
	 FXFX1DARNk1p9ef7yOR2tlIYQ4ylI/X/d1CDuoMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Angus Chen <angus.chen@jaguarmicro.com>,
	Xiaoguang Wang <lege.wang@jaguarmicro.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 6.6 34/82] vp_vdpa: fix id_table array not null terminated error
Date: Wed, 20 Nov 2024 13:56:44 +0100
Message-ID: <20241120125630.381800349@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoguang Wang <lege.wang@jaguarmicro.com>

commit 4e39ecadf1d2a08187139619f1f314b64ba7d947 upstream.

Allocate one extra virtio_device_id as null terminator, otherwise
vdpa_mgmtdev_get_classes() may iterate multiple times and visit
undefined memory.

Fixes: ffbda8e9df10 ("vdpa/vp_vdpa : add vdpa tool support in vp_vdpa")
Cc: stable@vger.kernel.org
Suggested-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
Signed-off-by: Xiaoguang Wang <lege.wang@jaguarmicro.com>
Message-Id: <20241105133518.1494-1-lege.wang@jaguarmicro.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/virtio_pci/vp_vdpa.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -591,7 +591,11 @@ static int vp_vdpa_probe(struct pci_dev
 		goto mdev_err;
 	}
 
-	mdev_id = kzalloc(sizeof(struct virtio_device_id), GFP_KERNEL);
+	/*
+	 * id_table should be a null terminated array, so allocate one additional
+	 * entry here, see vdpa_mgmtdev_get_classes().
+	 */
+	mdev_id = kcalloc(2, sizeof(struct virtio_device_id), GFP_KERNEL);
 	if (!mdev_id) {
 		err = -ENOMEM;
 		goto mdev_id_err;
@@ -611,8 +615,8 @@ static int vp_vdpa_probe(struct pci_dev
 		goto probe_err;
 	}
 
-	mdev_id->device = mdev->id.device;
-	mdev_id->vendor = mdev->id.vendor;
+	mdev_id[0].device = mdev->id.device;
+	mdev_id[0].vendor = mdev->id.vendor;
 	mgtdev->id_table = mdev_id;
 	mgtdev->max_supported_vqs = vp_modern_get_num_queues(mdev);
 	mgtdev->supported_features = vp_modern_get_features(mdev);


