Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF7CC129;
	Mon,  1 Apr 2024 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988580; cv=none; b=BM5B+nHTWYjSVblGwmOoMSUcttcoj3AQPKGjI3lALa8xJKSyNizqGIsNr0bUPJHXGp4zFqAxNtdO1tRYM5SVjof8fbcDll6Exwo4sM3JuuhvjHR6ErI0hoNh/GoWmaaeRFYK/jnZNoHm6tp7X6iyPPSb+qbFvlPhVbt+JTZmlNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988580; c=relaxed/simple;
	bh=EiFi1p45sEvOdKjySAqhHXIl0AtH6Bpd8SXt+/yGrX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfIGkbragahDn1mKg2goO9IRlizbNT8yV9og+6cA1X8bO5Oht7wXSrbLqX/bpiHDAcPWBhmFhJQAdvyVQ5S3a7SpGS2TjAfyXVVdnIf1XWraBsLpoN/eYYBkorIbhKdhPYakbhN11wJET6U/G+UO8Ck1OtrK6u8JV22p2GIP7rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iT9Lc0/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iT9Lc0/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FB9C433F1;
	Mon,  1 Apr 2024 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988580;
	bh=EiFi1p45sEvOdKjySAqhHXIl0AtH6Bpd8SXt+/yGrX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iT9Lc0/ADRIr8TwhcjxzNCtoikdXG1ldX1G7rCcNTs4BFVvqUQqWqo2Pt+7QXxkWT
	 Qeu7olAW/sSlier8cvRhta9MLLL2OVHvYdpyQjmrcStmkvUWW0+7zDbtjtWJxRtnUU
	 9MwzZXacbczbfYB9GJ0dK52WR4YdCVEyO72bczRU=
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
Subject: [PATCH 6.7 198/432] virtio: reenable config if freezing device failed
Date: Mon,  1 Apr 2024 17:43:05 +0200
Message-ID: <20240401152559.044724940@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



