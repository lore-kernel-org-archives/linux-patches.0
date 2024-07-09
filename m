Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2240A15887F;
	Tue,  9 Jul 2024 11:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524143; cv=none; b=guQquv2xB1ATcdtrR3Ie2FvGm85zk82rKP0l1krogLmseB+NqWEfXlCsUdU2S5olQq7cJ4UlUT+5YSw5tJ6+67wLafm6qOc7o7ubsdo8nwZ13HZYDtyAhDs25Ez9IyGJOyVhskrxnuvD58W88Iz5tUkc+xPebIa4EHZPHXwnN84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524143; c=relaxed/simple;
	bh=uLMAJ+2Kcg2bk0LxyQFEFhzLlyUDq1zmFmLYeZa8TjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR61454F4OTvJmkZu6v+z4W4n5mONsh2MpWEJ2WafFGv9li2hhvROY6U2LPlEJMB5PmII+3+jS7Zj4Rg2mueaO/0oJfSy4iajswawTaYh0iAhg91HaJZDEJ1FSGsrOG+z4rbWzgtE8GeLIHcPcVkHuUZdjgrRA/ilP8xiXjOtRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x11CORfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x11CORfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF4CC3277B;
	Tue,  9 Jul 2024 11:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524143;
	bh=uLMAJ+2Kcg2bk0LxyQFEFhzLlyUDq1zmFmLYeZa8TjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x11CORfGrwQkxrTt5ql5kiU/DWCMUFBSjEtgS8B+Op2klPcOQ29j0tlxTnUozWrjb
	 7EeYNJ1HQkGCzMRjLr2gq+Mv8UHl6Iw+CAczkO7yZA4KZWlahaquJtg3IMuru2Wfe2
	 YTmw8QwQ7TkxA/jJanG2xIFLHNe1Xo2gt4lzBO5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhang <zhanglikernel@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 084/197] virtio-pci: Check if is_avq is NULL
Date: Tue,  9 Jul 2024 13:08:58 +0200
Message-ID: <20240709110712.218178726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhang <zhanglikernel@gmail.com>

[ Upstream commit c8fae27d141a32a1624d0d0d5419d94252824498 ]

[bug]
In the virtio_pci_common.c function vp_del_vqs, vp_dev->is_avq is involved
to determine whether it is admin virtqueue, but this function vp_dev->is_avq
 may be empty. For installations, virtio_pci_legacy does not assign a value
 to vp_dev->is_avq.

[fix]
Check whether it is vp_dev->is_avq before use.

[test]
Test with virsh Attach device
Before this patch, the following command would crash the guest system

After applying the patch, everything seems to be working fine.

Signed-off-by: Li Zhang <zhanglikernel@gmail.com>
Message-Id: <1710566754-3532-1-git-send-email-zhanglikernel@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 584af7816532b..f6b0b00e4599f 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -236,7 +236,7 @@ void vp_del_vqs(struct virtio_device *vdev)
 	int i;
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
-		if (vp_dev->is_avq(vdev, vq->index))
+		if (vp_dev->is_avq && vp_dev->is_avq(vdev, vq->index))
 			continue;
 
 		if (vp_dev->per_vq_vectors) {
-- 
2.43.0



