Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D7E64CC0;
	Thu, 11 Apr 2024 10:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832543; cv=none; b=Ud0J6BSidP5VqfkV628hmhdnN1AWPe1uAlCzViGS0aWK4CaOFIyeVoQFRGdRi7pj9oCj5gh6LpCIle8cqtGMJhBQYoQJplmlqUF1WxErWPVVsdHryD6qVCLT6NH1XOpnr9501f2gylcyfwDm+5n02jFNqV5UNUgQgfgkrWfNEOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832543; c=relaxed/simple;
	bh=St1Chv0++2E3M7Q3OCCW8OnpEihsIONdsIGj9l8a+OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAT2J3UUWCFBCmKBC4xJUzshIUfM2ip8lROQ3fnQFrgIQ5fizR3m90X+LuN7WPKIudhpCcwnYn0bWDDskvosFgCXcYaNRf33M6hodjWTah25fODL81vwsDU3d8ZDrzxNi2jRNsyQG+2KXzoLH4J0noLXehwHAUwIvBVOZ9bATxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2QIeDum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2QIeDum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D3DC433C7;
	Thu, 11 Apr 2024 10:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832543;
	bh=St1Chv0++2E3M7Q3OCCW8OnpEihsIONdsIGj9l8a+OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2QIeDumcWbbThJDvzJRtTzASKq0MH1E7wB9XYQ607hlQD950+/9eSKUJNDJy3PSc
	 jD24ebRKjcslsg6KsEhzbFHgjKyTxYNbkQwZt7kWe9h0wxkV2+WbWTQcDt6NplLo0a
	 jmEm4XzFaRog5jpKWU6+xXmjTCHja6C12zceW7PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 6.1 77/83] virtio: reenable config if freezing device failed
Date: Thu, 11 Apr 2024 11:57:49 +0200
Message-ID: <20240411095415.006456055@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -489,13 +489,19 @@ EXPORT_SYMBOL_GPL(unregister_virtio_devi
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


