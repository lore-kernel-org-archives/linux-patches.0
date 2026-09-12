Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1D240680A;
	Sat, 12 Sep 2026 09:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204499; cv=none; b=YuFttZvHALnrmBbgHgWJyY69POOdKwPqr4UVmdkRkrlJCwrdYSDRCZq0YqtMTnjCDwfdUlVYkT31oJrVEM69Tt+fxur6BzAHG+v9n7G9JWgH/JYwmYJpJO3Nwe6ke7+FEr7Pxb0bhWB//V2hLC86Ok3+7qgPcWsJTvQu750fZCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204499; c=relaxed/simple;
	bh=yBsBy97/UdM+7AFO3R8E0dVyYWKeRTPW7EDwZtXs1GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/eULxVThu95JhmxYscB0zTimPffvx4zBI5FIOBVALKoiNatqWlnbg+W6dAwVtc4B9e+TGKBTpzb5X8WK4ErKP+Pb54xwcmMpBI4zPeWgU9VkliQDI0J5I42R23EGdJx7eXC87n1NSBMdhXkWFiRfEemTYan1YCrgAFODWHHPro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7SYISLW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7SYISLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014EA1F000FF;
	Sat, 12 Sep 2026 09:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204498;
	bh=imm9Sa05EK76vmq2EdPSB+P33oo3faFzdwqv/7lWrks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7SYISLWiTfiCw6T0/X7Vxro0Rh7ur9N/h2lciGaaisXHxC8jDqG2kbvVvMLtUuHx
	 8unjnq/Vpg5x8aCgenUorhxcr+JcooCpyh2IIRK2pwYI5tKjoBQ+hhyADrPK6phd6/
	 PdGSL4JNcjL4U66aBemPqx/+s/YUtTJ+F6EwY9Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1625/1815] virtio_pci: fix wrong queue index for admin vq in intx path
Date: Sat, 12 Sep 2026 08:56:15 +0200
Message-ID: <20260912065727.137437351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit dc3f1eef9ab678c396baf5df12aba61db061aa8c ]

In vp_find_vqs_intx(), the admin vq was set up using the local
queue_idx counter instead of avq->vq_index (the actual queue index
obtained from the device). This differs from vp_find_vqs_msix() which
correctly uses avq->vq_index. Using the wrong index causes the admin
virtqueue to be mapped to an incorrect hardware queue.

Fix it by using avq->vq_index consistent with the msix path.

Fixes: af22bbe1f4a5 ("virtio: create admin queues alongside other virtqueues")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Message-ID: <20260629033538.2476-1-lirongqing@baidu.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 164f480b18a6f..10371ecbc054c 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -499,7 +499,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 	if (!avq_num)
 		return 0;
 	sprintf(avq->name, "avq.%u", avq->vq_index);
-	vq = vp_setup_vq(vdev, queue_idx++, vp_modern_avq_done, avq->name,
+	vq = vp_setup_vq(vdev, avq->vq_index, vp_modern_avq_done, avq->name,
 			 false, VIRTIO_MSI_NO_VECTOR,
 			 &vp_dev->admin_vq.info);
 	if (IS_ERR(vq)) {
-- 
2.53.0



