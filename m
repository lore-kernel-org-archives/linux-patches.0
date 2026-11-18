Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060047;
	b=E5dzfABtyANJrPzEr0ki3ZcEKLr8s8aXxxpfQZR4K2579KL1pYPESm/nQJp/NaPZJcOJ
	 UgAKKUXs0OAYQOYNM2AEuqecwAlBP6iEYw8zR5fAu7DYFl4I4drXAXG8uHKeE0sc01kv/
	 UVv5vdPjcVN3tf0vw+BpzTD4Q6tN39LqnR3fKPhstFkwmwSfBJQ4J7ADvDtC/uUM0vy+n
	 lhlZgZUPRs43q0+lWJGJLy0EK31RfHQbVidtJ0aJmCHYbKdf4moJNK+8fqljHiVsBRmhm
	 OYPZK6BV1NPElVPNN2r/zg1dkhrwPHPAn/3FCTArRob4c8kz2M2B4ExeVMiO16lLDOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TkVGZEH0oivQWvhb8I37mX1I4sepwXCRqqzX2B/z24g=;
	b=WFHJWCdWqw7nYTcZzCv8eQBoyybBDqhdA4OSt3DSb5rg6/NkOwD8EZXoKtXJ/i8n7Cha
	 YzlQ06aQhoDI8A4BLX6YRUda80uqapyTAnCmYq2JMJAt7iLatihQ3rCu6KmTTOA0MtV6O
	 CUt6aOWD4vn6HN7mQQcd1RXjwVE4SQo4QncwWPrrEstPp2cFkEN2oX4j80hcZQl5+25CN
	 cnNV0tGNkSnm6NNO20UK9Zdc9w/4Q77F9KWIH+SImrVMAgl7slxR/6wv7r65mxSalHRwg
	 1tlC4DJC8ZpjIcyaELjn6/DSx1GlshwKgEH70p0r/O/5GQHstyl4DzuyxOUNCy85uOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ctY2H3uC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3775E606A320;
	Thu, 19 Nov 2026 03:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ctY2H3uC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884CF1F000C4;
	Thu, 19 Nov 2026 03:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060047;
	bh=TkVGZEH0oivQWvhb8I37mX1I4sepwXCRqqzX2B/z24g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctY2H3uCTS8zMfz5Tvlm+LaFE2rRWgo8lViesDcdeiKzECe45UqMmZ38CJJvy5cbW
	 UUf6Afk4f7eh9X9FJJ2Ec/V6WZFdsKWE5KLrbmOh5RrFfehFemxuockiK7peI8RNZQ
	 zv1svmuRvNRyl2lnJHEBQQbomlUowKuoky2YS7wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1057/1848] iommu/virtio: Reset device before deleting virtqueues on probe failure
Date: Wed, 18 Nov 2026 15:51:35 +0100
Message-ID: <20261118150001.665263734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced virtio_reset_device() with vdev->config->reset(vdev) after the existing err_unregister cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/virtio-iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 81dea4caf561f..ef5eabeafa8c7 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1058,12 +1058,12 @@ static int viommu_probe(struct virtio_device *vdev)
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
 
 	iommu_device_set_ops(&viommu->iommu, &viommu_ops);
 	iommu_device_set_fwnode(&viommu->iommu, parent_dev->fwnode);
@@ -1101,6 +1101,8 @@ static int viommu_probe(struct virtio_device *vdev)
 err_unregister:
 	iommu_device_sysfs_remove(&viommu->iommu);
 	iommu_device_unregister(&viommu->iommu);
+err_reset_vdev:
+	vdev->config->reset(vdev);
 err_free_vqs:
 	vdev->config->del_vqs(vdev);
 
-- 
2.53.0



