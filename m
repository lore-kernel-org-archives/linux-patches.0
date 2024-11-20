Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC8E1BE226;
	Wed, 20 Nov 2024 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107696; cv=none; b=D4sUeKTJ10Npe9dYHoBrQGhJUEIYBrK4VRKS72Z4Eq/oJzU1jgkqnL2fSwtT4XysFZTeTxk/ud+qo94GrSacgTTgnsc15z9WZplHZbqpCjwoHP8UELYBX++6FdnYBaBo+Da3eIyUK4nkwBWs/8OgUHJGuOdhiCxyUTCKEE/YlIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107696; c=relaxed/simple;
	bh=Blqfoc6rOlz5qJf+tunxJ3Ncx5VxViRCODQlzIQOFQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvqcLluOOTFfdYoupd+6S5okbwh0qNawsNmKOn6prr2DHotDNpA7J5ybWhrjL5K4xFT3Ao+/JA+7tzXiqKL2Sfok5b74PSrrTKPIFloiuKeZhZ87gg082LJRKgx/er8b2JW+aDiwEfqcufVMeH/g4vQoYpct10gnzttZfGk+BtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtftJdCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtftJdCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA43C4CECD;
	Wed, 20 Nov 2024 13:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107696;
	bh=Blqfoc6rOlz5qJf+tunxJ3Ncx5VxViRCODQlzIQOFQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtftJdCMZzIdZsazAFgdzV3dWywwohYGD2NG9fjthUES1Yp94dTNjz7Qm4ZmX+rXW
	 BWjVXCO6pnqLWNoXkhnStxKCq8iOb5C2OZzE9IBBJjT6ohVqLVEfBclbXBlAbqijHX
	 H1vzK67ueyILAYRvoIvV+WsG75cMBagImdcV3Nx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Angus Chen <angus.chen@jaguarmicro.com>,
	Xiaoguang Wang <lege.wang@jaguarmicro.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 6.1 20/73] vp_vdpa: fix id_table array not null terminated error
Date: Wed, 20 Nov 2024 13:58:06 +0100
Message-ID: <20241120125810.103198879@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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


