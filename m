Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590367;
	b=m/voF43ZtPNHoIpu83bjnSME1cNZdSHTMOaF62uAZBgmuW2dsMH/2htd1Cq+0rNG1lIV
	 Q5ZBdhFBF11WqzbdLwinIBVkPQKWz7MPNyfp9rzPrsRFl1hE5F8Cuab5YlvNpWEc7HZuN
	 T27zhDY3RP4E9zaO9eC63C13KMXeYpADn9Zi/qWFFRDJtRnjfA+R+j0GWgz2delAJ+RVO
	 RL9fh/FfQ1ecN7Uo0mHTxOuYsxfD8M3fUZRXfzbFYqQCC8jLfKWnhHN/v4cWQLNivX/Xm
	 bfdom0GHzh4fHthE0SRrfj4zrTniNo1+x6j9Yem3XWmxr1jehOC938nLRBetwXmkxvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bMoXUiTU12bViMYgm8hDU2HuZfNmLdDW9fhWBuUhZe8=;
	b=yL+kKNgDFZ7CN6wqATNOS6R7kPrVqBK2sK6Msipyeqampdj7eDILcnNBqXRFplxP29It
	 GmDTNlpOX1/rXwpWAfKRF8qwj2NRGwzDQzzbA6U4WWVzs09p8ap2CV4CbO0hLJ3FnpGyf
	 SwbRJbDrTSfWIKTiCg0huh/0OM0owTupHPIRY3BSoOtn6pA4C832P1tQzYghvRbp+tUxO
	 Qy1nGmvAK1lXzmm/OuMAYi81rSC7cN8vDRritJKf1T+DCVMwWzx2Qdv5JSw5ZsHRAnEYY
	 tn6Mx8tRtYsZyks1n0FRlidmN1FQ9QVos9m/N8zJkJL4T78LjMbGPTi39n8chVaRAvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qxa41c7d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA87606B340;
	Fri, 13 Nov 2026 17:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qxa41c7d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFFC1F000C4;
	Fri, 13 Nov 2026 17:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590367;
	bh=bMoXUiTU12bViMYgm8hDU2HuZfNmLdDW9fhWBuUhZe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qxa41c7d15Gb6KIv0YWQI7ElMEVY/zAkM5Q05RSi2QMbCzfXpXX6BZ9CZHfHqgITZ
	 Z8WmsafHnRz1wY3nBwebfFPZ5bhMIaaS2OcHQmva055DvzvgvgQljVZ1FsPGzhvvcY
	 t3rRzO2Ux2jMekQpjCgedREKfTXbWFF7wYzGJhPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 341/686] iommu/virtio: Reset device before deleting virtqueues on probe failure
Date: Fri, 13 Nov 2026 10:47:54 -0500
Message-ID: <20261113153832.489103524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d314fa5cd8476..3aa54bd716728 100644
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



