Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13EB373BF2;
	Sat, 12 Sep 2026 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218849; cv=none; b=qWkOGnan7hSI5PhrF5VPm8fC0wlIJmLj1cWH1U4mm8zGaYefzMfSIkzYMLG9vdsBc1eI+UIsSKW44SX9r+/xYqj91kB7gawj/mI8ROm8xpPJyZjgxEbCFCNTNn7Wn1GOfg2giWQ+CSENThlPECFv9N/b5UYC45nRi/dkGW261LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218849; c=relaxed/simple;
	bh=KftMS3EJhYv8OsyBcCw2F2jq6CzsjNxPlZyQyxyou6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2LO/r9U1rs24TUYoir1BMRV0obpHvBcxfuHRKDqnt+4zy1ALRrmlHRZ5iPXZ4h3R3nn79VAGKI26y8k9FeUJuWAQNsHPCfjesyHZlxb93uYB1ThaE3jLzrO+VW88L9Hz6KM9xjQtQfkLTNpv11Sc7H44ZIoIYPM4NgTYeseqB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNn/95vj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNn/95vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DD81F000FF;
	Sat, 12 Sep 2026 13:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218848;
	bh=Wa+XtD3V7NkqatRa+gO6J7pfKs+AUuEzY58jUWsStNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNn/95vj1ZbaL97ilREjO6dvOeJZkasWKG0+Y1yVT2SBVq8R+HPttKXwzclSJWYbU
	 fy/jcrgQ5xSczI8O7RY6wA6R/lk/DZ0HQ9JWlRPhzMz6Vk8wgLaN7MjKnuwTMg+ln+
	 9MZPIG4e9UI0Y09D8zCAHBejKXfpM+/49vimxyYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1230/1376] virtio_pci: fix wrong queue index for admin vq in intx path
Date: Sat, 12 Sep 2026 09:00:56 +0200
Message-ID: <20260912065634.959105638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 189261d230d2e..af31711f3861a 100644
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



