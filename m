Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888112DC792;
	Sat, 12 Sep 2026 11:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211756; cv=none; b=miRuocC4TFrBbatcZMJbmJ0USSAr98rXgf3tzuiJ5cGPIr9sFt8cITHIzQJUGoc4X+vI6lhmup3p4UjAICliWHHOfdXp0DX9UDU4nM81bOkI80CECjdKz9k1yWp8Ug9/Z+xuZyQpYB94Zs8opsZbDV6dRKPGr8w+Kvrxh4OhapQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211756; c=relaxed/simple;
	bh=DkUc0uS826W0t4vCfbQT5M9TIb+IpScroLobwMz7lyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INLiHfGajh+ijx3+tYE72npk73/ZMA6lRunUt6XtbscoqnPacqSej8B2sf8VwzI9fzI/YpC6quGsCpZI+/jO9McdEOIPO4w4E8PsLQFTs70oLcIEvTkzAqGp+Kswq3/1XmZufBZDI3goEGPYkLdiLqTjft+qKIp2MECihucWPU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWYVSD5m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWYVSD5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559C11F000FF;
	Sat, 12 Sep 2026 11:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211755;
	bh=8qLWa83iflX1tIqrwZ1dN3Can/Ct53CTxKYSyMPrX8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SWYVSD5mV4TvZrDwEzlMIkxc3668ojXTlJONtlgtj6I4fX6As8+dttQzp1hgUk/ln
	 v5mm3YPqb/rKfJIKTcNSkx2MXZiF1+dUHsH8b8dai+4e3Lw3fAqxkbCiefyPHeOA0x
	 MAsL+fg3pA9HN6GSOg8YGLbJjjhTzFIbAicOjqSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1297/1518] virtio_pci: fix wrong queue index for admin vq in intx path
Date: Sat, 12 Sep 2026 08:57:46 +0200
Message-ID: <20260912065652.856535766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 30c6627a5ce4d..ef87e7584756e 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -502,7 +502,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
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



