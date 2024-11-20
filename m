Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF76A1A4F19;
	Wed, 20 Nov 2024 12:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107521; cv=none; b=mGco3Bdu+i8fzwfwynHr6zchKxelYtwYgtMd2pExSDJNymrf2FSJhiNOBWeB40pTY92Pv6101cAH4iz12//X3+Pz06iQLIEesQaxr2tEFHLEOumZ4tr7QC3I657E0lp61ZkAKjmKkvmy9cSv42ONzSeQ/fVbF94h6gK18mvulbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107521; c=relaxed/simple;
	bh=AgHc8m5kExuuw3EOuLBpOYx7MEmRKsavfnWhon43T84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2KmjQA3V2oK3esJmHmEisGOocrWkHrxQioRUYa/aCXAfwqx8X00M9KVD3rN1fUmnrz/Tr5X9hCQYsKq8PXDgyPXlkMJozAdgx3il6GURS/AHOsoUlfo+HRQKXuj+rUWwDfNVEWSgKhC3th1kH5TuqaiBg8Yo1ybUuwQk85ZuqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8DHpuiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8DHpuiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA1BC4CED8;
	Wed, 20 Nov 2024 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107520;
	bh=AgHc8m5kExuuw3EOuLBpOYx7MEmRKsavfnWhon43T84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8DHpuival6TfvT6VY6bgcGsE0GKQzZta6485hnzNgfI+56bNU114qA//v2t6YbP5
	 +STn8js4Adi1a3I9Dxt8qIQHTzUe89mFFtI4R3yvGhYuHtvRW85OahhtLE7Nihae+i
	 zOBygle2Qvc2IYtuFgsQ/jTAbP51RN2AKTeHwa5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Angus Chen <angus.chen@jaguarmicro.com>,
	Xiaoguang Wang <lege.wang@jaguarmicro.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 6.11 051/107] vp_vdpa: fix id_table array not null terminated error
Date: Wed, 20 Nov 2024 13:56:26 +0100
Message-ID: <20241120125630.827017730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -612,7 +612,11 @@ static int vp_vdpa_probe(struct pci_dev
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
@@ -632,8 +636,8 @@ static int vp_vdpa_probe(struct pci_dev
 		goto probe_err;
 	}
 
-	mdev_id->device = mdev->id.device;
-	mdev_id->vendor = mdev->id.vendor;
+	mdev_id[0].device = mdev->id.device;
+	mdev_id[0].vendor = mdev->id.vendor;
 	mgtdev->id_table = mdev_id;
 	mgtdev->max_supported_vqs = vp_modern_get_num_queues(mdev);
 	mgtdev->supported_features = vp_modern_get_features(mdev);


