Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037719;
	b=vVBOuBxAoofd5VwnpKkx+5/3G6/gmXoLbMBq4H1BPw3Fzmy0ey++nIzzXlzLfYCRKIp3
	 zZ7wTeWAyeedwZwy4KE2F02es6qI/nk8whayCZzzCqoFpVUYkWhdkBq+8VKVrZWiruWHg
	 EL4N8+IW0bBUptMWHJIdYMDTxfdH/Jzd7Zm7SusK2h5t9ZaVaxU4cLze2LDbgImXMExS1
	 utClPfwFW7AXh/yjIxvSd8MFFlMUhFT4jhpxMCcpzeDNFo5INLyNhmzi8vpqIPqy1OfvB
	 IULlRzS1MyURpIty2J3ipowCi8ushXQpZbeaYHuBNjn2Xe1gdtLWARNhYmDgomk8xCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PSv40fCc2m35hu8Zt+RmqOlg24GpOTLmnvMPQCdU+8A=;
	b=yJLNd+DTIonnSjai2hOMJF3CaMZNPeYt8f3JrBdYqZD96j5JX4ofcQbp5LCrFcYeQzvB
	 EdYfKd6CNdkist+6qzsBlOrL5Jfc8ejywbr1KD36cryeIgRsLC6ocQLP8LJaAPyE854EU
	 K9eeyC6cLlxMZBlNf9L+ARi65ojZDuXtCMUlAILdbDuZPd63rfZ6TmTe9ocl262PN96YY
	 NUuMfFOle1v2DsAp5f0pcWI+fYRSB8fkWLezYIgA2JKBg23isX22JyiZiEvLIfI98+9r3
	 a491sME3OX3DcHWlDMz7Jt5hYBsGV2/MiQDM624iN+k0a4hvBze8RXklFbJ14xe9s3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVXy2Cc9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066E8606A325;
	Wed, 18 Nov 2026 21:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVXy2Cc9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4469F1F000C4;
	Wed, 18 Nov 2026 21:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037718;
	bh=PSv40fCc2m35hu8Zt+RmqOlg24GpOTLmnvMPQCdU+8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVXy2Cc96N5ec5kuByFplS4/K8EQbG46mJpQu7ntL2Jrgyhsh6ahTBCewDzQd5Xen
	 7IGeENxmYYcyRKyJFj/6gclumHQ5CFwYbHjohm+d1B776qnyOd7C2YsHo6nuornuVY
	 J8H2Yr1oRU6/3DvLRGxE0TVb5KL4smsJdonPNRQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1495/3318] iommu/virtio: Reset device before deleting virtqueues on probe failure
Date: Wed, 18 Nov 2026 15:35:17 +0100
Message-ID: <20261118150405.757768629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 1f8efac19a0870cdfdf8477e447e5a07ddce9623 ]

viommu_probe() marks the device DRIVER_OK before populating the event
virtqueue and registering the IOMMU device in sysfs.  viommu_fill_evtq()
hands the device a set of device-writable buffers through
virtqueue_add_inbuf(), so from that point on the device may write into
them and into the rings.

If either step fails, the error path deletes the virtqueues without
resetting the device first.  The event buffers are allocated with
devm_kmalloc_array() and are released as probe unwinds, so the device can
go on writing to memory that has been freed.

Reset the device before deleting the virtqueues, the way viommu_remove()
already does.

Fixes: edcd69ab9a32 ("iommu: Add virtio-iommu driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261004182218.177343-1-oss.patchbox@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/virtio-iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 17dcd826f5c20..8f8cb3f1e0d30 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1173,12 +1173,12 @@ static int viommu_probe(struct virtio_device *vdev)
 	/* Populate the event queue with buffers */
 	ret = viommu_fill_evtq(viommu);
 	if (ret)
-		goto err_free_vqs;
+		goto err_reset_vdev;
 
 	ret = iommu_device_sysfs_add(&viommu->iommu, dev, NULL, "%s",
 				     virtio_bus_name(vdev));
 	if (ret)
-		goto err_free_vqs;
+		goto err_reset_vdev;
 
 	iommu_device_register(&viommu->iommu, &viommu_ops, parent_dev);
 
@@ -1190,6 +1190,8 @@ static int viommu_probe(struct virtio_device *vdev)
 
 	return 0;
 
+err_reset_vdev:
+	virtio_reset_device(vdev);
 err_free_vqs:
 	vdev->config->del_vqs(vdev);
 
-- 
2.53.0



