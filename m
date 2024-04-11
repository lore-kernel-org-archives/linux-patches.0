Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2681E48E;
	Thu, 11 Apr 2024 10:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832700; cv=none; b=ZyAmImu9hTGmuh0MqWdLbM4GPolahwehDpprPVryeLPiYHCP3OXkq2LrLOjFgfYLf8tyOsKC+DOQGmtjI3h5Wg43NoJ55PZLYu7YAFua9HcVyMsnMJOg4N0ojH/V2nxhyfV8adBhJIbdasNkKC/6BzXF1kY751tMIUefXT0RWI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832700; c=relaxed/simple;
	bh=5gFV3cdFYX84H3TTr3drU+VwrfsmeB35CIwbl/rBxlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5ox7QsNFphPz/aLCU87UNDk6fc5hqydxpkc2wcSc5UFLuIzwRl6b4YxL6AkJdgP10XKilMCHBClKXJLW+rqxF/PyFsQov7XtOAY3yOhbpbY8j4qDltqQdgzK6LQZ7TJ8WnhFoKqCabrV8QhEO/irVx6pHux8UGYnwPjuQeWyTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNspmm4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNspmm4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF2EC433F1;
	Thu, 11 Apr 2024 10:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832699;
	bh=5gFV3cdFYX84H3TTr3drU+VwrfsmeB35CIwbl/rBxlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNspmm4fz456SqOIoC651DhPpiQ/5Ln/3s6XkUVXHdYJnY1WhoYY5DqGFOd1KcczT
	 7AWRmUoQv1OKz21U2DAq+GgTXGsDZkMN4pQikNYk3hPBez1mktY1y9D+eO4WXuf7Wi
	 /oUdkdPmcYBOvMZmIXLYBghDveFHkiqMg/+Uadms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.15 52/57] virtio: reenable config if freezing device failed
Date: Thu, 11 Apr 2024 11:58:00 +0200
Message-ID: <20240411095409.564294345@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 310227f42882c52356b523e2f4e11690eebcd2ab upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -455,13 +455,19 @@ EXPORT_SYMBOL_GPL(unregister_virtio_devi
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


