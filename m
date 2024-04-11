Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8C61448F3;
	Thu, 11 Apr 2024 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830013; cv=none; b=FCtGa55X7GGQJvHu2xSpdze97Ign03nQM1c0YRi8iZEd4mLeepSBulMR05mN/K/iG9C4UADaiTSKdX+lKMC9jvvbWxnK/YntFJdenBUrJh8ivBbpoIp1zcpoJt2wqGs1S7tclJirUNVROLQo5QJ3UYfnroLwis94ecQMlGb9BDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830013; c=relaxed/simple;
	bh=FBrG//iyI/rdQJDbZDGLfxWwvbJIBblLVRQooseH2xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTkSajIxG97Fkz1uiZ0AX+9VmO+RZkDr4MAzK4Ji/CH0GEvhEIB7xjEhtAH7tSw07WN8fGmdB87uHEW5oGasq2VuaatB4MrzEW5LxorzdkAZmcDDlPrBZ8KEaa8ma7RdUuc5vBSZFeeT+VDYGVeJ609Wu2om5H5ilHL4Ez1k1nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/AnzcXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/AnzcXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9880C43390;
	Thu, 11 Apr 2024 10:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830013;
	bh=FBrG//iyI/rdQJDbZDGLfxWwvbJIBblLVRQooseH2xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/AnzcXi+aUnMKOCdh3moHfgdgfYkjjzoDAOiv6suV/WPQKvPoGUdZ69CR+55UnyQ
	 rbsfY6UGC4/Aa8HwYtqaiZvVVnUC6o8DDW3X0CKvJMqxuMvQ84cdTtL7iaIcLiqYvm
	 ub8Elom6H2W19i14m1EOpdL1mebIoOA8AV1JWZMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 4.19 169/175] virtio: reenable config if freezing device failed
Date: Thu, 11 Apr 2024 11:56:32 +0200
Message-ID: <20240411095424.651663464@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -376,13 +376,19 @@ EXPORT_SYMBOL_GPL(unregister_virtio_devi
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


