Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054385;
	b=U+ZJi1gvx59xSHjGPjLy626w/mPnoQ0WzLgDBuiehVLFDI31u7qn3SbbJyZGxHROeDH8
	 tuEm2azl04MwhsBCOjXjoVmUK6M3IlXix3HHN49XKgLKzscrp+r2Kd+7jjQ87NIGXE1CM
	 FYuuK3fJ8alxmvdSiAjqbNv1RkfUycMBXx4GZotd+raHyj3IlzEBa6KanlHssHzJf05sL
	 zkhOde2kF0wMBQSuqkuX/PLjLR5SKIfl7FdZwFCuD15ixLktJhR47rN46erEtYe9h17wg
	 RAJGFUFIApp1SUU8la2QOJvjvbN/5xgWMTZwtZ9icsbD2xf2C6O6cQf8jdfeaShBEtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IFj92DWG8NrWch/EQ7D6jzSC+9sfwlQsHowRdJB3wjM=;
	b=lkX56rPzlRpvxODOemn4/SSS/dt+MtOeZRWj4dz7+0E+Ouwy55BzRikOax1kr2dNX+cZ
	 2hcOWFbkDYJws3+sik2dNGpPPSKsm2NnhZwqUkiv0dJx+DQ+0M1O3zaZ64WlkYMYNVWXg
	 vmaNKJq+sb4zHuVIRejJqL3+mqbQtx+kHpxLqHsToOlyCQcIgxkmUOfht0cbCKPAs85r4
	 VA0Ii8E+XzXJHoAJ1ncaVfbUZ/d1hXiPygjpCzASkKhMwPT0e28y8N+lZgnMcOZPadnc+
	 8EWlgxWl5o9CHggJTRhE1OiYpUPVB74SBOodBzD5TDVGmo/sELVu38tm5YqaAd9LSOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZxi6wf1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CBD606A32A;
	Thu, 19 Nov 2026 02:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZxi6wf1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEAB1F000C4;
	Thu, 19 Nov 2026 02:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054384;
	bh=IFj92DWG8NrWch/EQ7D6jzSC+9sfwlQsHowRdJB3wjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZxi6wf10UiIuYXCS2kRRur7KR/VhPhTmcj5brH4YsjA033pigg0eTvExx0coyp+E
	 1kHRMS0Ygrf1Jd+j6bCo4lJR8Xgt3q062CCpW6djMh6vC2fum0UVPVB3vK8PpwXgZl
	 ttewXSy7tx6r+eBI5aihhv749HzQwWq2lBl5BjvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1256/2214] iommu/virtio: Reset device before deleting virtqueues on probe failure
Date: Wed, 18 Nov 2026 15:48:52 +0100
Message-ID: <20261118150101.908956558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 80930ce04a168..f60a9d48f952b 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1061,12 +1061,12 @@ static int viommu_probe(struct virtio_device *vdev)
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



