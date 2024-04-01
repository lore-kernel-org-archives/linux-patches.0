Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700F74654F;
	Mon,  1 Apr 2024 16:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989853; cv=none; b=ZTXtBZxe/IJ5//A1emb80qkkRDDJ4ZYB/JxnG0T80QvzOCjIIz6gB3onOzoYxW0QagCR0g+xdow4y1MKT72zlDZZ8NT3hEt2cuR/OGt7yV0KsmCFT1ZmBPu3iab1qfocaq4TuvZzsTJuBM+Jpr48zxcFd4WrH0bB7aiKq545BeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989853; c=relaxed/simple;
	bh=XcH8oqrrYDPBxuzok9PbZsseQMn/DEy5pr4WPiMPnzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbPgppg2+GlGOmgc89h+/Se4lZMFLFll2PChu9KpNJJC9zQcJI07rIRghXswWhD+khNIseEEMt/TImbSHKssBIAyHjwxNPu0GpYG3MkfCDZq5ykAXxKxSg63DoIlt3x5NzVLDLo8jwQLroxBlRMpuNS506cJtCUoUjfdHGEBMx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TM8aCUTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TM8aCUTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA4EC433C7;
	Mon,  1 Apr 2024 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989853;
	bh=XcH8oqrrYDPBxuzok9PbZsseQMn/DEy5pr4WPiMPnzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TM8aCUTCxFoe2wAYrJdpl39rXmxx2CkgDxNm176yy9zylmZGilC2LDQBWEEZEnPh5
	 riY3JdN83I03U1Utz580XFOMvXtYNf6Nw2IL9P3knTL4mUqOM8C/5pCNI1qWwm96aN
	 Mrw007p83pxz9mb/Iw8sMYmr9pRFuIoTDUS1zvhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/396] virtio: reenable config if freezing device failed
Date: Mon,  1 Apr 2024 17:43:41 +0200
Message-ID: <20240401152553.068718704@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 310227f42882c52356b523e2f4e11690eebcd2ab ]

Currently, we don't reenable the config if freezing the device failed.

For example, virtio-mem currently doesn't support suspend+resume, and
trying to freeze the device will always fail. Afterwards, the device
will no longer respond to resize requests, because it won't get notified
about config changes.

Let's fix this by re-enabling the config if freezing fails.

Fixes: 22b7050a024d ("virtio: defer config changed notifications")
Cc: <stable@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Message-Id: <20240213135425.795001-1-david@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 3893dc29eb263..71dee622b771b 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -489,13 +489,19 @@ EXPORT_SYMBOL_GPL(unregister_virtio_device);
 int virtio_device_freeze(struct virtio_device *dev)
 {
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+	int ret;
 
 	virtio_config_disable(dev);
 
 	dev->failed = dev->config->get_status(dev) & VIRTIO_CONFIG_S_FAILED;
 
-	if (drv && drv->freeze)
-		return drv->freeze(dev);
+	if (drv && drv->freeze) {
+		ret = drv->freeze(dev);
+		if (ret) {
+			virtio_config_enable(dev);
+			return ret;
+		}
+	}
 
 	return 0;
 }
-- 
2.43.0



