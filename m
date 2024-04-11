Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395096BB29;
	Thu, 11 Apr 2024 10:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832266; cv=none; b=gHrgIQsVrANAOWmmWJbY5zFoZJPxOuONfu8C97nFGMT2BKEkETvSpdjNjzCzNCEa7pmEtiz2sBFzVWLTvS0Ed+l3eZD52x4gUBsmPhIeKKYx+CJjeNfanrG2R+XKqEdiHWuoE7qdWEgOxnEzvVRDKrY5c0r3YIuJs09xkN3RbPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832266; c=relaxed/simple;
	bh=Fegs8vIHYhk/4sBbt+2EnlFi/yurNM2QpEjy7YI8Dcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSrFFHEb9L6Mk2Cct5RNiBRLBC2BFIDWF28/E6qJ621pQvfalccG6DYtDOWldMNG1ywBvvVPv8pXBvQ0gpPtWqi0/im0o6TUvkwVy7j7YIazO22yj2DG1R2IKBpiY8gESlY6rOM+sQX/JrtyLP1rkRjufZLDZYt90tOFzMpxorI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xF3vbUlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xF3vbUlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6A9C433C7;
	Thu, 11 Apr 2024 10:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832266;
	bh=Fegs8vIHYhk/4sBbt+2EnlFi/yurNM2QpEjy7YI8Dcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xF3vbUlbihjEMr2ZGhrFNW60MuwNqgF4AsoNpxXPYigJcQmdXhGHmGiCP9BJFT5i7
	 /I9R6F7B5Voy/jzdawC2y2oajndNvSYsPSxKEXZ75pJTtS13MrQ51hKBkxZstJHryS
	 ZzL47T8TlM1bsm12AQ2I5j5bB1twS/eLfS1HrmzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.10 286/294] virtio: reenable config if freezing device failed
Date: Thu, 11 Apr 2024 11:57:29 +0200
Message-ID: <20240411095444.143423679@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,13 +403,19 @@ EXPORT_SYMBOL_GPL(unregister_virtio_devi
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


