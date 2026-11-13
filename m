Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585651;
	b=QCKVPBojpOZyXeaANj+tITKtWUG4m13fkPlA5XVF8QCTLC6KmXd9XkbAJ6jtcrABUTGW
	 GURWLlBYg7NAlPy30X2eWAd2AiH/XdKx4tChB7AM1mTX+Hd4mQUJbt+ZpXNKwkxqHOEMv
	 Ut/UEHu1cP6oZTxbDLWHp732UrYL+JdTVR9uigwRug/VuaP+TLyElB3+TgIgrVxAlEYBZ
	 Jr8Dhk6PRaDJESc7gtztTsS0L0NKvw8RhJsud2Mc4mTqpkmyCR1QgT9zOnqfsUHjR7oyD
	 LnNWMECb1jGQYiQDmWhCMMabPvy+2EYye1VM0VyGGBBQwPrwqyXr5fW/63LJEX5kXSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IFMLvCcvQWoEi4IuNTYUqdWvAAM+pGTBR+punHZuP+Q=;
	b=LxX/QL3hIPgDSleV2UYTdrShgUUvg+hdI18NTAipTWdS2terY1m0adMVk70/FB4uBfcE
	 aHK1EtTXxkXUEf6W2xdO3xXb8LqO+9Q6FpOu77vx6iX1tNowHqpQ9HWraMNAP4U1KDtRV
	 mAD3k9c6so3tNEfn+RpPpP9aexUKH5CwyQHE1NwXY90AZri8tARUHCvm1jLWyWZAaJPsr
	 3wXxo6KSSOT8AMzTnyWKxSA+9+KhgXiTdNao+z5v4hlPiASpw8jA4NqQkbsUBhz1Q2Anq
	 mJyp4NGj3viLDYLJgZ++ja6A/L2Ed9KGoMSDBKaqC6j/L/I4PsfNlHhItttG39T3uxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=poHIBvLD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECBF606B2DB;
	Fri, 13 Nov 2026 16:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=poHIBvLD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E131F000C4;
	Fri, 13 Nov 2026 16:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585651;
	bh=IFMLvCcvQWoEi4IuNTYUqdWvAAM+pGTBR+punHZuP+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=poHIBvLDFQhyrTY3zgOyqRqe56Xc8a9WcwNJfY/KzddFs8UesusRvyL1uqR5qXy+P
	 mj0EbnFpukDr7HT0mc0MIaQP5y33kAZ4onSuzLJctgHZOzRG8glWpcIlyzhTYx3bTb
	 3DKAWVqFKehGvFOGkhA1FSxkPPFAuWDOi18nTCUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 267/507] iommu/virtio: Reset device before deleting virtqueues on probe failure
Date: Fri, 13 Nov 2026 10:49:31 -0500
Message-ID: <20261113153803.671750668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 587fc13197f12..fa72ae23b8afa 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1227,12 +1227,12 @@ static int viommu_probe(struct virtio_device *vdev)
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
 
 	vdev->priv = viommu;
 
@@ -1244,6 +1244,8 @@ static int viommu_probe(struct virtio_device *vdev)
 
 	return 0;
 
+err_reset_vdev:
+	virtio_reset_device(vdev);
 err_free_vqs:
 	vdev->config->del_vqs(vdev);
 
-- 
2.53.0



