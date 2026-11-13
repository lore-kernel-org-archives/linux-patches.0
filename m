Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591156;
	b=3cqXCbnzryE/EcqGsBshCt385oi2WkWdTcHv1+ng6NRA/oAJHH8tXuGLhRX0a4bJ/2fD
	 GN5S/2e27ZJhsmmSWH5KVpHKxcDcVivuIhd99Le/67cdCZ8v5qXXI2JsrUfhzTWSG0rlc
	 T13OLUJ/slwowdiAkFglvpkgtsyNL3XE8XQ2EGFi3g4T6zzCnOwjoCL7AaT3CR8xWoDgx
	 sHONB38htuoBQ1ARXPncFbqKTDLKchQ9uJlTgR1OGrTAzn8PWePAmgY2Z2AzwEcLTTMXu
	 yQTHugZfIZkdEJXc3JFIFev3F5SaUKFl3HzB52kzfFeryY90vefoBukQPcgrGnf6kjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i0RhY0L5oB8hF0myc0fqe7j9oyZuDnyOo6Z1oyq/5SI=;
	b=U+GbhSpWs0Gt/ywsYCtq1Y744uBWg5LwsC696OqbxN9IswhO1b6DnSU7VgAq3sOPiyfQ
	 wQLn8oqHnNihh74/xDLBj/CMWWBlktxMwW5ckh/iaCvq2RBzB/Jeuzo5YW14hJ8mkHVl8
	 jXGug68cY6+CBXURISiJ0ltlagcMsrLJQg/uCI7A9RSKeg1xuKdT3BMoWX4FoW8uqDhoI
	 Gv21L8b1XYrD9dJokdDOANGmRAM/0Tm2SraYM6ekFCL1Ggzg+g82ojnxX+Gj+1Tp3f870
	 VGMppKJkVaolnFNGANz5wFw61mlmfRrF1xHpWat+TK1tLhe8WthZ1aOJlRPEcrx7V/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J9+9MT/p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DA5606BD27;
	Fri, 13 Nov 2026 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9+9MT/p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50051F000C6;
	Fri, 13 Nov 2026 17:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591155;
	bh=i0RhY0L5oB8hF0myc0fqe7j9oyZuDnyOo6Z1oyq/5SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9+9MT/pDzUa63wGUL78dEMFYGL2I8x1xzRME/GrkvG1Un2sR2Vco4ukGakt5T+UR
	 5PSvpOcmY702Ki6jHWT93qnR+0uxsZ+vzxaq7GoupTzVsOZKBlU9IHlnM3Mdm4hJuK
	 aoev7ZIXAZjNVoynipk6sma0bJGVl+RvlT+ZpeEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/670] iommu/virtio: Reset device before deleting virtqueues on probe failure
Date: Fri, 13 Nov 2026 10:47:44 -0500
Message-ID: <20261113153822.091368556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b85ce6310ddbd..f84a50596f4d1 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1191,12 +1191,12 @@ static int viommu_probe(struct virtio_device *vdev)
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
 
@@ -1208,6 +1208,8 @@ static int viommu_probe(struct virtio_device *vdev)
 
 	return 0;
 
+err_reset_vdev:
+	virtio_reset_device(vdev);
 err_free_vqs:
 	vdev->config->del_vqs(vdev);
 
-- 
2.53.0



